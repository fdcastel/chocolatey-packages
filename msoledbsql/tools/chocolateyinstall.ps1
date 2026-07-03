$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/0a09a9e0-e364-4d01-b102-04ddfcf38a7e/x86/1033/msoledbsql.msi'
$url64      = 'https://download.microsoft.com/download/7bf55274-18ac-4b26-9783-45453a1ab64f/amd64/1033/msoledbsql.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft OLE DB Driver for SQL Server'

  checksum      = 'B86F1EE532E6EA543721747EB03B32E5EFF6C292458DE3D90391B97908C8E13C'
  checksumType  = 'sha256'
  checksum64    = '409ADFD93165DD3622B2D7CD0B9C4D96A27B04F9F3FB5599D99ACBE90ADE0638'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSOLEDBSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
