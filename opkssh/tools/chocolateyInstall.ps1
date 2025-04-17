$ErrorActionPreference = 'Stop'

$packageName = 'opkssh'
$url64 = 'https://github.com/openpubkey/opkssh/releases/download/v0.3.0/opkssh-windows-amd64.exe'
$checksum64 = 'D864576A0007E9CAD914420A94DB51EA74B3473EA22F88317492AFC0B7B4F895'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChocolateyWebFile `
    -PackageName "$packageName" `
    -FileFullPath "$toolsDir\opkssh.exe" `
    -Url64bit $url64 `
    -Checksum64 $checksum64 `
    -ChecksumType64 SHA256
