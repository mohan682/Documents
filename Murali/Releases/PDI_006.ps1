Set-ExecutionPolicy Unrestricted

$defaultForeColor=$HOST.UI.RawUI.ForegroundColor
$defaultBackGroundColor=$HOST.UI.RawUI.BackgroundColor

Write-Host "PDI UAT Deployment Process Started $lineBreak" -foregroundcolor "DarkRed" -backgroundcolor "white"

$parentFolder="\\USPMVIFM013\\dfs\\DATA\\Informationtechnology\\UKDC\\Releases\\Release Components\\PDI.net"

$deploymentFolderName="v2_2_0_16_PlanManager"

$tempFolder=""

Write-Host "`nParen Folder: "+$parentFolder


$HOST.UI.RawUI.BackgroundColor="Yellow"
$HOST.UI.RawUI.ForegroundColor="black"


$doYouChange= Read-Host -Prompt "`nCurrent Folder Is :  $deploymentFolderName , do you want change (Y/N)?"

if ($doYouChange -match "yes" -or $doYouChange -match "Yes" -or $doYouChange -match "YES" -or $doYouChange -match "Y" -or $doYouChange -match "y")
{
    $deploymentFolderName = Read-Host -Prompt "`nEnter Deployment Folder Name" 
}

$HOST.UI.RawUI.BackgroundColor=$defaultBackGroundColor
$HOST.UI.RawUI.ForegroundColor=$defaultForeColor


Write-Host "`n Following folders have been created."


$tempFolder= $parentFolder+"\\"+$deploymentFolderName

New-Item -ItemType Directory -Force -Path $tempFolder | out-null

Write-Host "`n"+$tempFolder



$tempFolder1=$tempFolder + "\\Deployment Items\\UAT\\" + (Get-Date -format "yyyyMMdd_hhmm24")

New-Item -ItemType Directory -Force -Path $tempFolder1 | out-null

Write-Host "`n"+$tempFolder1


$tempFolder2=$tempFolder + "\\Previous\\UAT\\" + (Get-Date -format "yyyyMMdd_hhmm")

New-Item -ItemType Directory -Force -Path $tempFolder2 | out-null

Write-Host "`n"+$tempFolder2

$HOST.UI.RawUI.BackgroundColor="Yellow"
$HOST.UI.RawUI.ForegroundColor="black"

$doYouWantToContinue= Read-Host -Prompt "`ndo you want to proceed with website backup (Y/N)?" 

if ($doYouWantToContinue -match "no" -or $doYouWantToContinue -match "No" -or $doYouWantToContinue -match "NO" -or $doYouWantToContinue -match "N" -or $doYouWantToContinue -match "n")
{
    break
}


$HOST.UI.RawUI.BackgroundColor=$defaultBackGroundColor
$HOST.UI.RawUI.ForegroundColor=$defaultForeColor

$ServerName="UKTMVAPP006"

Write-Host "`nTarget server $ServerName"

$DefaultWebSite="PDI_PlanManager"

$HOST.UI.RawUI.BackgroundColor="Yellow"
$HOST.UI.RawUI.ForegroundColor="black"

$doYouChange= Read-Host -Prompt "`nCurrent Deafault Website Is :  $DefaultWebSite , do you want change (Y/N)?" 

if ($doYouChange -match "yes" -or $doYouChange -match "Yes" -or $doYouChange -match "YES" -or $doYouChange -match "Y" -or $doYouChange -match "y")
{
    $DefaultWebSite = Read-Host -Prompt "`nEnter Website Name" 
}


$HOST.UI.RawUI.BackgroundColor=$defaultBackGroundColor
$HOST.UI.RawUI.ForegroundColor=$defaultForeColor

Write-Host "`nBackup started `n" -foregroundcolor "green" -backgroundcolor "white"

$from="\\$ServerName\\c$\\inetpub\UserServices\\$DefaultWebSite\\*"
Write-Host "`nFrom : $from"

$to=$tempFolder2
Write-Host "`nTo : $to"

Copy-Item -Path $from -destination $to -recurse -Force

Write-Host "`nBackup Ended `n" -foregroundcolor "green" -backgroundcolor "white"



$from="C:\Publish"

$HOST.UI.RawUI.BackgroundColor="Yellow"
$HOST.UI.RawUI.ForegroundColor="black"

$doYouWantToContinue= Read-Host -Prompt "Your deployment items are ready in $from,do you want to continue (Y/N)?" 

if ($doYouWantToContinue -match "no" -or $doYouWantToContinue -match "No" -or $doYouWantToContinue -match "NO" -or $doYouWantToContinue -match "N" -or $doYouWantToContinue -match "n")
{
    break
}

$HOST.UI.RawUI.BackgroundColor=$defaultBackGroundColor
$HOST.UI.RawUI.ForegroundColor=$defaultForeColor


Write-Host "`nCopying Deployment Items from your local system to release area started." -foregroundcolor "green" -backgroundcolor "white"

$from="$from\\*"

Write-Host "`nFrom : $from"

$to=$tempFolder1
Write-Host "`nTo : $to"

Copy-Item -Path $from -destination $to -recurse -Force

Write-Host "`nCopying Deployment Items from your local system to release area ended.`n" -foregroundcolor "green" -backgroundcolor "white"

$HOST.UI.RawUI.BackgroundColor="Yellow"
$HOST.UI.RawUI.ForegroundColor="black"

$doYouWantToContinue= Read-Host -Prompt "`ndo you want to continue to deploy items on server i.e \\$ServerName\\c$\\inetpub\UserServices\\$DefaultWebSite\\ (Y/N)?" 


if ($doYouWantToContinue -match "no" -or $doYouWantToContinue -match "No" -or $doYouWantToContinue -match "NO" -or $doYouWantToContinue -match "N" -or $doYouWantToContinue -match "n")
{
    break
}


$HOST.UI.RawUI.BackgroundColor=$defaultBackGroundColor
$HOST.UI.RawUI.ForegroundColor=$defaultForeColor

Write-Host "`nCopying Deployment Items from release area to server started. `n" -foregroundcolor "green" -backgroundcolor "white"

$from="$to\\*"

Write-Host "`nFrom : $from"

$to="\\$ServerName\\c$\\inetpub\UserServices\\$DefaultWebSite\\"
Write-Host "`nTo : $to"

Copy-Item -Path $from -destination $to -recurse -Force

Write-Host "`nCopying Deployment Items from release area to server ended. `n" -foregroundcolor "green" -backgroundcolor "white"



Write-Host "`nRestart IIS Started `n" -foregroundcolor "green" -backgroundcolor "white"

$webConfigFile="$to\\*.config"

Add-Content $webConfigFile  "<!-- Test AAAAAAAAAA  -->"

(gc $webConfigFile).replace("<!-- Test AAAAAAAAAA  -->", "") | sc $webConfigFile

Write-Host "`nRestart IIS Ended `n" -foregroundcolor "green" -backgroundcolor "white"

$HOST.UI.RawUI.BackgroundColor="Yellow"
$HOST.UI.RawUI.ForegroundColor="black"

Read-Host -Prompt "`nDeployment is completed,Press Enter to exit" 


 



 
