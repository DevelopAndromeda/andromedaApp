// WARNING: Please don't edit this file. It was generated by C++/WinRT v2.0.220418.1

#pragma once
#ifndef WINRT_Windows_Devices_Geolocation_Provider_1_H
#define WINRT_Windows_Devices_Geolocation_Provider_1_H
#include "winrt/impl/Windows.Devices.Geolocation.Provider.0.h"
WINRT_EXPORT namespace winrt::Windows::Devices::Geolocation::Provider
{
    struct __declspec(empty_bases) IGeolocationProvider :
        winrt::Windows::Foundation::IInspectable,
        impl::consume_t<IGeolocationProvider>
    {
        IGeolocationProvider(std::nullptr_t = nullptr) noexcept {}
        IGeolocationProvider(void* ptr, take_ownership_from_abi_t) noexcept : winrt::Windows::Foundation::IInspectable(ptr, take_ownership_from_abi) {}
    };
}
#endif
