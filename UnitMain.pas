unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, DateUtils, Vcl.FileCtrl, ActiveX, System.Win.ComObj,
  Vcl.Samples.Spin;

type
  TFormMain = class(TForm)
    buttonCheck: TButton;
    LabelMonth: TLabel;
    comboboxSelectMO: TComboBox;
    labelSelectMo: TLabel;
    labelSelectDirectory: TLabel;
    editSelectDirectory: TEdit;
    buttonSelectDirectory: TButton;
    groupboxSelectMO: TGroupBox;
    groupboxSelectDirectory: TGroupBox;
    LabelSelectMonth: TLabel;
    comboboxSelectMonth: TComboBox;
    SpinEditYear: TSpinEdit;
    stringgridMails: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure buttonSelectDirectoryClick(Sender: TObject);
    procedure buttonCheckClick(Sender: TObject);
    procedure comboboxSelectMonthSelect(Sender: TObject);
    procedure SpinEditYearChange(Sender: TObject);
    procedure stringgridMailsMouseEnter(Sender: TObject);
    procedure stringgridMailsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    function correctPath(inputDirectory: string): string;
    function checkExcelInstall: boolean;
  end;

var
  FormMain: TFormMain;

var
  directoryRoot: string;
  selectedNumberMonth, selectedYear: integer;
  selectedMonth: string;
  imgMailSent, imgMailNotSent: TPicture;
const
  ALLMO = 0;

implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
var excelCodeMO: variant;
    i, lastRow:integer;
begin
  stringgridMails.Cells[0,0] := '��� ��:';
  stringgridMails.Cells[2,0] := '����:';
  stringgridMails.Cells[3,0] := '����:';
  imgMailSent := TPicture.Create;
  imgMailNotSent := TPicture.Create;
  imgMailSent.LoadFromFile(ExtractFilePath(ParamStr(0))+'Icons\mailSent32px.bmp');
  imgMailNotSent.LoadFromFile(ExtractFilePath(ParamStr(0))+'Icons\mailNotSent32px.bmp');
  stringgridMails.ColWidths[1] := 36;
  stringgridMails.RowHeights[1] := 32;

  comboboxSelectMo.ItemIndex := ALLMO;
  if FileExists(ExtractFilePath(ParamStr(0))+'codeMO.xls') = True then
    begin
      excelCodeMO := CreateOleObject('Excel.Application');
      try
        excelCodeMO.Workbooks.Open(ExtractFilePath(ParamStr(0))+'codeMO.xls');
        lastRow := excelCodeMO.WorkSheets[1].UsedRange.Rows.Count;
        for i := 2 to lastRow do
          begin
            comboboxSelectMO.Items[i-1] := VarToStr(excelCodeMO.Range['A'+IntToStr(i)]) + ' � ' + VarToStr(excelCodeMO.Range['B'+IntToStr(i)]);
          end;

        stringgridMails.RowCount := lastRow; //���������� ���������� ����� StringGrid
                                                 //������ ���������� �� �� Excel-���������

        excelCodeMO.DisplayAlerts := False; //��������� ����������, �����, ����� ���������� Excel-����,
                                            //�� ������������ ��������� �� ����.
      finally
        excelCodeMO.Quit;
      end;
    end
  else
    ShowMessage('� ����� � ���������� ����������� Excel-���� "codeMO.xls". ��� ���������� � ����������. ��� ���� ��������� �������� �� �����');

  selectedYear := YearOf(Date);
  spineditYear.Value := selectedYear;
  selectedNumberMonth := MonthOf(Date);
  comboboxSelectMonth.ItemIndex := selectedNumberMonth;
  case selectedNumberMonth of
    1 : selectedMonth := '������';
    2 : selectedMonth := '�������';
    3 : selectedMonth := '����';
    4 : selectedMonth := '������';
    5 : selectedMonth := '���';
    6 : selectedMonth := '����';
    7 : selectedMonth := '����';
    8 : selectedMonth := '������';
    9 : selectedMonth := '��������';
    10 : selectedMonth := '�������';
    11 : selectedMonth := '������';
    12 : selectedMonth := '�������';
  end;
  labelMonth.Caption := '������ �� ����� ' + selectedMonth + ' ' + IntToStr(selectedYear) + ' ����:';

  directoryRoot := correctPath(editSelectDirectory.Text);
