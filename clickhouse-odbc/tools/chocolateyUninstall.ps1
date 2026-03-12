$ErrorActionPreference = 'Stop'

$softwareName = 'clickhouse-odbc*'

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 0) {
  Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
  return
}

$key | ForEach-Object {
  $packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'msi'
    silentArgs     = "$($_.PSChildName) /qn /norestart"
    file           = ''
    validExitCodes = @(0, 3010, 1641)
  }
  Uninstall-ChocolateyPackage @packageArgs
}
