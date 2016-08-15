program tgbp;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  SysUtils,
  CustApp,
  fpjson,
  jsonparser,
  inifiles,
  dateutils,
  Process,
  // internal classes
  uKeyboardCls, uOtherFunctions;

type


  Msg = record
    chat_id: cardinal;
    date: cardinal;
    Text: string;
    msg_id: int64;
  end;

  Steping = record
    chat_id: cardinal;
    step: cardinal;
  end;

  TMsg = array of Msg;


  // const lis


  { TTgBotSKD }

  TTgBotSKD = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

  { TTgBotSKD }


const

  REC_START = '/start';

  // gobal variables
var

  cback: TStringStream;
  ini: tinifile;
  StepStore: array of Steping;





  procedure TTgBotSKD.DoRun;
  var
    ErrorMsg: string;
  begin
    // quick check parameters
    ErrorMsg := CheckOptions('h', 'help');
    if ErrorMsg <> '' then
    begin
      ShowException(Exception.Create(ErrorMsg));
      Terminate;
      Exit;
    end;

    // parse parameters
    if HasOption('h', 'help') then
    begin
      WriteHelp;
      Terminate;
      Exit;
    end;

    { add your program here }

    // stop program loop
    Terminate;
  end;

  constructor TTgBotSKD.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    //ini := TIniFile.Create();
    WriteLn(GetAppDir());
  end;

  destructor TTgBotSKD.Destroy;
  begin
    inherited Destroy;
  end;

  procedure TTgBotSKD.WriteHelp;
  begin
    { add your help code here }
    writeln('Usage: ', ExeName, ' -h');
  end;

var
  Application: TTgBotSKD;
begin
  Application := TTgBotSKD.Create(nil);
  Application.Title := 'Telegram Bot SDK';
  Application.Run;
  Application.Free;
end.


