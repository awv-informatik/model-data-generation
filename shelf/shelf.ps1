$ProgressPreference = 'SilentlyContinue'
New-Item -Path "../.out/shelf" -ItemType Directory -Force

$api = "http://127.0.0.1:9094/api"
$csv = Import-Csv -Path "./shelf.csv"
$outDir = (Resolve-Path "../.out/shelf").Path
if (Test-Path -Path $outDir) { Remove-Item -Path $outDir -Recurse -Force }
foreach ($line in $csv) {
    $name = "$($line.length)-$($line.depth)"
    New-Item -Path $outDir -ItemType Directory -Force

    $url = "$api/v1/common/clear"
    Invoke-RestMethod -Method POST -Uri "$url"

    # Run ccscript
    $file = [URI]::EscapeDataString("$PSScriptRoot/shelf.ccscript")
    $url = "$api/v1/script/run?file=$file&length=$($line.length)&depth=$($line.depth)&ft=$($line.ft)"
    Invoke-RestMethod -Method POST -Uri "$url"

    # Save ofb
    $file = [URI]::EscapeDataString("$outDir/$name.ofb")
    $url = "$api/v1/basemodeler/save?file=$file&format=ofb"
    Invoke-RestMethod -Method POST -Uri "$url"

    # Save iwp
    $file = [URI]::EscapeDataString("$($outDir)/$($name).iwp")
    $iwp = [URI]::EscapeDataString("{`"binary`": 1 }")
    $url = "$api/v1/basemodeler/save?file=$file&format=iwp&iwp=$iwp"
    Invoke-RestMethod -Method POST -Uri "$url"
}
