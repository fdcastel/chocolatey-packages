[CmdletBinding()]
Param([Switch]$Uninstall)

$packageName = 'xlite'
$installerType = 'exe'

$url = 'http://counterpath.s3.amazonaws.com/downloads/X-Lite_Win32_4.8.4_76589.exe'
$installerName = 'X-Lite_Win32_4.8.4_76589.exe'

# --- Main ---

if (-not $Uninstall) {
    # Download installer into TEMP folder
    $installerFullName = Join-Path $env:TEMP $installerName
    Get-ChocolateyWebFile $packageName $installerFullName $url
}
    
if (-not $Uninstall) {
    # Install in very silent mode
    $installerArgs = '/SP-', 
                        '/VERYSILENT', 
                        '/NORESTART'

    Install-ChocolateyInstallPackage $packageName $installerType $installerArgs $installerFullName -validExitCodes @(0,1)
}
