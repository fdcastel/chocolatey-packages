$ErrorActionPreference = 'Stop'

$packageName = 'firebird-odbc'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

# These variables will be replaced during build
$version = '{{version}}'
$url64 = '{{assets.x64.browser_download_url}}'
$url32 = '{{assets.x86.browser_download_url}}{{assets.Win32.browser_download_url}}'
$checksum64 = '{{assets.x64.sha256}}'
$checksum32 = '{{assets.x86.sha256}}{{assets.Win32.sha256}}'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url            = $url32
  url64bit       = $url64

  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)

  softwareName   = 'Firebird ODBC driver*'

  checksum       = $checksum32
  checksumType   = $checksumType
  checksum64     = $checksum64
  checksumType64 = $checksumType
}

Install-ChocolateyPackage @packageArgs
