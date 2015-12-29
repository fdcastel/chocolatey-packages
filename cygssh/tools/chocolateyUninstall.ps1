$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Alternative to UnInstall-ChocolateyZipPackage
#   https://github.com/chocolatey/chocolatey/issues?q=UnInstall-ChocolateyZipPackage
$zipFolder = Join-Path $toolsDir '.\cygssh-master'
Remove-Item $zipFolder -Recurse
