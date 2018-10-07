unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  bicycle_process;

type
  TForm1 = class(TForm)
    RichEdit1: TRichEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type OEMString = type AnsiString(866);

procedure TForm1.Button1Click(Sender: TObject);
const
  BufferSize= 512;
var
  h:bi_process_handle;
  AppName,CmdLine:String;
  Buffer: array [0..BufferSize] of AnsiChar;
  Size:ULong;
  Text:String;
begin
  CmdLine:=  'ping localhost';

  h:= bi_process_create();
  bi_process_set_cmd_line(h,PChar(CmdLine));
  bi_process_set_inherit_handle(h,true);
  bi_process_set_security_inherit_handle(h,true);
  bi_process_use_pipes(h,true);
  bi_process_set_show_window(h, SW_HIDE);
  
  if not bi_process_start(h) then
  begin
     ShowMessage(bi_process_last_error(h));
     bi_process_destroy(h);
     Exit;
  end;

   repeat
     begin;
       Size:= bi_process_pipe_stdout_read(h,Buffer,BufferSize-1);
       if Size>0 then
         begin
            Buffer[Size]:= Chr(0);            
            Text:=  OEMString(Buffer);

            SendMessage(RichEdit1.Handle, EM_SETSEL,-1, -1);                        
            SendMessage(RichEdit1.Handle, EM_REPLACESEL, 1, NativeInt(PChar(Text)));
            
            Application.ProcessMessages;
         end;   
     end;
   until(bi_process_has_error(h) or (Size<=0));
       
   RichEdit1.Lines.Add(AnsiString(bi_process_last_error(h)));
   bi_process_destroy(h);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  AppName,CmdLine,CurrentDir:String;
  h:Pointer;
begin
  CmdLine:=  'ping localhost';

  h:= bi_c_process_create_and_start(PChar(AppName),
                                   PChar(CmdLine),
                                   PChar(CurrentDir),
                                   RichEdit1.Handle);

 // bi_c_process_wait_for_finished(h,60000);



end;


end.
