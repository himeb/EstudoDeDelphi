unit uHSBanco;

interface

uses
  System.SysUtils, System.Classes, Data.Bind.EngExt, Vcl.Bind.DBEngExt,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  frxGradient, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Data.Bind.Components, Data.Bind.DBScope, REST.Types, REST.Response.Adapter,
  REST.Client, Data.Bind.ObjectScope, frxClass, frxDBSet;

type
  TBanco = class(TDataModule)
    fdConexao: TFDConnection;
    fdtabela: TFDTable;
    fdtabelaid: TFDAutoIncField;
    fdtabelanome: TStringField;
    fdtabelasobrenome: TStringField;
    fdtabelanascimento: TDateField;
    fdtabelacpf: TStringField;
    fdtabelaemail: TStringField;
    fdtabelasenha: TStringField;
    fdtabelacep: TIntegerField;
    fdtabelaestado: TStringField;
    fdtabelacidade: TStringField;
    fdtabelalogradouro: TStringField;
    fdtabelacomplemento: TWideStringField;
    fdtabelanumero: TIntegerField;
    fdtabelaimagem: TMemoField;
    frxGradientObject1: TfrxGradientObject;
    DataSource1: TDataSource;
    frxGradientObject2: TfrxGradientObject;
    qryDelete: TFDQuery;
    qryInsert: TFDQuery;
    qrySelect: TFDQuery;
    qryUpdate: TFDQuery;
    relDataSet: TfrxDBDataset;
    relRelatorio: TfrxReport;
    RESTClient2: TRESTClient;
    RESTRequest2: TRESTRequest;
    RESTResponse2: TRESTResponse;
    RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter;
    FDMemTable2: TFDMemTable;
    qryLogSelect: TFDQuery;
    qryLogUpdate: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Banco: TBanco;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
