unit uHSMainMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, uHSBanco, System.Notification;

type
  TLogForm = class(TForm)
    NotificationCenter1: TNotificationCenter;
    pLogin: TPanel;
    Logo: TImage;
    Nome: TLabel;
    pbtnLogin: TPanel;
    btnLogin: TSpeedButton;
    pInfosLogin: TPanel;
    lblLogEmail: TLabel;
    lblLogSenha: TLabel;
    lblLogEsqSenha: TLabel;
    edtLogEmail: TEdit;
    edtLogSenha: TEdit;
    pEsqSenha: TPanel;
    imgEsqSenha: TImage;
    edtEsqEmail: TEdit;
    lblEsqEmail: TLabel;
    pItensEsqSenha: TPanel;
    pbtnEsqSenha: TPanel;
    btnEsqSenha: TSpeedButton;
    pRecSenha: TPanel;
    Image1: TImage;
    edtRecSenhaVelha: TEdit;
    edtRecSenhaNova: TEdit;
    edtRecConfSenhaNova: TEdit;
    pbtnAtualizaSenha: TPanel;
    pItensRecSenha: TPanel;
    lblRecSenhaVelha: TLabel;
    lblRecSenhaNova: TLabel;
    lblRecConfSenhaNova: TLabel;
    btnAtualizaSenha: TSpeedButton;
    procedure lblLogEsqSenhaClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnEsqSenhaClick(Sender: TObject);
    procedure btnAtualizaSenhaClick(Sender: TObject);

  private
    function textoAleatorio(Tam: Integer = -1): String;
    procedure limpaCampos;
    procedure notificacao;
    procedure fazLogin;
    procedure verificaCodigoESenha;
    procedure atualizaSenha;
  public

  end;

var
  LogForm: TLogForm;
  resultadoSenha : string;

implementation

{$R *.dfm}

uses uHSJanela;

{Chama redefinição de senha}
procedure TLogForm.verificaCodigoESenha;
begin
  if (resultadoSenha <> '') and (edtLogSenha.Text = resultadoSenha) then
  begin
    ShowMessage('Redefina sua senha!');
    pRecSenha.Visible := true;
    pEsqSenha.Visible := false;
    pLogin.Visible    := false;
  end
  else
  begin
    fazLogin;
  end;
end;

{seta senha aleatória}
procedure TLogForm.btnAtualizaSenhaClick(Sender: TObject);
begin
  atualizaSenha;
end;

procedure TLogForm.btnEsqSenhaClick(Sender: TObject);
begin
  if edtEsqEmail.Text <> '' then
  begin
    Banco.qryLogSelect.Close;
    Banco.qryLogSelect.sql.Strings[6]                := '';
    Banco.qryLogSelect.sql.Strings[7]                := '';
    Banco.qryLogSelect.sql.Strings[6]                := 'and email = :email';
    Banco.qryLogSelect.ParamByName('email').AsString := edtEsqEmail.Text;
    Banco.qryLogSelect.Open;
    if not Banco.qryLogSelect.isEmpty then
    begin
      notificacao;
      Banco.qryLogUpdate.ParamByName('senha').AsString := resultadoSenha;
      Banco.qryLogUpdate.ParamByName('email').AsString := edtEsqEmail.Text;
      Banco.qryLogUpdate.execsql;
      pLogin.Visible    := true;
      pEsqSenha.Visible := false;
      pRecSenha.Visible := false;
      limpaCampos;
    end;
  end;
end;

{Chama o Login}
procedure TLogForm.btnLoginClick(Sender: TObject);
begin
  verificaCodigoESenha;
end;

