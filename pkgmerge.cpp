#include <iostream>
#include <fstream>
#include <filesystem>
#include <vector>
#include <map>
#include <algorithm>
#include <string>
#include <thread>
#include <atomic>
#include <mutex>
#include <cstring>
#include <fcntl.h>
#include <sys/stat.h>
#include <memory>
#include <cstdlib>
#ifndef _WIN32
#include <unistd.h>
#else
#include <io.h>
#include <malloc.h>
#ifndef O_BINARY
#define O_BINARY _O_BINARY
#endif
typedef ptrdiff_t ssize_t;
#endif

#ifndef O_BINARY
#define O_BINARY 0
#endif
#if defined(__APPLE__)
#include <CommonCrypto/CommonDigest.h>
#else
#include <openssl/sha.h>
#endif

#if defined(__APPLE__)
#include <libkern/OSByteOrder.h>
#define be32toh(x) OSSwapBigToHostInt32(x)
#define be64toh(x) OSSwapBigToHostInt64(x)
#elif defined(__linux__)
#include <endian.h>
#else
#include <winsock2.h>
#define be32toh(x) ntohl(x)
#endif

namespace fs = std::filesystem;
using namespace std;

const char PKG_MAGIC_PS4[4] = { 0x7F, 0x43, 0x4E, 0x54 }; // \x7FCNT
const char PKG_MAGIC_PS5[4] = { 0x7F, 0x46, 0x49, 0x48 }; // \x7FFIH

std::mutex log_mutex;

std::string escape_json(const std::string& s) {
    std::string result;
    result.reserve(s.length());
    for (char c : s) {
        if (c == '"') result += "\\\"";
        else if (c == '\\') result += "\\\\";
        else if (c == '\b') result += "\\b";
        else if (c == '\f') result += "\\f";
        else if (c == '\n') result += "\\n";
        else if (c == '\r') result += "\\r";
        else if (c == '\t') result += "\\t";
        else if (0 <= c && c <= 0x1f) {
            char buf[8];
            snprintf(buf, sizeof(buf), "\\u%04x", c);
            result += buf;
        } else {
            result += c;
        }
    }
    return result;
}

void emit_json_progress(int thread_id, int part_num, double progress, double global_progress) {
    std::lock_guard<std::mutex> lock(log_mutex);
    cout << "{\"type\": \"progress\", \"thread\": " << thread_id 
         << ", \"part\": " << part_num 
         << ", \"progress\": " << progress 
         << ", \"global\": " << global_progress << "}" << endl;
}

void emit_json_error(const string& msg, bool dracarys_needed) {
    std::lock_guard<std::mutex> lock(log_mutex);
    cout << "{\"type\": \"error\", \"message\": \"" << escape_json(msg)
         << "\", \"dracarys_needed\": " << (dracarys_needed ? "true" : "false") << "}" << endl;
}

void emit_json_success(const string& msg) {
    std::lock_guard<std::mutex> lock(log_mutex);
    cout << "{\"type\": \"success\", \"message\": \"" << escape_json(msg) << "\"}" << endl;
}

void emit_json_info(const string& msg) {
    std::lock_guard<std::mutex> lock(log_mutex);
    cout << "{\"type\": \"info\", \"message\": \"" << escape_json(msg) << "\"}" << endl;
}

struct PackagePart {
    int part_num;
    fs::path file;
    uintmax_t size;
    uintmax_t offset_in_merged;
    
    bool operator<(const PackagePart& rhs) const {
        return part_num < rhs.part_num;
    }
};

bool has_pkg_magic(const fs::path& path) {
    std::error_code ec;
    if (!fs::exists(path, ec) || fs::file_size(path, ec) < 4) return false;
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs) return false;
    char magic[4];
    ifs.read(magic, sizeof(magic));
    ifs.close();
    return (memcmp(magic, PKG_MAGIC_PS4, 4) == 0 || memcmp(magic, PKG_MAGIC_PS5, 4) == 0);
}

