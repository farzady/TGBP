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
  Process;

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




  function sHTTPEncode(const AStr: string): string;
  const
    NoConversion = ['A'..'Z', 'a'..'z', '*', '@', '.', '_', ';', '-',
      '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
  var
    Sp, Rp: PChar;

  begin

    SetLength(Result, Length(AStr) * 3);
    Sp := PChar(AStr);
    Rp := PChar(Result);
    while Sp^ <> #0 do
    begin
      if Sp^ in NoConversion then
        Rp^ := Sp^
      else if Sp^ = ' ' then
        Rp^ := '+'
      else
      begin
        FormatBuf(Rp^, 3, '%%%.2x', 6, [Ord(Sp^)]);
        Inc(Rp, 2);
      end;
      Inc(Rp);
      Inc(Sp);
    end;
    SetLength(Result, Rp - PChar(Result));
  end;




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


