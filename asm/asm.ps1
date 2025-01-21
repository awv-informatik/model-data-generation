New-Item -Path "../.out/asm" -ItemType Directory -Force

$api = "http://127.0.0.1:9094/api"
$csv = Import-Csv -Path "./asm.csv"
$inDir = (Resolve-Path "../.out").Path
$outDir = (Resolve-Path "../.out/asm").Path
if (Test-Path -Path $outDir) { Remove-Item -Path $outDir -Recurse -Force }
foreach ($line in $csv) {
    $name = "asm-$($line.id)"
    New-Item -Path "$outDir" -ItemType Directory -Force

    $url = "$api/v1/common/clear"
    Invoke-RestMethod -Method POST -Uri "$url"

    # Run ccscript
    $file = [URI]::EscapeDataString("$PSScriptRoot/asm.ccscript")
    $dir = [URI]::EscapeDataString("$inDir/")
    $url = "$api/v1/script/run?file=$file&height=$($line.height)&nShelves=$($line.nShelves)&col_file=$($line.col_file)&shelf_file=$($line.shelf_file)&dir=$dir"
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

    # Save step
    $file = [URI]::EscapeDataString("$outDir/$name.stp")
    $url = "$api/v1/basemodeler/save?file=$file&format=stp"
    Invoke-RestMethod -Method POST -Uri "$url"
}
