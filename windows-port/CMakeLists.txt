cmake_minimum_required(VERSION 3.20)
project(PKGMachete CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configure C++/WinRT and WinUI 3
# Note: In a real build environment, you'd use the Microsoft.Windows.CppWinRT NuGet package
# and appropriate CMake modules for WinUI 3 / XAML compilation.

# find_package(cppwinrt REQUIRED)

add_executable(PKGMachete WIN32
    main.cpp
    pch.h
    App.xaml.cpp
    App.xaml.h
    MainWindow.xaml.cpp
    MainWindow.xaml.h
)

# Typically, XAML files are compiled via msbuild or specialized CMake functions
# provided by CppWinRT to generate .g.h and .g.cpp files.

target_link_libraries(PKGMachete PRIVATE
    # Microsoft.UI.Xaml
    windowsapp
)
