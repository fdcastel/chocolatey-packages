$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$toolsScript = Join-Path $toolsDir ".\firebirdTools.ps1"

. $toolsScript

$packageName = 'firebirdclient'

Uninstall-Firebird $packageName
