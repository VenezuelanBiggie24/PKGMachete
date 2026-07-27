#include <jni.h>
#include <string>
#include <unistd.h>
#include <android/log.h>
#include <cerrno>
#include <cstring>

#define LOG_TAG "PKGMacheteNative"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

extern "C" JNIEXPORT jboolean JNICALL
Java_com_pkgmachete_port_MainActivity_processPkgNative(
        JNIEnv* env,
        jobject /* this */,
        jint fd) {
        
    LOGI("Descriptor de archivo recibido en C++: %d", fd);

    // Ejemplo de uso de pwrite con el descriptor de archivo proporcionado
    const char* data_to_write = "Datos de prueba de PKGMachete Port";
    size_t data_size = strlen(data_to_write);
    off_t offset = 0; // Posición en el archivo donde queremos escribir

    // Intentamos escribir en el archivo usando pwrite
    ssize_t bytes_written = pwrite(fd, data_to_write, data_size, offset);

    if (bytes_written == -1) {
        LOGE("Error en pwrite: %s", strerror(errno));
        return JNI_FALSE;
    }

    LOGI("Se escribieron exitosamente %zd bytes en el offset %ld usando pwrite", bytes_written, (long)offset);
    
    // Aquí se integraría la lógica real de manipulación del PKG en C++ usando el 'fd'
    
    return JNI_TRUE;
}
