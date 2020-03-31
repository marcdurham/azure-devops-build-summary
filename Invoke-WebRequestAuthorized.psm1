function Invoke-WebRequestAuthorized {
    param (
        [Parameter(Mandatory=$true)]
        [String] 
        $PersonalAccessToken,
        [Parameter(Mandatory=$true)]
        [String] 
        $Uri
    )

    # Make web request with a basic authorization header
    try {
        $auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("ignored:$PersonalAccessToken"))
        $result = Invoke-WebRequest -Uri $Uri -Headers @{Authorization="Basic $auth"}
    } catch {
        throw "Authorization Error: Uri: $Uri Error: $_"
    }

    return $result.Content
}