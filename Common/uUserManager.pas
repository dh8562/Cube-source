unit uUserManager;

interface

uses
  Windows;

function UserLogIn(ActiveLang : String; LoggedUser : PChar; var LoggedUserAuthority : Integer) : Boolean;

function LogIn(ActiveLangIndex : Integer; LoggedUser : PChar; var LoggedUserAuthority : Integer) : Boolean; stdcall;
function LogInWith(ActiveLangIndex : Integer; AUser : PChar; APassword : PChar) : Integer; stdcall;
function umLogIn(ActiveLangIndex : Integer; LoggedUser : PChar; var LoggedUserAuthority : Integer) : Boolean; stdcall;
function umLogInWith(ActiveLangIndex : Integer; AUser : PChar; APassword : PChar) : Integer; stdcall;
function umConfirmPassword(ActiveLangIndex : Integer; AUser : PChar) : Boolean; stdcall;

implementation

const
  USERMGR_DLL = 'usermgr.dll';

function UserLogIn(ActiveLang : String; LoggedUser : PChar; var LoggedUserAuthority : Integer) : Boolean;
var
  LangIndex : Integer;
begin
  if ActiveLang = 'ENU' then
    LangIndex := 1
  else if ActiveLang = 'JPN' then
    LangIndex := 2
  else if ActiveLang = 'CHT' then
    LangIndex := 3
  else if ActiveLang = 'CHS' then
    LangIndex := 4
  else
    LangIndex := 0;
  Result := LogIn(LangIndex, LoggedUser, LoggedUserAuthority);
end;

{$IFDEF WIN64}
{ The available usermgr.dll is a legacy Win32 DLL.  A Win64 process cannot
  load it, so keep the application startable until a native Win64 UserMgr is
  supplied.  Returning False/-1 is the safe equivalent of cancelling login. }
function LogIn(ActiveLangIndex : Integer; LoggedUser : PChar;
  var LoggedUserAuthority : Integer) : Boolean;
begin
  LoggedUserAuthority := 0;
  Result := False;
end;

function LogInWith(ActiveLangIndex : Integer; AUser : PChar;
  APassword : PChar) : Integer;
begin
  Result := -1;
end;

function umLogIn(ActiveLangIndex : Integer; LoggedUser : PChar;
  var LoggedUserAuthority : Integer) : Boolean;
begin
  LoggedUserAuthority := 0;
  Result := False;
end;

function umLogInWith(ActiveLangIndex : Integer; AUser : PChar;
  APassword : PChar) : Integer;
begin
  Result := -1;
end;

function umConfirmPassword(ActiveLangIndex : Integer;
  AUser : PChar) : Boolean;
begin
  Result := False;
end;
{$ELSE}
function LogIn; external USERMGR_DLL name 'LogIn';
function LogInWith; external USERMGR_DLL name 'LogInWith';
function umLogIn; external USERMGR_DLL name 'umLogIn';
function umLogInWith; external USERMGR_DLL name 'umLogInWith';
function umConfirmPassword; external USERMGR_DLL name 'umConfirmPassword';
{$ENDIF}

end.
