program HimeSolutions;

uses
  Vcl.Forms,
  uHSJanela in 'uHSJanela.pas' {Form1},
  uHSMainMenu in 'uHSMainMenu.pas' {LogForm},
  uHSBanco in 'uHSBanco.pas' {Banco: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBanco, Banco);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
