unit Form.Main;

interface

uses
  UCL.Form, UCL.Classes, UCL.ThemeManager,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, UCL.Panel, UCL.Utils,
  UCL.Graphics, UCL.CaptionBar, UCL.ProgressBar;

type
  TForm85 = class(TUForm)
    UPanel1: TUPanel;
    ComboBox1: TComboBox;
    Button1: TButton;
    UCaptionBar1: TUCaptionBar;
    Button2: TButton;
    UProgressBar1: TUProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form85: TForm85;

implementation

{$R *.dfm}

procedure TForm85.Button1Click(Sender: TObject);
begin
  ThemeManager.UpdateTheme;
end;

procedure TForm85.Button2Click(Sender: TObject);
begin
  Randomize;
  UProgressBar1.GoToValue(Random(100));
end;

procedure TForm85.ComboBox1Select(Sender: TObject);
begin
  ThemeManager.ThemeType := TUThemeType(ComboBox1.ItemIndex);
end;

procedure TForm85.FormCreate(Sender: TObject);
begin
  UPanel1.Hint :=
    'This is line 1' + sLineBreak +
    'This is line 2' + sLineBreak +
    'This is a multi-line tooltip';
end;

end.
