# Format Build Results
function Merge-CombinedBuildResults {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $InputObject
    )

    begin {
        $timeZoneName = (Get-TimeZone).StandardName
        $timeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($timeZoneName)
        $table = @()
    }

    process {
        try {
            $row = @{}
            $row.BuildId        = $InputObject.Build.id
            $row.BuildNumber    = $InputObject.Build.buildNumber
            $row.DefinitionId   = $InputObject.Build.definition.id
            $row.DefinitionName = $InputObject.Build.definition.name
            $row.Result         = $InputObject.Build.result
            $row.Commit         = $InputObject.Build.sourceVersion
            $row.RequestedFor   = $InputObject.Build.requestedFor.displayName

            # Branches
            # For pull requests there is a target branch, source branch, and a merge branch
            # Trim 'refs/heads' from branch
            $row.Branch = $InputObject.Build.sourceBranch.Substring(11)
            $row.TargetBranch = ""
            if($InputObject.Build.parameters) {
                $p = $InputObject.Build.parameters | ConvertFrom-Json
                if($p."system.pullRequest.targetBranch") {
                    # Trim 'refs/heads' from branch
                    $row.TargetBranch = $p."system.pullRequest.targetBranch".Substring(11)
                }
            }

            $row.ClickUri = "https://dev.azure.com/$($InputObject.Organization)/$($InputObject.Project)/_build/results?buildId=$($InputObject.Build.id)&view=results"

            # Show local time instead of UTC
            $start = [System.TimeZoneInfo]::ConvertTimeToUtc($InputObject.Build.startTime)
            $row.StartTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($start, $timeZone)    

            # Not all records have a workerName, find one that does
            $row.Agent = ""
            ForEach ($record in $InputObject.Records) {
                if($record.workerName) {
                    $row.Agent = $record.workerName
                    break
                }
            }

            # Set the task name where the first error was
            if($InputObject.FirstErrorRecord) {
                $row.Task = $InputObject.FirstErrorRecord.name
            } else {
                $row.Task = ""
            }

            # Set the first error message
            if($InputObject.FirstError) {
                # Only include the first line of the message if there are multiple
                if($InputObject.FirstError.message -and $InputObject.FirstError.message.Contains("`n")) {
                    # Remove any trailing carriage return characters (`r)
                    $row.Message = $InputObject.FirstError.message.Split("`n").Replace("`r","")[0] + " (truncated)"
                } else {
                    $row.Message = $InputObject.FirstError.message
                }
            } else {
                $row.Message = ""
            }

            $table += $row
        } catch {
            throw $_
        }
    }

    end {
        $objects = $table | ForEach-Object {[PSCustomObject]$_}
        return $objects
    }
}
