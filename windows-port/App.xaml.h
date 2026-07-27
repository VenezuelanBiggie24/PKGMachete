#pragma once

#if __has_include("App.xaml.g.h")
#include "App.xaml.g.h"
#endif

namespace winrt::PKGMachete::implementation
{
    struct App : AppT<App>
    {
        App();
        void OnLaunched(Microsoft::UI::Xaml::LaunchActivatedEventArgs const&);
    private:
        winrt::Microsoft::UI::Xaml::Window window{ nullptr };
    };
}
