$moduleFolder = [System.IO.Path]::GetDirectoryName($PSCommandPath)

Import-Module $moduleFolder\Invoke-WebRequestAuthorized.psm1 -Force
Import-Module $moduleFolder\Get-BuildTimeline.psm1 -Force
Import-Module $moduleFolder\Get-BuildList.psm1 -Force
Import-Module $moduleFolder\Get-CombinedBuildResults.psm1 -Force
Import-Module $moduleFolder\Merge-CombinedBuildResults.psm1 -Force
