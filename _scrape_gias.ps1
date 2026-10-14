# Fetch headteacher + chair of governors from GIAS for each URN.
# Output: E:\BH_Schools_2\_gias_scraped.csv with columns:
#   URN, gias_head, gias_chair, gias_status, source_url
#
# Notes:
#  - Headteacher is in <dd id="head-teacher-value">Name</dd>
#  - Chair of governors is the first row in the table under
#    <h2 id="chair-of-governors-heading">. The page lists historical
#    chairs too; the current chair is the row whose "To" cell is empty
#    or a future date. We take the row with no "To" date (if any),
#    falling back to the most-recent "From" date.

param(
  [string]$InputCsv  = 'E:\BH_Schools_2\_current.csv',
  [string]$OutputCsv = 'E:\BH_Schools_2\_gias_scraped.csv'
)

$ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36'

$rows = Import-Csv $InputCsv
# Dedupe URNs (West Hove Infant has two rows with same URN 114428)
$urns = $rows | Select-Object -ExpandProperty URN -Unique

$results = New-Object System.Collections.Generic.List[object]
$total = $urns.Count
$i = 0

foreach ($urn in $urns) {
  $i++
  $url = "https://get-information-schools.service.gov.uk/Establishments/Establishment/Details/$urn"

  $head  = ''
  $chair = ''
  $status = 'ok'

  try {
    $resp = Invoke-WebRequest -Uri $url -UserAgent $ua -UseBasicParsing -ErrorAction Stop
    $html = $resp.Content

    # Head teacher: <dd id="head-teacher-value" ...> Name </dd>
    $m = [regex]::Match($html, '(?is)<dd id="head-teacher-value"[^>]*>\s*([^<]*?)\s*</dd>')
    if ($m.Success) {
      $head = ($m.Groups[1].Value -replace '\s+', ' ').Trim()
    }

    # Chair of governors: find the section starting at <h2 id="chair-of-governors-heading">,
    # then the <tbody> rows. Each row's cells are <td> in order: Name, GID, Appointed-by, From, To.
    $sectionMatch = [regex]::Match(
      $html,
      '(?is)id="chair-of-governors-heading".*?<tbody[^>]*>(.*?)</tbody>'
    )
    if ($sectionMatch.Success) {
      $tbody = $sectionMatch.Groups[1].Value
      $rowMatches = [regex]::Matches($tbody, '(?is)<tr[^>]*>(.*?)</tr>')

      $chairCandidates = @()
      foreach ($rm in $rowMatches) {
        $rowHtml = $rm.Groups[1].Value
        $cells = [regex]::Matches($rowHtml, '(?is)<td[^>]*>(.*?)</td>') |
          ForEach-Object {
            # Strip nested tags, collapse whitespace
            (($_.Groups[1].Value -replace '<[^>]+>', '') -replace '&nbsp;', ' ' -replace '\s+', ' ').Trim()
          }
        if ($cells.Count -ge 5) {
          $chairCandidates += [pscustomobject]@{
            name        = $cells[0]
            from        = $cells[3]
            to          = $cells[4]
          }
        } elseif ($cells.Count -ge 1) {
          $chairCandidates += [pscustomobject]@{
            name        = $cells[0]
            from        = ''
            to          = ''
          }
        }
      }

      # Prefer the row with no "to" date (current incumbent); else most-recent "from"
      $current = $chairCandidates | Where-Object { [string]::IsNullOrWhiteSpace($_.to) } | Select-Object -First 1
      if (-not $current -and $chairCandidates.Count -gt 0) {
        $current = $chairCandidates | Sort-Object { [datetime]::Parse($_.from) } -Descending -ErrorAction SilentlyContinue | Select-Object -First 1
      }
      if ($current) { $chair = $current.name }
    } else {
      # No chair table found
      if ($html -match 'no governance' -or $html -match 'No governors') {
        $status = 'no_governance_data'
      }
    }

    if ([string]::IsNullOrWhiteSpace($head) -and [string]::IsNullOrWhiteSpace($chair)) {
      $status = 'no_data'
    }
  } catch {
    $status = "error: $($_.Exception.Message)"
  }

  Write-Output ("[{0}/{1}] URN {2}: head='{3}'  chair='{4}'  status={5}" -f $i, $total, $urn, $head, $chair, $status)

  $results.Add([pscustomobject]@{
    URN         = $urn
    gias_head   = $head
    gias_chair  = $chair
    gias_status = $status
    source_url  = $url
  }) | Out-Null

  Start-Sleep -Milliseconds 200  # polite delay
}

$results | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8
Write-Output ""
Write-Output ("Wrote {0} rows to {1}" -f $results.Count, $OutputCsv)
