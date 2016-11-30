
$cred = Get-Credential -UserName "US\dadmmbesta" -Message "Please provide the password for the DADMMBESTA user."
Invoke-Command -ComputerName "WIN00811" -ScriptBlock {$env:USERNAME}
Invoke-Command -ComputerName "WIN00811" -ScriptBlock {$env:USERNAME} -Credential $cred