$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/a8711829-f40a-4956-84fc-d08e7f877a06/x86/1033/msoledbsql.msi'
$url64      = 'https://download.microsoft.com/download/b5865bb8-7bc6-4068-9c1d-fb77c256a865/amd64/1033/msoledbsql.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft OLE DB Driver for SQL Server'

  checksum      = 'C5427A3314A1118FA435BB644AE555BD2B7301E28CF26CB4E0F55DA6823E02E9'
  checksumType  = 'sha256'
  checksum64    = '5ABB621F09B947D5799B90C98159EC6E157734251565F1133EFAED2BDCBF2B1B'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSOLEDBSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
