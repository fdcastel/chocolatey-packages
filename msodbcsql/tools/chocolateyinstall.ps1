$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/c/5/4/c54c2bf1-87d0-4f6f-b837-b78d34d4d28a/en-US/18.2.1.1/x86/msodbcsql.msi'
$url64      = 'https://download.microsoft.com/download/c/5/4/c54c2bf1-87d0-4f6f-b837-b78d34d4d28a/en-US/18.2.1.1/x64/msodbcsql.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Microsoft ODBC Driver 18 for SQL Server'

  checksum      = 'A3C94EAFF6A7443C26BE7F5B2F2EED9235921251F01A86D998EAA41E905F5BCD'
  checksumType  = 'sha256'
  checksum64    = '3B9C9F8584B1AFA9071E6324E7C8BE66696211C0FF5A3B0670F2F6C8E2424CF8'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" IACCEPTMSODBCSQLLICENSETERMS=YES"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
