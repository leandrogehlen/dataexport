{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit dataexport;

interface

uses
  exDefinition, exExporter, exSerializer, exComponentReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('exComponentReg', @exComponentReg.Register);
end;

initialization
  RegisterPackage('dataexport', @Register);
end.
