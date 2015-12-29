$packageName = 'cygrsync'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://github.com/fdcastel/cygrsync/archive/master.zip'
$checksum = '3D18538BF626F3EC6BB8F29A63E1A2306422BFB5'
$checksumType = 'sha1'

Install-ChocolateyZipPackage -PackageName "$packageName" `
                             -Url "$url" `
                             -UnzipLocation "$toolsDir" `
                             -Url64bit "" `
                             -Checksum "$checksum" `
                             -ChecksumType "$checksumType"
