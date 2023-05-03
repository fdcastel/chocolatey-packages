$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/f/1/3/f13ce329-0835-44e7-b110-44decd29b0ad/en-US/19.3.0.0/x86/msoledbsql.msi'
$url64      = 'https://download.microsoft.com/download/f/1/3/f13ce329-0835-44e7-b110-44decd29b0ad/en-US/19.3.0.0/x64/msoledbsql.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft OLE DB Driver for SQL Server'

  checksum      = '3F0C8708885EA40D71C86BA824403BB94F43E06E6EA593A40284B11D08AF5E00'
  checksumType  = 'sha256'
  checksum64    = 'C92F83E881043D08C5D4DABC45DBE78490C26A0924C29B42327FBC0B49EF127A'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSOLEDBSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
