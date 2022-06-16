$packageName = 'firebird'

$version = '<%$($Configuration.version)%>'
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
            Stop-Service -Name FirebirdServerDefaultInstance -Force
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

function Install-Firebird
{
    Download-FirebirdInstaller

    Uninstall-Firebird

    if ($env:chocolateyPackageParameters -contains '/ClientOnly') {
        Write-Host 'Installing Firebird Client...'
        $serverTypeComponent = 'ClientComponent,'
        $serverTypeTask = ''
    } elseif ($env:chocolateyPackageParameters -contains '/ClientAndDevTools') {
        Write-Host 'Installing Firebird Client and Development tools...'
        $serverTypeComponent = 'ClientComponent,DevAdminComponent,'
        $serverTypeTask = ''
    } else {
        if ($version -lt '4') {
            # Firebird 3
            if ($env:chocolateyPackageParameters -contains '/SuperClassic') {
                Write-Host 'Installing Firebird SuperClassic...'
                $serverTypeComponent = 'ServerComponent,'
                $serverTypeTask = 'UseSuperClassicTask,'
            } elseif ($env:chocolateyPackageParameters -contains '/Classic') {
                Write-Host 'Installing Firebird Classic...'
                $serverTypeComponent = 'ServerComponent,'
                $serverTypeTask = 'UseClassicServerTask,'
            } else {
                Write-Host 'Installing Firebird SuperServer...'
                $serverTypeComponent = 'ServerComponent,'
                $serverTypeTask = 'UseSuperServerTask,'
            }

            # Server installation: always with admin components.
            $serverTypeComponent += 'DevAdminComponent,'
        } else {
            # Firebird 4
            if ($env:chocolateyPackageParameters -contains '/SuperClassic') {
                Write-Host 'Installing Firebird SuperClassic...'
                $serverTypeComponent = 'ServerComponent,'
                $serverTypeTask = 'UseSuperClassicTask,'
            } elseif ($env:chocolateyPackageParameters -contains '/Classic') {
                Write-Host 'Installing Firebird Classic...'
                $serverTypeComponent = 'ServerComponent,'
                $serverTypeTask = 'UseClassicServerTask,'
            } else {
                Write-Host 'Installing Firebird SuperServer...'
                $serverTypeComponent = 'ServerComponent,'
                $serverTypeTask = 'UseSuperServerTask,'
            }

            # Firebird 4: Do not pass serverTypeComponent
            $serverTypeComponent = $null
        }
    }

    # Install server with legacy client authentication (3.0+) and copy fbclient.dll & gds32.dll into System folder.
    $installerArgs = '/SP-', 
                     '/VERYSILENT', 
                     '/NORESTART',
                     '/NOICONS',
                     '/SUPPRESSMSGBOXES'

    if ($serverTypeComponent) {
        $installerArgs += '/COMPONENTS="' + $serverTypeComponent + 'ClientComponent"'
    }    

    $installerArgs += '/TASKS="' + $serverTypeTask + 'UseServiceTask,AutoStartTask,|UseGuardianTask,|InstallCPLAppletTask,|MenuGroupTask,CopyFbClientToSysTask,CopyFbClientAsGds32Task,EnableLegacyClientAuth"'

    Install-ChocolateyInstallPackage -PackageName $packageName -FileType $installerType `
                                     -SilentArgs $installerArgs -File $installerFullName
}
