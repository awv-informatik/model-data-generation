$ProgressPreference = 'SilentlyContinue'
New-Item -Path "../.out/column" -ItemType Directory -Force

$api = "http://127.0.0.1:9094/api"
$csv = Import-Csv -Path "./column.csv"
$outDir = (Resolve-Path "../.out/column").Path
if (Test-Path -Path $outDir) { Remove-Item -Path $outDir -Recurse -Force }
foreach ($line in $csv) {
    $name = "$($line.height)-$($line.length)-$($line.depth)"
    New-Item -Path $outDir -ItemType Directory -Force

    # Run ccfunc
    $body = Get-Content "./column.ccfunc"
    $url = "$api/Developer/Run?clear=1&height=$($line.height)&length=$($line.length)&depth=$($line.depth)"
    Invoke-RestMethod -Method POST -Uri "$url" -Body "$body" -ContentType application/octet-stream

    # Save ofb
    $file = [URI]::EscapeDataString("$outDir/$name.ofb")
    $url = "$api/BaseModeler_v1/save?file=$file&format=ofb"
    Invoke-RestMethod -Method POST -Uri "$url"
}
