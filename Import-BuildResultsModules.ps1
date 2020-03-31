$moduleFolder = [System.IO.Path]::GetDirectoryName($PSCommandPath)

Import-Module $moduleFolder\Invoke-WebRequestAuthorized.psm1 -Force
Import-Module $moduleFolder\Get-BuildTimeline.psm1 -Force
Import-Module $moduleFolder\Get-BuildList.psm1 -Force
Import-Module $moduleFolder\Get-BuildResults.psm1 -Force
Import-Module $moduleFolder\Get-BuildResultsFormatted.psm1 -Force
