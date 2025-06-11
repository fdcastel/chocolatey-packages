$ErrorActionPreference = 'Stop'

$packageName = 'firebird'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# These variables will be replaced during build
$version = '{{version}}'
$url64 = '{{assets.x64.browser_download_url}}'
$url32 = '{{assets.x86.browser_download_url}}{{assets.Win32.browser_download_url}}'
$checksum64 = '{{assets.x64.sha256}}'
$checksum32 = '{{assets.x86.sha256}}{{assets.Win32.sha256}}'
$checksumType = 'sha256'

$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    fileType       = 'EXE'
    url            = $url32
    url64bit       = $url64
    silentArgs     = '/SP- /VERYSILENT /NORESTART /NOICONS /SUPPRESSMSGBOXES'
    validExitCodes = @(0)
    softwareName   = 'Firebird*'
    checksum       = $checksum32
    checksumType   = $checksumType
    checksum64     = $checksum64
    checksumType64 = $checksumType
}

function Get-FirebirdPath {
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
        Write-Host 'Firebird is NOT installed.'
        $null
    }
}

function Uninstall-Firebird {
    $firebirdPath = Get-FirebirdPath

    if ($firebirdPath) {
        if (Get-Service -Name FirebirdServerDefaultInstance -ErrorAction SilentlyContinue) {
            Write-Host 'Stopping Firebird service...'
            Stop-Service -Name FirebirdServerDefaultInstance -Force
        }

        $uninstallers = Join-Path $firebirdPath 'unins*.exe'
        $lastUninstaller = Get-Item $uninstallers | Sort-Object LastWriteTime | Select-Object -Last 1
        
        if ($lastUninstaller) {
            $uninstallerArgs = '/VERYSILENT', '/NORESTART', '/SUPPRESSMSGBOXES'
            Write-Host "Calling uninstaller: $($lastUninstaller.FullName)"
            Uninstall-ChocolateyPackage -PackageName $packageName -FileType 'EXE' `
                -SilentArgs $uninstallerArgs -File $lastUninstaller.FullName
        }
    }
}

# Uninstall any existing Firebird installation
Uninstall-Firebird

# Determine installation components and tasks based on parameters and version
if ($env:chocolateyPackageParameters -contains '/ClientOnly') {
    Write-Host 'Installing Firebird Client...'
    $serverTypeComponent = 'ClientComponent'
    $serverTypeTask = ''
} elseif ($env:chocolateyPackageParameters -contains '/ClientAndDevTools') {
    Write-Host 'Installing Firebird Client and Development tools...'
    $serverTypeComponent = 'ClientComponent,DevAdminComponent'
    $serverTypeTask = ''
} else {
    # Parse version to determine if it's version 4+ (different component structure)
    $majorVersion = [int]($version -split '\.')[0]
    
    if ($majorVersion -lt 4) {
        # Firebird 3.x
        if ($env:chocolateyPackageParameters -contains '/SuperClassic') {
            Write-Host 'Installing Firebird SuperClassic...'
            $serverTypeComponent = 'ServerComponent,DevAdminComponent,ClientComponent'
            $serverTypeTask = 'UseSuperClassicTask'
        } elseif ($env:chocolateyPackageParameters -contains '/Classic') {
            Write-Host 'Installing Firebird Classic...'
            $serverTypeComponent = 'ServerComponent,DevAdminComponent,ClientComponent'
            $serverTypeTask = 'UseClassicServerTask'
        } else {
            Write-Host 'Installing Firebird SuperServer...'
            $serverTypeComponent = 'ServerComponent,DevAdminComponent,ClientComponent'
            $serverTypeTask = 'UseSuperServerTask'
        }
    } else {
        # Firebird 4.x and 5.x - simplified component structure
        if ($env:chocolateyPackageParameters -contains '/SuperClassic') {
            Write-Host 'Installing Firebird SuperClassic...'
            $serverTypeComponent = 'ServerComponent,ClientComponent'
            $serverTypeTask = 'UseSuperClassicTask'
        } elseif ($env:chocolateyPackageParameters -contains '/Classic') {
            Write-Host 'Installing Firebird Classic...'
            $serverTypeComponent = 'ServerComponent,ClientComponent'
            $serverTypeTask = 'UseClassicServerTask'
        } else {
            Write-Host 'Installing Firebird SuperServer...'
            $serverTypeComponent = 'ServerComponent,ClientComponent'
            $serverTypeTask = 'UseSuperServerTask'
        }
    }
}

# Build installer arguments
$installerArgs = @('/SP-', '/VERYSILENT', '/NORESTART', '/NOICONS', '/SUPPRESSMSGBOXES')

if ($serverTypeComponent) {
    $installerArgs += "/COMPONENTS=`"$serverTypeComponent`""
}

# Common tasks for all installations
$commonTasks = @('UseServiceTask', 'AutoStartTask', 'CopyFbClientToSysTask', 'CopyFbClientAsGds32Task', 'EnableLegacyClientAuth')
$excludeTasks = @('UseGuardianTask', 'InstallCPLAppletTask', 'MenuGroupTask')

$allTasks = @()
if ($serverTypeTask) {
    $allTasks += $serverTypeTask
}
$allTasks += $commonTasks
$allTasks += $excludeTasks | ForEach-Object { "|$_" }

$installerArgs += "/TASKS=`"$($allTasks -join ',')`""

$packageArgs.silentArgs = $installerArgs -join ' '

Write-Host "Installing with arguments: $($packageArgs.silentArgs)"
Install-ChocolateyPackage @packageArgs