{Verificações do Login}
procedure TLogForm.fazLogin;
begin
  if (edtLogEmail.Text <> '') and (edtLogSenha.Text <> '') then
  begin
    Banco.qryLogSelect.Close;
    Banco.qryLogSelect.sql.Strings[6] := 'and email   = :email';
    Banco.qryLogSelect.ParamByName('email').AsString := edtLogEmail.Text;
    Banco.qryLogSelect.sql.Strings[7] := 'and senha   = :senha';
    Banco.qryLogSelect.ParamByName('senha').AsString := edtLogSenha.Text;
    Banco.qryLogSelect.Open;
    if not Banco.qryLogSelect.isEmpty then
    begin
      Form1.Notebook1.PageIndex := 1;
      Form1.Panel2.Visible      := true;
      Form1.Panel1.Visible      := true;
      close;
    end
    else
    begin
      application.MessageBox('Falha no login, os dados não conferem!','Falha no Login',mb_OK+mb_IconError);
      limpacampos;
    end;
  end
  else
  begin
    application.MessageBox('Falha no login, favor preencher os campos obrigatórios!','Falha no Login',mb_OK+mb_IconError);
  end;
end;

{Muda de código para nova senha}
procedure TLogForm.atualizaSenha;
begin
  Banco.qryLogSelect.Close;
  Banco.qryLogSelect.sql.Strings[6] := '';
  Banco.qryLogSelect.sql.Strings[7] := '';
  Banco.qryLogSelect.sql.Strings[6] := 'and senha = :senha';
  Banco.qryLogSelect.ParamByName('senha').AsString := edtRecSenhaVelha.Text;
  Banco.qryLogSelect.Open;
  if not Banco.qryLogSelect.isEmpty then
  begin
    if edtRecSenhaNova.Text = edtRecConfSenhaNova.Text then
    begin
      Banco.qryLogUpdate.ParamByName('senha').AsString := edtRecSenhaNova.Text;
      Banco.qryLogUpdate.ExecSQL;
      Application.MessageBox('Senha atualizada com sucesso!!','Senha atualizada',mb_ICONINFORMATION+mb_OK);
      pLogin.Visible := true;
      pEsqSenha.Visible := false;
      pRecSenha.Visible := false;
      resultadoSenha := '';
    end
    else
    begin
      Application.MessageBox('As senhas informadas não conferem!','Erro',mb_ICONERROR+mb_OK);
    end;
  end
  else
  begin
    Application.MessageBox('O código informado não é valido','Erro',MB_ICONERROR+MB_OK)
  end;
end;

{Configurações da notificação}
procedure TLogForm.notificacao;
var Notification : TNotification;
begin
  Notification := NotificationCenter1.CreateNotification;
  try
    resultadoSenha          := textoAleatorio;
    Notification.Name       := 'RecuperaSenha';
    Notification.Title      := 'Utilize a senha abaixo para acessar o sistema';
    Notification.AlertBody  := resultadoSenha;
    NotificationCenter1.PresentNotification(Notification);
  finally
    Notification.free;
  end;
end;

{formatação esqueceu a senha}
procedure TLogForm.lblLogEsqSenhaClick(Sender: TObject);
begin
  pLogin.Visible    := false;
  pRecSenha.Visible := false;
  pEsqSenha.Visible := true;
end;

{limpa os campos}
procedure TLogForm.limpaCampos;
begin
  edtLogEmail.Text         := '';
  edtLogEmail.SetFocus;
  edtLogSenha.Text         := '';
  edtEsqEmail.Text         := '';
  edtRecSenhaVelha.Text    := '';
  edtRecSenhaNova.Text     := '';
  edtRecConfSenhaNova.Text := '';
end;

{Gera código alfanumérico 8 dígitos}
function TLogForm.textoAleatorio(Tam: Integer = -1): String;
var
  I: Integer;
  begin
    if Tam = -1 then
    begin
      Tam := 8;
      Setlength(Result, Tam);
      for I := 1 to Tam do
      begin
        if Random(2) = 0 then
        begin
          Result[I] := Chr(Ord('A') + Random(Ord('Z') - Ord('A') + 1));
        end
        else
        begin
          Result[I] := Chr(Ord('0') + Random(Ord('9') - Ord('0') + 1));
        end;
      end;
    end;
  end;

end.
