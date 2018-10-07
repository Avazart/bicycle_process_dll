[Setup]
AppName=test
AppVerName=test
CreateAppDir=false
DefaultDirName={tmp}
Uninstallable=false
DisableWelcomePage=no

[Languages]
Name: ru; MessagesFile: compiler:Languages\russian.isl

[Files]
Source: "../build-bicycle_process-Desktop_Qt_5_9_1_MSVC2015_32bit-Release/release/bicycle_process.dll"; Flags: dontcopy solidbreak

[Code]
type Pointer= Integer;
type bi_process_handle= Pointer;
type ULong = DWORD;
type
  TMsg = record
    hwnd: HWND;
    message: UINT;
    wParam: Longint;
    lParam: Longint;
    time: DWORD;
    pt: TPoint;
  end;

const
  PM_REMOVE= 1;
  BufferSize= 512;
     
var
  OutputMemo: TMemo;
  RunButton: TButton;
  AppName,CmdLine,CurrentDir:String;

function PeekMessage(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; external 'PeekMessageA@user32.dll stdcall';
function TranslateMessage(const lpMsg: TMsg): BOOL; external 'TranslateMessage@user32.dll stdcall';
function DispatchMessage(const lpMsg: TMsg): Longint; external 'DispatchMessageA@user32.dll stdcall';

// bool bi_process_has_error(bi_process_handle handle);
function bi_process_has_error(h:bi_process_handle):Boolean;
   external 'bi_process_has_error@files:bicycle_process.dll cdecl delayload';

// const char*  bi_process_last_error(bi_process_handle handle);
function bi_process_last_error(h:bi_process_handle):PAnsiChar;
   external 'bi_process_last_error@files:bicycle_process.dll cdecl delayload';

// bi_process_handle   bi_process_create();
function  bi_process_create():bi_process_handle;
   external 'bi_process_create@files:bicycle_process.dll cdecl delayload';

// void bi_process_destroy(bi_process_handle handle);
procedure  bi_process_destroy(h:bi_process_handle);
   external 'bi_process_destroy@files:bicycle_process.dll cdecl delayload';

// void bi_process_set_app_name(bi_process_handle handle,const wchar_t* app_name);
procedure bi_process_set_app_name(h:bi_process_handle;const app_name:string);
   external 'bi_process_set_app_name@files:bicycle_process.dll cdecl delayload';

// void bi_process_set_cmd_line(bi_process_handle handle,const wchar_t* cmd_line);
procedure bi_process_set_cmd_line(h:bi_process_handle;const cmd_line:string);
   external 'bi_process_set_cmd_line@files:bicycle_process.dll cdecl delayload';

// void bi_process_set_current_dir(bi_process_handle handle,const wchar_t* current_dir);
procedure bi_process_set_current_dir(h:bi_process_handle;const current_dir:string);
   external '@files:bicycle_process.dll cdecl delayload';

// void bi_process_use_pipes(bi_process_handle handle,bool use_pipes);
procedure bi_process_use_pipes(h:bi_process_handle;use_pipes:Boolean);
   external 'bi_process_use_pipes@files:bicycle_process.dll cdecl delayload';

//void bi_process_set_startup_info_flags(bi_process_handle handle,ulong startup_info_flags);
procedure bi_process_set_startup_info_flags(h:bi_process_handle;startup_info_flags:DWORD);
   external 'bi_process_set_startup_info_flags@files:bicycle_process.dll cdecl delayload';

// void bi_process_set_inherit_handle(bi_process_handle handle,bool inherit_handle);
procedure bi_process_set_inherit_handle(h:bi_process_handle;inherit_handle:Boolean);
   external 'bi_process_set_inherit_handle@files:bicycle_process.dll cdecl delayload';

// void bi_process_set_security_inherit_handle(bi_process_handle handle,bool inherit_handle);
procedure bi_process_set_security_inherit_handle(h:bi_process_handle;inherit_handle:Boolean);
   external 'bi_process_set_security_inherit_handle@files:bicycle_process.dll cdecl delayload';

//void bi_process_set_show_window(bi_process_handle handle,unsigned short show_window);
procedure bi_process_set_show_window(h:bi_process_handle;show_window:WORD);
   external 'bi_process_set_show_window@files:bicycle_process.dll cdecl delayload';

//  bool bi_process_start(bi_process_handle handle);
function  bi_process_start(h:bi_process_handle):Boolean;
   external 'bi_process_start@files:bicycle_process.dll cdecl delayload';

// bool bi_process_start2(bi_process_handle handle, const wchar_t* app_name, const wchar_t* cmd_line);
function  bi_process_start2(h:bi_process_handle; const app_name:string; const cmd_line:string):Boolean;
   external 'bi_process_start2@files:bicycle_process.dll cdecl delayload';

// void bi_process_detach(bi_process_handle handle);
procedure bi_process_detach(h:bi_process_handle);
   external 'bi_process_detach@files:bicycle_process.dll cdecl delayload';

// ulong bi_process_pipe_stdout_read(bi_process_handle handle,char* data, ulong size);
function  bi_process_pipe_stdout_read(h:bi_process_handle;data:AnsiString;size:Ulong):ULong;
   external 'bi_process_pipe_stdout_read@files:bicycle_process.dll cdecl delayload';

// ulong bi_process_pipe_stdin_write(bi_process_handle handle,const char* data, ulong size);
function  bi_process_pipe_stdin_write(h:bi_process_handle;const data:AnsiString;size:Ulong):ULong;
   external 'bi_process_pipe_stdin_write@files:bicycle_process.dll cdecl delayload';


procedure ApplicationProcessMessages;
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, WizardForm.Handle, 0, 0, PM_REMOVE) do begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;

