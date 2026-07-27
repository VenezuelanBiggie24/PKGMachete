#include "pch.h"
#include "MainWindow.xaml.h"
#if __has_include("MainWindow.xaml.g.cpp")
#include "MainWindow.xaml.g.cpp"
#endif

#include <windows.h>
#include <iostream>
#include <vector>
#include <memory>
#include <wil/resource.h>

using namespace winrt;
using namespace Microsoft::UI::Xaml;

namespace winrt::PKGMachete::implementation
{
    MainWindow::MainWindow()
    {
#if __has_include("MainWindow.xaml.g.h")
        InitializeComponent();
#endif
    }

    winrt::Windows::Foundation::IAsyncAction MainWindow::MergeButton_Click(IInspectable const&, RoutedEventArgs const&)
    {
        MergeButton().IsEnabled(false);
        MergeProgress().Visibility(Visibility::Visible);
        MergeProgress().Value(0);
        StatusText().Text(L"Fusionando paquetes...");

        bool success = co_await MergeFilesAsync();
        co_await winrt::resume_foreground(DispatcherQueue());

        if (success)
        {
            StatusText().Text(L"Fusión completada exitosamente.");
            MergeProgress().Value(100);
        }
        else
        {
            StatusText().Text(L"Error al fusionar paquetes.");
            MergeProgress().Value(0);
        }

        MergeProgress().Visibility(Visibility::Collapsed);
        MergeButton().IsEnabled(true);
    }

    winrt::Windows::Foundation::IAsyncOperation<bool> MainWindow::MergeFilesAsync()
    {
        // Mantener viva la ventana durante la operación asíncrona
        auto lifetime = get_strong();

        // Cambiar al hilo de fondo para no bloquear la UI
        co_await winrt::resume_background();

        // Archivo de salida simulado
        LPCWSTR outputFilePath = L"output_merged.pkg";
        
        // Se crea el archivo con FILE_FLAG_NO_BUFFERING y OVERLAPPED (asíncrono)
        wil::unique_hfile hFile(CreateFileW(
            outputFilePath,
            GENERIC_WRITE,
            0,
            NULL,
            CREATE_ALWAYS,
            FILE_ATTRIBUTE_NORMAL | FILE_FLAG_NO_BUFFERING | FILE_FLAG_OVERLAPPED,
            NULL
        ));

        if (!hFile)
        {
            co_return false;
        }

        // Para NO_BUFFERING, los tamaños y direcciones en memoria deben estar alineados al tamaño de sector (típicamente 4KB)
        const size_t bufferSize = 4096 * 1024; // Buffer de 4MB
        
        struct VirtualFreeDeleter {
            void operator()(void* p) const { if (p) VirtualFree(p, 0, MEM_RELEASE); }
        };
        std::unique_ptr<void, VirtualFreeDeleter> buffer(VirtualAlloc(NULL, bufferSize, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE));
        
        if (!buffer)
        {
            co_return false;
        }

        // Simulamos llenado de datos del PKG chunk
        memset(buffer.get(), 0xAB, bufferSize);

        OVERLAPPED overlapped = { 0 };
        wil::unique_handle hEvent(CreateEvent(NULL, TRUE, FALSE, NULL));
        overlapped.hEvent = hEvent.get();

        if (!overlapped.hEvent)
        {
            co_return false;
        }

        DWORD bytesWritten = 0;
        
        // Escritura asíncrona usando WriteFile con la estructura OVERLAPPED
        BOOL result = WriteFile(
            hFile.get(),
            buffer.get(),
            (DWORD)bufferSize,
            &bytesWritten,
            &overlapped
        );

        if (!result)
        {
            if (GetLastError() == ERROR_IO_PENDING)
            {
                co_await winrt::resume_on_signal(overlapped.hEvent);
                if (!GetOverlappedResult(hFile.get(), &overlapped, &bytesWritten, FALSE))
                {
                    co_return false;
                }
            }
            else
            {
                // Fallo inmediato sin ERROR_IO_PENDING
                co_return false;
            }
        }

        // Volver al hilo principal (UI)
        co_await winrt::resume_foreground(DispatcherQueue());
        co_return true;
    }
}
