# Get formatted build summary

# Defaults
param (
    # Get a Personal Access Token from dev.azure.com and 
    # put it in the environment variable named PAT
    # $Env:PAT = "YOUR_PERSONAL_ACCESS_TOKEN_HERE"
    $PersonalAccessToken = $Env:PAT,
    $Organization = "my-org-here",
    $Project = "My Project Name Here",
    # Comma separated build definition ids
    $Definitions = "1234,2345", 
    # This is a date formatted YYYY-MM-DD
    $MinTime = "2020-03-20"
)

$ErrorActionPreference = "Stop"

&"C:\Path\to\Scripts\Import-BuildResultsModules.ps1"

$results = Get-CombinedBuildResults `
    -Definitions $Definitions `
    -MinTime $MinTime `
    -Project $Project `
    -Organization $Organization `
    -PersonalAccessToken $PersonalAccessToken

# Print out to a GridView GUI
$results `
    | Merge-CombinedBuildResults `
    | Select-Object BuildId, StartTime, Agent, Result, Task, Message `
    | Sort-Object -Property StartTime -Descending `
    | Out-GridView

# Print out to the PowerShell console
# $results | Merge-CombinedBuildResults | Format-Table