# Gets timestamps for all computers in the domain that have not logged in since after specified date
# Examples:
# GetInactiveComputer.ps1 -DaysInactive 180 -OutputFileName C:\temp.csv -DebugPreference Continue

Param(
	# Default days inactive is 90
	# Determines how far back to look for inactive computer accounts.
	# The script will report computers that are inactive for at least 90 days.
	[int]$DaysInactive = 90,

	# File name to save output to
	[string]$OutputFileName = "C:\GetInactiveComputer.csv",

	# Set default debug
	# Controls whether debugging statements are printed or not.
	# To print debug statements, set this to Continue.
	$DebugPreference = "SilentlyContinue"
)

$time = (Get-Date).Adddays(-($DaysInactive))

# Debugging
Write-Debug "Days inactive to search for: $DaysInactive"
Write-Debug "Timestamp to search for: $time"

# Get all AD computers with lastLogonTimestamp less than our time
Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp |

# Output hostname and lastLogonTimestamp into CSV
select-object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | export-csv $OutputFileName -notypeinformation
