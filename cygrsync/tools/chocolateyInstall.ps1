[CmdletBinding()]
Param([Switch]$Uninstall)

$packageName = 'cygrsync'

$url = 'https://github.com/fdcastel/cygrsync/archive/master.zip'

$rootPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

if (-not $Uninstall) {
    Install-ChocolateyZipPackage $packageName $url $rootPath
} else {
    $zipFolder = Join-Path $rootPath '.\cygrsync-master'
    Remove-Item $zipFolder -Recurse

    # Can of worms!
    #   https://github.com/chocolatey/chocolatey/issues?q=UnInstall-ChocolateyZipPackage
    # 
    # UnInstall-ChocolateyZipPackage $packageName 'cygrsyncInstall.zip'
}
