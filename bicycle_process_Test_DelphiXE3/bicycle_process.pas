unit bicycle_process;

interface

uses Windows;

const LibraryName = 'bicycle_process.dll';

type bi_process_handle= Pointer;

// bool bi_process_has_error(bi_process_handle handle);
function bi_process_has_error(h:bi_process_handle):Boolean;
   cdecl; external LibraryName name 'bi_process_has_error';

// const char*  bi_process_last_error(bi_process_handle handle);
function bi_process_last_error(h:bi_process_handle):PAnsiChar;
   cdecl; external LibraryName name 'bi_process_last_error';

// bi_process_handle   bi_process_create();
function  bi_process_create():bi_process_handle;
   cdecl; external LibraryName name 'bi_process_create';

// void bi_process_destroy(bi_process_handle handle);
procedure  bi_process_destroy(h:bi_process_handle);
   cdecl; external LibraryName name 'bi_process_destroy';

// void bi_process_set_app_name(bi_process_handle handle,const wchar_t* app_name);
procedure bi_process_set_app_name(h:bi_process_handle;const app_name:PChar);
   cdecl; external LibraryName name 'bi_process_set_app_name';

// void bi_process_set_cmd_line(bi_process_handle handle,const wchar_t* cmd_line);
procedure bi_process_set_cmd_line(h:bi_process_handle;const cmd_line:PChar);
   cdecl; external LibraryName name 'bi_process_set_cmd_line';

// void bi_process_set_current_dir(bi_process_handle handle,const wchar_t* current_dir);
procedure bi_process_set_current_dir(h:bi_process_handle;const current_dir:PChar);
   cdecl; external LibraryName name 'bi_process_set_current_dir';

// void bi_process_use_pipes(bi_process_handle handle,bool use_pipes);
procedure bi_process_use_pipes(h:bi_process_handle;use_pipes:Boolean);
   cdecl; external LibraryName name 'bi_process_use_pipes';

//void bi_process_set_startup_info_flags(bi_process_handle handle,ulong startup_info_flags);
procedure bi_process_set_startup_info_flags(h:bi_process_handle;startup_info_flags:DWORD);
   cdecl; external LibraryName name 'bi_process_set_startup_info_flags';

// void bi_process_set_inherit_handle(bi_process_handle handle,bool inherit_handle);
procedure bi_process_set_inherit_handle(h:bi_process_handle;inherit_handle:Boolean);
   cdecl; external LibraryName name 'bi_process_set_inherit_handle';

// void bi_process_set_security_inherit_handle(bi_process_handle handle,bool inherit_handle);
procedure bi_process_set_security_inherit_handle(h:bi_process_handle;inherit_handle:Boolean);
   cdecl; external LibraryName name 'bi_process_set_security_inherit_handle';

//void bi_process_set_show_window(bi_process_handle handle,unsigned short show_window);
procedure bi_process_set_show_window(h:bi_process_handle;show_window:WORD);
   cdecl; external LibraryName name 'bi_process_set_show_window';

//  bool bi_process_start(bi_process_handle handle);
function  bi_process_start(h:bi_process_handle):Boolean;
   cdecl; external LibraryName name 'bi_process_start';

// bool bi_process_start2(bi_process_handle handle, const wchar_t* app_name, const wchar_t* cmd_line);
function  bi_process_start2(h:bi_process_handle; const app_name:PChar; const cmd_line:PChar):Boolean;
   cdecl; external LibraryName name 'bi_process_start2';

// void bi_process_detach(bi_process_handle handle);
procedure bi_process_detach(h:bi_process_handle);
   cdecl; external LibraryName name 'bi_process_detach';

// ulong bi_process_pipe_stdout_read(bi_process_handle handle,char* data, ulong size);
function  bi_process_pipe_stdout_read(h:bi_process_handle;data:PAnsiChar;size:Ulong):ULong;
   cdecl; external LibraryName name 'bi_process_pipe_stdout_read';

// ulong bi_process_pipe_stdin_write(bi_process_handle handle,const char* data, ulong size);
function  bi_process_pipe_stdin_write(h:bi_process_handle;const data:PAnsiChar;size:Ulong):ULong;
   cdecl; external LibraryName name 'bi_process_pipe_stdin_write';

//work_thread bi_c_process_create_and_start(const wchar_t* app_name,
//                                          const wchar_t* cmd_line,
//                                          const wchar_t* current_dir,
//                                          HWND logWindowHandle);


function  bi_c_process_create_and_start(const app_name:PChar;
                                        const cmd_line:PChar;
                                        const current_dir:PChar;
                                        logWindowHandle:HWND):Pointer;
   cdecl; external LibraryName name 'bi_c_process_create_and_start';


// ulong bi_c_process_wait_for_finished(work_thread thread,ulong msecs);
function  bi_c_process_wait_for_finished(h:Pointer;
                                         msecs:ULong):Ulong;
   cdecl; external LibraryName name 'bi_c_process_wait_for_finished';

implementation

end.
