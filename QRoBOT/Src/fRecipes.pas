unit fRecipes;

interface

uses
  System.Classes, System.IniFiles, System.SysUtils, Vcl.Controls, Vcl.ExtCtrls,
  Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls, uTouchInput;

type
  TfrmRecipes = class(TForm)
    lblTitle: TLabel;
    grpLibrary: TGroupBox;
    lstRecipes: TListBox;
    btnRefresh: TButton;
    btnLoad: TButton;
    btnDelete: TButton;
    btnActivate: TButton;
    lblActiveCaption: TLabel;
    lblActiveRecipe: TLabel;
    grpRecipe: TGroupBox;
    lblName: TLabel;
    edtName: TEdit;
    lblGas: TLabel;
    chkH2: TCheckBox;
    chkN2: TCheckBox;
    chkAr: TCheckBox;
    chkO2: TCheckBox;
    lblPower: TLabel;
    edtPower: TEdit;
    lblSpeed: TLabel;
    edtSpeed: TEdit;
    lblProcessZ: TLabel;
    edtProcessZ: TEdit;
    lblMinLevel: TLabel;
    edtMinLevel: TEdit;
    grpTiming: TGroupBox;
    lblOnTime: TLabel;
    edtOnTime: TEdit;
    lblOffTime: TLabel;
    edtOffTime: TEdit;
    lblTotalTime: TLabel;
    edtTotalTime: TEdit;
    lblManualLimit: TLabel;
    edtManualLimit: TEdit;
    btnNew: TButton;
    btnSaveCopy: TButton;
    btnSave: TButton;
    lblStorage: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnActivateClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnSaveCopyClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure lstRecipesClick(Sender: TObject);
    procedure lstRecipesDblClick(Sender: TObject);
  private
    function RecipeFileName: string;
    function RecipeSection(const AName: string): string;
    procedure ClearEditor;
    procedure LoadSelectedRecipe;
    procedure RefreshRecipeList;
    procedure SaveRecipe(const AName: string);
    function ActiveRecipeName: string;
    function ValidateEditor(out AMessage: string): Boolean;
  end;

implementation

{$R *.dfm}

const
  CRecipePrefix = 'Recipe.';

function TfrmRecipes.ActiveRecipeName: string;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(RecipeFileName);
  try
    Result := Ini.ReadString('Active', 'Name', 'Default');
  finally
    Ini.Free;
  end;
end;

procedure TfrmRecipes.btnActivateClick(Sender: TObject);
var
  Ini: TIniFile;
  RecipeName: string;
begin
  if lstRecipes.ItemIndex < 0 then
    Exit;
  RecipeName := lstRecipes.Items[lstRecipes.ItemIndex];
  Ini := TIniFile.Create(RecipeFileName);
  try
    Ini.WriteString('Active', 'Name', RecipeName);
  finally
    Ini.Free;
  end;
  lblStorage.Caption := 'Active recipe: ' + RecipeName;
  lblStorage.Font.Color := clGreen;
  lblActiveRecipe.Caption := RecipeName;
end;

procedure TfrmRecipes.btnDeleteClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  if lstRecipes.ItemIndex < 0 then
    Exit;
  if SameText(lstRecipes.Items[lstRecipes.ItemIndex], ActiveRecipeName) then
  begin
    lblStorage.Caption := 'The active recipe cannot be deleted. Activate another recipe first.';
    lblStorage.Font.Color := clRed;
    Exit;
  end;
  Ini := TIniFile.Create(RecipeFileName);
  try
    Ini.EraseSection(RecipeSection(lstRecipes.Items[lstRecipes.ItemIndex]));
  finally
    Ini.Free;
  end;
  RefreshRecipeList;
  LoadSelectedRecipe;
end;

procedure TfrmRecipes.btnLoadClick(Sender: TObject);
begin
  LoadSelectedRecipe;
end;

procedure TfrmRecipes.btnNewClick(Sender: TObject);
begin
  lstRecipes.ItemIndex := -1;
  ClearEditor;
  edtName.SetFocus;
end;

procedure TfrmRecipes.btnRefreshClick(Sender: TObject);
begin
  RefreshRecipeList;
  LoadSelectedRecipe;
end;

procedure TfrmRecipes.btnSaveClick(Sender: TObject);
var
  MessageText: string;
