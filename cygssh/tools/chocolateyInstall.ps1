[CmdletBinding()]
Param([Switch]$Uninstall)

$packageName = 'cygssh'

$url = 'https://github.com/fdcastel/cygssh/archive/master.zip'

$rootPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

if (-not $Uninstall) {
    Install-ChocolateyZipPackage $packageName $url $rootPath
} else {
    $zipFolder = Join-Path $rootPath '.\cygssh-master'
    Remove-Item $zipFolder -Recurse

    # Can of worms!
    #   https://github.com/chocolatey/chocolatey/issues?q=UnInstall-ChocolateyZipPackage
    # 
    # UnInstall-ChocolateyZipPackage $packageName 'cygrsyncInstall.zip'
}
