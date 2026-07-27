cmake_minimum_required(VERSION 3.22.1)

project("pkgmachete")

# Agregar la librería compartida que compila nuestro código C++
add_library(
        pkgmachete
        SHARED
        native-lib.cpp)

# Encontrar la librería de logging de Android
find_library(
        log-lib
        log)

# Vincular nuestra librería con la librería de log de Android
target_link_libraries(
        pkgmachete
        ${log-lib})
