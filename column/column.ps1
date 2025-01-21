$ProgressPreference = 'SilentlyContinue'
New-Item -Path "../.out/column" -ItemType Directory -Force

$api = "http://127.0.0.1:9094/api"
$csv = Import-Csv -Path "./column.csv"
$outDir = (Resolve-Path "../.out/column").Path
if (Test-Path -Path $outDir) { Remove-Item -Path $outDir -Recurse -Force }
foreach ($line in $csv) {
    $name = "$($line.height)-$($line.length)-$($line.depth)"
    New-Item -Path $outDir -ItemType Directory -Force

    $url = "$api/v1/common/clear"
    Invoke-RestMethod -Method POST -Uri "$url"

    # Run ccscript
    $file = [URI]::EscapeDataString("$PSScriptRoot/column.ccscript")
    $url = "$api/v1/script/run?file=$file&height=$($line.height)&length=$($line.length)&depth=$($line.depth)"
    Invoke-RestMethod -Method POST -Uri "$url"

    # Save ofb
    $file = [URI]::EscapeDataString("$outDir/$name.ofb")
    $url = "$api/v1/basemodeler/save?file=$file&format=ofb"
    Invoke-RestMethod -Method POST -Uri "$url"
}