bool process_package(const string& title_id, std::vector<PackagePart>& parts, const string& output_dir, bool force_mode) {
    if (parts.empty()) return true;
    
    std::sort(parts.begin(), parts.end());

    if (!has_pkg_magic(parts[0].file)) {
        emit_json_error("Invalid PKG magic bytes. The first part is not a valid PS4/PS5 package.", false);
        return false;
    }

    uintmax_t total_size = 0;
    uintmax_t common_chunk_size = 0;
    bool size_mismatch_detected = false;

    // First pass: Verify sizes
    for (size_t i = 0; i < parts.size(); ++i) {
        parts[i].offset_in_merged = total_size;
        parts[i].size = fs::file_size(parts[i].file);
        total_size += parts[i].size;
        
        if (i < parts.size() - 1) { // Not the last part
            if (common_chunk_size == 0) {
                common_chunk_size = parts[i].size;
            } else if (parts[i].size != common_chunk_size) {
                size_mismatch_detected = true;
            }
        }
    }

    if (size_mismatch_detected && !force_mode) {
        emit_json_error("Math mismatch detected! The parts do not have identical chunk sizes. This means a part is missing or a Scene Hack (like injecting sc.pkg) is being attempted.", true);
        return false; // Abort unless forced
    }
    
    if (size_mismatch_detected && force_mode) {
        emit_json_info("DRACARYS! Ignoring math mismatch due to --force mode. Proceeding with brute-force merge.");
    }

    // Check disk space
    fs::path out_path = output_dir.empty() ? parts[0].file.parent_path() : fs::path(output_dir);
    std::error_code ec;
    fs::create_directories(out_path, ec);
    fs::space_info space = fs::space(out_path, ec);
    if (ec || space.available < total_size) {
        emit_json_error("Not enough free disk space or cannot access directory. Required: " + to_string(total_size) + " bytes.", false);
        return false;
    }

    string merged_file_name = title_id + "-merged.pkg";
    string full_merged_file = (out_path / merged_file_name).string();

    if (fs::exists(full_merged_file)) {
        fs::remove(full_merged_file);
    }

    // Open file for writing (creation and preallocation on main thread)
#ifdef _WIN32
    int fd_main = _open(full_merged_file.c_str(), _O_WRONLY | _O_CREAT | _O_TRUNC | _O_BINARY, _S_IREAD | _S_IWRITE);
#else
    int fd_main = open(full_merged_file.c_str(), O_WRONLY | O_CREAT | O_TRUNC | O_BINARY, 0644);
#endif
    if (fd_main < 0) {
        emit_json_error("Could not open destination file for writing.", false);
        return false;
    }

    // Preallocate
#if defined(__APPLE__)
    fstore_t store = {F_ALLOCATECONTIG, F_PEOFPOSMODE, 0, (off_t)total_size, 0};
    int ret = fcntl(fd_main, F_PREALLOCATE, &store);
    if (ret == -1) {
        store.fst_flags = F_ALLOCATEALL;
        fcntl(fd_main, F_PREALLOCATE, &store);
    }
    ftruncate(fd_main, total_size);
#elif defined(__linux__)
    posix_fallocate(fd_main, 0, total_size);
#endif
#ifdef _WIN32
    _close(fd_main);
#else
    close(fd_main);
#endif

    std::atomic<uintmax_t> total_written{0};
    std::atomic<bool> has_error{false};
    
    // Create threads for parallel merging
    size_t num_threads = std::min<size_t>(std::thread::hardware_concurrency(), parts.size());
    if (num_threads == 0) num_threads = 1;
    if (num_threads > 4) num_threads = 4; // Cap at 4 for optimal NVMe queue depth

    std::vector<std::thread> workers;
    std::atomic<size_t> part_index{0};

    auto worker_task = [&](int thread_id) {
        // Open independent output file descriptor to avoid VFS Lock contention
#ifdef _WIN32
        int fd_out = _open(full_merged_file.c_str(), _O_WRONLY | _O_BINARY);
#else
        int fd_out = open(full_merged_file.c_str(), O_WRONLY | O_BINARY);
#endif
        if (fd_out < 0) {
            emit_json_error("Thread " + to_string(thread_id) + " failed to open destination file.", false);
            return;
        }

#if defined(__APPLE__)
        fcntl(fd_out, F_NOCACHE, 1);
#endif

        int counter = 0;

        while (!has_error.load()) {
            size_t idx = part_index.fetch_add(1);
            if (idx >= parts.size()) break;
            
            const auto& part = parts[idx];
#ifdef _WIN32
            int fd_in = _open(part.file.string().c_str(), _O_RDONLY | _O_BINARY);
#else
            int fd_in = open(part.file.string().c_str(), O_RDONLY | O_BINARY);
#endif
            if (fd_in < 0) {
                emit_json_error("Thread " + to_string(thread_id) + " failed to open part " + to_string(part.part_num), false);
                has_error = true;
                break;
            }

#if defined(__APPLE__)
            fcntl(fd_in, F_NOCACHE, 1);
#elif defined(__linux__)
            posix_fadvise(fd_in, 0, 0, POSIX_FADV_SEQUENTIAL);
#endif

            const size_t buf_size = 16 * 1024 * 1024; // 16MB buffer
#ifdef _WIN32
            char* buffer_ptr = (char*)_aligned_malloc(buf_size, 4096);
            if (!buffer_ptr) {
                emit_json_error("Thread " + to_string(thread_id) + " failed to allocate aligned memory", false);
                has_error = true;
                break;
            }
            std::unique_ptr<char, decltype(&_aligned_free)> buffer_guard(buffer_ptr, _aligned_free);
#else
            char* buffer_ptr = nullptr;
            if (posix_memalign((void**)&buffer_ptr, 4096, buf_size) != 0) {
                emit_json_error("Thread " + to_string(thread_id) + " failed to allocate aligned memory", false);
                has_error = true;
                break;
            }
            std::unique_ptr<char, decltype(&free)> buffer_guard(buffer_ptr, free);
#endif
            char* buffer = buffer_ptr;
            
            uintmax_t offset_in_out = part.offset_in_merged;
            uintmax_t written_for_part = 0;
            
            while (!has_error.load()) {
#ifdef _WIN32
                ssize_t bytes_read = _read(fd_in, buffer, (unsigned int)buf_size);
#else
                ssize_t bytes_read = read(fd_in, buffer, buf_size);
#endif
                if (bytes_read < 0) {
                    emit_json_error("Thread " + to_string(thread_id) + " failed to read from part " + to_string(part.part_num), false);
                    has_error = true;
                    break;
                }
                if (bytes_read == 0) break;
                
                ssize_t total_written_for_buffer = 0;
                while (total_written_for_buffer < bytes_read && !has_error.load()) {
#ifdef _WIN32
                    _lseeki64(fd_out, offset_in_out, SEEK_SET);
                    ssize_t bytes_written = _write(fd_out, buffer + total_written_for_buffer, (unsigned int)(bytes_read - total_written_for_buffer));
#else
                    ssize_t bytes_written = pwrite(fd_out, buffer + total_written_for_buffer, bytes_read - total_written_for_buffer, offset_in_out);
#endif
                    if (bytes_written < 0) {
                        emit_json_error("Write error on part " + to_string(part.part_num), false);
                        has_error = true;
                        break;
                    }
                    offset_in_out += bytes_written;
                    written_for_part += bytes_written;
                    total_written_for_buffer += bytes_written;
                    
                    total_written.fetch_add(bytes_written);
                }
                if (has_error.load()) break;
                
                uintmax_t cur_total = total_written.load();
                
                double part_prog = ((double)written_for_part / part.size) * 100.0;
                double glob_prog = ((double)cur_total / total_size) * 100.0;
                
                if (counter++ % 10 == 0 || part_prog >= 100.0) {
                    emit_json_progress(thread_id, part.part_num, part_prog, glob_prog);
                }
            }
#ifdef _WIN32
            _close(fd_in);
#else
            close(fd_in);
#endif
        }
#ifdef _WIN32
        _close(fd_out);
#else
        close(fd_out);
#endif
    };

    for (size_t i = 0; i < num_threads; ++i) {
        workers.emplace_back(worker_task, i);
    }
    
    for (auto& w : workers) {
        w.join();
    }
    
    if (has_error.load()) {
        fs::remove(full_merged_file); // Clean up corrupted file
        return false;
    }

    emit_json_success("Merged PKG saved to: " + full_merged_file);
    return true;
}

