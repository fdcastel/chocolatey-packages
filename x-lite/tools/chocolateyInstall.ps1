$packageName = 'x-lite'
$installerType = 'exe'

$silentArgs = '/VERYSILENT /NORESTART'
$url = 'http://counterpath.s3.amazonaws.com/downloads/X-Lite_4.9.2_79048.exe'
$validExitCodes = @(0,1)


$checksum = '7EB91D07DDF7568B3CDA042BC3119AB7B48CE264'
$checksumType = 'sha1'

Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -SilentArgs "$silentArgs" `
                          -Url "$url" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType"
