#pragma once

#if __has_include("MainWindow.xaml.g.h")
#include "MainWindow.xaml.g.h"
#endif

namespace winrt::PKGMachete::implementation
{
    struct MainWindow : MainWindowT<MainWindow>
    {
        MainWindow();

        winrt::Windows::Foundation::IAsyncAction MergeButton_Click(winrt::Windows::Foundation::IInspectable const& sender, winrt::Microsoft::UI::Xaml::RoutedEventArgs const& args);
    
    private:
        winrt::Windows::Foundation::IAsyncOperation<bool> MergeFilesAsync();
    };
}

namespace winrt::PKGMachete::factory_implementation
{
    struct MainWindow : MainWindowT<MainWindow, implementation::MainWindow>
    {
    };
}
