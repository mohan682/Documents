#Set-ExecutionPolicy Unrestricted

Set-ExecutionPolicy RemoteSigned

$defaultForeColor=$HOST.UI.RawUI.ForegroundColor
$defaultBackGroundColor=$HOST.UI.RawUI.BackgroundColor

Write-Host "PDI UAT Deployment Process Started $lineBreak" -foregroundcolor "DarkRed" -backgroundcolor "white"

#-----------------------------------------------------------------------------------------------------------------

Function inputFromUser($p1,$p2) 
{ 
$HOST.UI.RawUI.BackgroundColor="Yellow"
$HOST.UI.RawUI.ForegroundColor="black"

do{
$temp= Read-Host -Prompt "`n Current $p2 is :  $p1 , do you want change (Y/N)?"
}while(-not (("y","yes","n","no")  -contains $temp))

$HOST.UI.RawUI.BackgroundColor=$defaultBackGroundColor
$HOST.UI.RawUI.ForegroundColor=$defaultForeColor

if ($temp -match "y" -or $temp -match "yes")
{
    $p1 = Read-Host -Prompt "`n Enter $p2" 
}

return $p1
} 

#-----------------------------------------------------------------------------------------------------------------

$releaseArea="N:\\UKDC2\\UKDC\\Releases\\Release Components\\PDI.net"

#$releaseArea= inputFromUser -p1 $releaseArea -p2 "release area"

#Write-Host $releaseAreaFolder


$releaseAreaFolder= gci $releaseArea | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1

$releaseAreaFolder=inputFromUser -p1 $releaseAreaFolder -p2 "release area folder name"


$targetServer="WIN000797"

#$targetServer=inputFromUser -p1 $targetServer -p2 "target server"


$targetIIsWebsite="PDI"

$targetIIsWebsite=inputFromUser -p1 $targetIIsWebsite -p2 "target IIS website"


$environment="UAT"

#$environment=inputFromUser -p1 $environment -p2 "environment"


$localCodebaseFolder="C:\Publish"

$localCodebaseFolder=inputFromUser -p1 $localCodebaseFolder -p2 "code base on local system"


#-----------------------------------------------------------------------------------------------------------------

Write-Host "`n Following folders have been created."

$temp=$releaseArea+"\\"+$releaseAreaFolder

New-Item -ItemType Directory -Force -Path $temp | out-null

Write-Host "`n "+$temp


$t1="$temp\\Deployment Items\\$environment\\" + (Get-Date -format "yyyyMMdd_HHmm")

New-Item -ItemType Directory -Force -Path $t1 | out-null

Write-Host "`n "+$t1


$t2="$temp\\Previous\\$environment\\" + (Get-Date -format "yyyyMMdd_HHmm")

New-Item -ItemType Directory -Force -Path $t2 | out-null

Write-Host "`n "+$t2


#-----------------------------------------------------------------------------------------------------------------
Write-Host "`n Backup started" -foregroundcolor "green" -backgroundcolor "black"

$from="\\$targetServer\\e$\\inetpub\pdi\\$targetIIsWebsite\\*"

Write-Host "`n From : $from"

$to=$t2

Copy-Item -Path $from -destination $to -recurse -Force

Write-Host "`n Backup Ended" -foregroundcolor "green" -backgroundcolor "black"
#-----------------------------------------------------------------------------------------------------------------

Write-Host "`n Copying Deployment Items from your local system to release area started." -foregroundcolor "green" -backgroundcolor "white"

$from="$localCodebaseFolder\\*"

Write-Host "`n From : $from"

$to=$t1

Copy-Item -Path $from -destination $to -recurse -Force

Write-Host "`n Copying Deployment Items from your local system to release area ended." -foregroundcolor "green" -backgroundcolor "white"
#-----------------------------------------------------------------------------------------------------------------

Write-Host "`n Copying Deployment Items from release area to server started." -foregroundcolor "green" -backgroundcolor "white"

$from="$t1\\*"

Write-Host "`n From : $from"

$to="\\$targetServer\\e$\\inetpub\\pdi\\$targetIIsWebsite\\"

Copy-Item -Path $from -destination $to -recurse -Force

Write-Host "`n Copying Deployment Items from release area to server ended." -foregroundcolor "green" -backgroundcolor "white"
#-----------------------------------------------------------------------------------------------------------------

Write-Host "`nRestart IIS Started `n" -foregroundcolor "green" -backgroundcolor "black"

$webConfigFile="$to\\*.config"

Add-Content $webConfigFile  "<!-- Test AAAAAAAAAA  -->"

(gc $webConfigFile).replace("<!-- Test AAAAAAAAAA  -->", "") | sc $webConfigFile

Write-Host "`nRestart IIS Ended `n" -foregroundcolor "green" -backgroundcolor "black"

#-----------------------------------------------------------------------------------------------------------------

$HOST.UI.RawUI.BackgroundColor="Yellow"
$HOST.UI.RawUI.ForegroundColor="black"

Read-Host -Prompt "`n Deployment is completed,Press Enter to exit" 

$HOST.UI.RawUI.BackgroundColor=$defaultBackGroundColor
$HOST.UI.RawUI.ForegroundColor=$defaultForeColor


 



 
