//---------------------------------------------------------------------------
#include "Global.h"
//---------------------------------------------------------------------------
const std::string Bicycle::CRLF=std::string("\r\n");
const Bicycle::ulong Bicycle::DEFAULT_BUFF_SIZE= 10*1024*1024; // 10 MB
const Bicycle::ulong Bicycle::DEFAULT_TIMEOUT= INFINITE;
//---------------------------------------------------------------------------
std::string Bicycle::formatMessage(ulong code, const tstring &moduleName)
{
  bool useModule= !moduleName.empty();
  HMODULE module = useModule?GetModuleHandle(moduleName.c_str()):nullptr;

  LPSTR errorMsg = nullptr;   // will be allocated and filled by FormatMessage
  ulong r= FormatMessageA(
                FORMAT_MESSAGE_ALLOCATE_BUFFER |
                FORMAT_MESSAGE_FROM_SYSTEM |
                (useModule?FORMAT_MESSAGE_FROM_HMODULE:0) |
                FORMAT_MESSAGE_ALLOCATE_BUFFER |
                FORMAT_MESSAGE_IGNORE_INSERTS |
                FORMAT_MESSAGE_ARGUMENT_ARRAY, // use windows internal message table
             module,       // 0 since source is internal message table
             code,    // this is the error code
             // Could just as well have been an error code from generic
             // Windows errors from GetLastError()
             MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),       // auto-determine language to use
             (LPSTR)&errorMsg,
             0,       // min length for buffer
             nullptr);

  return r?errorMsg:"Can not get error code description!";
}
//---------------------------------------------------------------------------
std::wstring Bicycle::formatMessageW(ulong code, const tstring &moduleName)
{
  bool useModule= !moduleName.empty();
  HMODULE module = useModule?GetModuleHandle(moduleName.c_str()):nullptr;

  LPTSTR errorMsg = nullptr;   // will be allocated and filled by FormatMessage
  ulong r= FormatMessage(
             FORMAT_MESSAGE_ALLOCATE_BUFFER |
             FORMAT_MESSAGE_FROM_SYSTEM |
             (useModule?FORMAT_MESSAGE_FROM_HMODULE:0) |
             FORMAT_MESSAGE_ALLOCATE_BUFFER |
             FORMAT_MESSAGE_IGNORE_INSERTS |
             FORMAT_MESSAGE_ARGUMENT_ARRAY, // use windows internal message table
             module,       // 0 since source is internal message table
             code,    // this is the error code
             // Could just as well have been an error code from generic
             // Windows errors from GetLastError()
             MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),       // auto-determine language to use
             (LPTSTR)&errorMsg,
             0,       // min length for buffer
             nullptr);

  return r?errorMsg:L"Не удалось получить описание ошибки.";
}
//---------------------------------------------------------------------------
Bicycle::tstring Bicycle::appModuleFileName()
{
  tstring filePath(MAX_PATH,L'\0');
  ulong length= GetModuleFileName(nullptr, &filePath[0], filePath.size());
  filePath.resize(length);
  return filePath;
}
//---------------------------------------------------------------------------
