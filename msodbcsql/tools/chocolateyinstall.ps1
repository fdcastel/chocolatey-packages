$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/E/6/B/E6BFDC7A-5BCD-4C51-9912-635646DA801E/en-US/msodbcsql_17.2.0.1_x86.msi'
$url64      = 'https://download.microsoft.com/download/E/6/B/E6BFDC7A-5BCD-4C51-9912-635646DA801E/en-US/msodbcsql_17.2.0.1_x64.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft ODBC Driver 17 for SQL Server'

  checksum      = 'F52B68F2700E882D4BFFB47ACB440AF3AF0C82F5584A60242C5D5D69BF1170D1'
  checksumType  = 'sha256'
  checksum64    = 'A5A315A7B47A17C56FE6E1185AC09C069594C13CF2343D453090D1C066AD2AEF'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSODBCSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
