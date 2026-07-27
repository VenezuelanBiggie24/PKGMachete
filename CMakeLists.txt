cmake_minimum_required(VERSION 3.10)
project(pkg-merge VERSION 4.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Homebrew OpenSSL hint for macOS Apple Silicon
if(APPLE AND EXISTS "/opt/homebrew/opt/openssl@3")
    set(OPENSSL_ROOT_DIR "/opt/homebrew/opt/openssl@3")
elseif(APPLE AND EXISTS "/usr/local/opt/openssl")
    set(OPENSSL_ROOT_DIR "/usr/local/opt/openssl")
endif()

find_package(OpenSSL REQUIRED)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

add_executable(pkg-merge pkgmerge.cpp)

target_link_libraries(pkg-merge PRIVATE OpenSSL::Crypto Threads::Threads)
