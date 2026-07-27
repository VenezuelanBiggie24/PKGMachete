#include <stdio.h>
#include <string>
#include <iostream>
#include <fstream>
#include <filesystem>
#include <map>
#include <vector>
#include <algorithm>
#include <assert.h>
#include <cstring>

namespace fs = std::filesystem;
using std::string;
using std::map;
using std::vector;

struct Package {
	int					part;
	fs::path			file;
	vector<Package>		parts;
	bool operator < (const Package& rhs) const {
		return part < rhs.part;
	}
};

const char PKG_MAGIC_PS4[4] = { 0x7F, 0x43, 0x4E, 0x54 }; // \x7FCNT
const char PKG_MAGIC_PS5[4] = { 0x7F, 0x46, 0x49, 0x48 }; // \x7FFIH

bool has_pkg_magic(const fs::path& path) {
	std::error_code ec;
	if (!fs::exists(path, ec) || fs::file_size(path, ec) < 4) return false;
	std::ifstream ifs(path, std::ios::binary);
	if (!ifs) return false;
	char magic[4];
	ifs.read(magic, sizeof(magic));
	ifs.close();
	if (memcmp(magic, PKG_MAGIC_PS4, sizeof(PKG_MAGIC_PS4)) == 0) return true;
	if (memcmp(magic, PKG_MAGIC_PS5, sizeof(PKG_MAGIC_PS5)) == 0) return true;
	return false;
}

void merge(const map<string, Package>& packages, const string& output_dir) {
	for (auto & root : packages) {
		auto pkg = root.second;
        if (pkg.parts.empty()) {
            continue;
        }

		// Before we start, we need to sort the lists properly
		std::sort(pkg.parts.begin(), pkg.parts.end());

		size_t pieces = pkg.parts.size();
		auto title_id = root.first.c_str();

		printf("[work] beginning to merge %d %s for package %s...\n", (int)pieces, pieces == 1 ? "piece" : "pieces", title_id);

		string merged_file_name = root.first + "-merged.pkg";
		fs::path out_path = output_dir.empty() ? pkg.file.parent_path() : fs::path(output_dir);
		string full_merged_file = (out_path / merged_file_name).string();

		if (fs::exists(full_merged_file)) {
			fs::remove(full_merged_file);
		}

		printf("\t[work] copying root package file to new file...");
		auto merged_file = fs::path(full_merged_file);

		// Deal with root file first
		fs::copy_file(pkg.file, merged_file, fs::copy_options::update_existing);
		printf("done\n");

		// Using C API from here on because it just works and is fast
		FILE *merged = fopen(full_merged_file.c_str(), "a+b");
		if (!merged) {
			printf("\n[error] could not open merged file %s for writing\n", full_merged_file.c_str());
			continue;
		}

		// Now all the pieces...
		for (auto & part : pkg.parts) {
			FILE *to_merge = fopen(part.file.string().c_str(), "rb");
            if (!to_merge) {
                printf("\n[error] could not open piece %s\n", part.file.string().c_str());
                continue;
            }

			auto total_size = fs::file_size(part.file);
			if (total_size == 0) {
				fclose(to_merge);
				continue;
			}
			std::vector<char> buffer(1024 * 512);
			uintmax_t copied = 0;

			size_t read_data;
			while ((read_data = fread(buffer.data(), sizeof(char), buffer.size(), to_merge)) > 0)
			{
				size_t written = fwrite(buffer.data(), sizeof(char), read_data, merged);
				if (written != read_data) {
					printf("\n[error] write error or short write\n");
					break;
				}
				copied += read_data * sizeof(char);
				auto percentage = ((double)copied / (double)total_size) * 100;
				printf("\r\t[work] merged %llu/%llu bytes (%.0lf%%) for part %d...", (unsigned long long)copied, (unsigned long long)total_size, percentage, part.part);
				fflush(stdout);
			}
			fclose(to_merge);

			printf("done\n");
		}
		fclose(merged);
	}
}

struct ParsedFile {
    string title_id;
    int part_num;
    bool is_root;
    fs::path file_path;
};

int main(int argc, char *argv[])
{
	setvbuf(stdout, NULL, _IONBF, 0); // Disable stdout buffering for realtime Swift parsing

	if (argc < 2 || argc > 3) {
		std::cout << "No pkg directory supplied\nUsage: pkg-merge <directory> [output_directory]" << std::endl;
		return 1;
	}
	string dir = argv[1];
	string out_dir = "";
	if (argc == 3) {
		out_dir = argv[2];
		if (!fs::is_directory(out_dir)) {
			printf("[error] argument '%s' is not a directory\n", out_dir.c_str());
			return 1;
		}
	}

	if (!fs::is_directory(dir)) {
		printf("[error] argument '%s' is not a directory\n", dir.c_str());
		return 1;
	}
	
    map<string, Package> packages;
    vector<ParsedFile> all_files;

	for (auto & file : fs::directory_iterator(dir)) {
		string file_name = file.path().filename().string();

		if (file.path().extension() != ".pkg") {
			continue;
		}
		if (file_name.find("-merged") != string::npos) continue;

        string title_id = file_name.substr(0, file_name.find_last_of("."));
        int part_num = 0;
        
        size_t found_part_begin = title_id.find_last_of("_");
        if (found_part_begin != string::npos) {
            string part_str = title_id.substr(found_part_begin + 1);
            char* ptr = nullptr;
            int parsed_part = strtol(part_str.c_str(), &ptr, 10);
            if (ptr != nullptr && *ptr == '\0' && part_str.length() > 0) {
                // It is a valid piece!
                part_num = parsed_part;
                title_id = title_id.substr(0, found_part_begin);
            }
        }
        
        bool is_root = has_pkg_magic(file.path());
        
        ParsedFile pf;
        pf.title_id = title_id;
        pf.part_num = part_num;
        pf.is_root = is_root;
        pf.file_path = file.path();
        
        all_files.push_back(pf);
	}
    
    // First pass: Find all roots
    for (auto& pf : all_files) {
        if (pf.is_root) {
            auto package = Package();
            package.part = pf.part_num; // Usually 0
            package.file = pf.file_path;
            packages.insert(std::pair<string, Package>(pf.title_id, package));
            printf("[success] found root PKG file for %s\n", pf.title_id.c_str());
        }
    }
    
    // Second pass: Find all pieces and attach them to roots
    for (auto& pf : all_files) {
        if (!pf.is_root) {
            auto it = packages.find(pf.title_id);
            if (it != packages.end()) {
                auto pkg = &it->second;
                auto piece = Package();
                piece.file = pf.file_path;
                piece.part = pf.part_num;
                pkg->parts.push_back(piece);
                printf("[success] found piece %d for PKG file %s\n", pf.part_num, pf.title_id.c_str());
            } else {
                printf("[warn] '%s' seems to be a piece but no root package was found. skipping...\n", pf.file_path.filename().string().c_str());
            }
        }
    }

	merge(packages, out_dir);
	printf("\n[success] completed\n");
	return 0;
}
