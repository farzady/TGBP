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
  uKeyboardCls, uOtherFunctions, uFileCls;

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
  private
    function HttpGetBinaryEx(url: string; var mem: TMemoryStream): boolean;
    function BotInit(): boolean;
  end;

  { TTgBotSKD }


const

  REC_START = '/start';

  // gobal variables
var

  cback: TStringStream;
  ini: tinifile;
  StepStore: array of Steping;
  BOT_TOKKEN,URL_REQ: String;
  mstr: tmemorystream;
  JsonDoc: TJSONObject;
  JsonParsera: TJSONParser;




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

    BotInit();

    // stop program loop
    Terminate;
  end;

  constructor TTgBotSKD.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    ini := TIniFile.Create(GetAppDir()+'/config.ini');
    { // init ini file
    ini.WriteString('APP','TOKKEN','123xxxxxxxx');
    ini.WriteString('APP','LAST_MESSAGE','0');
    // end init ini file }
    BOT_TOKKEN:=ini.ReadString('APP','TOKKEN','');
    URL_REQ :=  'https://api.telegram.org/bot' + BOT_TOKKEN + '/';


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

function TTgBotSKD.HttpGetBinaryEx(url: string; var mem: TMemoryStream): boolean;
  var
    r: string;
  begin
    //WriteLn('/usr/bin/curl',['-o',ExtractFileDir(ExeName)+'/catch',url]);
    if RunCommand('/usr/bin/curl', ['-o', ExtractFileDir(ExeName) +
      '/catch', url, '-H',
      'Content-Type: application/x-www-form-urlencoded; charset: UTF-8'],
      r) then
    begin
      mem.LoadFromFile(ExtractFileDir(ExeName) + '/catch');
    end;
    Result := True;
  end;


function TTgBotSKD.BotInit(): boolean;

  begin
    mstr := TMemoryStream.Create;
    try
      if HttpGetBinaryEx(URL_REQ + 'getMe', mstr) then
      begin
        mstr.position := 0;
        JsonParsera := TJSONParser.Create(mstr);
        JsonDoc := TJSONObject(JsonParsera.Parse);

        if jsonDoc.findpath('ok').AsBoolean then
        begin
          WriteLn('@' + jsonDoc.findpath('result.username').AsString);
        end;
      end
      else
      begin
        WriteLn('cant init bot...');
        halt(0);
      end;

    finally
      //HTTPClient.Free
    end;
    Result := True;

  end;


var
  Application: TTgBotSKD;
begin
  Application := TTgBotSKD.Create(nil);
  Application.Title := 'Telegram Bot SDK';
  Application.Run;
  Application.Free;
end.


