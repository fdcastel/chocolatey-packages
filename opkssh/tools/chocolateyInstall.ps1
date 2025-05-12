$ErrorActionPreference = 'Stop'

$packageName = 'opkssh'
$url64 = 'https://github.com/openpubkey/opkssh/releases/download/v0.6.1/opkssh-windows-amd64.exe'
$checksum64 = '9FD481FC6682BF56D7723B6672FAB71BB942DFEFDD2E166B1C276F3F7D4767BA'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChocolateyWebFile `
    -PackageName "$packageName" `
    -FileFullPath "$toolsDir\opkssh.exe" `
    -Url64bit $url64 `
    -Checksum64 $checksum64 `
    -ChecksumType64 SHA256
