unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, ComCtrls, StdCtrls, WebCopy, CJVLinkLabel, Shellapi;

type
  TForm2 = class(TForm)
    Image1: TImage;
    ProgressBar1: TProgressBar;
    Panel4: TPanel;
    d: TWebCopy;
    Label3: TLabel;
    l: TCJVLinkLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    Button11: TButton;
    Button2: TButton;
    procedure dConnectError(Sender: TObject);
    procedure dCopyProgress(Sender: TObject; fileidx, size,
      totsize: Integer);
    procedure dError(Sender: TObject; ErrorCode: Integer);
    procedure dFileDateCheck(Sender: TObject; idx: Integer;
      newdate: TDateTime; allow: Boolean);
    procedure dFileDone(Sender: TObject; idx: Integer);
    procedure dFileStart(Sender: TObject; idx: Integer);
    procedure dURLNotFound(Sender: TObject; url: String);
    procedure Button2Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure ExecutePrograma(Nome, Parametros: String);
Var
 Comando: Array[0..1024] of Char;
 Parms: Array[0..1024] of Char;
begin
  StrPCopy (Comando, Nome);
  StrPCopy (Parms, Parametros);
  ShellExecute (0, Nil, Comando, Parms, Nil, SW_ShowNormal);
end;


procedure TForm2.dConnectError(Sender: TObject);
begin
  Application.MessageBox('Erro de conexao com a Internet!', 'Informação', mb_Ok + mb_IconInformation);
  Button1.enabled := True;
end;

procedure TForm2.dCopyProgress(Sender: TObject; fileidx, size,
  totsize: Integer);
begin
label1.Caption := IntToStr(size) + ' bytes recebidos de ' + IntToStr(totsize);
ProgressBar1.Max:=totsize;
ProgressBar1.Position :=size;
end;

procedure TForm2.dError(Sender: TObject; ErrorCode: Integer);
begin
  panel4.Caption := 'Erro';
  Application.MessageBox('Erro ao fazer o Download do Interbase, Clique em Ok para que o sistema acesse a pagina da HF-Software para que você possa faze-lo manualmente!', 'Erro', mb_Ok + mb_IconError);
  l.Click;
  Label1.Caption := '';
  progressbar1.Position := 0;
  panel4.Caption := '';
  Button1.enabled := True;
end;

procedure TForm2.dFileDateCheck(Sender: TObject; idx: Integer;
  newdate: TDateTime; allow: Boolean);
begin
panel4.Caption := 'Baixando arquivo, por favor Aguarde...';
end;

procedure TForm2.dFileDone(Sender: TObject; idx: Integer);
begin
if fileexists('C:\HF-Software\Siscomad\Interbase.exe') then
begin
  panel4.Caption := 'Concluído';
  if Application.MessageBox('Download realizado com sucesso, Clique em Ok para Instalar o Interbase?', 'Confirmação',
  mb_Ok + mb_ICONInformation) = idOk then
  begin
  Label1.Caption := '';
  progressbar1.Position := 0;
  panel4.Caption := '';
  ExecutePrograma('C:\HF-Software\Siscomad\Interbase.exe','');
  Button1.enabled := True;
  end
  end;
end;

procedure TForm2.dFileStart(Sender: TObject; idx: Integer);
begin
panel4.Caption := 'Abrindo ' + D.Items[0].URL;
end;

procedure TForm2.dURLNotFound(Sender: TObject; url: String);
begin
  Application.MessageBox('Não foi possivel estabelecer conexão com o servidor de download!', 'Informação', mb_Ok + mb_IconInformation);
  panel4.Caption := '';
  Button1.enabled := True;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm2.Button11Click(Sender: TObject);
begin
if button1.Enabled = True then
  begin
  Application.MessageBox('Não há Download em andamento para ser cancelado!', 'Informação', mb_Ok + mb_IconInformation);
  end
  else
  begin
  D.CancelCopy;
  Application.MessageBox('Download cancelado pelo usuário!', 'Informação', mb_Ok + mb_IconInformation);
  Label1.Caption := '';
  progressbar1.Position := 0;
  panel4.Caption := '';
  Button1.enabled := True;
  end
end;

procedure TForm2.FormShow(Sender: TObject);
begin
form1.Visible := False;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
      Button1.enabled := False;
      D.Items[0].URL := 'http://www.hfinformatica.net/ib.exe';
      D.Items[0].TargetDir := 'C:\';
      D.Items[0].TargetFilename := 'HF-Software\interbase.exe';
      D.Execute;
end;

end.
