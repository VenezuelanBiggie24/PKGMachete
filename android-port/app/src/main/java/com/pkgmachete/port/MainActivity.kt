package com.pkgmachete.port

import android.net.Uri
import android.os.Bundle
import android.os.ParcelFileDescriptor
import android.util.Log
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity : AppCompatActivity() {

    companion object {
        init {
            System.loadLibrary("pkgmachete")
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // setContentView(R.layout.activity_main)

        // Ejemplo: abrir el selector de archivos al iniciar la actividad
        openFilePicker()
    }

    private val openDocumentLauncher = registerForActivityResult(ActivityResultContracts.OpenDocument()) { uri: Uri? ->
        uri?.let {
            processFile(it)
        }
    }

    private fun openFilePicker() {
        // Abre el SAF (Storage Access Framework) para seleccionar un archivo
        openDocumentLauncher.launch(arrayOf("*/*"))
    }

    private fun processFile(uri: Uri) {
        lifecycleScope.launch(Dispatchers.IO) {
            try {
                // Usamos ContentResolver para obtener el ParcelFileDescriptor con permisos de lectura/escritura ("rw")
                contentResolver.openFileDescriptor(uri, "rw")?.use { pfd ->
                    // Extraemos el descriptor de archivo (int fd) real
                    val fd = pfd.fd
                    Log.d("PKGMachete", "Descriptor de archivo obtenido: $fd")
                    
                    // Pasamos el descriptor a la capa nativa (C++)
                    val result = processPkgNative(fd)
                    Log.d("PKGMachete", "Resultado del procesamiento nativo: $result")
                }
            } catch (e: Exception) {
                Log.e("PKGMachete", "Error al procesar el archivo: ${e.message}")
            }
        }
    }

    // Declaración del método nativo en C++
    private external fun processPkgNative(fd: Int): Boolean
}
