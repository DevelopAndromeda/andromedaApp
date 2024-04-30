// WARNING: Please don't edit this file. It was generated by C++/WinRT v2.0.220418.1

#pragma once
#ifndef WINRT_Windows_Devices_Printers_Extensions_2_H
#define WINRT_Windows_Devices_Printers_Extensions_2_H
#include "winrt/impl/Windows.Devices.Printers.Extensions.1.h"
WINRT_EXPORT namespace winrt::Windows::Devices::Printers::Extensions
{
    struct __declspec(empty_bases) Print3DWorkflow : winrt::Windows::Devices::Printers::Extensions::IPrint3DWorkflow,
        impl::require<Print3DWorkflow, winrt::Windows::Devices::Printers::Extensions::IPrint3DWorkflow2>
    {
        Print3DWorkflow(std::nullptr_t) noexcept {}
        Print3DWorkflow(void* ptr, take_ownership_from_abi_t) noexcept : winrt::Windows::Devices::Printers::Extensions::IPrint3DWorkflow(ptr, take_ownership_from_abi) {}
    };
    struct __declspec(empty_bases) Print3DWorkflowPrintRequestedEventArgs : winrt::Windows::Devices::Printers::Extensions::IPrint3DWorkflowPrintRequestedEventArgs
    {
        Print3DWorkflowPrintRequestedEventArgs(std::nullptr_t) noexcept {}
        Print3DWorkflowPrintRequestedEventArgs(void* ptr, take_ownership_from_abi_t) noexcept : winrt::Windows::Devices::Printers::Extensions::IPrint3DWorkflowPrintRequestedEventArgs(ptr, take_ownership_from_abi) {}
    };
    struct __declspec(empty_bases) Print3DWorkflowPrinterChangedEventArgs : winrt::Windows::Devices::Printers::Extensions::IPrint3DWorkflowPrinterChangedEventArgs
    {
        Print3DWorkflowPrinterChangedEventArgs(std::nullptr_t) noexcept {}
        Print3DWorkflowPrinterChangedEventArgs(void* ptr, take_ownership_from_abi_t) noexcept : winrt::Windows::Devices::Printers::Extensions::IPrint3DWorkflowPrinterChangedEventArgs(ptr, take_ownership_from_abi) {}
    };
}
#endif
