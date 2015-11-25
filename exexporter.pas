unit exExporter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, fgl, exDefinition, exSerializer;

type

  { TexProvider }

  TexProvider = class(TComponent)
  public
    function CreateQuery(APipeline: TexPipeline; AMaster: TDataSet): TDataSet; virtual; abstract;
    procedure OpenConnection; virtual; abstract;
    procedure CloseConnection; virtual; abstract;
  end;

  { TexExporter }

  TexResutMap = specialize TFPGMap<String, TStrings>;

  TexExporter = class(TComponent)
  private
    FProvider: TexProvider;
    FFiles: TexFileList;
    FDescription: String;
    FEvents: TexVariableList;
    FParameters: TexParameterList;
    FPipelines: TexPipelineList;
    FSerializer: TexSerializer;
    FSessions: TexSessionList;
    FDictionaries: TexDictionaryList;
    procedure SetFiles(AValue: TexFileList);
    procedure SetDictionaries(AValue: TexDictionaryList);
    procedure SetEvents(AValue: TexVariableList);
    procedure SetParameters(AValue: TexParameterList);
    procedure SetPipelines(AValue: TexPipelineList);
    procedure SetSessions(AValue: TexSessionList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromStream(const AStream: TStream);
    procedure LoadFromFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
    procedure SaveToFile(const AFileName: string);
    function Execute: TexResutMap;
  published
    property Description: String read FDescription write FDescription;
    property Sessions: TexSessionList read FSessions write SetSessions;
    property Provider: TexProvider read FProvider write FProvider;
    property Dictionaries: TexDictionaryList read FDictionaries write SetDictionaries;
    property Events: TexVariableList read FEvents write SetEvents;
    property Pipelines: TexPipelineList read FPipelines write SetPipelines;
    property Parameters: TexParameterList read FParameters write SetParameters;
    property Serializer: TexSerializer read FSerializer write FSerializer;
    property Files: TexFileList read FFiles write SetFiles;
  end;

implementation

{ TexExporter }

constructor TexExporter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSessions := TexSessionList.Create(nil);
  FDictionaries := TexDictionaryList.Create;
  FEvents := TexVariableList.Create;
  FPipelines := TexPipelineList.Create;
  FParameters := TexParameterList.Create;
  FFiles := TexFileList.Create;
end;

destructor TexExporter.Destroy;
begin
  FSessions.Free;
  FDictionaries.Free;
  FEvents.Free;
  FPipelines.Free;
  FParameters.Free;
  FFiles.Free;;
  inherited Destroy;
end;

procedure TexExporter.SetFiles(AValue: TexFileList);
begin
  FFiles.Assign(AValue);
end;

procedure TexExporter.SetSessions(AValue: TexSessionList);
begin
  FSessions.Assign(AValue);
end;

procedure TexExporter.SetDictionaries(AValue: TexDictionaryList);
begin
  FDictionaries.Assign(AValue);
end;

procedure TexExporter.SetEvents(AValue: TexVariableList);
begin
  FEvents.Assign(AValue);
end;

procedure TexExporter.SetParameters(AValue: TexParameterList);
begin
  FParameters.Assign(AValue);
end;

procedure TexExporter.SetPipelines(AValue: TexPipelineList);
begin
  FPipelines.Assign(AValue);
end;

procedure TexExporter.LoadFromStream(const AStream: TStream);
var
  AMemStream: TMemoryStream;
begin
  AMemStream := TMemoryStream.Create;
  try
    ObjectTextToBinary(AStream, AMemStream);
    AMemStream.Position := 0;
    AMemStream.ReadComponent(Self);
  finally
    AMemStream.Free;
  end;
end;

procedure TexExporter.LoadFromFile(const AFileName: String);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TexExporter.SaveToStream(const AStream: TStream);
var
  AMemStream: TMemoryStream;
begin
  AMemStream := TMemoryStream.Create;
  try
    AMemStream.WriteComponent(Self);
    AMemStream.Position := 0;
    ObjectBinaryToText(AMemStream, AStream);
  finally
    AMemStream.Free;
  end;
end;

procedure TexExporter.SaveToFile(const AFileName: string);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(AStream);
  finally
    AStream.Free;
  end;
end;

function TexExporter.Execute: TexResutMap;
begin

end;

end.
