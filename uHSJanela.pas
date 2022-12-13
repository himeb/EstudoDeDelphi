unit uHSJanela;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.ComCtrls, Vcl.FileCtrl, Vcl.ExtDlgs, jpeg, uHSBanco,
  Vcl.Grids, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Vcl.Bind.Grid, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, VCLTee.TeCanvas, Vcl.Buttons, Data.DB, FireDAC.Stan.Param,
  Vcl.DBGrids, frxClass, uHSMainMenu, System.Notification;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    pPerfil: TPanel;
    pMenu: TPanel;
    Image1: TImage;
    pnpRel: TPanel;
    Image2: TImage;
    pnpCad: TPanel;
    Image5: TImage;
    Image4: TImage;
    opdPerfil: TOpenPictureDialog;
    Notebook1: TNotebook;
    Label1: TLabel;
    lblLogradouro: TLabel;
    lblCEP: TLabel;
    lblEstado: TLabel;
    lblNº: TLabel;
    lblCidade: TLabel;
    imgPerfil: TImage;
    edtLogradouro: TEdit;
    edtCEP: TEdit;
    edtNº: TEdit;
    edtCidade: TEdit;
    edtEstado: TEdit;
    edtComplemento: TEdit;
    lblComplemento: TLabel;
    lblNome: TLabel;
    lblSobrenome: TLabel;
    lblNascimento: TLabel;
    lblCPF: TLabel;
    lblEmail: TLabel;
    lblConfEmail: TLabel;
    dtNascimento: TDateTimePicker;
    edtSobrenome: TEdit;
    edtNome: TEdit;
    edtCPF: TEdit;
    edtEmail: TEdit;
    edtConfEmail: TEdit;
    pDiv: TPanel;
    lblSenha: TLabel;
    lblConfSenha: TLabel;
    edtSenha: TEdit;
    edtConfSenha: TEdit;
    btnLimpa: TSpeedButton;
    edtPesquisa: TEdit;
    rgItemPesquisa: TRadioGroup;
    pBotoes: TPanel;
    pbtnBuscaCadastro: TPanel;
    btnBuscaCadastro: TSpeedButton;
    pbtnCadastra: TPanel;
    btnCadastra: TSpeedButton;
    pbtnExcluiCadastro: TPanel;
    SpeedButton1: TSpeedButton;
    pbtnEditaCadastro: TPanel;
    btnEditaCadastro: TSpeedButton;
    Panel3: TPanel;
    btnRelCad: TImage;
    dbgTabela: TDBGrid;
    pbtnConfEdt: TPanel;
    pbtnCancEdt: TPanel;
    NotificationCenter1: TNotificationCenter;
    procedure pnpCadMouseEnter(Sender: TObject);
    procedure pnpCadMouseLeave(Sender: TObject);
    procedure pnpCadClick(Sender: TObject);
    procedure pnpRelClick(Sender: TObject);
    procedure pPerfilClick(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
    procedure imgPerfilClick(Sender: TObject);
    procedure btnRelCadClick(Sender: TObject);
    procedure btnCadastraClick(Sender: TObject);
    procedure mantemFormato(Sender: TObject);
    procedure limpaFormato(Sender: TObject);
    procedure btnLimpaClick(Sender: TObject);
    procedure btnBuscaCadastroClick(Sender: TObject);
    procedure edtPesquisaClick(Sender: TObject);
    procedure dbgTabelaCellClick(Column: TColumn);
    procedure btnEditaCadastroClick(Sender: TObject);
    procedure pbtnConfEdtClick(Sender: TObject);
    procedure pbtnCancEdtClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure edtCPFExit(Sender: TObject);
  private

  public
    function verificaCampo : Boolean;
    function verificaUsuario: Boolean;
    function verificaEquivalencia : Boolean;
    procedure escolheItem;
    procedure cadastro;
    procedure limpaCampos;
    procedure retornaPesquisa;
    procedure desabilitaCampos;
    procedure habilitaCampos;
    procedure atualizaDados;
    procedure chamaLogin;
  end;

var
  Form1: TForm1;
  vgOBJPanel : TObject;
  vgFMT : Boolean;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Notebook1.PageIndex := 0;
  Form1.Panel2.Visible := false;
  Form1.Panel1.Visible := false;
  Form1.dtNascimento.Date := Date();
  Form1.Show;
  chamaLogin;
end;

{chama Formulário de Login}
procedure TForm1.chamaLogin;
begin
  if Notebook1.PageIndex = 0 then
  begin
    if logForm = nil then
    begin
      logForm := TlogForm.Create(nil);
      logForm.pLogin.Visible := true;
      logForm.Show;
    end;
  end;
end;

{abre notebook index Perfil}
procedure TForm1.pPerfilClick(Sender: TObject);
begin
  limpaFormato(vgOBJPanel);
  vgOBJPanel := Sender;
  vgFMT := true;
  mantemFormato(Sender);
  Notebook1.pageIndex := 1;
end;

{abre notebook index Cadastro}
procedure TForm1.pnpCadClick(Sender: TObject);
begin
  limpaFormato(vgOBJPanel);
  vgOBJPanel := Sender;
  vgFMT := true;
  mantemFormato(Sender);
  Notebook1.PageIndex := 2;
end;

{abre notebook index Relatórios}
procedure TForm1.pnpRelClick(Sender: TObject);
begin
  limpaFormato(vgOBJPanel);
  vgOBJPanel := Sender;
  vgFMT := true;
  mantemFormato(Sender);
  Notebook1.pageIndex := 3;
end;

{chama o explorador de arquivos}
procedure TForm1.imgPerfilClick(Sender: TObject);
begin
  opdPerfil.Execute;
  if not (opdPerfil.FileName = '') then
  begin
    imgPerfil.Picture.LoadFromFile(opdPerfil.FileName);
  end;
end;

{chama o relatório sem filtros}
procedure TForm1.btnRelCadClick(Sender: TObject);
begin
  escolheItem;
  Banco.relRelatorio.LoadFromFile('C:\Users\paulo\OneDrive\Área de Trabalho\Hime\Win32\Debug\Relatórios\relRelatorio.fr3');
  if not Banco.qrySelect.isEmpty then
  begin
    Banco.relRelatorio.ShowReport;
  end
  else
  begin
  ShowMessage('Não foram encontrados dados compatíveis com a pesquisa feita');
  end;
  limpaCampos;
end;

{chama a qryInsert}
procedure TForm1.cadastro;
begin
Banco.fdConexao.StartTransaction;
  try
  begin
    Banco.qryInsert.ParamByName('nome').AsString := edtNome.Text;
    Banco.qryInsert.ParamByName('sobrenome').AsString := edtSobrenome.Text;
    Banco.qryInsert.ParamByName('nascimento').AsDate := dtNascimento.Date;
    Banco.qryInsert.ParamByName('cpf').AsString := edtCpf.Text;
    Banco.qryInsert.ParamByName('email').AsString := edtEmail.Text;
    Banco.qryInsert.ParamByName('senha').AsString := edtSenha.Text;
    Banco.qryInsert.ParamByName('cep').AsInteger := strToInt(edtCep.Text);
    Banco.qryInsert.ParamByName('estado').AsString := edtEstado.Text;
    Banco.qryInsert.ParamByName('cidade').AsString := edtCidade.Text;
    Banco.qryInsert.ParamByName('logradouro').AsString := edtLogradouro.Text;
    Banco.qryInsert.ParamByName('complemento').AsString := edtComplemento.Text;
    Banco.qryInsert.ParamByName('numero').AsInteger := strToInt(edtNº.Text);
    Banco.qryInsert.ParamByName('imagem').AsString := opdPerfil.FileName;
    Banco.qryInsert.ExecSQL;
    Banco.fdConexao.Commit;
    Application.MessageBox('Cadastro realizado com sucesso','Confirmação',MB_ICONINFORMATION+MB_OK);
    limpaCampos;
  end;
  except
    on e:exception do
    begin
      Banco.fdConexao.Rollback;
    end;
  end;
end;

{Cadastra}
procedure TForm1.btnCadastraClick(Sender: TObject);
begin
  if (verificaCampo) and (verificaEquivalencia) then
  begin
    if (verificaUsuario) then
    begin
      cadastro;
    end;
  end;
end;

{chama a procedure limpaCampos}
procedure TForm1.btnLimpaClick(Sender: TObject);
begin
  limpaCampos;
end;

{chama a pesquisa}
procedure TForm1.btnBuscaCadastroClick(Sender: TObject);
begin
  retornaPesquisa;
end;

{Cancela atualização}
procedure TForm1.pbtnCancEdtClick(Sender: TObject);
begin
  limpacampos;
  habilitaCampos;
  pbtnConfEdt.Visible        := false;
  pbtnCancEdt.Visible        := false;
  pbtnCadastra.Visible       := true;
  pbtnBuscaCadastro.Visible  := true;
  pbtnEditaCadastro.Visible  := true;
  PbtnExcluiCadastro.Visible := true;
end;

{Atualiza}
procedure TForm1.pbtnConfEdtClick(Sender: TObject);
begin
  if (verificaCampo) and (verificaEquivalencia) then
  begin
    atualizaDados;
  end;
end;

{Exclui}
procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if Banco.qrySelect.IsEmpty then
  begin
    Application.MessageBox('Não foram identificados registros para exclusão!','Erro',MB_ICONError+MB_OK);
    exit
  end;
  if (Application.MessageBox('Deseja realmente excluir este cadastro?','Confirmação de Exclusão',MB_ICONINFORMATION+MB_YESNO) = mrYes) then
  Begin
    try
      Banco.fdConexao.StartTransaction;
      Banco.qryDelete.ParamByName('ID').AsInteger := Banco.qrySelect.FieldByName('ID').AsInteger;
      Banco.qryDelete.Execute;
      Banco.fdConexao.Commit;
      Application.MessageBox('Usuário excluído com sucesso!','Exclusão Confirmada',MB_ICONINFORMATION+MB_OK);
      limpaCampos;
    except
    begin
      Banco.fdConexao.Rollback;
      Application.MessageBox('Erro ao excluir usuario!','Usuário não deletado',MB_ICONError+MB_OK);
    end;
    end;
  end;
end;

{chama a qryUpdate}
procedure TForm1.atualizaDados;
begin
  Banco.fdConexao.StartTransaction;
  try
  begin
    Banco.qryUpdate.Close;
    Banco.qryUpdate.ParamByName('id').AsInteger         := Banco.qrySelect.FieldByName('id').AsInteger;
    Banco.qryUpdate.ParamByName('nome').AsString        := edtNome.Text;
    Banco.qryUpdate.ParamByName('sobrenome').AsString   := edtSobrenome.Text;
    Banco.qryUpdate.ParamByName('nascimento').AsDate    := dtNascimento.Date;
    Banco.qryUpdate.ParamByName('cpf').AsString         := edtCpf.Text;
    Banco.qryUpdate.ParamByName('email').AsString       := edtEmail.Text;
    Banco.qryUpdate.ParamByName('senha').AsString       := edtSenha.Text;
    Banco.qryUpdate.ParamByName('cep').AsInteger        := strToInt(edtCep.Text);
    Banco.qryUpdate.ParamByName('estado').AsString      := edtEstado.Text;
    Banco.qryUpdate.ParamByName('cidade').AsString      := edtCidade.Text;
    Banco.qryUpdate.ParamByName('logradouro').AsString  := edtLogradouro.Text;
    Banco.qryUpdate.ParamByName('complemento').AsString := edtComplemento.Text;
    Banco.qryUpdate.ParamByName('numero').AsInteger     := strToInt(edtNº.Text);
    Banco.qryUpdate.ParamByName('imagem').AsString      := opdPerfil.FileName;
    Banco.qryUpdate.ExecSQL;
    Banco.fdConexao.Commit;
    Application.MessageBox('Atualização realizada com sucesso','Confirmação',MB_ICONINFORMATION+MB_OK);
    limpaCampos;
  end;
  except
    on e:exception do
    begin
      Banco.fdConexao.Rollback;
      Application.MessageBox('Atualização Falhou','Falha',MB_ICONERROR+MB_OK);
    end;
  end;
end;

{chama habilitaCampos e prepara o Update}
procedure TForm1.btnEditaCadastroClick(Sender: TObject);
begin
  habilitaCampos;
  pbtnConfEdt.Visible        := true;
  pbtnCancEdt.Visible        := true;
  pbtnCadastra.Visible       := false;
  pbtnBuscaCadastro.Visible  := false;
  pbtnEditaCadastro.Visible  := false;
  PbtnExcluiCadastro.Visible := false;
end;

{insere parametros nome e cpf na qrySelect}
procedure TForm1.retornaPesquisa;
begin
  Banco.qrySelect.Close;
  Banco.qrySelect.sql.strings[18] := '';
  if edtNome.Text <> '' then
  begin
    Banco.qrySelect.sql.strings[18] := Banco.qrySelect.sql.strings[18] + 'and nome like ' + quotedstr('%'+edtNome.Text+'%');
  end;
  if edtCPF.Text <> '' then
  begin
    Banco.qrySelect.sql.strings[18] := Banco.qrySelect.sql.strings[18] + 'and cpf like ' + quotedstr('%'+edtCpf.Text+'%');
  end;
  Banco.qrySelect.Open;
  if not Banco.qrySelect.IsEmpty then
  begin
    dbgTabela.Refresh;
    dbgTabela.Visible := true;
  end
  else
  begin
    Application.MessageBox('Não existem usuários cadastrados com esses dados!','Usuário não encontrado',mb_ICONERROR+MB_OK)
  end;
end;

{retorna o valor da pesquisa para os campos}
procedure TForm1.dbgTabelaCellClick(Column: TColumn);
begin
  edtNome.Text        := Banco.qrySelect.FieldByName('nome').AsString;
  edtSobrenome.Text   := Banco.qrySelect.FieldByName('sobrenome').AsString;
  dtNascimento.Date   := Banco.qrySelect.FieldByName('nascimento').AsDateTime;
  edtCPF.Text         := Banco.qrySelect.FieldByName('CPF').AsString;
  edtEmail.Text       := Banco.qrySelect.FieldByName('email').AsString;
  edtCEP.Text         := Banco.qrySelect.FieldByName('CEP').AsString;
  edtEstado.Text      := Banco.qrySelect.FieldByName('estado').AsString;
  edtCidade.Text      := Banco.qrySelect.FieldByName('cidade').AsString;
  edtLogradouro.Text  := Banco.qrySelect.FieldByName('logradouro').AsString;
  edtComplemento.Text := Banco.qrySelect.FieldByName('complemento').AsString;
  edtNº.Text          := Banco.qrySelect.FieldByName('numero').AsString;
  opdPerfil.FileName  := Banco.qrySelect.FieldByName('imagem').AsString;
  dbgTabela.Visible := False;
  desabilitaCampos;
end;

{seleção de filtros para relatório}
procedure TForm1.escolheItem;
begin
  if rgItemPesquisa.ItemIndex = -1 then
  begin
    Banco.qrySelect.Close;
    Banco.qrySelect.sql.strings[18] := '';
    Banco.qrySelect.sql.strings[19] := 'ORDER BY estado asc';
    Banco.qrySelect.Open;
  end;
  if rgItemPesquisa.ItemIndex = 0 then
  begin
    Banco.qrySelect.Close;
    Banco.qrySelect.sql.strings[18] := ' and nome like ' + quotedstr('%'+edtPesquisa.Text+'%');
    Banco.qrySelect.sql.strings[19] := 'ORDER BY nome asc';
    Banco.qrySelect.Open;
  end;
  if rgItemPesquisa.ItemIndex = 1 then
  begin
    Banco.qrySelect.Close;
    Banco.qrySelect.sql.strings[18] := ' and cpf like ' + quotedstr('%'+edtPesquisa.Text+'%');
    Banco.qrySelect.sql.strings[19] := 'ORDER BY nome asc';
    Banco.qrySelect.Open;
  end;
  if rgItemPesquisa.ItemIndex = 2 then
  begin
    Banco.qrySelect.Close;
    Banco.qrySelect.sql.strings[18] := ' and estado like ' + quotedstr('%'+edtPesquisa.Text+'%');
    Banco.qrySelect.sql.strings[19] := 'ORDER BY nome asc';
    Banco.qrySelect.Open;
  end;
  if rgItemPesquisa.ItemIndex = 3 then
  begin
    Banco.qrySelect.Close;
    Banco.qrySelect.sql.strings[18] := ' and cidade like ' + quotedstr('%'+edtPesquisa.Text+'%');
    Banco.qrySelect.sql.strings[19] := 'ORDER BY nome asc';
    Banco.qrySelect.Open;
  end;
end;

{formata o campo pesquisa}
procedure TForm1.edtPesquisaClick(Sender: TObject);
begin
  edtPesquisa.ReadOnly   := false;
  edtPesquisa.Font.Color := clblack;
  edtPesquisa.Text       := '';
end;

{habilita os campos}
procedure TForm1.habilitaCampos;
begin
  edtNome.Enabled       := true;
  edtSobrenome.Enabled  := true;
  dtNascimento.Enabled  := true;
  edtCPF.Enabled        := true;
  edtEmail.Enabled      := true;
  edtConfEmail.Visible  := true;
  edtSenha.Visible      := true;
  edtConfSenha.Visible  := true;
  edtCEP.Enabled        := true;
  edtEstado.Enabled     := true;
  edtEstado.Enabled     := false;
  edtCidade.Enabled     := false;
  edtLogradouro.Enabled := false;
  edtNº.Enabled         := true;
  imgPerfil.Enabled     := true;
  lblConfEmail.Visible  := true;
  lblSenha.Visible      := true;
  lblConfSenha.Visible  := true;
  edtEmail.Width        := 130;
end;

{desabilita os campos}
procedure TForm1.desabilitaCampos;
begin
  edtNome.Enabled        := false;
  edtSobrenome.Enabled   := false;
  dtNascimento.Enabled   := false;
  edtCPF.Enabled         := false;
  edtEmail.Enabled       := false;
  edtConfEmail.Visible   := false;
  edtSenha.Visible       := false;
  edtConfSenha.Visible   := false;
  edtCEP.Enabled         := false;
  edtEstado.Enabled      := false;
  edtCidade.Enabled      := false;
  edtLogradouro.Enabled  := false;
  edtComplemento.Enabled := false;
  edtNº.Enabled          := false;
  imgPerfil.Enabled      := false;
  lblConfEmail.Visible   := false;
  lblSenha.Visible       := false;
  lblConfSenha.Visible   := false;
  edtEmail.Width         := 260;
end;

{limpa os campos}
procedure TForm1.limpaCampos;
var
C : Integer;
begin
  for C := 0 to Self.ComponentCount - 1 do
  begin
    if (Self.Components[C] is TEdit) then
    begin
      (Self.Components[C] as TEdit).Clear;
    end;
  end;
  imgPerfil.Picture.LoadFromFile('C:\Users\paulo\OneDrive\Área de Trabalho\Hime\Imagens\DefaultImg.png');
  habilitaCampos;
  rgItemPesquisa.ItemIndex := -1;
  edtPesquisa.Text         := '';
  dtNascimento.DateTime    := Date();
  Banco.qrySelect.Close;
  Banco.qrySelect.sql.strings[18] := '';
  dbgTabela.Visible := False;
end;

{formata passagem do mouse-entrando}
procedure TForm1.pnpCadMouseEnter(Sender: TObject);
begin
  if vgFMT = false then
  begin
    TPanel(Sender).Color      := $008AB0FF;        //TPanel(Sender) : serve para chamar o componente
    TPanel(Sender).BevelOuter := bvSpace;     //TPanel que originou o evento, substituindo assim
    TPanel(Sender).Cursor     := crHandPoint;     //o Name específico de cada um deles.
  end;
end;

{formata passagem do mouse-saindo}
procedure TForm1.pnpCadMouseLeave(Sender: TObject);
begin
  if vgFMT = false then
  begin
    TPanel(Sender).Color      := clTeal;
    TPanel(Sender).BevelOuter := bvNone;
    TPanel(Sender).Cursor     := crHandPoint;
  end;
end;

{formata botão ao clicar}
procedure TForm1.mantemFormato(Sender: TObject);
begin
  if vgFMT = true then
  begin
    TPanel(Sender).Color      := $008AB0FF;
    TPanel(Sender).BevelOuter := bvSpace;
    TPanel(Sender).Cursor     := crHandPoint;
  end;
end;

{formata botão inicial}
procedure TForm1.limpaFormato(Sender: TObject);
begin
  if vgFMT = true then
  begin
    TPanel(Sender).Color      := clTeal;
    TPanel(Sender).BevelOuter := bvNone;
    TPanel(Sender).Cursor     := crHandPoint;
  end;
end;

{chama API de cep e preenche auto}
procedure TForm1.edtCEPExit(Sender: TObject);
begin
  try
  Banco.RESTClient2.BaseURL := 'https://viacep.com.br/ws/'+edtCep.Text+'/json';
  Banco.RESTRequest2.Execute;
  Form1.edtLogradouro.Text  := Banco.fdMemTable2.FieldByName('logradouro').AsString;
  Form1.edtCidade.Text      := Banco.fdMemTable2.FieldByName('localidade').AsString;
  Form1.edtEstado.Text      := Banco.fdMemTable2.FieldByName('uf').AsString;
  if Form1.edtLogradouro.Text = ''then
  begin
    Form1.edtLogradouro.Enabled := true;
  end;
  except
    ShowMessage('CEP não encontrado!');
  end;
end;

{verifica se o CPF já existe no registro}
function TForm1.verificaUsuario;
begin
  result := true;
  Banco.qrySelect.sql.strings[18] := '';
  Banco.qrySelect.Close;
  Banco.qrySelect.sql.strings[18] := Banco.qrySelect.sql.strings[18] + ' and cpf = :cpf';
  Banco.qrySelect.ParamByName('cpf').AsString := edtCPF.Text;
  Banco.qrySelect.Open;
  if not Banco.qrySelect.IsEmpty then
  begin
    ShowMessage('O CPF informado já está cadastrado!');
    edtCPF.SetFocus;
    result := false;
  end;
  Banco.qrySelect.Close;
  Banco.qrySelect.sql.strings[18] := Banco.qrySelect.sql.strings[18] +  ' and email = :email';
  Banco.qrySelect.ParamByName('email').AsString := edtEmail.Text;
  Banco.qrySelect.Open;
  if not Banco.qrySelect.IsEmpty then
  begin
    ShowMessage('O email informado já está cadastrado!');
    edtCPF.SetFocus;
    result := false;
  end;
end;

{verifica se os campos obrigatórios estão preenchidos}
function TForm1.verificaCampo;
var
vNome : string;
begin
  var
  I : Integer;
  begin
    for I := 0 to Self.ComponentCount - 1 do
    begin
      if (Self.Components[i]).Tag = 1 then
      begin
        if (Self.Components[i]).Tag <> 999 then
        begin
          vNome := Copy((Self.Components[i]).Name,4,20);
          if (TEdit(Self.Components[i])).Text = ('') then
          begin
            TLabel(Form1.FindComponent('lbl'+vNome)).Caption := (vNome+'*');
            TLabel(Form1.FindComponent('lbl'+vNome)).Font.Color := clred;
          end
          else
          begin
            TLabel(Form1.FindComponent('lbl'+vNome)).Caption := vNome;
            TLabel(Form1.FindComponent('lbl'+vNome)).Font.Color := clblack;
          end;
        end;
      end;
    end;
    if (lblNome.Font.Color = clred) or (lblSobrenome.Font.Color = clred) or
     (lblCpf.Font.Color = clred) or (lblEmail.Font.Color = clred) or
     (lblSenha.Font.Color = clred) or (lblCep.Font.Color = clred) or
     (lblNº.Font.Color = clred)then
    begin
      Application.MessageBox('Favor preencher os campos obrigatórios','Atenção',MB_ICONEXCLAMATION+MB_OK);
      result := false;
    end
    else
    begin
      result := true;
    end;
  end;
end;

{verifica equidade dos campos email e senha}
function TForm1.verificaEquivalencia;
begin
  if (edtEmail.Text = edtConfEmail.Text) and (edtsenha.Text = edtConfSenha.Text) then
  begin
    result := true;
  end
  else
  begin
    Application.MessageBox('Email ou Senha não conferem','Atenção',MB_ICONEXCLAMATION+MB_OK);
    result := false;
  end;
end;

{verifica se o CPF possui 11 dígitos numéricos}
procedure TForm1.edtCPFExit(Sender: TObject);
var
  S: string;
  N: Integer;
begin
  N := Length(edtCPF.Text);
  S := edtCPF.Text;
  N := Length(S);
  if N < 11 then
  begin
    Application.MessageBox('O CPF informado não é válido!','Erro no CPF',MB_ICONERROR+MB_OK)
  end;
end;

{fechamento do Form}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := cafree;
  Form1 := nil;
end;
end.