end;

procedure TFormMain.stringgridMailsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (ACol = 1) and (ARow = 1) then
    begin
      stringgridMails.Canvas.StretchDraw(Rect, imgMailSent.Graphic);
    end;
end;

procedure TFormMain.SpinEditYearChange(Sender: TObject);
begin
  selectedYear := spineditYear.Value;
  if selectedNumberMonth = 0 then
    labelMonth.Caption := '������ �� ��� ������' + ' ' + IntToStr(selectedYear) + ' ����:'
  else
    labelMonth.Caption := '������ �� ����� ' + selectedMonth + ' ' + IntToStr(selectedYear) + ' ����:';
end;

procedure TFormMain.comboboxSelectMonthSelect(Sender: TObject);
begin
  selectedNumberMonth := comboboxSelectMonth.ItemIndex;
  case selectedNumberMonth of
    1 : selectedMonth := '������';
    2 : selectedMonth := '�������';
    3 : selectedMonth := '����';
    4 : selectedMonth := '������';
    5 : selectedMonth := '���';
    6 : selectedMonth := '����';
    7 : selectedMonth := '����';
    8 : selectedMonth := '������';
    9 : selectedMonth := '��������';
    10 : selectedMonth := '�������';
    11 : selectedMonth := '������';
    12 : selectedMonth := '�������';
  else selectedMonth := '��� ������';
  end;
  if selectedNumberMonth = 0 then
    labelMonth.Caption := '������ �� ��� ������' + ' ' + IntToStr(selectedYear) + ' ����:'
  else
    labelMonth.Caption := '������ �� ����� ' + selectedMonth + ' ' + IntToStr(selectedYear) + ' ����:';
end;

procedure TFormMain.buttonCheckClick(Sender: TObject);
begin
  buttonCheck.Enabled := false;
  directoryRoot := correctPath(editSelectDirectory.Text);
  if System.SysUtils.DirectoryExists(DirectoryRoot) = False then
    ShowMessage('��������� ����� ��� ����������� �����. ��������� ����� ����� �� �����.')
  else
  if checkExcelInstall = False then
    ShowMessage('�� ����� ���������� �� ���������� Excel.')
  else
  if FileExists(ExtractFilePath(ParamStr(0))+'codeMO.xls') = False then
    ShowMessage('� ����� � ���������� ����������� Excel-���� "codeMO.xls". ��� ���������� � ����������. ��� ���� ��������� �������� �� �����.');
  if System.SysUtils.DirectoryExists(directoryRoot + 'Archive\') = False then
    ShowMessage('����������� ����� "Archive" � ���������� ' + directoryRoot + ', � ������� �������� ������������ ������.');
  buttonCheck.Enabled := true;
end;

procedure TFormMain.buttonSelectDirectoryClick(Sender: TObject);
begin
  if SelectDirectory('�������� ����� ��� ������ ���������������:', '', directoryRoot, [sdNewFolder, sdShowShares, sdNewUI, sdValidateDir]) then
    editSelectDirectory.Text := directoryRoot;
end;

function TFormMain.correctPath(inputDirectory: string): string;
begin
  if inputDirectory = '' then
    Result := ''
  else
    begin
      inputDirectory := Trim(inputDirectory);

      if Pos('/', inputDirectory) <> 0 then
        begin
          inputDirectory := StringReplace(inputDirectory, '/', '\', [rfReplaceAll]);
        end;

      if inputDirectory[length(inputDirectory)] <> '\' then
        Result := inputDirectory + '\'
      else
        Result := inputDirectory;
    end;
end;

function TFormMain.checkExcelInstall;
var ClassID: TCLSID;
    HRES: HRESULT;
begin
  HRES := CLSIDFromProgId( PWideChar(WideString('Excel.Application')), ClassID );
  if HRES = S_OK then
    result := true
  else
    result := false;
end;

procedure TFormMain.stringgridMailsMouseEnter(Sender: TObject);
begin
  stringgridMails.SetFocus;
end;

end.
