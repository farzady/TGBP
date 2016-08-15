unit uKeyboardCls;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils;

type

  TgKeyboard = class(TObject)
  public
     constructor Create();
     procedure AddBtn(Title:string);
     procedure EOL();
     procedure Clear();
     function Render():string;
     function Hide():string;
  private
     var
        IsLineStarted,IsRendered : Boolean;
        Buffer: String;
     const
       DEF_STR = '{"keyboard":[%btns%]}' ;
       HIDE_KEYBORAD = '{"keyboard":[],"hide_keyboard":true}' ;
  protected

  end;


  TgInlineKeyboard = class(TObject)
  public
     constructor Create();
     procedure AddBtn(Title,CallBack:string);
     procedure EOL();
     procedure Clear();
     function Render():string;
  private
     var
        IsLineStarted,IsRendered : Boolean;
        Buffer: String;
     const
       DEF_STR = '{"inline_keyboard":[%btns%]}' ;
  protected

  end;

implementation

constructor TgKeyboard.Create();
begin
  IsLineStarted:= false;
  IsRendered := false;
  Buffer:= '' ;
end;

procedure TgKeyboard.Clear();
begin
  Buffer:= '' ;
end;

procedure TgKeyboard.EOL();
begin
  if not IsLineStarted  then
 begin
   Exit;
 end;
  Delete(Buffer,length(Buffer),1);
  Buffer += '],' ;
  IsLineStarted:= false;
  IsRendered := false;
end;


procedure TgKeyboard.AddBtn(Title:string);

begin
 if not IsLineStarted  then
 begin
   Buffer += '[' ;
   IsLineStarted := true ;
 end;
 Buffer += '"'+Title+'",' ;
 IsRendered := false;
end;


function TgKeyboard.Render():string;
begin
  if IsRendered then
  begin
    Result := Buffer;
    Exit;
  end;
  if IsLineStarted then
  begin
    EOL();
  end;
  Delete(Buffer,length(Buffer),1);
  //Buffer += ']' ;
  IsRendered := true;
  Result := StringReplace(DEF_STR,'%btns%',Buffer,[]);
end;


function TgKeyboard.Hide():string;
begin
  Result := HIDE_KEYBORAD;
end;


constructor TgInlineKeyboard.Create();
begin
  IsLineStarted:= false;
  IsRendered := false;
  Buffer:= '' ;
end;

procedure TgInlineKeyboard.Clear();
begin
  Buffer:= '' ;
end;

procedure TgInlineKeyboard.EOL();
begin
  if not IsLineStarted  then
 begin
   Exit;
 end;
  Delete(Buffer,length(Buffer),1);
  Buffer += '],' ;
  IsLineStarted:= false;
  IsRendered := false;
end;


procedure TgInlineKeyboard.AddBtn(Title,CallBack:string);

begin
 if not IsLineStarted  then
 begin
   Buffer += '[' ;
   IsLineStarted := true ;
 end;
 Buffer += '{"text":"'+Title+'","callback_data":"'+CallBack+'"},' ;
 IsRendered := false;
end;


function TgInlineKeyboard.Render():string;
begin
  if IsRendered then
  begin
    Result := Buffer;
    Exit;
  end;
  if IsLineStarted then
  begin
    EOL();
  end;
  Delete(Buffer,length(Buffer),1);
  //Buffer += ']' ;
  IsRendered := true;
  Result := StringReplace(DEF_STR,'%btns%',Buffer,[]);
end;



end.

