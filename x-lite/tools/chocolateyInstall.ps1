$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName = 'x-lite'
$installerType = 'exe'

$silentArgs = '-s'
$url = 'https://counterpath.s3.amazonaws.com/downloads/X-Lite_4.9.8_84253.exe'
$validExitCodes = @(0)

$checksum = '12D6C33C566FAE275191BBA639B890DC4CF0294A840D2DA69528FC3C1DD137EB'
$checksumType = 'sha256'

$ahkScript = "$toolsDir\install.ahk"

Start-Process -FilePath 'AutoHotkey' -ArgumentList $ahkScript -PassThru

Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -SilentArgs "$silentArgs" `
                          -Url "$url" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType"