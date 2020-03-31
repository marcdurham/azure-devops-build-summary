# Includes first error message of failed builds
function Get-BuildResults {
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

    $result = Get-BuildList -MinTime $MinTime -Definitions $Definitions -Project $Project -Organization $Organization -PersonalAccessToken $PersonalAccessToken
    $builds = $result.value

    $table = @()

    ForEach ($build in $builds) {
        $timeline = Get-BuildTimeline -BuildId $build.id -Project $project -Organization $Organization -PersonalAccessToken $PersonalAccessToken

        $row = @{ Build = $build; }
        if(!$timeline) {
            $row.FirstRecord = @{}
            $row.FirstIssueRecord = @{}
            $row.FirstIssue = @{}
            continue
        }

        $row.FirstRecord = $timeline.records[0]

        ForEach ($record in $timeline.records) {       
            if($record.issues) {
                $row.FirstIssueRecord = $record
                $row.FirstIssue = $record.issues[0] 
                break
            }
        }

        $table += $row
    }

    return $table
}
