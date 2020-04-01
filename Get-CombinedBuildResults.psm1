﻿# Includes first error message of failed builds
function Get-CombinedBuildResults {
    param (
        [Parameter(Mandatory=$true)]
        [String] 
        $PersonalAccessToken,
        [Parameter(Mandatory=$true)]
        [String] 
        $Organization,
        [Parameter(Mandatory=$true)]
        [String] 
        $Project,
        [Parameter(Mandatory=$true)]
        [String] 
        $Definitions,
        [Parameter(Mandatory=$true)]
        [String]         
        $MinTime
    )

    $result = Get-BuildList `
        -MinTime $MinTime `
        -Definitions $Definitions `
        -Project $Project `
        -Organization $Organization `
        -PersonalAccessToken $PersonalAccessToken

        $builds = $result.value

    $table = @()

    ForEach ($build in $builds) {
        $row = @{
            Organization = $Organization
            Project = $Project
            Build = $build
            Records = @()
            FirstRecord = @{}
            FirstIssueRecord = @{}
            FirstIssue = @{}
        }
        
        $timeline = Get-BuildTimeline `
            -BuildId $build.id `
            -Project $project `
            -Organization $Organization `
            -PersonalAccessToken $PersonalAccessToken

        if(!$timeline) {
            return $table
        }

        # Keep records in order so the first record happened first
        $row.Records = $timeline.records | Sort-Object -Property order

        $row.FirstRecord = $row.Records[0]

        ForEach ($record in $row.Records) {
            if($record.issues -and $record.issues.Count -gt 0) {
                $row.FirstIssueRecord = $record
                $row.FirstIssue = $record.issues[0] 
                break
            }
        }

        $table += $row
    }

    return $table
}
