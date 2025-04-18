$packageName = 'qemu-img'
$url64 = 'https://cloudbase.it/downloads/qemu-img-win-x64-2_3_0.zip'
$checksum64 = '8DC1C69D9880919CDAD8C09126A016262D4A9EDF48B87A1EF587914FE4177909'

Install-ChocolateyZipPackage `
    -PackageName "$packageName" `
    -UnzipLocation "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" `
    -Url64bit $url64 `
    -Checksum64 $checksum64 `
    -ChecksumType64 SHA256
