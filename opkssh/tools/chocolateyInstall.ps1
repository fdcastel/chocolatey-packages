$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  PackageName    = 'opkssh'
  FileFullPath   = "$toolsDir\opkssh.exe"
  Url64bit       = '{{assets.browser_download_url}}'
  Checksum64     = '{{assets.sha256}}'
  ChecksumType64 = 'sha256'
}
Install-ChocolateyPackage @packageArgs
