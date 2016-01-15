$url = 'http://downloads.sourceforge.net/project/firebird/firebird-win32/2.5.5-Release/Firebird-2.5.5.26952_0_Win32.exe'
$url64 = 'http://downloads.sourceforge.net/project/firebird/firebird-win64/2.5.5-Release/Firebird-2.5.5.26952_0_x64.exe'

$installerName = 'Firebird-2.5.5.26952.exe'
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

function Export-FirebirdPath
{
    $firebirdPath = Get-FirebirdPath
    Write-Host "PATH: $firebirdPath\bin" 
    Install-ChocolateyPath "$firebirdPath\bin" "Machine"
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
                     '/TASKS="|InstallCPLAppletTask,|MenuGroupTask,|CopyFbClientToSysTask,CopyFbClientAsGds32Task"'

    Install-ChocolateyInstallPackage $packageName $installerType $installerArgs $installerFullName

    Check-FirebirdInstalled
}

function Install-FirebirdClassicServer ($packageName)
{
    Download-FirebirdInstaller

    Uninstall-Firebird

    # Install SuperClassic server, without Guardian, without Control Panel Applet and copy gds32.dll into System folder
    $installerArgs = '/SP-', 
                     '/VERYSILENT', 
                     '/NORESTART',
                     '/NOICONS',
                     '/SUPPRESSMSGBOXES',
                     '/COMPONENTS="ServerComponent,ServerComponent\ClassicServerComponent,DevAdminComponent,ClientComponent"',
                     '/TASKS="SuperClassicTask,|UseGuardianTask,UseServiceTask,AutoStartTask,|InstallCPLAppletTask,|MenuGroupTask,|CopyFbClientToSysTask,CopyFbClientAsGds32Task"'

    Install-ChocolateyInstallPackage $packageName $installerType $installerArgs $installerFullName

    Check-FirebirdInstalled
}

function Install-FirebirdSuperServer ($packageName)
{
    Download-FirebirdInstaller

    Uninstall-Firebird

    # Install SuperClassic server, without Guardian, without Control Panel Applet and copy gds32.dll into System folder
    $installerArgs = '/SP-', 
                     '/VERYSILENT', 
                     '/NORESTART',
                     '/NOICONS',
                     '/SUPPRESSMSGBOXES',
                     '/COMPONENTS="ServerComponent\SuperServerComponent,ServerComponent,DevAdminComponent,ClientComponent"',
                     '/TASKS="UseGuardianTask,UseServiceTask,AutoStartTask,|InstallCPLAppletTask,|MenuGroupTask,|CopyFbClientToSysTask,CopyFbClientAsGds32Task"'

    Install-ChocolateyInstallPackage $packageName $installerType $installerArgs $installerFullName
    
    Check-FirebirdInstalled
}

