$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/a/e/b/aeb7d4ff-ca20-45db-86b8-8a8f774ce97b/en-US/17.8.1.1/x86/msodbcsql.msi'
$url64      = 'https://download.microsoft.com/download/a/e/b/aeb7d4ff-ca20-45db-86b8-8a8f774ce97b/en-US/17.8.1.1/x64/msodbcsql.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft ODBC Driver 17 for SQL Server'

  checksum      = '9D5C7435B62C114E3EC1BDDA523A9801943F5B7E82DBF2D6D50A376D39E3DF07'
  checksumType  = 'sha256'
  checksum64    = '4AFEC331979CECAC6E5F55286D8D6FB94CA4137033D4BD1B3716003F4EDE78B7'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSODBCSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
