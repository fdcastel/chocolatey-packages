$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/A/9/8/A98CF446-A38E-4B0A-A967-F93FAB474AE0/en-US/18.6.0.0/x86/msoledbsql.msi'
$url64      = 'https://download.microsoft.com/download/A/9/8/A98CF446-A38E-4B0A-A967-F93FAB474AE0/en-US/18.6.0.0/x64/msoledbsql.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft OLE DB Driver for SQL Server'

  checksum      = '48BEEDF9A0527490E9B61DFB21E62834B69CFC0F11D4EF7EF5ACA920F7510031'
  checksumType  = 'sha256'
  checksum64    = 'A0B4416D2B3E5197578B1C276D95505F57EB0C30743604775D11003E6369D21D'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSOLEDBSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
