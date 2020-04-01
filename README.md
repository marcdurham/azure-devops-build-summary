# azure-devops-build-summary
PowerShell script and modules for getting a summary of build results including the first error shown in the log

# Usage
Edit the Run-Script-Example.ps1 with your Azure DevOps project properties.

Get Build Ids for you builds from your browser's address bar, it should look like this:
````
https://dev.azure.com/my-org-name/My%20Project%20Name/_build/results?buildId=123456
````
You can see the Build Id *123456* at the end

Get a Personal Access Token (PAT) from Azure DevOps and set it to an environment variable
````
$Env:PAT = "PAST_YOUR_PAT_HERE"
````

Run script
