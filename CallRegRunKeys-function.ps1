Function callRegRunKeys {
if ($($args.Count) -eq 0){
$temp_file = Read-Host "one argument must be supplied please do so now"
}
Else 
{$temp_file = $args[0]
}
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
        reg query $regrunkey /s  >>$temp_file
           }
         
        catch { Write-Host "unable to retreive $regrunkey" -ForegroundColor Red
        }
        
                                           } 
                                
      
Write-host "if successful the file will be saved in $temp_file"

                                                
                                      
    
}
## testing
callRegRunKeys triage
