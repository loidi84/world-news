#Requires -Version 7.0
<#
.SYNOPSIS
    Validates World News monthly data files.
.DESCRIPTION
    Checks JSON syntax, dates within the month, allowed topics, unique IDs,
    non-empty text, source URLs, and chart schemas.
#>

[CmdletBinding()]
param(
    [string]$DataDir = "data"
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

$allowedTopics = [System.Collections.Generic.HashSet[string]]@(
    "business", "film", "music", "deaths", "politics",
    "science", "sport", "tech", "games", "wrestling"
)

$allowedConfidence = [System.Collections.Generic.HashSet[string]]@("high", "medium", "low")
$allowedChartKinds = [System.Collections.Generic.HashSet[string]]@("games", "music", "film", "cinema")

if (-not (Test-Path -Path $DataDir -PathType Container)) {
    Write-Error "Data directory '$DataDir' does not exist."
    exit 1
}

$files = Get-ChildItem -Path $DataDir -Filter "*.json" | Sort-Object Name
if ($files.Count -eq 0) {
    Write-Host "No JSON files found in '$DataDir'." -ForegroundColor Yellow
    exit 0
}

$totalFiles = $files.Count
$totalErrors = 0
$totalWarnings = 0
$allWrestling = [System.Collections.Generic.List[PSCustomObject]]::new()
$allLowConf = [System.Collections.Generic.List[PSCustomObject]]::new()

Write-Host "Validating $totalFiles file(s) in '$DataDir'...`n" -ForegroundColor Cyan

foreach ($file in $files) {
    $fileErrors = [System.Collections.Generic.List[string]]::new()
    $fileWarnings = [System.Collections.Generic.List[string]]::new()

    # Filename format YYYY-MM.json
    if ($file.Name -notmatch '^(\d{4})-(\d{2})\.json$') {
        $fileErrors.Add("Filename '$($file.Name)' does not match pattern YYYY-MM.json")
        Write-Host "[FAIL] $($file.Name):" -ForegroundColor Red
        foreach ($e in $fileErrors) { Write-Host "  - ERROR: $e" -ForegroundColor Red }
        $totalErrors += $fileErrors.Count
        continue
    }

    $expectedYear = [int]$Matches[1]
    $expectedMonth = [int]$Matches[2]

    if ($expectedMonth -lt 1 -or $expectedMonth -gt 12) {
        $fileErrors.Add("Month $expectedMonth out of range (1-12)")
    }

    $content = Get-Content -Path $file.FullName -Raw -Encoding utf8
    $data = $null
    try {
        $data = $content | ConvertFrom-Json
    }
    catch {
        $fileErrors.Add("Invalid JSON: $($_.Exception.Message)")
        Write-Host "[FAIL] $($file.Name):" -ForegroundColor Red
        foreach ($e in $fileErrors) { Write-Host "  - ERROR: $e" -ForegroundColor Red }
        $totalErrors += $fileErrors.Count
        continue
    }

    # Month check
    $expectedMonthStr = "{0:D4}-{1:D2}" -f $expectedYear, $expectedMonth
    if ($data.month -ne $expectedMonthStr) {
        $fileErrors.Add("Root 'month' is '$($data.month)', expected '$expectedMonthStr'")
    }

    # Region check
    if ($data.region -ne "UK") {
        $fileWarnings.Add("Root 'region' is '$($data.region)', expected 'UK'")
    }

    # News items
    if ($null -eq $data.news -or -not ($data.news -is [System.Array])) {
        $fileErrors.Add("Root 'news' must be an array")
    }
    else {
        $seenIds = [System.Collections.Generic.HashSet[string]]::new()

        for ($i = 0; $i -lt $data.news.Count; $i++) {
            $item = $data.news[$i]
            $id = $item.id

            if ([string]::IsNullOrWhiteSpace($id)) {
                $fileErrors.Add("News item #$i missing 'id'")
            }
            elseif (-not $seenIds.Add($id)) {
                $fileErrors.Add("Duplicate news id '$id'")
            }

            # Date check
            if ([string]::IsNullOrWhiteSpace($item.date)) {
                $fileErrors.Add("News item '$id' missing 'date'")
            }
            else {
                $parsedDate = [datetime]::MinValue
                if ([datetime]::TryParseExact($item.date, "yyyy-MM-dd", [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref]$parsedDate)) {
                    if ($parsedDate.Year -ne $expectedYear -or $parsedDate.Month -ne $expectedMonth) {
                        $fileErrors.Add("Item '$id' date '$($item.date)' is outside month $expectedMonthStr")
                    }
                }
                else {
                    $fileErrors.Add("Item '$id' date '$($item.date)' is not in YYYY-MM-DD format")
                }
            }

            # Topic check
            if ([string]::IsNullOrWhiteSpace($item.topic)) {
                $fileErrors.Add("Item '$id' missing 'topic'")
            }
            elseif (-not $allowedTopics.Contains($item.topic)) {
                $fileErrors.Add("Item '$id' has invalid topic '$($item.topic)'. Allowed: $($allowedTopics -join ', ')")
            }

            if ($item.topic -eq "wrestling") {
                $allWrestling.Add([PSCustomObject]@{
                    File = $file.Name
                    Id   = $id
                    Text = if ($item.text) { $item.text.Substring(0, [Math]::Min(70, $item.text.Length)) } else { "" }
                })
            }

            # Text check
            if ([string]::IsNullOrWhiteSpace($item.text)) {
                $fileErrors.Add("Item '$id' has empty or whitespace 'text'")
            }
            else {
                if ($item.text.Contains("`n")) {
                    $fileWarnings.Add("Item '$id' text contains multiple paragraphs")
                }
            }

            # Source check
            if ([string]::IsNullOrWhiteSpace($item.source)) {
                $fileErrors.Add("Item '$id' missing 'source'")
            }
            elseif (-not ($item.source.StartsWith("http://") -or $item.source.StartsWith("https://") -or $item.source.StartsWith("Supplied page"))) {
                $fileWarnings.Add("Item '$id' source does not look like a URL: '$($item.source)'")
            }

            # Confidence check
            $confProp = $item.PSObject.Properties["confidence"]
            if ($null -ne $confProp -and $null -ne $confProp.Value) {
                if (-not $allowedConfidence.Contains([string]$confProp.Value)) {
                    $fileErrors.Add("Item '$id' confidence '$($confProp.Value)' invalid")
                }
                if ($confProp.Value -eq "low") {
                    $allLowConf.Add([PSCustomObject]@{
                        File = $file.Name
                        Id   = $id
                        Text = if ($item.text) { $item.text.Substring(0, [Math]::Min(70, $item.text.Length)) } else { "" }
                    })
                }
            }

            # Importance check
            $impProp = $item.PSObject.Properties["importance"]
            if ($null -ne $impProp -and $null -ne $impProp.Value) {
                $val = $impProp.Value
                if ($val -lt 1 -or $val -gt 5) {
                    $fileErrors.Add("Item '$id' importance must be between 1 and 5")
                }
            }
        }

        if ($data.news.Count -lt 4) {
            $fileWarnings.Add("File has only $($data.news.Count) news items (pool should ideally be 5-12)")
        }
    }

    # Charts check
    $chartsProp = $data.PSObject.Properties["charts"]
    if ($null -ne $chartsProp -and $null -ne $chartsProp.Value) {
        $chartsList = $chartsProp.Value
        if (-not ($chartsList -is [System.Array])) {
            $fileErrors.Add("'charts' must be an array")
        }
        else {
            foreach ($chart in $chartsList) {
                if ([string]::IsNullOrWhiteSpace($chart.section)) {
                    $fileErrors.Add("Chart missing 'section'")
                }
                if (-not $allowedChartKinds.Contains($chart.kind)) {
                    $fileErrors.Add("Chart '$($chart.section)' kind '$($chart.kind)' invalid")
                }
                $entriesProp = $chart.PSObject.Properties["entries"]
                if ($null -ne $entriesProp -and $null -ne $entriesProp.Value) {
                    foreach ($entry in $entriesProp.Value) {
                        $posProp = $entry.PSObject.Properties["pos"]
                        if ($null -eq $posProp -or $null -eq $posProp.Value) {
                            $fileErrors.Add("Chart '$($chart.section)' entry missing 'pos'")
                        }
                        elseif (-not ($posProp.Value -is [int] -or $posProp.Value -is [long])) {
                            $fileErrors.Add("Chart '$($chart.section)' entry 'pos' must be an integer")
                        }

                        $titleProp = $entry.PSObject.Properties["title"]
                        if ($null -eq $titleProp -or [string]::IsNullOrWhiteSpace($titleProp.Value)) {
                            $fileErrors.Add("Chart '$($chart.section)' entry missing 'title'")
                        }

                        $byProp = $entry.PSObject.Properties["by"]
                        if ($null -eq $byProp -or [string]::IsNullOrWhiteSpace($byProp.Value)) {
                            $fileErrors.Add("Chart '$($chart.section)' entry missing 'by'")
                        }
                    }
                }
            }
        }
    }

    # Report file status
    if ($fileErrors.Count -gt 0) {
        $totalErrors += $fileErrors.Count
        Write-Host "[FAIL] $($file.Name):" -ForegroundColor Red
        foreach ($e in $fileErrors) { Write-Host "  - ERROR: $e" -ForegroundColor Red }
    }
    elseif ($fileWarnings.Count -gt 0) {
        $totalWarnings += $fileWarnings.Count
        Write-Host "[WARN] $($file.Name)" -ForegroundColor Yellow
        foreach ($w in $fileWarnings) { Write-Host "  - WARNING: $w" -ForegroundColor Yellow }
    }
    else {
        Write-Host "[OK]   $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`n$("=" * 50)" -ForegroundColor Cyan
Write-Host "Summary: $totalFiles file(s) checked. $totalErrors error(s), $totalWarnings warning(s)." -ForegroundColor $(if ($totalErrors -gt 0) { "Red" } else { "Green" })

if ($allWrestling.Count -gt 0) {
    Write-Host "`n--- Wrestling Items ($($allWrestling.Count)) for Human Review ---" -ForegroundColor Magenta
    foreach ($w in $allWrestling) {
        Write-Host "  [$($w.File)] $($w.Id): $($w.Text)..."
    }
}

if ($allLowConf.Count -gt 0) {
    Write-Host "`n--- Low Confidence Items ($($allLowConf.Count)) ---" -ForegroundColor Yellow
    foreach ($lc in $allLowConf) {
        Write-Host "  [$($lc.File)] $($lc.Id): $($lc.Text)..."
    }
}

if ($totalErrors -gt 0) {
    exit 1
}
else {
    # Auto-compile bundle.js for seamless local / file:// browsing
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine("// Auto-generated data bundle for offline/file:// browsing")
    [void]$sb.AppendLine("window.ALL_DATA = window.ALL_DATA || {};")
    foreach ($f in $files) {
        $monthKey = $f.BaseName
        $rawJson = Get-Content -Path $f.FullName -Raw -Encoding utf8
        [void]$sb.AppendLine("window.ALL_DATA['$monthKey'] = $rawJson;")
    }
    $bundlePath = "bundle.js"
    [System.IO.File]::WriteAllText($bundlePath, $sb.ToString(), [System.Text.Encoding]::UTF8)
    Write-Host "`n[OK] Updated $bundlePath with $($files.Count) month(s) for offline viewing." -ForegroundColor Green
    exit 0
}
