$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/f/1/3/f13ce329-0835-44e7-b110-44decd29b0ad/en-US/19.3.5.0/x86/msoledbsql.msi'
$url64      = 'https://download.microsoft.com/download/f/1/3/f13ce329-0835-44e7-b110-44decd29b0ad/en-US/19.3.5.0/x64/msoledbsql.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft OLE DB Driver for SQL Server'

  checksum      = '4A7FC2AB01D9D0F804CA5B0E94EB6DB14340543FDC7A719C91C395E6AA3AECC8'
  checksumType  = 'sha256'
  checksum64    = '599EE4A83F3F9E1DC5510577ADF36A5E7482C011C347EF0DE9A8C5DE36E052FE'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSOLEDBSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
