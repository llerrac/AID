{*******************************************************}
{                                                       }
{       Title: Windows information unit for Delphi™     }
{       Version: 1.5 2002-05-28                         }
{       Author:  Jonas Gunnarsson                       }
{                                                       }
{       Send comments to Guson@spray.se                 }
{                                                       }
{*******************************************************}
{ Microsoft® Platform SDK <http://www.microsoft.com/msdownload/platformsdk/sdkupdate/> }
{ OSVERSIONINFO <http://msdn.microsoft.com/library/default.asp?url=/library/en-us/sysinfo/sysinfo_3a0i.asp> }
{ GetVersionEx <http://msdn.microsoft.com/library/default.asp?url=/library/en-us/sysinfo/sysinfo_49iw.asp> }
{ OSVERSIONINFOEX <http://msdn.microsoft.com/library/default.asp?url=/library/en-us/sysinfo/sysinfo_1o1e.asp> }
{ Getting the System Version <http://msdn.microsoft.com/library/default.asp?url=/library/en-us/sysinfo/sysinfo_92jy.asp> }
{ Core Platform SDK November 2001, winnt.h (BUILD Version: 0082) }

unit WinInfo;

interface

uses
  WinTypes;

type
  { ref winnt.h, line 7681}
  OSVERSIONINFOEX = packed record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array [0..127] of AnsiChar; { Maintenance string for PSS usage }
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: WORD;
    wProductType: BYTE;
    wReserved: BYTE;
  end;
  TOSVersionInfoEx = OSVERSIONINFOEX;
  POSVersionInfoEx = ^TOSVersionInfoEx;

const
  { WindowsVersions }
  wvWin311      = 0;
  wvWin95       = 1;
  wvWin95OSR2   = 2;
  wvWin98       = 3;
  wvWin98SE     = 4;
  wvWinMe       = 5;
  wvWinNT       = 6;
  wvWinNTServer = 7;
  wvWin2K       = 8;
  wvWin2KServer = 9;
  wvWinXP       = 10;
  wvWinXPServer = 11;

const
  { ref winnt.h, line 7749 }
  VER_NT_WORKSTATION                 = $0000001;
  VER_NT_DOMAIN_CONTROLLER           = $0000002;
  VER_NT_SERVER                      = $0000003;
  { ref winnt.h, line 893 }
  VER_SERVER_NT                      = $80000000;
  VER_WORKSTATION_NT                 = $40000000;
  VER_SUITE_SMALLBUSINESS            = $00000001;
  VER_SUITE_ENTERPRISE               = $00000002;
  VER_SUITE_BACKOFFICE               = $00000004;
  VER_SUITE_COMMUNICATIONS           = $00000008;
  VER_SUITE_TERMINAL                 = $00000010;
  VER_SUITE_SMALLBUSINESS_RESTRICTED = $00000020;
  VER_SUITE_EMBEDDEDNT               = $00000040;
  VER_SUITE_DATACENTER               = $00000080;
  VER_SUITE_SINGLEUSERTS             = $00000100;
  VER_SUITE_PERSONAL                 = $00000200;
  VER_SUITE_BLADE                    = $00000400;

  procedure GetWindowsVersion(var MajorVersion: Integer;
                              var MinorVersion: Integer;
                              var BuildNumber: Integer;
                              var PlatformId: Integer;
                              var CSDVersion: String);

  procedure GetProductType(var IsServer: Boolean;
                           var ProductTypeString: String;
                           var SuiteMaskString: String;
                           var ServicePackString: String);

  procedure GetWindowsInfo(var WindowsVersion: Integer;
                           var WindowsPlatformId: Integer;
                           var WindowsVersionString: String;
                           var WindowsBuildString: String);

  function GetWindowsLongInfo: String;

implementation

uses
  SysUtils, Registry;

{ ref sysinfo_92jy }
procedure GetWindowsVersion(var MajorVersion: Integer;
                            var MinorVersion: Integer;
                            var BuildNumber: Integer;
                            var PlatformId: Integer;
                            var CSDVersion: String);
var
  VerInfoRec: OSVERSIONINFO;
begin
  ZeroMemory(@VerInfoRec, SizeOf(OSVERSIONINFO));
  VerInfoRec.dwOSVersionInfoSize := SizeOf(OSVERSIONINFO);
  if GetVersionEx(VerInfoRec) then
  begin
    MajorVersion := VerInfoRec.dwMajorVersion;
    MinorVersion := VerInfoRec.dwMinorVersion;
    BuildNumber := (VerInfoRec.dwBuildNumber and $FFFF);
    PlatformId := VerInfoRec.dwPlatformId;
    CSDVersion := StrPas(VerInfoRec.szCSDVersion);
    if (PlatformId = VER_PLATFORM_WIN32_WINDOWS) then
      MinorVersion := (VerInfoRec.dwBuildNumber and $FF0000) shr 16;
  end
  else
  begin
    MajorVersion := 0;
    MinorVersion := 0;
    BuildNumber := 0;
    PlatformId := VER_PLATFORM_WIN32_NT;
    CSDVersion := 'Error retriving version';
  end;
end;

{ ref sysinfo_1o1e }
procedure GetProductType(var IsServer: Boolean;
                         var ProductTypeString: String;
                         var SuiteMaskString: String;
                         var ServicePackString: String);
var
  VerInfoRec: TOSVersionInfoEx;
  pVerInfoRec : POSVersionInfo;
  szProductType: String;
  szSuiteMask: String;
  szCSDVersion: String;
  IsProductType, IsSuiteMask: Boolean;
begin
  IsServer := False;
  ProductTypeString := '';
  SuiteMaskString := '';
  ServicePackString := '';
  ZeroMemory(@VerInfoRec, SizeOf(OSVERSIONINFO));
  VerInfoRec.dwOSVersionInfoSize := SizeOf(VerInfoRec);
  pVerInfoRec := @VerInfoRec;
  if GetVersionEx(pVerInfoRec^) then  //Requires Windows NT 4.0 SP6 or later.
  begin
    IsProductType := True;
    szProductType := '';
    case VerInfoRec.wProductType of
      VER_NT_WORKSTATION: szProductType := 'Professional';
      VER_NT_DOMAIN_CONTROLLER: szProductType := 'Domain controller';
      VER_NT_SERVER: szProductType := 'Server'
    else
      IsProductType := False;
      IsServer := True;
    end;

    IsSuiteMask := False;
    szSuiteMask := '';
    if VerInfoRec.wProductType = VER_NT_WORKSTATION then
    begin
      IsServer := False;
      if (VerInfoRec.wSuiteMask and VER_SUITE_SINGLEUSERTS) <> 0 then
        szSuiteMask := 'Personal';
      if (VerInfoRec.wSuiteMask and VER_SUITE_PERSONAL) <> 0 then
        szSuiteMask := szSuiteMask + 'Home Edition';
    end
    else
    begin
      IsServer := True;
      if (VerInfoRec.wSuiteMask and VER_SUITE_SMALLBUSINESS) <> 0 then
        szSuiteMask := szSuiteMask + 'Small Business Server';
      if (VerInfoRec.wSuiteMask and VER_SUITE_ENTERPRISE) <> 0 then
      begin
        if VerInfoRec.dwMinorVersion = 0 then
          szSuiteMask := szSuiteMask + 'Advanced Server'
        else
          szSuiteMask := szSuiteMask + 'Enterprise Server';
      end;
      if (VerInfoRec.wSuiteMask and VER_SUITE_BACKOFFICE) <> 0 then
        szSuiteMask := szSuiteMask + 'BackOffice components';
      if (VerInfoRec.wSuiteMask and VER_SUITE_COMMUNICATIONS) <> 0 then
        szSuiteMask := szSuiteMask + 'Communication components';
      if (VerInfoRec.wSuiteMask and VER_SUITE_TERMINAL) <> 0 then
        szSuiteMask := szSuiteMask + 'Terminal Services';
      if (VerInfoRec.wSuiteMask and VER_SUITE_SMALLBUSINESS_RESTRICTED) <> 0 then
        szSuiteMask := szSuiteMask + 'Small Business Server with restrictive client license';
      if (VerInfoRec.wSuiteMask and VER_SUITE_EMBEDDEDNT) <> 0 then
        szSuiteMask := szSuiteMask + 'Embedded NT';
      if (VerInfoRec.wSuiteMask and VER_SUITE_DATACENTER) <> 0 then
        szSuiteMask := szSuiteMask + 'DataCenter Server';
      if (VerInfoRec.wSuiteMask and VER_SUITE_BLADE) <> 0 then
        szSuiteMask := szSuiteMask + 'Web Server';
    end;
    if szSuiteMask <> '' then IsSuiteMask := True;

    if IsProductType or IsSuiteMask then
    begin
      if IsProductType and IsSuiteMask then
      begin
        ProductTypeString := szProductType;
        SuiteMaskString := szSuiteMask;
      end
      else
      begin
        if IsProductType then
          ProductTypeString := szProductType
        else
          SuiteMaskString := szSuiteMask;
      end;
    end;
    ServicePackString := StrPas(VerInfoRec.szCSDVersion);
  end
  else  // Use the registry on early versions of Windows NT.
  begin
    with TRegistry.Create do
    begin
      try
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey('SYSTEM\CurrentControlSet\Control\ProductOptions', True) then
        begin
          if ValueExists('ProductType') then
          begin
            szProductType := ReadString('ProductType');
            if Pos('WINNT', UpperCase(szProductType)) <> 0 then
            begin
              IsServer := False;
              ProductTypeString := 'Professional';
            end
            else
            begin
              IsServer := True;
              if (Pos('SERVERNT', UpperCase(szProductType)) <> 0) then
                ProductTypeString := 'Server';
              if (Pos('LANMANNT', UpperCase(szProductType)) <> 0) then
                ProductTypeString := 'Advanced Server';
             end;
          end;
          if ValueExists('SuiteMask') then
          begin
            szSuiteMask := ReadString('SuiteMask');
            IsServer := True;
            SuiteMaskString := szSuiteMask;
          end;
        end;
        CloseKey;
        if OpenKey('SYSTEM\CurrentControlSet\Control\Windows', True) then
        begin
          if ValueExists('CSDVersion') then
          begin
            szCSDVersion := ReadString('CSDVersion');
            ServicePackString := szCSDVersion;
          end;
        end;
        CloseKey;
      finally
        Free;
      end;
    end;
  end;
end;

procedure GetWindowsInfo(var WindowsVersion: Integer;
                         var WindowsPlatformId: Integer;
                         var WindowsVersionString: String;
                         var WindowsBuildString: String);

var
  MajorVersion: Integer;
  MinorVersion: Integer;
  BuildNumber: Integer;
  PlatformId: Integer;
  CSDVersion: string;
  IsServer: Boolean;
  ProductTypeString: String;
  SuiteMaskString: String;
  ServicePackString: String;
begin
  GetWindowsVersion(MajorVersion, MinorVersion, BuildNumber, PlatformId, CSDVersion);
  WindowsVersion := wvWinXP;
  WindowsPlatformId := VER_PLATFORM_WIN32_NT;
  case PlatformId of
    VER_PLATFORM_WIN32s:
      begin
        WindowsPlatformId := VER_PLATFORM_WIN32s;
        WindowsVersion := wvWin311;
      end;
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        WindowsPlatformId := VER_PLATFORM_WIN32_WINDOWS;
        if (MajorVersion = 4) then
        begin
          case MinorVersion of
            0..9: //All 'normal' Win95 versions are 4.00, 4.03 is the USB Supplement
              begin
                if Pos('C', CSDVersion) in [1, 2] then
                  WindowsVersion := wvWin95OSR2
                else
                  WindowsVersion := wvWin95; // B
              end;
            10..89: //All 'normal' Win98 versions are 4.10
              begin
                if Pos('A', CSDVersion) in [1, 2] then
                  WindowsVersion := wvWin98SE
                else
                  WindowsVersion := wvWin98;
              end;
            90..99:  //All 'normal' WinMe versions are 4.90
              begin
                WindowsVersion := wvWinMe;
              end;
          end;
        end;
      end;
    VER_PLATFORM_WIN32_NT:
      begin
        WindowsPlatformId := VER_PLATFORM_WIN32_NT;
        GetProductType(IsServer, ProductTypeString, SuiteMaskString, ServicePackString);
        if (MajorVersion = 5) then
        begin
          if IsServer then
          begin
            case MinorVersion of
              0: WindowsVersion := wvWin2kServer;
              1: WindowsVersion := wvWinXPServer;
            end;
          end
          else
          begin
            case MinorVersion of
              0: WindowsVersion := wvWin2k;
              1: WindowsVersion := wvWinXP;
            end;
          end;
        end
        else
        begin
          if (MajorVersion <= 4) then  // 4 is NT 4.x, 3 is NT 3.x
          begin
            if IsServer then
              WindowsVersion := wvWinNTServer
            else
              WindowsVersion := wvWinNT;
          end;
        end;
      end;
  end;

  WindowsVersionString := 'Microsoft Windows ';
  case WindowsVersion of
    wvWin311: WindowsVersionString := WindowsVersionString + '3.11';
    wvWin95: WindowsVersionString := WindowsVersionString + '95';
    wvWin95OSR2: WindowsVersionString := WindowsVersionString + '95 OSR2';
    wvWin98: WindowsVersionString := WindowsVersionString + '98';
    wvWin98SE: WindowsVersionString := WindowsVersionString + '98 SE';
    wvWinMe: WindowsVersionString := WindowsVersionString + 'Me';
    wvWinNT: WindowsVersionString := WindowsVersionString + 'NT';
    wvWinNTServer: WindowsVersionString := WindowsVersionString + 'NT Server';
    wvWin2K: WindowsVersionString := WindowsVersionString + '2000';
    wvWin2KServer: WindowsVersionString := WindowsVersionString + '2000 Server';
    wvWinXP: WindowsVersionString := WindowsVersionString + 'XP';
    wvWinXPServer: WindowsVersionString := WindowsVersionString + '.NET Server';
  end;
  WindowsBuildString := IntToStr(MajorVersion)+'.'+
                        Format('%2.2d', [MinorVersion])+'.'+
                        IntToStr(BuildNumber);
end;

function GetWindowsLongInfo: String;
var
  WindowsVersion: Integer;
  WindowsPlatformId: Integer;
  WindowsVersionString: String;
  WindowsBuildString: String;
  IsServer: Boolean;
  ProductTypeString: String;
  SuiteMaskString: String;
  ServicePackString: String;
begin
  GetWindowsInfo(WindowsVersion, WindowsPlatformId, WindowsVersionString, WindowsBuildString);
  Result := WindowsVersionString+' '+ WindowsBuildString;
  GetProductType(IsServer, ProductTypeString, SuiteMaskString, ServicePackString);
  if ServicePackString <> '' then
    Result := Result+' '+ServicePackString;
  if ProductTypeString <> '' then
    Result := Result+' '+ProductTypeString;
  if SuiteMaskString <> '' then
    Result := Result+' '+SuiteMaskString;
end;

end.