begin
  if not ValidateEditor(MessageText) then
  begin
    lblStorage.Caption := MessageText;
    lblStorage.Font.Color := clRed;
    Exit;
  end;

  SaveRecipe(Trim(edtName.Text));
  lblStorage.Caption := 'Recipe saved: ' + Trim(edtName.Text);
  lblStorage.Font.Color := clGreen;
  RefreshRecipeList;
end;

procedure TfrmRecipes.btnSaveCopyClick(Sender: TObject);
var
  CopyName: string;
  MessageText: string;
begin
  if not ValidateEditor(MessageText) then
  begin
    lblStorage.Caption := MessageText;
    lblStorage.Font.Color := clRed;
    Exit;
  end;

  CopyName := Trim(edtName.Text) + '_Copy_' +
    FormatDateTime('yyyymmdd_hhnnss', Now);
  SaveRecipe(CopyName);
  edtName.Text := CopyName;
  lblStorage.Caption := 'Recipe copy saved: ' + CopyName;
  lblStorage.Font.Color := clGreen;
  RefreshRecipeList;
  lstRecipes.ItemIndex := lstRecipes.Items.IndexOf(CopyName);
end;

procedure TfrmRecipes.ClearEditor;
begin
  edtName.Clear;
  chkH2.Checked := False;
  chkN2.Checked := False;
  chkAr.Checked := True;
  chkO2.Checked := False;
  edtPower.Text := '100';
  edtSpeed.Text := '10';
  edtProcessZ.Text := '20.0';
  edtMinLevel.Text := '20';
  edtOnTime.Text := '10';
  edtOffTime.Text := '0';
  edtTotalTime.Text := '60';
  edtManualLimit.Text := '300';
end;

procedure TfrmRecipes.FormCreate(Sender: TObject);
begin
  EnableTouchKeyboards(Self);
  lblStorage.Caption := RecipeFileName;
  ClearEditor;
  RefreshRecipeList;
  LoadSelectedRecipe;
end;

procedure TfrmRecipes.FormShow(Sender: TObject);
begin
  RefreshRecipeList;
  LoadSelectedRecipe;
end;

procedure TfrmRecipes.LoadSelectedRecipe;
var
  Ini: TIniFile;
  Section: string;
begin
  if lstRecipes.ItemIndex < 0 then
    Exit;
  Section := RecipeSection(lstRecipes.Items[lstRecipes.ItemIndex]);
  Ini := TIniFile.Create(RecipeFileName);
  try
    edtName.Text := Ini.ReadString(Section, 'Name',
      lstRecipes.Items[lstRecipes.ItemIndex]);
    chkH2.Checked := Ini.ReadBool(Section, 'GasH2', False);
    chkN2.Checked := Ini.ReadBool(Section, 'GasN2', False);
    chkAr.Checked := Ini.ReadBool(Section, 'GasAr', False);
    chkO2.Checked := Ini.ReadBool(Section, 'GasO2', False);
    edtPower.Text := Ini.ReadString(Section, 'PowerW', '100');
    edtSpeed.Text := Ini.ReadString(Section, 'SpeedMmPerSec', '10');
    edtProcessZ.Text := Ini.ReadString(Section, 'ProcessZMm', '20.0');
    edtMinLevel.Text := Ini.ReadString(Section,
      'MinimumWaterLevelPercent', '20');
    edtOnTime.Text := Ini.ReadString(Section, 'PlasmaOnSeconds', '10');
    edtOffTime.Text := Ini.ReadString(Section, 'PlasmaOffSeconds', '0');
    edtTotalTime.Text := Ini.ReadString(Section, 'AutoTotalSeconds', '60');
    edtManualLimit.Text := Ini.ReadString(Section,
      'ManualLimitSeconds', '300');
  finally
    Ini.Free;
  end;
  lblStorage.Caption := 'Recipe loaded: ' + edtName.Text;
  lblStorage.Font.Color := clNavy;
end;

procedure TfrmRecipes.lstRecipesDblClick(Sender: TObject);
begin
  LoadSelectedRecipe;
end;

procedure TfrmRecipes.lstRecipesClick(Sender: TObject);
begin
  LoadSelectedRecipe;
end;

function TfrmRecipes.RecipeFileName: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.recipes.ini');
end;

