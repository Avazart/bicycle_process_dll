#ifndef BICYCLE_PROCESS_H
#define BICYCLE_PROCESS_H
//-----------------------------------------------------------------------------------------------------------
#include <Windows.h>
//-----------------------------------------------------------------------------------------------------------
#ifdef BI_PROCESS_LIBRARY
  #define BI_PROCESS_EXPORT extern "C" __declspec(dllexport)
#else
  #define BI_PROCESS_EXPORT extern "C" __declspec(dllimport)
#endif
//===========================================================================================================
typedef void* bi_process_handle;
typedef unsigned long ulong;

BI_PROCESS_EXPORT bool bi_process_has_error(bi_process_handle handle);
BI_PROCESS_EXPORT const char*  bi_process_last_error(bi_process_handle handle);
BI_PROCESS_EXPORT ulong bi_process_last_error_code(bi_process_handle handle);
BI_PROCESS_EXPORT void bi_process_clear_last_error(bi_process_handle handle);

BI_PROCESS_EXPORT bi_process_handle   bi_process_create();
BI_PROCESS_EXPORT void bi_process_destroy(bi_process_handle handle);

BI_PROCESS_EXPORT void bi_process_set_app_name(bi_process_handle handle,const wchar_t* app_name);
BI_PROCESS_EXPORT void bi_process_set_cmd_line(bi_process_handle handle,const wchar_t* cmd_line);
BI_PROCESS_EXPORT void bi_process_set_current_dir(bi_process_handle handle,const wchar_t* current_dir);
BI_PROCESS_EXPORT void bi_process_use_pipes(bi_process_handle handle,bool use_pipes);
BI_PROCESS_EXPORT void bi_process_set_startup_info_flags(bi_process_handle handle,ulong startup_info_flags);
BI_PROCESS_EXPORT void bi_process_set_inherit_handle(bi_process_handle handle,bool inherit_handle);
BI_PROCESS_EXPORT void bi_process_set_security_inherit_handle(bi_process_handle handle,bool inherit_handle);
BI_PROCESS_EXPORT void bi_process_set_show_window(bi_process_handle handle,unsigned short show_window);

BI_PROCESS_EXPORT bool bi_process_start(bi_process_handle handle);
BI_PROCESS_EXPORT bool bi_process_start2(bi_process_handle handle,
                                         const wchar_t* app_name,
                                         const wchar_t* cmd_line);

BI_PROCESS_EXPORT void bi_process_terminate(bi_process_handle handle,unsigned exit_code);
BI_PROCESS_EXPORT void bi_process_close_windows(bi_process_handle handle);
BI_PROCESS_EXPORT void bi_process_detach(bi_process_handle handle);
BI_PROCESS_EXPORT void bi_process_cancel(bi_process_handle handle);

BI_PROCESS_EXPORT HANDLE bi_process_process_handle(bi_process_handle handle);
BI_PROCESS_EXPORT HANDLE bi_process_thread_handle(bi_process_handle handle);
BI_PROCESS_EXPORT ulong bi_process_process_id(bi_process_handle handle);
BI_PROCESS_EXPORT ulong bi_process_thread_id(bi_process_handle handle);

BI_PROCESS_EXPORT ulong bi_process_pipe_stdout_read(bi_process_handle handle,char* data, ulong size);
BI_PROCESS_EXPORT ulong bi_process_pipe_stdin_write(bi_process_handle handle,const char* data, ulong size);

BI_PROCESS_EXPORT void bi_process_pipe_stdout_set_buffer_size(bi_process_handle handle,ulong size);
BI_PROCESS_EXPORT void bi_process_pipe_stdout_set_timeout(bi_process_handle handle,ulong msecs);
//===========================================================================================================
typedef void* work_thread;


BI_PROCESS_EXPORT work_thread bi_c_process_create_and_start(const wchar_t *app_name,
                                                     const wchar_t *cmd_line,
                                                     const wchar_t *current_dir,
                                                     HWND mainWindowHandle,
                                                     UINT readDataMessage,
                                                     UINT finishedMessage,
                                                     bool decodeOEM);

BI_PROCESS_EXPORT void bi_c_process_cancel(work_thread thread);
BI_PROCESS_EXPORT ulong bi_c_process_wait_for_finished(work_thread thread,ulong msecs);
BI_PROCESS_EXPORT void bi_c_process_destroy(work_thread thread);

BI_PROCESS_EXPORT ulong  bi_c_process_exit_code(work_thread thread);
BI_PROCESS_EXPORT ulong bi_c_process_work_thread_handle(work_thread thread);

BI_PROCESS_EXPORT ulong  bi_c_process_last_error_code(work_thread thread);
BI_PROCESS_EXPORT const char*  bi_c_process_last_error(work_thread thread);
BI_PROCESS_EXPORT bool   bi_c_process_has_error(work_thread thread);


//===========================================================================================================
#endif // BICYCLE_PROCESS_H
