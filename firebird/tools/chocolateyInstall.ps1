$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$toolsScript = Join-Path $toolsDir '..\..\firebirdclient\tools\firebirdTools.ps1'

. $toolsScript

$packageName = 'firebird'

if ($env:chocolateyPackageParameters -contains '/SuperServer') {
    Write-Host 'Installing Firebird SuperServer...'
    Install-FirebirdSuperServer $packageName
} else {
    Write-Host 'Installing Firebird SuperClassic...'
    Install-FirebirdSuperClassic $packageName 
}
