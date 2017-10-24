{
Code needs cleaning of unused routines.
}
unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CustomRes(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrayIcon1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    Menues: array of TMenuItem;
    procedure AboutClick(Sender: TObject);
  public
    { Public declarations }
    CurRes: TStringList;
    Updated: Boolean;
  protected

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure NuevaRes(Xres,Yres:DWORD;Bits:Byte);
var
modo:TDevMode;
nada:PdevMode;
valor:integer;
begin
     nada:=nil;
     EnumDisplaySettings(nil,0,modo);
     modo.dmfields:=DM_PELSWIDTH or DM_PELSHEIGHT;
     modo.dmpelswidth:=xres;
     modo.dmpelsheight:=yres;
     modo.dmBitsPerPel:=bits;
     ShowWindow(FindWindow('ShellTrayWnd',nil),SW_HIDE);
     valor:=ChangeDisplaySettings(modo,0);
     {if valor=0 then Showmessage('Waooh! funcionó')
else if valor=1 then ShowMessage('Para que el cambio Resulte, deberá reiniciar el Ordenador!')
else if valor=2 then ShowMessage('Uso invalido del software!')
else if valor=3 then begin ShowMessage('Que pena, no funcionó');ChangeDisplaySettings(nada^,0);end
else if valor=4 then begin ShowMessage('Modo Gráfico no soportado');ChangeDisplaySettings(nada^,0);end
else if valor=5 then ShowMessage('Imposible de escribir en el registro de Windows debido a restricciones del administrador.');
     ShowWindow(FindWindow('ShellTrayWnd',nil),SW_SHOWNA);}
end;

procedure Split(Delimiter: Char; Str: String; ListOfStrings: TStrings);
begin
  ListOfStrings.Clear;
  ListOfStrings.Delimiter := Delimiter;
  ListOfStrings.StrictDelimiter := True;
  ListOfStrings.DelimitedText := Str;
end;

procedure TForm1.AboutClick(Sender: TObject);
begin
  MessageDlg('ScreenResizer v1.2'#13'Author: vhanla'#13'http://codigobit.net', mtInformation, [mbOK], 0);
end;

procedure TForm1.CustomRes(Sender: TObject);
var
  OutPutList: TStringList;
  w, h, bpp : Integer;
begin
  if Sender is TMenuItem then
  begin
    OutPutList := TStringList.Create;
    try
      Split('x', TMenuItem(Sender).Caption, OutPutList);
      w := StrToInt(Trim(OutPutList[0]));
      h := StrToInt(Trim(OutPutList[1]));
      bpp := StrToInt(Trim(OutPutList[2]));
      NuevaRes(w, h, bpp);
    finally
      OutPutList.Free;
    end;
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  close
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  CurRes := TStringList.Create;
  Updated := True;
  TrayIcon1.Visible := True;
  PopupMenu1.AutoHotkeys := maManual;

end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  CurRes.Free;
  for I := 0 to Length(Menues) - 1 do
  begin
    Menues[I].Free;
  end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pos: TPoint;
begin
  if Button = mbRight then
  begin
    pos := ClientToScreen(Point(X, Y));
    PopupMenu1.Popup(pos.X, pos.Y);
  end;
end;

procedure TForm1.TrayIcon1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  iModeNum: Integer;
  Modo: TDevMode;
  I: Integer;
begin
  if Button = mbLeft then Exit;
  if Updated then
  begin
    Updated := False;

    iModeNum := 0;
    CurRes.BeginUpdate;
    CurRes.Clear;
    while (EnumDisplaySettings(nil, iModeNum, Modo)) <> False do
    begin
      if Modo.dmDefaultSource = 0 then
        CurRes.Add(IntToStr(Modo.dmPelsWidth) + ' x ' + IntToStr(Modo.dmPelsHeight) + ' x ' + IntToStr(Modo.dmBitsPerPel));
      Inc(iModeNum);
    end;
    CurRes.EndUpdate;

    for I := 0 to Length(Menues) - 1  do
    begin
      Menues[I].Free;
    end;

    SetLength(Menues, CurRes.Count + 2 + 2);
    for I := 0 to Length(Menues) - 1 - 2 - 2 do
    begin
      Menues[I] := TMenuItem.Create(PopupMenu1);
      Menues[I].Caption := CurRes[CurRes.Count - 1 - I];
      Menues[I].OnClick := CustomRes;
      PopupMenu1.Items.Add(Menues[I]);
    end;

    // Add extra menu items [-dash- and exit]
    Menues[CurRes.Count] := TMenuItem.Create(PopupMenu1);
    Menues[CurRes.Count].Caption := '-';
    PopupMenu1.Items.Add(Menues[CurRes.Count]);

    Menues[CurRes.Count + 1] := TMenuItem.Create(PopupMenu1);
    Menues[CurRes.Count + 1].Caption := 'About';
    Menues[CurRes.Count + 1].OnClick := AboutClick;
    PopupMenu1.Items.Add(Menues[CurRes.Count + 1]);

    // Add extra menu items [-dash- and exit]
    Menues[CurRes.Count + 2] := TMenuItem.Create(PopupMenu1);
    Menues[CurRes.Count + 2].Caption := '-';
    PopupMenu1.Items.Add(Menues[CurRes.Count + 2]);

    Menues[CurRes.Count + 3] := TMenuItem.Create(PopupMenu1);
    Menues[CurRes.Count + 3].Caption := 'E&xit';
    Menues[CurRes.Count + 3].OnClick := Exit1Click;
    PopupMenu1.Items.Add(Menues[CurRes.Count + 3]);

    PopupMenu1.Popup(X, Y);
    Updated := True;
  end;
end;

end.
