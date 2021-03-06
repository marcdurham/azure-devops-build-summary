﻿function Get-BuildTimeline {
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
        $BuildId
    )

    $uri = "https://dev.azure.com/$Organization/$Project/_apis/build/builds/$BuildId/Timeline?api-version=5.1"

    $json = Invoke-WebRequestAuthorized -Uri $uri -PersonalAccessToken $PersonalAccessToken

    $result = $json | ConvertFrom-Json

    return $result
}