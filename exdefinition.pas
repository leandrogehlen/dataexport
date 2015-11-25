unit exDefinition;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  { Text alignment types }

  TexAlignment = (altNone, altRight, altLeft, altCenter);


  { TexElement }

  TexElement = class(TCollectionItem)
  private
    FName: String;
  published
    property Name: String read FName write FName;
  end;

  { TexElementList }

  TexElementList = class(TCollection)
  public
    function FindByName(AName: String): TexElement;
  end;

  { TexVariable }

  TexVariable = class(TexElement)
  private
    FExpression: String;
  published
    property Expression: String read FExpression write FExpression;
  end;

  { TexVariableList }

  TexVariableList = class(TexElementList)
  private
    function GetItem(Index: Integer): TexVariable;
    procedure SetItem(Index: Integer; AValue: TexVariable);
  public
    constructor Create;
    function FindByName(AName: String): TexVariable; reintroduce;
    function Add: TexVariable;
    property Items[Index: Integer]: TexVariable read GetItem write SetItem; default;
  end;

  { TexDictionary }

  TexDictionary = class(TexVariable)
  private
    FAlign: TexAlignment;
    FComplete: Char;
    FSize: Integer;
  public
    constructor Create(ACollection: TCollection); override;
  published
    property Align: TexAlignment read FAlign write FAlign default altNone;
    property Complete: Char read FComplete write FComplete;
    property Size: Integer read FSize write FSize;
  end;

  { TexDictionaryList }

  TexDictionaryList = class(TexElementList)
  private
    function GetItem(Index: Integer): TexDictionary;
    procedure SetItem(Index: Integer; AValue: TexDictionary);
  public
    constructor Create;
    function FindByName(AName: String): TexDictionary; reintroduce;
    function Add: TexDictionary;
    property Items[Index: Integer]: TexDictionary read GetItem write SetItem; default;
  end;

  { TexColumn }

  TexColumn = class(TexDictionary)
  private
    FDictionary: String;
  published
    property Dictionary: String read FDictionary write FDictionary;
  end;

  { TexColumnList }

  TexColumnList = class(TexElementList)
  private
    function GetItem(Index: Integer): TexColumn;
    procedure SetItem(Index: Integer; AValue: TexColumn);
  public
    constructor Create;
    function FindByName(AName: String): TexColumn; reintroduce;
    function Add: TexColumn;
    property Items[Index: Integer]: TexColumn read GetItem write SetItem; default;
  end;

  { TexParameter }

  TexParameter = class(TexVariable)
  private
    FCaption: String;
    FRequired: Boolean;
  published
    property Caption: String read FCaption write FCaption;
    property Required: Boolean read FRequired write FRequired;
  end;

  { TexParameterList }

  TexParameterList = class(TexElementList)
  private
    function GetItem(Index: Integer): TexParameter;
    procedure SetItem(Index: Integer; AValue: TexParameter);
  public
    constructor Create;
    function FindByName(AName: String): TexParameter; reintroduce;
    function Add: TexParameter;
    property Items[Index: Integer]: TexParameter read GetItem write SetItem; default;
  end;

  { TexPipeline }

  TexPipeline = class(TexElement)
  private
    FSQL: TStrings;
    procedure SetSQL(AValue: TStrings);
  public
    constructor Create(ACollection: TCollection);override;
    destructor Destroy; override;
  published
    property SQL: TStrings read FSQL write SetSQL;
  end;

  { TexPipelineList }

  TexPipelineList = class(TexElementList)
  private
    function GetItem(Index: Integer): TexPipeline;
    procedure SetItem(Index: Integer; AValue: TexPipeline);
  public
    constructor Create;
    function FindByName(AName: String): TexPipeline; reintroduce;
    function Add: TexPipeline;
    property Items[Index: Integer]: TexPipeline read GetItem write SetItem; default;
  end;

  { TexSessionList }

  TexSession = class;
  TexSessionList = class(TexElementList)
  private
    FOwner: TexSession;
    function GetItem(Index: Integer): TexSession;
    procedure SetItem(Index: Integer; AValue: TexSession);
  public
    constructor Create(AOwner: TexSession);
    function GetOwner: TPersistent; override;
    function FindByName(AName: String): TexSession; reintroduce;
    function Add: TexSession;
    property Items[Index: Integer]: TexSession read GetItem write SetItem; default;
  end;

  { TexSession }

  TexSession = class(TexElement)
  private
    FColumns: TexColumnList;
    FPipeline: String;
    FRowCount: Integer;
    FSessions: TexSessionList;
    FVisible: Boolean;
    procedure SeTexColumns(AValue: TexColumnList);
    procedure SeTexSessions(AValue: TexSessionList);
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    property RowCount: Integer read FRowCount write FRowCount;
  published
    property Pipeline: String read FPipeline write FPipeline;
    property Visible: Boolean read FVisible write FVisible;
    property Columns: TexColumnList read FColumns write SeTexColumns;
    property Sessions: TexSessionList read FSessions write SeTexSessions;
  end;

  { TexFile }

  TexFile = class(TexElement)
  private
    FSessions: TStrings;
    procedure SetSessions(AValue: TStrings);
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
  published
    property Sessions: TStrings read FSessions write SetSessions;
  end;

  { TexFileList }

  TexFileList = class(TexElementList)
  private
    function GetItem(Index: Integer): TexFile;
    procedure SetItem(Index: Integer; AValue: TexFile);
  public
    constructor Create;
    function FindByName(AName: String): TexFile; reintroduce;
    function Add: TexFile;
    property Items[Index: Integer]: TexFile read GetItem write SetItem; default;
  end;


