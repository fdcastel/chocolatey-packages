$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/A/9/8/A98CF446-A38E-4B0A-A967-F93FAB474AE0/en-US/msoledbsql_18.1.0.0_x86.msi'
$url64      = 'https://download.microsoft.com/download/A/9/8/A98CF446-A38E-4B0A-A967-F93FAB474AE0/en-US/msoledbsql_18.1.0.0_x64.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft OLE DB Driver for SQL Server'

  checksum      = '90C78D9399C990F8FE82CF7F1B66D7A980DC06188E74412F39982C8EF938985D'
  checksumType  = 'sha256'
  checksum64    = '18602476895224CFA1EE95659C0A30369E0F76F69782210302D4A7757F7F7511'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSOLEDBSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
