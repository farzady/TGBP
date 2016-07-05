program tgbp;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

type

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

procedure TTgBotSKD.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
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
  Application:=TTgBotSKD.Create(nil);
  Application.Title:='Telegram Bot SDK';
  Application.Run;
  Application.Free;
end.

