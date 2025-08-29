
<#
.SYNOPSIS
    Converts a text-based Ikea work schedule to both iCalendar (.ics) and JSON (.json) formats.

.DESCRIPTION
    This script parses a text file generated from an Ikea work schedule PDF and creates:
      - An iCalendar (.ics) file for calendar import.
      - A JSON (.json) file for use with the calendarUpdate.py script.
    The script expects the text file to follow the layout of the Ikea schedule as of January 2020.

.PARAMETER mySchedule
    The name of the input text file (default: report.txt).

.EXAMPLE
    powershell .\createIcsAndJsonFiles.ps1 -mySchedule "output_schedule.txt"

.NOTES
    - Requires PowerShell.
    - The input text file should be generated from a PDF using the tool pdftotext.
    - Output files will be created in the same directory as the script.
    - Adjust parsing logic if the Ikea PDF layout changes.

.LINK
    https://github.com/reposol/MigrateWerkRooster
#>

param (
#	[String]$myHome = "D:\schedule",
	[String]$mySchedule = "report.txt"
)

$iFile = ".\${mySchedule}"
$iBasename = $mySchedule.Split('.',2)[0]
$oFile = "${myHome}\${iBasename}.ics"
$oFileJson = "${myHome}\${iBasename}.json"
$workday = @{}
$schedule = @{}
$eventsJson = @()

$excludeLine = "^\s*$|Personeelsdienstrooster|Medewerker:|Datum|Totaal"
$moreDetails = $false

$tmplProlog = @"
BEGIN:VCALENDAR
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
VERSION:2.0
CALSCALE:GREGORIAN
METHOD:PUBLISH
X-WR-CALNAME:myCalendar
X-WR-TIMEZONE:Europe/Amsterdam
X-WR-CALDESC:this is my\ntest calendar

"@

$tmplEvent = @"
BEGIN:VEVENT
DTSTART:#DATE#T#FROM#00
DTEND:#DATE#T#TO#00
DTSTAMP:#NOW#00
UID:#RANDOM#@mijn.werk
DESCRIPTION:#DETAILS#
SUMMARY:Ikea
END:VEVENT

"@
	
$tmplEpilog = @"
END:VCALENDAR
"@

function storeDay {
	$date = ($workday.date | % {$d = $_.Split("-"); -join $d[2]+$d[1]+$d[0]})
	$schedule.Add($date, $workday.Clone())
	$workday.Clear()
}

if (-not (Test-Path $iFile)) {
	Write-host "`nInput file $iFile not found.`n"
	exit 
}
if (Test-Path $oFile)     { Remove-Item $oFile }
if (Test-Path $oFileJson) { Remove-Item $oFileJson }

$tmplEvent = $tmplEvent -replace "#NOW#", $(Get-Date -f yyyyMMdd`THHmm)

<#
# check random range, 100.000x 26 digits
$hash = @{}
foreach ($c in (1..100000)) {
	$a = (-join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 26 | % {[char]$_}))
#	$a = 123
	try {
		$hash.add("$a", "")
	} catch {
		$_.Exception.Message
	}
}
break;
#>

# get weekday, date, from, to, details
foreach ($line in Get-Content $iFile) {
	# exclude stuff
	if ($line -match $excludeLine) { continue }

	$line = $line -split "\s+"

	Switch -regex -casesensitive ($line[0]) {
		# exclude off days
		{ $line[2] -eq "0:00" } { break }
		# weekday 
		"Ma|Di|Wo|Do|Vr|Za|Zo" { 
			if ( ($workday).Count -ne 0 ) { storeDay }
			$workday.Add("weekday", $line[0])
			$workday.Add("date", $line[1])
			$workday.Add("details", $line[2..$line.length] + '\n')
			# next record doesn't contain details
			$moreDetails = $false
			break
		}
		# worktime
		{$_ -match "^\d+:"} {
			if ($line[0] -match "^\d:\d{2}") { $line[0] = '0' + $line[0] }
			$workday.Add("from", $line[0])
			$workday.Add("to", $line[2])
			$workday["details"] = $workday.details + $line[3..$line.length] + '\n'
			# next record could contain details
			$moreDetails = $true
			break
		}
		{$moreDetails} {
			$workday["details"] = $workday.details + $line[0..$line.length] + '\n'
			break
		}
		default { break }
	}
	
}
storeDay  # store last workday

$tmplProlog | Out-File $oFile -Append

# $i=0
$schedule.keys | Sort-Object | % {
	# if ($i++ -ge 2) { return }

	$locEvent = $tmplEvent

	# create ICAL file
#	$weekday = $schedule.$_.weekday
	$locEvent = $locEvent -replace "#DATE#", ($schedule.$_.date | % {$d = $_.Split("-"); -join $d[2]+$d[1]+$d[0]})
	$locEvent = $locEvent -replace "#FROM#", ($schedule.$_.from -replace ":")
	$locEvent = $locEvent -replace "#TO#", ($schedule.$_.to -replace ":")
	$locEvent = $locEvent -replace "#DETAILS#", [String]$schedule.$_.details
	$locEvent = $locEvent -replace "#RANDOM#", (-join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 26 | % {[char]$_}))

	# all-day-event
	if ($schedule.$_.from -eq "00:00") {
		$locDate = $schedule.$_.date | % {$d = $_.Split("-"); -join $d[2]+$d[1]+$d[0]}
		$locEvent = $locEvent -replace 'DTSTART.+', "DTSTART;VALUE=DATE:${locDate}"
		$locEvent = $locEvent -replace 'DTEND.+', "DTEND;VALUE=DATE:${locDate}"
	}

	$locEvent | Out-File $oFile -Append

	# create list of event-hashes for json output
	$locJson = @{}
	$locJson.Add("summary", "Ikea")
	$locJson.Add("date",  ($schedule.$_.date | % {$d = $_.Split("-"); `
		return $d[2]+'-'+$d[1]+'-'+$d[0]}))	# needed for all-day-events
	$tmpTime = $schedule.$_.from
	$locJson.Add("start", ($schedule.$_.date | % {$d = $_.Split("-"); `
		return $d[2]+'-'+$d[1]+'-'+$d[0]+'T'+$tmpTime+':00'}))
	$tmpTime = $schedule.$_.to
	$locJson.Add("end", ($schedule.$_.date | % {$d = $_.Split("-"); `
		return $d[2]+'-'+$d[1]+'-'+$d[0]+'T'+$tmpTime+':00'}))
	$locJson.Add("description", $schedule.$_.details)
	$eventsJson += $locJson.clone()
}

$tmplEpilog | Out-File $oFile -Append

$hashJson = @{ events = $eventsJson } 
# revert automatic char escape feature of convertto-json
(ConvertTo-Json $hashJson).replace('\\n','\n') | Out-File $oFileJson -Append
# .net global solution
# ConvertTo-Json $hashJson | % { [System.Text.RegularExpressions.Regex]::Unescape($_) }  | Out-File $oFileJson -Append
