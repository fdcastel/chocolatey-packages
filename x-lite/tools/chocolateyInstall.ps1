$packageName = 'x-lite'
$installerType = 'exe'

$silentArgs = '/VERYSILENT /NORESTART'
$url = 'http://counterpath.s3.amazonaws.com/downloads/X-Lite_4.9.5.1_81564.exe'
$validExitCodes = @(0,1)


$checksum = '051CEB094DA4BFBC6FDC8FCA2A5E94B39D548D643AD90854207C907FBC04DA59'
$checksumType = 'sha256'

Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -SilentArgs "$silentArgs" `
                          -Url "$url" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType"
