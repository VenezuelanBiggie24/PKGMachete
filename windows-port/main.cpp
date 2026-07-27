#include "pch.h"
#include "App.xaml.h"
#include <winrt/Microsoft.UI.Xaml.h>

using namespace winrt;
using namespace Microsoft::UI::Xaml;

int __stdcall wWinMain(HINSTANCE, HINSTANCE, PWSTR, int)
{
    init_apartment(apartment_type::single_threaded);

    Application::Start([](auto&&)
    {
        make<winrt::PKGMachete::implementation::App>();
    });

    return 0;
}
