object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Screen Resolution Changer'
  ClientHeight = 327
  ClientWidth = 531
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  object TrayIcon1: TTrayIcon
    Icon.Data = {
      0000010001001010020001000100B00000001600000028000000100000002000
      0000010001000000000000000000000000000000000000000000000000000000
      0000FFFFFF00000000000FF0000001800000FFFF000080010000800100008001
      00008001000080010000800100008001000080010000FFFF0000000000000000
      000000000000FFFF0000F00F0000FE7F0000000000007FFE00007FFE00007FFE
      00007FFE00007FFE00007FFE00007FFE00007FFE000000000000FFFF0000FFFF
      0000FFFF0000}
    OnMouseUp = TrayIcon1MouseUp
    Left = 72
    Top = 128
  end
  object PopupMenu1: TPopupMenu
    Left = 72
    Top = 64
  end
end
