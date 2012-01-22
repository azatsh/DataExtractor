unit uSelectDirectoryBox;

interface

uses
  SysUtils, Windows, ShlObj;

function GetFolderDialog(Handle: Integer; Caption: string; var strFolder: string): Boolean;

implementation

function BrowseCallbackProc(hwnd: HWND; uMsg: UINT; lParam: LPARAM; lpData: LPARAM): Integer; stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) then
    SendMessage(hwnd, BFFM_SETSELECTION, 1, lpData);
  BrowseCallbackProc:= 0;
end;

function GetFolderDialog(Handle: Integer; Caption: string; var strFolder: string): Boolean;
const
  BIF_STATUSTEXT           = $0004;
  BIF_NEWDIALOGSTYLE       = $0040;
  BIF_RETURNONLYFSDIRS     = $0080;
  BIF_SHAREABLE            = $0100;
  BIF_USENEWUI             = BIF_EDITBOX or BIF_NEWDIALOGSTYLE;

var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  JtemIDList: PItemIDList;
  Path: PChar;
begin
  Result:= False;
  Path:= StrAlloc(MAX_PATH);
  SHGetSpecialFolderLocation(Handle, CSIDL_DRIVES, JtemIDList);
  with BrowseInfo do
  begin
    hwndOwner:= GetActiveWindow;
    pidlRoot:= JtemIDList;
    SHGetSpecialFolderLocation(hwndOwner, CSIDL_DRIVES, JtemIDList);

    { ������� �������� ���������� �������� }
    pszDisplayName:= StrAlloc(MAX_PATH);

    { ��������� �������� ������� ������ ����� }
    lpszTitle:= PChar(Caption); // '������� ����� �� Delphi (������)';
    { �����, �������������� ������� }
    lpfn:= @BrowseCallbackProc;
    { �������������� ����������, ������� ������� ������� � �������� ����� (callback) }
    lParam:= LongInt(PChar(strFolder));
  end;

  ItemIDList:= SHBrowseForFolder(BrowseInfo);

  if (ItemIDList <> nil) then
    if SHGetPathFromIDList(ItemIDList, Path) then
    begin
      strFolder:= Path;
      Result:= True;
    end;
end;

end.