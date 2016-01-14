$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$toolsScript = Join-Path $toolsDir "..\..\firebirdclient\tools\firebirdTools.ps1"

$packageParameters = $env:chocolateyPackageParameters

$classicServerType = $true

. $toolsScript

$packageName = 'firebird'

$arguments = @{}

# Now parse the packageParameters using good old regular expression
if ($packageParameters) {
    $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
    $option_name = 'option'
    $value_name = 'value'

    if ($packageParameters -match $match_pattern ){
        $results = $packageParameters | Select-String $match_pattern -AllMatches
        $results.matches | % {
            $arguments.Add(
                $_.Groups[$option_name].Value.Trim(),
                $_.Groups[$value_name].Value.Trim())
        }
    } else {
        Throw "Package Parameters were found but were invalid (REGEX Failure)"
    }

    if ($arguments.ContainsKey("SuperServer")) {
        $classicServerType = $false
    } 

} else {
    Write-Debug "No Package Parameters Passed in"
}

if ($classicServerType -eq $true) {
    Write-Host "ClassicServer Installation"
    Install-FirebirdClassicServer $packageName 
} else {
    Write-Host "SuperServer Installation"
    Install-FirebirdSuperServer $packageName
}
Export-FirebirdPath
