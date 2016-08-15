unit uOtherFunctions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function sHTTPEncode(const AStr: string): string;
function GetAppDir():String;


implementation


function GetAppDir():String;
begin
  Result := (GetCurrentDir());
end;

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



end.