implementation

{ TexDictionary }

constructor TexDictionary.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FAlign := altNone;
end;

{ TexElementList }

function TexElementList.FindByName(AName: String): TexElement;
var
  AItem: TCollectionItem;
  AElement: TexElement;
begin
  Result := nil;
  for AItem in Self do
  begin
    AElement := AItem as TexElement;
    if (SameText(AElement.Name, AName)) then
    begin
      Result := AElement;
      Exit;
    end;
  end;
end;

{ TexColumnList }

constructor TexColumnList.Create;
begin
  inherited Create(TexColumn);
end;

function TexColumnList.FindByName(AName: String): TexColumn;
begin
  Result := TexColumn(inherited FindByName(AName));
end;

function TexColumnList.Add: TexColumn;
begin
  Result := TexColumn(inherited Add);
end;

function TexColumnList.GetItem(Index: Integer): TexColumn;
begin
  Result := TexColumn(inherited GetItem(Index));
end;

procedure TexColumnList.SetItem(Index: Integer; AValue: TexColumn);
begin
  inherited SetItem(Index, AValue);
end;

{ TexParameterList }

constructor TexParameterList.Create;
begin
  inherited Create(TexParameter);
end;

function TexParameterList.FindByName(AName: String): TexParameter;
begin
  Result := TexParameter(inherited FindByName(AName));
end;

function TexParameterList.Add: TexParameter;
begin
  Result := TexParameter(inherited Add);
end;


function TexParameterList.GetItem(Index: Integer): TexParameter;
begin
  Result := TexParameter(inherited GetItem(Index));
end;

procedure TexParameterList.SetItem(Index: Integer; AValue: TexParameter);
begin
  inherited SetItem(Index, AValue);
end;

{ TexPipelineList }

constructor TexPipelineList.Create;
begin
  inherited Create(TexPipeline);
end;

function TexPipelineList.FindByName(AName: String): TexPipeline;
begin
  Result := TexPipeline(inherited FindByName(AName));
end;

function TexPipelineList.Add: TexPipeline;
begin
  Result := TexPipeline(inherited Add);
end;

function TexPipelineList.GetItem(Index: Integer): TexPipeline;
begin
  Result := TexPipeline(GetItem(Index));