int main(int argc, char *argv[]) {
    setvbuf(stdout, NULL, _IONBF, 0);

    string dir = "";
    string out_dir = "";
    bool force_mode = false;

    for (int i = 1; i < argc; ++i) {
        string arg = argv[i];
        if (arg == "--force") {
            force_mode = true;
        } else if (dir.empty()) {
            dir = arg;
        } else if (out_dir.empty()) {
            out_dir = arg;
        }
    }

    if (dir.empty()) {
        emit_json_error("No pkg directory supplied. Usage: pkg-merge <directory> [output_directory] [--force]", false);
        return 1;
    }

    if (!fs::is_directory(dir)) {
        emit_json_error("Argument is not a directory: " + dir, false);
        return 1;
    }
    
    map<string, vector<PackagePart>> root_groups;

    for (auto & file : fs::directory_iterator(dir)) {
        if (!file.is_regular_file()) continue;
        string file_name = file.path().filename().string();
        if (file.path().extension() != ".pkg") continue;
        if (file_name.find("-merged") != string::npos) continue;

        string title_id = file_name.substr(0, file_name.find_last_of("."));
        int part_num = 0;
        
        size_t found_part_begin = title_id.find_last_of("_");
        if (found_part_begin != string::npos && found_part_begin + 1 < title_id.length()) {
            string part_str = title_id.substr(found_part_begin + 1);
            char* ptr = nullptr;
            int parsed_part = strtol(part_str.c_str(), &ptr, 10);
            if (ptr != nullptr && *ptr == '\0' && part_str.length() > 0) {
                part_num = parsed_part;
                title_id = title_id.substr(0, found_part_begin);
            }
        }
        
        PackagePart p;
        p.part_num = part_num;
        p.file = file.path();
        
        root_groups[title_id].push_back(p);
    }
    
    bool all_success = true;
    for (auto& group : root_groups) {
        if (!process_package(group.first, group.second, out_dir, force_mode)) {
            all_success = false;
        }
    }

    return all_success ? 0 : 1;
}
