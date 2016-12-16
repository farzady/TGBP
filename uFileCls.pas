unit uFileCls;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,process;

type
  TgFile = class(TObject)
  public
    constructor Create(tgUrl:String);
    function SendFileFromUrl(chat_id,fileUrl,caption:String;var mem: TMemoryStream):Boolean;
    function SendFileFromLocation(chat_id,fullAddPath,caption:String;var mem: TMemoryStream):Boolean;
    //function
  private
  var
     _TgURL_ : String;
  protected

  end;

implementation

constructor TgFile.Create(tgUrl:String);
begin
  _TgURL_ := tgUrl;
end;



function TgFile.SendFileFromLocation(chat_id,fullAddPath,caption:String;var mem: TMemoryStream):Boolean;
  var
    r: string;
  begin
    if RunCommand('/usr/bin/curl', ['-o', ExtractFileDir(ExeName) +
      '/catch', _TgURL_ + 'chat_id='+ chat_id + '&caption='+ caption, '-H',
      'Content-Type:multipart/form-data','--form','photo=@'+fullAddPath+';type=image/jpeg'],
      r) then
    begin
      mem.LoadFromFile(ExtractFileDir(ExeName) + '/catch');
    end;
    Result := True;

  end;



function TgFile.SendFileFromUrl(chat_id,fileUrl,caption:String;var mem: TMemoryStream):Boolean;
  var
    r: string;
  begin

    if RunCommand('/usr/bin/curl', ['-o', ExtractFileDir(ExeName) +
      '/tmp', fileUrl, r) then
    begin
      Result := SendFileFromLocation(chat_id,ExtractFileDir(ExeName) +
      '/tmp',caption,mem);
    end
    else
    begin
      Result := False;
      Exit;
    end;
    //WriteLn('/usr/bin/curl',['-o',ExtractFileDir(ExeName)+'/catch',url]);

  end;

end.


