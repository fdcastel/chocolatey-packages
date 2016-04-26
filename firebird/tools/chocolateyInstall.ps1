$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$toolsScript = Join-Path $toolsDir '..\..\firebirdclient\tools\firebirdTools.ps1'

. $toolsScript

$packageName = 'firebird'

if ($env:chocolateyPackageParameters -contains '/SuperClassic') {
    Write-Host 'Installing Firebird SuperClassic...'
    Install-FirebirdServer $packageName 'UseSuperClassicTask'
} elseif ($env:chocolateyPackageParameters -contains '/Classic') {
    Write-Host 'Installing Firebird Classic...'
    Install-FirebirdServer $packageName 'UseClassicServerTask'
} else {
    Write-Host 'Installing Firebird SuperServer...'
    Install-FirebirdServer $packageName 'UseSuperServerTask'
}
