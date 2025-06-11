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

Uninstall-Firebird