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
Source: "InnoCallback.dll"; DestDir: "{tmp}"; Flags: dontcopy

[Code]
#ifdef UNICODE
  #define AW "W"
#else
  #define AW "A"
#endif

const
  GWL_WNDPROC = -4;
  WM_USER = $0400; 
  CONSOLE_READ_DATA_MSG= WM_USER+1;
  CONSOLE_FINISHED_MSG= WM_USER+2;
  ERROR_BROKEN_PIPE =  109;// 0x6D

type
  Pointer= Integer;
  ULong = DWORD;

  WPARAM = UINT_PTR;
  LPARAM = LongInt;
  LRESULT = LongInt;

  TWindowProc = function(hwnd: HWND; uMsg: UINT; wParam: WPARAM; 
    lParam: LPARAM): LRESULT;

var
  OutputMemo: TMemo;
  OldWndProc: LongInt;
  ConsoleFinished: Boolean;
  thread:Pointer;

function CallWindowProc(lpPrevWndFunc: LongInt; hWnd: HWND; Msg: UINT;wParam: WPARAM; lParam: LPARAM): LRESULT;
  external 'CallWindowProc{#AW}@user32.dll stdcall';
function SetWindowLong(hWnd: HWND; nIndex: Integer;dwNewLong: LongInt): LongInt;
  external 'SetWindowLong{#AW}@user32.dll stdcall';
function WrapWindowProc(Callback: TWindowProc; ParamCount: Integer): LongWord;
  external 'wrapcallback@files:InnoCallback.dll stdcall';

{
   work_thread bi_c_process_create_and_start(wchar_t *app_name,
                                             wchar_t *cmd_line, 
                                             wchar_t *current_dir,
                                             HWND mainWindowHandle, 
                                             UINT readDataMessage, 
                                             UINT finishedMessage,
                                             bool decodeOEM);
}
function bi_c_process_create_and_start(const app_name:String; 
                                       const cmd_line:String; 
                                       const current_dir:String;
                                       mainWindowHandle:HWND; 
                                       readDataMessage: UINT; 
                                       finishedMessage: UINT;
                                       decodeOEM: Boolean):Pointer;
  external 'bi_c_process_create_and_start@files:bicycle_process.dll cdecl delayload';

{ void bi_c_process_destroy(work_thread thread); }
procedure bi_c_process_destroy(thread :Pointer);
  external 'bi_c_process_destroy@files:bicycle_process.dll cdecl delayload';

{ ulong   bi_c_process_last_error_code(work_thread thread);}
function bi_c_process_last_error_code(thread :Pointer):Ulong;
  external 'bi_c_process_last_error_code@files:bicycle_process.dll cdecl delayload';

{ const char*  bi_c_process_last_error(work_thread thread); }
function bi_c_process_last_error(thread :Pointer):PAnsiChar;
  external 'bi_c_process_last_error@files:bicycle_process.dll cdecl delayload';

{ ulong  bi_c_process_exit_code(work_thread thread); }
function bi_c_process_exit_code(thread :Pointer):ULong;
  external 'bi_c_process_exit_code@files:bicycle_process.dll cdecl delayload';

procedure WizardFormShow(Sender: TObject);
begin
//
end;

#IFDEF UNICODE
function BufferToAnsi(const Buffer: string): AnsiString;
var
  W: Word;
  I: Integer;
begin
  SetLength(Result, Length(Buffer) * 2);
  for I := 1 to Length(Buffer) do
  begin
    W := Ord(Buffer[I]);
    Result[(I * 2)] := Chr(W shr 8); // high byte
    Result[(I * 2) - 1] := Chr(Byte(W)); // low byte
  end;
end;
#ENDIF

function WizardFormWndProc(hwnd: HWND; uMsg: UINT; w: WPARAM; l: LPARAM): LRESULT;
var 
  data:AnsiString;
  lastErrorCode:Ulong;
begin
  case uMsg of

    CONSOLE_READ_DATA_MSG:
    begin
      data:= BufferToAnsi(CastIntegerToString(l));       
      OutputMemo.Lines.Text := OutputMemo.Lines.Text + data;
    end;

    CONSOLE_FINISHED_MSG:
    begin
       Wizardform.NextButton.Enabled := True;
       ConsoleFinished:= True;
       lastErrorCode:= bi_c_process_last_error_code(thread);       

       if (lastErrorCode<>0) and (lastErrorCode<>ERROR_BROKEN_PIPE) then
          OutputMemo.Lines.Add('Error #'+
                               IntToStr(bi_c_process_last_error_code(thread))+
                               ': "'+AnsiString(bi_c_process_last_error(thread))+'"')
       else       
          OutputMemo.Lines.Add('Exit Code: '+IntToStr(bi_c_process_exit_code(thread)));

       bi_c_process_destroy(thread);
    end;
  end;

  Result := CallWindowProc(OldWndProc, hwnd, uMsg, w, l);
end;

procedure InitializeWizard;
begin
  ConsoleFinished:= False;

  OldWndProc := SetWindowLong(WizardForm.Handle, GWL_WNDPROC,WrapWindowProc(@WizardFormWndProc, 4));
  WizardForm.OnShow := @WizardFormShow;

  WizardForm.OuterNotebook.Hide;
  OutputMemo := TMemo.Create(WizardForm);
  with OutputMemo do
  begin
    Parent := WizardForm;
    SetBounds(WizardForm.OuterNotebook.Left, 
              WizardForm.OuterNotebook.Top, 
              WizardForm.OuterNotebook.Width, 
              WizardForm.OuterNotebook.Height);

    ScrollBars := ssVertical;
    ReadOnly := True;
  #ifdef IS_ENHANCED
    DoubleBuffered := True;
  #endif
  end;
end;

//////////////////////////////////////////////////////
function NextButtonClick(CurPageID: Integer): Boolean;
var
  AppName,CmdLine,CurrentDir:String;
begin
  if (not ConsoleFinished) and (CurPageID=1)  then
  begin 
     AppName:='';
     CmdLine:='ping google.com';
     
     thread:= bi_c_process_create_and_start(AppName,CmdLine,
                                            CurrentDir,
                                            WizardForm.Handle, 
                                            CONSOLE_READ_DATA_MSG, 
                                            CONSOLE_FINISHED_MSG,
                                            true);

     Wizardform.NextButton.Enabled:= False;
     Result:= False;
  end
  else if ConsoleFinished then 
  begin
      Result:= True;
      OutputMemo.Hide;
  end;
end;

procedure DeinitializeSetup;
begin
  SetWindowLong(WizardForm.Handle, GWL_WNDPROC, OldWndProc);
end;



