
##################################################################################################################################################
#function to create  a triage image. Based on cylr. note that you must have full admin to run this. also WinRM should be 
# turned on and configured for access by your account.This function assumes you have already copied the cylr.exe(https://github.com/orlikoski/CyLR)
# to the remote computer and placed it in C:\temp
## Author:Keneth Ray
## 
##################################################################################################################################################

Function get_TriageImage { 
# Declare Variables#
#########################################################
$computer_name = $args[0]
if ($computer_name -eq $null) {$computer_name=Read-Host -prompt 'computer name not provided on call, computername?'}
#prompt for username
$Username = Read-Host -prompt 'Provide user name here suggest using fully qualified name like usa\username'
#prompt for $secureString
$SecureString = Read-Host -prompt 'Provide Password for the account' -AsSecureString
#prompt for save Directory
#$temp_dir = Read-Host -prompt 'provide directory on 14day temp to save output'
#Save credentials as new variable.
$MySecureCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username,$SecureString
#########################################################
Invoke-Command -ComputerName $computer_name -ScriptBlock {cmd.exe /c "C:\temp\cylr.exe"} -Credential $MySecureCreds

Write-host "if successful the zip file will be in the C:\Users\<username>\Documents directory on the remote host"
}

#test the above function change the mycomputer to an actual computerName 
get_TriageImage <enter your computer name here. 
