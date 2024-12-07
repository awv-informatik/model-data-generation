$ProgressPreference = 'SilentlyContinue'
New-Item -Path "../.out/shelf" -ItemType Directory -Force

$api = "http://127.0.0.1:9094/api"
$csv = Import-Csv -Path "./shelf.csv"
$outDir = (Resolve-Path "../.out/shelf").Path
if (Test-Path -Path $outDir) { Remove-Item -Path $outDir -Recurse -Force }
foreach ($line in $csv) {
    $name = "$($line.length)-$($line.depth)"
    New-Item -Path $outDir -ItemType Directory -Force

    # Run ccfunc
    $body = Get-Content "./shelf.ccfunc"
    $url = "$api/Developer/Run?clear=1&length=$($line.length)&depth=$($line.depth)&ft=$($line.ft)"
    Invoke-RestMethod -Method POST -Uri "$url" -Body "$body" -ContentType application/octet-stream

    # Save ofb
    $file = [URI]::EscapeDataString("$outDir/$name.ofb")
    $url = "$api/BaseModeler_v1/save?file=$file&format=ofb"
    Invoke-RestMethod -Method POST -Uri "$url"

    # Save iwp
    $file = [URI]::EscapeDataString("$($outDir)/$($name).iwp")
    $iwp = [URI]::EscapeDataString("{`"binary`": 1 }")
    $url = "$api/BaseModeler_v1/save?file=$file&format=iwp&iwp=$iwp"
    Invoke-RestMethod -Method POST -Uri "$url"
}
