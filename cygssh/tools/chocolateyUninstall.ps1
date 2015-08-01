$here = Split-Path -Parent $MyInvocation.MyCommand.Definition
$installScript = Join-Path $here '.\chocolateyInstall.ps1'

& $installScript -Uninstall