end;

procedure TexPipelineList.SetItem(Index: Integer; AValue: TexPipeline);
begin
  inherited SetItem(Index, AValue);
end;

{ TexVariableList }

constructor TexVariableList.Create;
begin
  inherited Create(TexVariable);
end;

function TexVariableList.FindByName(AName: String): TexVariable;
begin
  Result := TexVariable(inherited FindByName(AName));
end;

function TexVariableList.Add: TexVariable;
begin
  Result := TexVariable(inherited Add);
end;

function TexVariableList.GetItem(Index: Integer): TexVariable;
begin
  Result := TexVariable(inherited GetItem(Index));
end;

procedure TexVariableList.SetItem(Index: Integer; AValue: TexVariable);
begin
  inherited SetItem(Index, AValue);
end;

{ TexDictionaryList }

constructor TexDictionaryList.Create;
begin
  inherited Create(TexDictionary);
end;

function TexDictionaryList.FindByName(AName: String): TexDictionary;
begin
  Result := TexDictionary(inherited FindByName(AName));
end;

function TexDictionaryList.GetItem(Index: Integer): TexDictionary;
begin
  Result := TexDictionary(inherited GetItem(Index)) ;
end;

procedure TexDictionaryList.SetItem(Index: Integer; AValue: TexDictionary);
begin
  inherited SetItem(Index, AValue);
end;

function TexDictionaryList.Add: TexDictionary;
begin
  Result := TexDictionary(inherited Add);
end;

{ TexSessionList }

constructor TexSessionList.Create(AOwner: TexSession);
begin
  inherited Create(TexSession);
  FOwner := AOwner;
end;

function TexSessionList.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TexSessionList.FindByName(AName: String): TexSession;
begin
  Result := TexSession(inherited FindByName(AName));
end;

function TexSessionList.Add: TexSession;
begin
  Result := TexSession(inherited Add);
end;

function TexSessionList.GetItem(Index: Integer): TexSession;
begin
  Result := TexSession(inherited GetItem(Index));
end;

procedure TexSessionList.SetItem(Index: Integer; AValue: TexSession);
begin
  inherited SetItem(Index, AValue);
end;

{ TexSession }

constructor TexSession.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FColumns := TexColumnList.Create;
  FSessions := TexSessionList.Create(Self);
end;

destructor TexSession.Destroy;
begin
  FColumns.Free;
  FSessions.Free;
  inherited Destroy;
end;

procedure TexSession.SeTexSessions(AValue: TexSessionList);
begin
  FSessions.Assign(AValue);
end;

procedure TexSession.SeTexColumns(AValue: TexColumnList);
begin
  FColumns.Assign(AValue);
end;

{ TexPipeline }

constructor TexPipeline.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FSQL := TStringList.Create;
end;

destructor TexPipeline.Destroy;
begin
  FSQL.Free;
  inherited Destroy;
end;

procedure TexPipeline.SetSQL(AValue: TStrings);
begin
  FSQL.Assign(AValue);
end;

{ TexFile }

constructor TexFile.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FSessions := TStringList.Create;
end;

destructor TexFile.Destroy;
begin
  FSessions.Free;
  inherited Destroy;
end;

procedure TexFile.SetSessions(AValue: TStrings);
begin
  FSessions.Assign(AValue);
end;

{ TexFileList }

constructor TexFileList.Create;
begin
  inherited Create(TexFile);
end;

function TexFileList.FindByName(AName: String): TexFile;
begin
  Result := TexFile(inherited FindByName(AName));
end;

function TexFileList.Add: TexFile;
begin
  Result := TexFile(inherited Add);
end;

function TexFileList.GetItem(Index: Integer): TexFile;
begin
  Result := TexFile(inherited GetItem(Index));
end;

procedure TexFileList.SetItem(Index: Integer; AValue: TexFile);
begin
  inherited SetItem(Index, AValue);
end;

end.
