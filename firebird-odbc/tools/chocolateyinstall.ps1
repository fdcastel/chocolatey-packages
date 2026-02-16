$ErrorActionPreference = 'Stop'

$packageName = 'firebird-odbc'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

# These variables will be replaced during build
$file64 = '{{assets.x64.name}}'
$file32 = '{{assets.x86.name}}{{assets.Win32.name}}'

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'EXE'

  file          = "$toolsDir\$file32"
  file64        = "$toolsDir\$file64"

  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)

  softwareName   = 'Firebird ODBC driver*'
}

Install-ChocolateyInstallPackage @packageArgs
