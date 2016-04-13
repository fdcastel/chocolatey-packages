$packageName = 'x-lite'
$installerType = 'exe'

$silentArgs = '/VERYSILENT /NORESTART'
$url = 'http://counterpath.s3.amazonaws.com/downloads/X-Lite_4.9.3_79961.exe'
$validExitCodes = @(0,1)


$checksum = '2656A68CEDEB413C26B8E3EE5D026D3DD30C4E92'
$checksumType = 'sha1'

Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -SilentArgs "$silentArgs" `
                          -Url "$url" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType"
