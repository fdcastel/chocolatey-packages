$packageName = '<%$($Configuration.packageName)%>'

$url = '<%$($Configuration.url)%>'
$url64 = '<%$($Configuration.url64)%>'
$checksum = '<%$($Configuration.checksum)%>'
$checksum64 = '<%$($Configuration.checksum64)%>'
$checksumType = '<%$($Configuration.checksumType)%>'
$installerName = '<%$($Configuration.installerName)%>'

$installerType = 'exe'
$installerFullName = Join-Path $env:TEMP $installerName

function Get-FirebirdPath
{
    $HKLMFirebirdInstancesKey = 'HKLM:\Software\Firebird Project\Firebird Server\Instances'
    $instances = Get-ItemProperty -Path "$HKLMFirebirdInstancesKey" -ErrorAction SilentlyContinue

    if (-not $instances) {
        # Not found. Try to search for a 32-bit install in a 64-bit architecture.

        $HKLMFirebirdInstancesKey = 'HKLM:\Software\Wow6432Node\Firebird Project\Firebird Server\Instances'
        $instances = Get-ItemProperty -Path "$HKLMFirebirdInstancesKey" -ErrorAction SilentlyContinue
    }

    if ($instances) {
        Write-Host "Firebird installation path: $($instances.DefaultInstance)"
        $instances.DefaultInstance
    } else {
        Write-Host "Firebird is NOT installed."
        $null
    }
}

function Download-FirebirdInstaller
{
    Write-Host "Downloading installer file: $installerFullName"
    Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $installerFullName `
                          -Url $url -Url64bit $url64 `
                          -Checksum $checksum -ChecksumType $checksumType -Checksum64 $checksum64 -ChecksumType64 $checksumType
}

function Uninstall-Firebird
{
    $firebirdPath = Get-FirebirdPath

    if ($firebirdPath) {
        if (Get-Service -Name FirebirdServerDefaultInstance -ErrorAction SilentlyContinue) {
            Write-Host "Stopping Firebird service..."
            Stop-Service -Name FirebirdServerDefaultInstance
        }

        $uninstallers = Join-Path $firebirdPath 'unins*.exe'
        $lastUninstaller = Get-Item $uninstallers | Sort-Object LastWriteTime | Select-Object -Last 1
        $uninstallerArgs = '/VERYSILENT',
                           '/NORESTART',
                           '/SUPPRESSMSGBOXES'
        
        Write-Host "Calling uninstaller: $($lastUninstaller.FullName)"
        Uninstall-ChocolateyPackage -PackageName $packageName -FileType $installerType `
                                    -SilentArgs $uninstallerArgs -File $lastUninstaller.FullName
    }
}

function Check-FirebirdInstalled
{
    $firebirdPath = Get-FirebirdPath

    if ($firebirdPath -eq $null) {
        throw "ERROR: Firebird *WAS NOT* successfully installed."
    }
}

function Install-FirebirdClient
{
    Download-FirebirdInstaller

    Uninstall-Firebird

    # Install client components and copy gds32.dll into System folder
    $installerArgs = '/SP-', 
                     '/VERYSILENT', 
                     '/NORESTART',
                     '/NOICONS',
                     '/SUPPRESSMSGBOXES',
                     '/COMPONENTS="ClientComponent"',
                     '/TASKS="|InstallCPLAppletTask,|MenuGroupTask,CopyFbClientToSysTask,CopyFbClientAsGds32Task"'

    Install-ChocolateyInstallPackage -PackageName $packageName -FileType $installerType `
                                     -SilentArgs $installerArgs -File $installerFullName

    Check-FirebirdInstalled
}

function Install-FirebirdServer
{
    Download-FirebirdInstaller

    Uninstall-Firebird

    # Install server without Guardian, without Control Panel Applet, with legacy client authentication
    #   and copy fbclient.dll & gds32.dll into System folder.
    $installerArgs = '/SP-', 
                     '/VERYSILENT', 
                     '/NORESTART',
                     '/NOICONS',
                     '/SUPPRESSMSGBOXES',
                     '/COMPONENTS="ServerComponent\SuperServerComponent,ServerComponent,DevAdminComponent,ClientComponent"',
                     '/TASKS="' + $serverTypeTask + ',|UseGuardianTask,UseServiceTask,AutoStartTask,|InstallCPLAppletTask,|MenuGroupTask,CopyFbClientToSysTask,CopyFbClientAsGds32Task,EnableLegacyClientAuth"'

    if ($env:chocolateyPackageParameters -contains '/SuperClassic') {
        Write-Host 'Installing Firebird SuperClassic...'
        $serverTypeTask = 'UseSuperClassicTask'
    } elseif ($env:chocolateyPackageParameters -contains '/Classic') {
        Write-Host 'Installing Firebird Classic...'
        $serverTypeTask = 'UseClassicServerTask'
    } else {
        Write-Host 'Installing Firebird SuperServer...'
        $serverTypeTask = 'UseSuperServerTask'
    }

    Install-ChocolateyInstallPackage -PackageName $packageName -FileType $installerType `
                                     -SilentArgs $installerArgs -File $installerFullName
    
    Check-FirebirdInstalled
}
