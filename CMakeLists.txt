cmake_minimum_required(VERSION 3.10)
project(pkg-merge VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(pkg-merge pkgmerge.cpp)

# Link stdc++fs if needed for older compilers (GCC < 9)
if(CMAKE_COMPILER_IS_GNUCXX AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 9.0)
    target_link_libraries(pkg-merge stdc++fs)
endif()
