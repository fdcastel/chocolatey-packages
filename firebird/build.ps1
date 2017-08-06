#Requires -Version 5.0

$config = @{
    'current' = @{
        'version' = '3.0.2'
        'url' = 'https://downloads.sourceforge.net/project/firebird/firebird-win32/3.0.2-Release/Firebird-3.0.2.32703_0_Win32.exe'
        'url64' = 'https://downloads.sourceforge.net/project/firebird/firebird-win64/3.0.2-Release/Firebird-3.0.2.32703_0_x64.exe'
        'installerName' = 'Firebird-3.0.2.32703_0.exe'
    }
    'series25' = @{
        'version' = '2.5.7.1000'
        'url' = 'https://downloads.sourceforge.net/project/firebird/firebird-win32/2.5.7-Release/Firebird-2.5.7.27050_0_Win32.exe'
        'url64' = 'https://downloads.sourceforge.net/project/firebird/firebird-win64/2.5.7-Release/Firebird-2.5.7.27050_0_x64.exe'
        'installerName' = 'Firebird-2.5.7.27050_0_x64.exe'
    }
    'series21' = @{
        'version' = '2.1.7.1000'
        'url' = 'https://downloads.sourceforge.net/project/firebird/firebird-win32/2.1.7-Release/Firebird-2.1.7.18553_0_Win32.exe'
        'url64' = 'https://downloads.sourceforge.net/project/firebird/firebird-win64/2.1.7-Release/Firebird-2.1.7.18553_0_x64.exe'
        'installerName' = 'Firebird-2.1.7.18553_0.exe'
    }
    'series210' = @{
        'version' = '2.1.0.17798'
        'url' = 'https://downloads.sourceforge.net/project/firebird/OldFiles/firebird-win32/Firebird-2.1.0.17798_0_Win32.exe'
        'url64' = 'https://downloads.sourceforge.net/project/firebird/OldFiles/firebird-win64/Firebird-2.1.0.17798_0_x64.exe'
        'installerName' = 'Firebird-2.1.0.17798_0.exe'
    }
}

$ErrorActionPreference = 'Stop'

function New-File ($FileName) {
    # Create a empty file and its complete path
    New-Item $FileName -ItemType File -Force | Out-Null
}

function Expand-Template([Parameter(ValueFromPipeline=$true)]$Template) {
    $evaluator = { 
        $innerTemplate = $args[0].Groups[1].Value
        # TODO: change the ExpandString below to something compatible with PS4
        $ExecutionContext.InvokeCommand.ExpandString($innerTemplate)
    }
    $regex = [regex]"\<\%(.*?)\%\>"
    $regex.Replace($Template, $evaluator)
}

function Expand-TemplateFolder($SourcePath, $TargetPath) {
    Push-Location $SourcePath
    try {
        Get-ChildItem . -Recurse | 
            ForEach-Object {
                if ($_ -isnot [System.IO.DirectoryInfo]) {
                    $sourceFileName = $_ | Resolve-Path -Relative
                    $targetFileName = Join-Path $TargetPath $sourceFileName

                    if ($_.BaseName.EndsWith('.template', 'CurrentCultureIgnoreCase')) {
                        $targetFileName = $targetFileName.Replace('.template', '')
                        New-File $targetFileName
                        Get-Content $sourceFileName -Raw -Encoding UTF8 |
                            Expand-Template |
                                Set-Content $targetFileName -Encoding UTF8
                    }
                    else {
                        New-File $targetFileName
                        Copy-Item -Path $sourceFileName $targetFileName
                    }
                }
            }
    }
    finally {
        Pop-Location
    }
}

function Download-TempFile([uri]$url){
    $fileName = $url.Segments[-1]
    $file = Join-Path $env:TEMP $fileName

    # Download file, if needed
    if (-not (Test-Path $file)) {
        Write-Verbose "    Downloading $url..."
        
        # DownloadFile fails if folder doesn't exists. 
        New-File $file
        
        (New-Object Net.WebClient).DownloadFile($url, $file)
    }

    if (-not (Test-Path $file)) {
        throw "ERROR: Cannot download from $url."
    }

    $file
}

function Build-FirebirdPackage($Configuration) {
    # Calculate checksums for each installer
    $Configuration.checksum = (Get-FileHash (Download-TempFile $Configuration.url) -Algorithm SHA256).Hash
    $Configuration.checksum64 = (Get-FileHash (Download-TempFile $Configuration.url64) -Algorithm SHA256).Hash
    $Configuration.checksumType = 'sha256'

    # Expand .\firebirdTools.template.ps1
    $toolsTemplate = Get-Content '.\firebirdTools.template.ps1' -Raw -Encoding UTF8
    $includeFirebirdTools = Expand-Template $toolsTemplate

    # Create temp folder
    $tempName = [System.IO.Path]::GetRandomFileName()
    $tempFolder = "$env:TEMP\$tempName"
    mkdir $tempFolder | Out-Null
    try {
        # Copy source folder content to temp folder, expanding templates
        Expand-TemplateFolder -SourcePath '.\src' -TargetPath $tempFolder

        # Create chocolatey package in .\out 
        $outputPath = (Get-Item '.\out').FullName
        Push-Location $tempFolder
        try {
            choco pack --outputdirectory=$outputPath
        }
        finally {
            Pop-Location
        }
    }
    finally {
        # Delete temp folder
        rmdir $tempFolder -Recurse
    }
}



#
# Main
#

mkdir '.\out' -ErrorAction SilentlyContinue | Out-Null

$config.Keys | ForEach-Object {
    Build-FirebirdPackage -Configuration $config.$_
}
