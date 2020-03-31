# Format Build Results
function Get-BuildResultsFormatted {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $InputObject
    )

    begin {
        $currentTimeZone = (Get-WmiObject win32_timezone).StandardName
        $tz = [System.TimeZoneInfo]::FindSystemTimeZoneById($currentTimeZone)
        $table = @()
    }

    process {
        $row = @{}
        $row.BuildNumber = $InputObject.Build.buildNumber;
        $row.Result = $InputObject.Build.result
        $row.Branch = $InputObject.Build.sourceBranch.Substring(11) # Trim refs/heads from branch
        $row.Commit = $InputObject.Build.sourceVersion
        
        $row.StartUtc = [System.TimeZoneInfo]::ConvertTimeToUtc($InputObject.Build.startTime)
        $row.StartLocal = [System.TimeZoneInfo]::ConvertTimeFromUtc($row.StartUtc, $tz)    

        $row.Task = $InputObject.FirstRecord.name
        $row.Agent = $InputObject.FirstRecord.workerName

        if($InputObject.FirstIssueRecord) {
            $row.Task = $InputObject.FirstIssueRecord.name
        }

        if($InputObject.FirstIssue) {
            $row.Message = $InputObject.FirstIssue.message
        } else {
            $row.Message = ""
        }       

        $table += $row
    }

    end {
        $objects = $table | ForEach-Object {[PSCustomObject]$_}
        return $objects
    }
}
