cmake_minimum_required(VERSION 3.16)
project(PKGMachete VERSION 5.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Gui Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Gui Widgets)

# Dummy check to compile CLI if parent cpp exists
if(EXISTS "${CMAKE_SOURCE_DIR}/../pkgmerge.cpp")
    add_executable(pkgmachete-cli "${CMAKE_SOURCE_DIR}/../pkgmerge.cpp")
    find_package(Threads REQUIRED)
    target_link_libraries(pkgmachete-cli PRIVATE Threads::Threads)
else()
    message(WARNING "pkgmerge.cpp not found in parent directory. CLI tool will not be built.")
endif()

add_executable(PKGMachete
    main.cpp
    MainWindow.cpp
    MainWindow.h
    LanguageManager.cpp
    LanguageManager.h
)

target_link_libraries(PKGMachete PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Gui Qt${QT_VERSION_MAJOR}::Widgets)

if(TARGET pkgmachete-cli)
    add_custom_command(TARGET PKGMachete POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:pkgmachete-cli> $<TARGET_FILE_DIR:PKGMachete>/pkgmachete-cli
    )
endif()
