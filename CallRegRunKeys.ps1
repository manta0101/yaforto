#################################
#CallRegRunKeys function 
## to be used on local system to get all the runs. 
##################################
### POC designed by Kenneth Ray
##################################
# Intent: A version of this will be implemented in the YARFOTO script 
# to enumerate the remotelycollected Registry Hives.
## if you find it useful feel free to use it.
###################################
#define Function and name
Function callRegRunKeys {

#check the amount of arguments, if none were supplied just do nothign except notify caller
if ($($args.Count) -eq 0){
$temp_file = Read-Host "one argument must be supplied please do so now"
}
Else 
# Defines a variable to output to. 
{$temp_file = $args[0]
#define the array of run keys toi pas to the reg query. 

$regrunkeys="HKLM\Software\Microsoft\Windows\CurrentVersion\Run\",
"HKCU\Software\Microsoft\Windows\CurrentVersion\Run" ,
"HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" ,
"HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run",
"HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce\",
"HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnceEx",
"HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects",
"HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler",
"HKU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
       foreach($regrunkey in $regrunkeys) { 

        Write-host "checking " $regrunkey
        $ErrorActionPreference = "SilentlyContinue"
      #
        try {
#Used reg query instead of get-childitem, but you could also use the HKLM: PSDrive to do the same thing.
# but remember to accomodate that name in the Array of Keys as it will be different. 
        reg query $regrunkey /s  >>$temp_file
           }
         
        catch { Write-Host "unable to retreive $regrunkey" -ForegroundColor Red
        }
        
                                           } 
                                
      
Write-host "if successful the file will be saved in $temp_file"
}
                                                
                                      
    
}
## testing would create a file called Triage with all the keys that matched the query
#callRegRunKeys triage
