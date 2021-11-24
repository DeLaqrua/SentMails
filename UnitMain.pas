unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, DateUtils, Vcl.FileCtrl, ActiveX, System.Win.ComObj,
  Vcl.Samples.Spin;

type
  TFormMain = class(TForm)
    buttonCheck: TButton;
    labelHelp: TLabel;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    function correctPath(inputDirectory: string): string;
    function checkExcelInstall: boolean;
  end;

TMail = class(TObject)
  codeMO: string;
  isSent: boolean;
end;

var
  FormMain: TFormMain;

var
  directoryRoot: string;
  listCodeMO: TStringList;
  selectedNumberMonth, selectedYear: integer;
  selectedMonth: string;
  imgMailSent, imgMailNotSent: TPicture;
const
  ALLMO = 0;
  ALLMONTH = 0;

implementation

{$R *.dfm}

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  imgMailSent.Free;
  imgMailNotSent.Free;
  listCodeMO.Free;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var excelCodeMO: variant;
    i, lastRow: integer;
begin
  stringgridMails.Cells[0,0] := '��� ��:';
  stringgridMails.Cells[2,0] := '���� � ��������� ����� ��������:';
  stringgridMails.Cells[3,0] := '��� �����:';
  imgMailSent := TPicture.Create;
  imgMailNotSent := TPicture.Create;
  imgMailSent.LoadFromFile(ExtractFilePath(ParamStr(0))+'Icons\mailSent32px.bmp');
  imgMailNotSent.LoadFromFile(ExtractFilePath(ParamStr(0))+'Icons\mailNotSent32px.bmp');
  stringgridMails.ColWidths[1] := 36;
  stringgridMails.RowHeights[1] := 32;

  listCodeMo := TStringList.Create;
  comboboxSelectMo.ItemIndex := ALLMO;
  if FileExists(ExtractFilePath(ParamStr(0))+'codeMO.xls') = True then
    begin
      excelCodeMO := CreateOleObject('Excel.Application');
      try
        excelCodeMO.Workbooks.Open(ExtractFilePath(ParamStr(0))+'codeMO.xls');
        lastRow := excelCodeMO.WorkSheets[1].UsedRange.Rows.Count;
        for i := 2 to lastRow do
          begin
            listCodeMO.Add(VarToStr(excelCodeMO.Range['A'+IntToStr(i)]));
            comboboxSelectMO.Items[i-1] := listCodeMO[i-2] + ' � ' + VarToStr(excelCodeMO.Range['B'+IntToStr(i)]);
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
  labelHelp.Caption := '������ �� ����� ' + selectedMonth + ' ' + IntToStr(selectedYear) + ' ����:';

  directoryRoot := correctPath(editSelectDirectory.Text);
end;

procedure TFormMain.buttonCheckClick(Sender: TObject);
var searchResult: TSearchRec;
    i, j, monthNumber: integer;
begin
  buttonCheck.Enabled := false;

  for i := 1 to stringgridMails.RowCount-1 do
    begin
      stringgridMails.Rows[i].Clear;
    end;

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
    ShowMessage('����������� ����� "Archive" � ���������� ' + directoryRoot + ', � ������� �������� ������������ ������.')
  else
    begin
      j := 0;
      IF comboboxSelectMO.ItemIndex = ALLMO THEN
        begin
          for i := 0 to listCodeMO.Count-1 do
            begin
              if comboboxSelectMonth.ItemIndex = ALLMONTH then
                begin
                  for monthNumber := 1 to comboboxSelectMonth.Items.Count-1 do
                    begin
                      if FindFirst(directoryRoot + 'Archive\' + IntToStr(selectedYear) + '\' +
                                   comboboxSelectMonth.Items[monthNumber] +
                                   '\*' + listCodeMO[i] + '*', faNormal, searchResult) = 0 then
                        begin
                          repeat
                            j := j + 1;
                            stringgridMails.Cells[2, j] := DateTimeToStr(FileDateToDateTime(searchResult.Time));
                            stringgridMails.Cells[3, j] := searchResult.Name;
                          until FindNext(searchResult) <> 0;
                          FindClose(searchResult);
                        end;
                    end;
                end
              else
                begin
                  if FindFirst(directoryRoot + 'Archive\' + IntToStr(selectedYear) + '\' +
                               comboboxSelectMonth.Text +
                               '\*' + listCodeMO[i] + '*', faNormal, searchResult) = 0 then
                    begin
                      repeat
                        j := j + 1;
                        stringgridMails.Cells[2, j] := DateTimeToStr(FileDateToDateTime(searchResult.Time));
                        stringgridMails.Cells[3, j] := searchResult.Name;
                      until FindNext(searchResult) <> 0;
                      FindClose(searchResult);
                    end;
                end;
            end;
        end
      ELSE
        begin
          if comboboxSelectMonth.ItemIndex = ALLMONTH then
            begin
              for monthNumber := 1 to comboboxSelectMonth.Items.Count-1 do
                begin
                  if FindFirst(directoryRoot + 'Archive\' + IntToStr(selectedYear) + '\' +
                               comboboxSelectMonth.Items[monthNumber] +
                               '\*' + listCodeMO[comboboxSelectMO.ItemIndex-1] + '*', faNormal, searchResult) = 0 then
                    begin
                      repeat
                        j := j + 1;
                        stringgridMails.Cells[2, j] := DateTimeToStr(FileDateToDateTime(searchResult.Time));
                        stringgridMails.Cells[3, j] := searchResult.Name;
                      until FindNext(searchResult) <> 0;
                      FindClose(searchResult);
                    end;
                end;
            end
          else
            begin
              if FindFirst(directoryRoot + 'Archive\' + IntToStr(selectedYear) + '\' +
                           comboboxSelectMonth.Text +
                           '\*' + listCodeMO[comboboxSelectMO.ItemIndex-1] + '*', faNormal, searchResult) = 0 then
                begin
                  repeat
                    j := j + 1;
                    stringgridMails.Cells[2, j] := DateTimeToStr(FileDateToDateTime(searchResult.Time));
                    stringgridMails.Cells[3, j] := searchResult.Name;
                  until FindNext(searchResult) <> 0;
                  FindClose(searchResult);
                end;
            end;
        end;
    end;

  buttonCheck.Enabled := true;
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
    labelHelp.Caption := '������ �� ��� ������' + ' ' + IntToStr(selectedYear) + ' ����:'
  else
    labelHelp.Caption := '������ �� ����� ' + selectedMonth + ' ' + IntToStr(selectedYear) + ' ����:';
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
    labelHelp.Caption := '������ �� ��� ������' + ' ' + IntToStr(selectedYear) + ' ����:'
  else
    labelHelp.Caption := '������ �� ����� ' + selectedMonth + ' ' + IntToStr(selectedYear) + ' ����:';
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
