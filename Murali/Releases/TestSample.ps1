#Get-ChildItem "\\USPMVIFM013\\dfs\\DATA\\Informationtechnology\\UKDC\\Releases\\Release Components\\PDI.net" -Recurse -Directory -Filter "plan_manager" | Where-Object {$_.FullName -notlike *rawr_testfile1\stuck_test'}


$f1=gci "\\USPMVIFM013\\dfs\\DATA\\Informationtechnology\\UKDC\\Releases\\Release Components\\PDI.net" | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1

Write-Host $f1


Import-Module bitstransfer

$Username = "devadmin"
$Password = ConvertTo-SecureString "Chicken1" -AsPlainText -Force

$cred = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $Username, $Password

#$mycreds = New-Object System.Management.Automation.PSCredential($Username, $Password)

$Source = "C:\Temp\Sorce\myfile.txt"
$Dest   = "\\uktmvapp006\C$\temp\PDI\Test123.txt"

$serverNameOrIp = "uktmvapp006"


Restart-Computer -ComputerName $serverNameOrIp `
                 -Authentication default `
                 -Credential $cred

Start-BitsTransfer -Source $Dest  -Destination $Source 

#New-PSDrive -Name Y -PSProvider FileSystem -Root $Dest -Credential $mycreds -Persist
#Copy-Item -Path $Source -Destination "J:\myfile.txt"
Copy-Item -Path  "\\45.69.65.244\c$\temp\PDI\planManager\Logger.txt" -Credential $creds -Destination $Source



$VerbosePreference = 'Continue'
$source = 'C:\Temp\Sorce\myfile.txt'

$Username = "devadmin"
$Password = ConvertTo-SecureString "Chicken1" -AsPlainText -Force

$cred = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $Username, $Password

#$cred = Get-Credential devadmin
$server="uktmvapp006"

Write-Verbose "Working on $server"
if (test-connection $server -quiet)
{ 
Write-Verbose "-- Mapping drive" 
New-PSDrive -name $server -PsProvider FileSystem -root "\\$server\c$\temp\PDI\planManager\Logger.txt" -credential $cred 
Write-Verbose "-- Starting copy" 

#Copy-Item $source\* -Destination "$($server):" 
Copy-Item -Path  "\\$server\c$\temp\PDI\planManager\Logger.txt" -Destination $Source


Write-Verbose "-- Copy complete for $server; removing drive" 
Remove-PSDrive -Name $server 
} else { Write-Verbose "Couldn't verify connection to $server" 
}


