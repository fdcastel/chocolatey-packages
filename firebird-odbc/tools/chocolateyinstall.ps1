$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://sourceforge.net/projects/firebird/files/firebird-ODBC-driver/2.0.5-Release/Firebird_ODBC_2.0.5.156_Win32.exe/download'
$url64      = 'https://sourceforge.net/projects/firebird/files/firebird-ODBC-driver/2.0.5-Release/Firebird_ODBC_2.0.5.156_x64.exe/download'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Firebird ODBC driver*'

  checksum      = '20DDB6E602DDB7B249F000829D919B17BD5C37ADA90CAF8E80EEA29C7D4673DA'
  checksumType  = 'sha256'
  checksum64    = 'DFB4F5695813BAD3F9F7B9CDDFD22358413B4CBAA91ADE6AC299E3C5973ED7CC'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