procedure RunButtonOnClick(Sender: TObject);
var
  h:bi_process_handle;
  Buffer: AnsiString;
  Size:ULong;
  Text:String;
begin
  CmdLine:=  'ping localhost';

  SetLength(Buffer,BufferSize);

  h:= bi_process_create();
  bi_process_set_cmd_line(h,CmdLine);
  bi_process_set_inherit_handle(h,true);
  bi_process_set_security_inherit_handle(h,true);
  bi_process_use_pipes(h,true);
  bi_process_set_show_window(h, SW_HIDE);
  
  if not bi_process_start(h) then
  begin
     MsgBox(bi_process_last_error(h), mbError, MB_YESNO);
     bi_process_destroy(h);
     Exit;
  end;

   repeat
     begin;
       SetLength(Buffer,BufferSize);
       Size:= bi_process_pipe_stdout_read(h,PAnsiChar(Buffer),BufferSize-1);
       if Size>0 then
         begin
            SetLength(Buffer,Size);
            OemToCharBuff(Buffer);
            Text:= Buffer;
            OutputMemo.Text:=  OutputMemo.Text+ Text; 
            ApplicationProcessMessages();
         end;   
     end;
   until(bi_process_has_error(h) or (Size<=0));
       
   bi_process_destroy(h);
end;

///////////////////////////
procedure InitializeWizard;
begin
  WizardForm.OuterNotebook.Hide;

  OutputMemo := TMemo.Create(WizardForm);
  with OutputMemo do
  begin
    Parent := WizardForm;
    SetBounds(WizardForm.OuterNotebook.Left, WizardForm.OuterNotebook.Top, WizardForm.OuterNotebook.Width, WizardForm.OuterNotebook.Height);
    ScrollBars := ssVertical;
    ReadOnly := True;
  #ifdef IS_ENHANCED
    DoubleBuffered := True;
  #endif
  end;

  RunButton := TButton.Create(WizardForm);
  with RunButton do
  begin
    Parent := WizardForm;
    SetBounds(WizardForm.OuterNotebook.Left, WizardForm.NextButton.Top, WizardForm.NextButton.Width, WizardForm.NextButton.Height);
    Caption := 'Run';
    OnClick := @RunButtonOnClick;
  end;
end;

//////////////////////////////////////////////////////
function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := False;
end;