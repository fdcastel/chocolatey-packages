$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/f/1/3/f13ce329-0835-44e7-b110-44decd29b0ad/en-US/19.3.2.0/x86/msoledbsql.msi'
$url64      = 'https://download.microsoft.com/download/f/1/3/f13ce329-0835-44e7-b110-44decd29b0ad/en-US/19.3.2.0/x64/msoledbsql.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft OLE DB Driver for SQL Server'

  checksum      = '4D3998E1BC6FF76AA7C0C347144046C0E82BD40E2EC965ADCD9FF6DAA9CBD0D7'
  checksumType  = 'sha256'
  checksum64    = '8A0B76F9880284333E403DB2272B9F46CF2401E984C8864F77DB1D685E94C2BF'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSOLEDBSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