function TfrmRecipes.RecipeSection(const AName: string): string;
begin
  Result := CRecipePrefix + AName;
end;

procedure TfrmRecipes.RefreshRecipeList;
var
  I: Integer;
  Ini: TIniFile;
  Sections: TStringList;
  ActiveName: string;
begin
  ActiveName := ActiveRecipeName;
  Sections := TStringList.Create;
  Ini := TIniFile.Create(RecipeFileName);
  try
    Ini.ReadSections(Sections);
    lstRecipes.Items.BeginUpdate;
    try
      lstRecipes.Clear;
      for I := 0 to Sections.Count - 1 do
        if SameText(Copy(Sections[I], 1, Length(CRecipePrefix)),
          CRecipePrefix) then
          lstRecipes.Items.Add(Copy(Sections[I], Length(CRecipePrefix) + 1,
            MaxInt));
      lblActiveRecipe.Caption := ActiveName;
      lstRecipes.ItemIndex := lstRecipes.Items.IndexOf(ActiveName);
    finally
      lstRecipes.Items.EndUpdate;
    end;
  finally
    Ini.Free;
    Sections.Free;
  end;
end;

procedure TfrmRecipes.SaveRecipe(const AName: string);
var
  Ini: TIniFile;
  Section: string;
begin
  Section := RecipeSection(AName);
  Ini := TIniFile.Create(RecipeFileName);
  try
    Ini.WriteString(Section, 'Name', AName);
    Ini.WriteBool(Section, 'GasH2', chkH2.Checked);
    Ini.WriteBool(Section, 'GasN2', chkN2.Checked);
    Ini.WriteBool(Section, 'GasAr', chkAr.Checked);
    Ini.WriteBool(Section, 'GasO2', chkO2.Checked);
    Ini.WriteString(Section, 'PowerW', Trim(edtPower.Text));
    Ini.WriteString(Section, 'SpeedMmPerSec', Trim(edtSpeed.Text));
    Ini.WriteString(Section, 'ProcessZMm', Trim(edtProcessZ.Text));
    Ini.WriteString(Section, 'MinimumWaterLevelPercent', Trim(edtMinLevel.Text));
    Ini.WriteString(Section, 'PlasmaOnSeconds', Trim(edtOnTime.Text));
    Ini.WriteString(Section, 'PlasmaOffSeconds', Trim(edtOffTime.Text));
    Ini.WriteString(Section, 'AutoTotalSeconds', Trim(edtTotalTime.Text));
    Ini.WriteString(Section, 'ManualLimitSeconds', Trim(edtManualLimit.Text));
  finally
    Ini.Free;
  end;
end;

function TfrmRecipes.ValidateEditor(out AMessage: string): Boolean;
var
  D: Double;
  N: Integer;
begin
  Result := False;
  if Trim(edtName.Text) = '' then
    AMessage := 'Enter a recipe name'
  else if not (chkH2.Checked or chkN2.Checked or chkAr.Checked or
    chkO2.Checked) then
    AMessage := 'Select at least one process gas'
  else if (not TryStrToFloat(edtPower.Text, D)) or (D <= 0) then
    AMessage := 'Power must be greater than zero'
  else if (not TryStrToFloat(edtSpeed.Text, D)) or (D <= 0) then
    AMessage := 'Speed must be greater than zero'
  else if (not TryStrToFloat(edtProcessZ.Text, D)) or (D < 0) or (D > 80) then
    AMessage := 'Process Z must be between 0 and 80 mm'
  else if (not TryStrToInt(edtMinLevel.Text, N)) or (N < 0) or (N > 100) then
    AMessage := 'Minimum water level must be 0 to 100%'
  else if (not TryStrToInt(edtOnTime.Text, N)) or (N < 0) then
    AMessage := 'Plasma ON time is invalid'
  else if (not TryStrToInt(edtOffTime.Text, N)) or (N < 0) then
    AMessage := 'Plasma OFF time is invalid'
  else if (not TryStrToInt(edtTotalTime.Text, N)) or (N < 1) then
    AMessage := 'AUTO total time must be at least 1 second'
  else if (not TryStrToInt(edtManualLimit.Text, N)) or
    (N < 1) or (N > 86400) then
    AMessage := 'MANUAL limit must be 1 to 86400 seconds'
  else
  begin
    AMessage := '';
    Result := True;
  end;
end;

end.
