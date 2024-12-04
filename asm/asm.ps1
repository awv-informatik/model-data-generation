New-Item -Path "../.out/asm" -ItemType Directory -Force

$api = "http://127.0.0.1:9094/api"
$csv = Import-Csv -Path "./asm.csv"
$inDir = (Resolve-Path "../.out").Path
$outDir = (Resolve-Path "../.out/asm").Path
if (Test-Path -Path $outDir) { Remove-Item -Path $outDir -Recurse -Force }
foreach ($line in $csv) {
    $name = "asm-$($line.id)"
    New-Item -Path "$outDir" -ItemType Directory -Force

    # Run ccfunc
    $body = Get-Content "./asm.ccfunc"
    $dir = [URI]::EscapeDataString("$inDir/")
    $url = "$api/Developer/Run?clear=1&height=$($line.height)&depth=$($line.depth)&length=$($line.length)&nShelves=$($line.nShelves)&col_file=$($line.col_file)&shelf_file=$($line.shelf_file)&dir=$dir"
    Invoke-RestMethod -Method POST -Uri "$url" -Body "$body" -ContentType application/octet-stream

    # Save ofb
    $file = [URI]::EscapeDataString("$outDir/$name.ofb")
    $url = "$api/BaseModeler_v1/save?file=$file&format=ofb"
    Invoke-RestMethod -Method POST -Uri "$url"

    # Save iwp
    $file = [URI]::EscapeDataString("$($outDir)/$($name)_binary.iwp")
    $iwp = [URI]::EscapeDataString("{`"binary`": 0 }")
    $url = "$api/BaseModeler_v1/save?file=$file&format=iwp&iwp=$iwp"
    Invoke-RestMethod -Method POST -Uri "$url"

    # Save step
    $file = [URI]::EscapeDataString("$outDir/$name.stp")
    $url = "$api/BaseModeler_v1/save?file=$file&format=stp"
    Invoke-RestMethod -Method POST -Uri "$url"
}
