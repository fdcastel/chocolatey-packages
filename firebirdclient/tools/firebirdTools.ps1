$url = 'http://downloads.sourceforge.net/project/firebird/firebird-win32/3.0-Release/Firebird-3.0.0.32483_2_Win32.exe'
$url64 = 'http://downloads.sourceforge.net/project/firebird/firebird-win64/3.0-Release/Firebird-3.0.0.32483_2_x64.exe'
$installerName = 'Firebird-3.0.0.32483_2.exe'
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
        $instances.DefaultInstance
    } else {
        $null
    }
}

function Download-FirebirdInstaller ($packageName)
{
    Get-ChocolateyWebFile $packageName $installerFullName $url $url64
}

function Uninstall-Firebird ($packageName)
{
    $firebirdPath = Get-FirebirdPath

    if ($firebirdPath) {
        Stop-Service FirebirdServerDefaultInstance -ErrorAction SilentlyContinue

        $uninstallers = Join-Path $firebirdPath 'unins*.exe'
        $lastUninstaller = Get-Item $uninstallers | Sort-Object LastWriteTime | Select-Object -Last 1
        $uninstallerArgs = '/VERYSILENT',
                           '/NORESTART',
                           '/SUPPRESSMSGBOXES'
        
        Uninstall-ChocolateyPackage $packageName $installerType $uninstallerArgs $lastUninstaller.FullName
    }
}

function Check-FirebirdInstalled
{
    $firebirdPath = Get-FirebirdPath

    if ($firebirdPath -eq $null) {
        throw "ERROR: Firebird *WAS NOT* successfully installed."
    }
}

function Install-FirebirdClient ($packageName)
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

    Install-ChocolateyInstallPackage $packageName $installerType $installerArgs $installerFullName

    Check-FirebirdInstalled
}

function Install-FirebirdServer ($packageName, $serverTypeTask)
{
    Download-FirebirdInstaller

    Uninstall-Firebird

    # Install server without Guardian, without Control Panel Applet, with legacy client authentication and copy fbclient.dll & gds32.dll into System folder.
    $installerArgs = '/SP-', 
                     '/VERYSILENT', 
                     '/NORESTART',
                     '/NOICONS',
                     '/SUPPRESSMSGBOXES',
                     '/COMPONENTS="ServerComponent\SuperServerComponent,ServerComponent,DevAdminComponent,ClientComponent"',
                     '/TASKS="' + $serverTypeTask + ',|UseGuardianTask,UseServiceTask,AutoStartTask,|InstallCPLAppletTask,|MenuGroupTask,CopyFbClientToSysTask,CopyFbClientAsGds32Task,EnableLegacyClientAuth"'

    Install-ChocolateyInstallPackage $packageName $installerType $installerArgs $installerFullName
    
    Check-FirebirdInstalled
}
