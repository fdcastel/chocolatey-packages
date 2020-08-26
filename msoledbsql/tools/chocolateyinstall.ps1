$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/A/9/8/A98CF446-A38E-4B0A-A967-F93FAB474AE0/en-US/18.4.0.0/x86/msoledbsql.msi'
$url64      = 'https://download.microsoft.com/download/A/9/8/A98CF446-A38E-4B0A-A967-F93FAB474AE0/en-US/18.4.0.0/x64/msoledbsql.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft OLE DB Driver for SQL Server'

  checksum      = '41440175DAD30853AB6470DC9B2BBCA27DCDC9C85273F07F95A5153F1B588F17'
  checksumType  = 'sha256'
  checksum64    = 'A32671FFC086A632E8108300FD81B5A06F25F23D9BF15E95DD951861D762E2C6'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSOLEDBSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
