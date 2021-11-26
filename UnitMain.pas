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

    procedure searchMails(inputDirectoryArchive: string; //������ ��� ������������ ����� ���� ����� Archive.
                                                         //Ÿ � ����� ��������� ��� ������ �����.
                          inputYear, inputMonth: string;
                          inputCodeMO: string;
                          inputRowStringGrid: integer);
  end;

TMail = class(TObject)
  codeMO: string;
  isSent: boolean;
  month: string;
  fileName: string;
  fileDateTime: string;
end;

var
  FormMain: TFormMain;

var
  directoryRoot, directoryArchive: string;
  listCodeMO: TStringList;
  selectedNumberMonth, selectedYear: integer;
  selectedMonth: string;
  imgMailSent, imgMailNotSent: TPicture;
  mails: array of TMail;
  indexMails: integer;
const
  ALLMO = 0;
  ALLMONTH = 0;

implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
var excelCodeMO: variant;
    i, lastRow: integer;
begin
  stringgridMails.RowCount := 2; //���������� ���������� ����� StringGrid
                                 //������ ���������� �� �� Excel-���������
  stringgridMails.FixedRows := 1; //������ ������ � ���������
  stringgridMails.Cells[0,0] := '��� ��:';
  stringgridMails.Cells[2,0] := '����� ��������:';
  stringgridMails.Cells[3,0] := '��� �����:';
  stringgridMails.Cells[4,0] := '���� ��������� �����:';
  imgMailSent := TPicture.Create;
  imgMailNotSent := TPicture.Create;
  imgMailSent.LoadFromFile(ExtractFilePath(ParamStr(0))+'Icons\mailSent32px.bmp');
  imgMailNotSent.LoadFromFile(ExtractFilePath(ParamStr(0))+'Icons\mailNotSent32px.bmp');
  stringgridMails.ColWidths[1] := 36;
  stringgridMails.DefaultRowHeight := 32;

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
  directoryArchive := directoryRoot + 'Archive\';
end;

procedure TFormMain.buttonCheckClick(Sender: TObject);
var searchResult: TSearchRec;
    i, j, monthNumber, indexMO: integer;
    test1, test2, test3: string;
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
  if System.SysUtils.DirectoryExists(directoryArchive) = False then
    ShowMessage('����������� ����� "Archive" � ���������� ' + directoryRoot + ', � ������� �������� ������������ ������.')
  else
    begin
      //������� ������
      if Length(mails) > 0 then
        begin
          for indexMails := 0 to High(mails) do
            begin
              mails[indexMails].Free;
            end;
        end;
      SetLength(mails, 0);
      indexMails := 0;
      //������� StringGrid
      for i := 1 to stringgridMails.RowCount-1 do
        begin
          stringgridMails.Rows[i].Clear;
        end;
      stringgridMails.RowCount := 2;
      stringgridMails.FixedRows := 1; //������ ������ � ���������.
                                      //�� ����� ���� ������ ������ ���������� �����.
                                      //������� RowCount ������ ���� ���� �� 2.
      j := 0;
      IF comboboxSelectMO.ItemIndex = ALLMO THEN
        begin
          for indexMO := 0 to listCodeMO.Count-1 do
            begin
              if comboboxSelectMonth.ItemIndex = ALLMONTH then
                begin
                  for monthNumber := 1 to comboboxSelectMonth.Items.Count-1 do
                    searchMails(directoryArchive, IntToStr(selectedYear), comboboxSelectMonth.Items[monthNumber], listCodeMO[indexMO], indexMails);
                end
              else
                searchMails(directoryArchive, IntToStr(selectedYear), comboboxSelectMonth.Text, listCodeMO[indexMO], indexMails);
            end;
        end
      ELSE
        begin
          if comboboxSelectMonth.ItemIndex = ALLMONTH then
            begin
              for monthNumber := 1 to comboboxSelectMonth.Items.Count-1 do
                searchMails(directoryArchive, IntToStr(selectedYear), comboboxSelectMonth.Items[monthNumber], listCodeMO[comboboxSelectMO.ItemIndex-1], indexMails);
            end
          else
            searchMails(directoryArchive, IntToStr(selectedYear), comboboxSelectMonth.Text, listCodeMO[comboboxSelectMO.ItemIndex-1], indexMails);
        end;

      //�� ������� ������� �������� � StringGrid
      stringgridMails.RowCount := Length(mails)+1;
      for i := 0 to High(mails) do
        begin
          stringgridMails.Cells[0, i+1] := mails[i].codeMO;
          stringgridMails.Cells[2, i+1] := mails[i].month;
          stringgridMails.Cells[3, i+1] := mails[i].fileName;
          stringgridMails.Cells[4, i+1] := mails[i].fileDateTime;
        end;
    end;

  buttonCheck.Enabled := true;
end;

procedure TFormMain.stringgridMailsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  {if (ACol = 1) and (ARow = 1) then
    begin
      stringgridMails.Canvas.StretchDraw(Rect, imgMailSent.Graphic);
    end;}
end;

procedure TFormMain.searchMails(inputDirectoryArchive, inputYear, inputMonth, inputCodeMO: string; inputRowStringGrid: integer);
var searchResult: TSearchRec;
begin
  if FindFirst(inputDirectoryArchive + inputYear + '\' + inputMonth + '\*' + inputCodeMO + '*', faNormal, searchResult) = 0 then
    begin
      repeat
        SetLength(mails, Length(mails)+1);
        mails[inputRowStringGrid] := TMail.Create;
        mails[inputRowStringGrid].codeMO := inputCodeMO;
        mails[inputRowStringGrid].isSent := True;
        mails[inputRowStringGrid].month := inputMonth;
        mails[inputRowStringGrid].fileDateTime := DateTimeToStr(FileDateToDateTime(searchResult.Time)); //����� ��������� ����� ������������
                                                                                                        //� DOS-�������(Integer)
        mails[inputRowStringGrid].fileName := searchResult.Name;
        indexMails := IndexMails + 1;
        inputRowStringGrid := IndexMails;
      until FindNext(searchResult) <> 0;
      FindClose(searchResult);
    end
  else
    begin
      SetLength(mails, Length(mails)+1);
      mails[inputRowStringGrid] := TMail.Create;
      mails[inputRowStringGrid].codeMO := inputCodeMO;
      mails[inputRowStringGrid].isSent := False;
      mails[inputRowStringGrid].month := inputMonth;
      indexMails := IndexMails + 1;
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

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  imgMailSent.Free;
  imgMailNotSent.Free;
  listCodeMO.Free;
  //������� ������
  if Length(mails) > 0 then
    begin
      for indexMails := 0 to High(mails) do
        begin
          mails[indexMails].Free;
        end;
    end;
  SetLength(mails, 0);
end;

end.
