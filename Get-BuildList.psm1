function Get-BuildList {
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
        # Comma separated array of build definitions
        $Definitions,
        [Parameter(Mandatory=$true)]
        [String] 
        $MinTime
    )

    $uri = "https://dev.azure.com/$Organization/$Project/_apis/build/builds?api-version=5.1&definitions=$Definitions&minTime=$MinTime"

    $json = Invoke-WebRequestAuthorized -Uri $uri -PersonalAccessToken $PersonalAccessToken

    $result = $json | ConvertFrom-Json

    return $result
}