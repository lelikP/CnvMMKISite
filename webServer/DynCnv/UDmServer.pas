unit UDmServer;

interface

uses
  System.SysUtils, uDWDatamodule, uDWAbout, uRESTDWServerEvents,
  uDWJSONObject, uDWConsts, System.JSON, System.Classes;

type
  TDMServer = class(TServerMethodDataModule)
    api: TDWServerEvents;
    procedure apiEventsverReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure apiEventsdyncnvReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure apiEventsdynmnlzReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure apiEventshimReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);

  private
    procedure GetHimParams(var Params: TDWParams);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMServer: TDMServer;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Main, UDbClasses;

{$R *.dfm}

procedure TDMServer.apiEventsdyncnvReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
  inherited;
  FMain.AddLogToMemo(RequestHeader);
  Result := DM.JsonCnv.GetData.ToString;
end;

procedure TDMServer.apiEventsdynmnlzReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
  inherited;
  FMain.AddLogToMemo(RequestHeader);
  Result := DM.JsonMnlz.GetData.ToString;
end;

procedure TDMServer.apiEventshimReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);

begin
  inherited;
  FMain.AddLogToMemo(RequestHeader);
  GetHimParams(Params);

  Result := DM.JsonHim.GetData.ToString;
end;

procedure TDMServer.GetHimParams(var Params: TDWParams);
var
  tp: string;
  npl: Integer;
begin
  DM.qHim.ParamByName('rowstart').AsString := Params.ItemsString
    ['rowstart'].AsString;
  DM.qHim.ParamByName('rowend').AsString := Params.ItemsString
    ['rowend'].AsString;
  npl := Params.ItemsString['npl'].AsInteger;
  if (npl = 0) or not(trunc(npl / 100000) in [1, 2, 3]) then
  begin
    DM.qHim.SQL[4] :=
      'where data>trunc(sysdate)- :days and data< trunc(sysdate)- :days+1';
    DM.qHim.ParamByName('days').AsString := Params.ItemsString['days'].AsString;
  end
  else
  begin
    DM.qHim.SQL[4] := 'where nplav=' + npl.ToString;
  end;

  tp := Params.ItemsString['type'].AsString.ToLower;
  if tp = 'all' then
    DM.qHim.SQL[5] := ''
  else
    DM.qHim.SQL[5] := 'and lower(tipproby)=''' + tp + '''';
  tp := Params.ItemsString['type'].AsString.ToLower;

end;

procedure TDMServer.apiEventsverReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
  inherited;
  FMain.AddLogToMemo(RequestHeader);
  Result := '{"������": "' + FMain.GetVersionDate + '"}';
end;

end.
