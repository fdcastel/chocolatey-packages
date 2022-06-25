$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/1/a/4/1a4a49b8-9fe6-4237-be0d-a6b8f2d559b5/en-US/18.0.1.1/x86/msodbcsql.msi'
$url64      = 'https://download.microsoft.com/download/1/a/4/1a4a49b8-9fe6-4237-be0d-a6b8f2d559b5/en-US/18.0.1.1/x64/msodbcsql.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft ODBC Driver 18 for SQL Server'

  checksum      = '4065F5568650C8F39B472394870EF2F63DB6C5D95215AA1B6701A90A99B64EB4'
  checksumType  = 'sha256'
  checksum64    = '5EEDB40754558DC36C44061228ED7832A4A53CDA9B3D9319B5A5DD33944E9AF9'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSODBCSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
