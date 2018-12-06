#variables passed to this functon comment after testing
#####################################################
$myworkingDirectory = "<define your working directory here where the reg files are>"
$UserInvest = "<Define your user here> "
##################################################
#Local Variables 
#$mySAMRegWork location of downloaded SAM
#$mySYSTEMRegWork location of downloaded SYSTEM
#$mySECURITYRegWork location of Downloaded SECURITY
# 
$mySAMRegWork= $myworkingDirectory + "windows\system32\config\SAM"
$mySYSTEMRegWork= $myworkingDirectory + "windows\system32\config\SYSTEM"
$mySECURITYRegWork= $myworkingDirectory + "windows\system32\config\SECURITY"
$mySOFTWARERegWork= $myworkingDirectory + "windows\system32\config\SOFTWARE"
$myUSERRegWork = $myworkingDirectory+"Users\"+$UserInvest+"\NTUSER.DAT"

#create an Array to sift through that includes all the Registry files. IF one is missing just add it above and then below
$registryFiles = $mySAMRegWork,$mySYSTEMRegWork,$mySECURITYRegWork,$mySOFTWARERegWork,$myUSERRegWork

$myRegripperEXE = "rip.exe"
#location of the executabe *need this for the Change directory command to make the plugins work
$myRegRipperDir = "C:\Temp\RegRipper2.8-master\"
# combination of both the exe and directory used to execute the command.
$myRegRipperLocation = $myRegRipperDir+$myRegripperEXE

#function reg-ripping {
#define the registry files we are ripping with RegRipper
#$mySAMRegWork= $myworkingDirectory + "windows\system32\config\SAM"
#$mySYSTEMRegWork= $myworkingDirectory + "windows\system32\config\SYSTEM"
#$mySECURITYRegWork= $myworkingDirectory + "windows\system32\config\SECURITY"

#$myRegRipperLocation = "C:\Temp\RegRipper2.8-master\rip.exe"
#write-host 
#& cmd /c "$myRegRipperLocation -r $mySYSTEMRegWork -p regtime"

#}
#set a variable pointing to the SYSTEM Hive
#$mySYSTEMRegWork= $myworkingDirectory + "windows\system32\config\SYSTEM"
#set a variable pointing to where the regRipper command line executable is. 

#& cmd /c "$myRegRipperLocation -r $mySYSTEMRegWork -p del"
$getminRange = read-host "give me a start date in mm/dd/yyyy hh:mm:ss AM/PM format (ex 10/12/2018 12:30:00 PM)"
[double]$min = (Get-date "$getminRange").ToFileTime()
$getMaxRange = read-host "give me a end date in mm/dd/yyyy hh:mm:ss AM/PM format (ex 10/12/2018 12:30:00 PM)"
[double]$max = (Get-date "$getMaxRange").ToFileTime()
###############################################################
#looking for deleted files with the del plugin of regripper
###############################################################
cd $myRegRipperDir

Foreach ($registryFile in $registryFiles) {
$out = @()
Write-host "looking for deleted entries for $registryFile.`n You can safely ignore the error for CMD.exe : Launching del ...`n Its an expected handling issue with the PowerShell command line execution"
$out = & cmd /c "$myRegRipperLocation -r $registryFile -p del"

$DAtaSplit =[ordered]@{}
$out2 =$out |Select-String "Key:" 



foreach ($KeyString in $out2) {

$Datasplit.key, $Datasplit.LastWriteTime =$KeyString -split 'LW:'
#replace because the format is 'Fri Nov 16 18:48:52 2018 Z' we need to convert so we can run a comparison

$test= $DAtaSplit.LastWriteTime -replace "^...\s" -replace ".Z|Z" -replace "Jan.","01/" -replace "Feb.","02/" -replace "Mar.","03/" -replace "Apr.","04/" -replace "May.","05/" -replace "Jun.","06/" -replace "Jul.","07/" -replace "Aug.","08/" -replace "Sep.","09/" -replace "Oct.","10/" -replace "Nov.","11/"  -replace "Dec.", "12/" -replace "\d\d:\d\d:\d\d","/" -replace " "
$test = (get-date $test).toFileTime()
if (($test -ge $min) -and ($test -le $max)) {
$DAtaSplit.ActionTKN = "Delete,"
$KeyString
Write-host  $registryFile "," $DAtaSplit.ActionTKN $DAtaSplit.LastWriteTime "," $DAtaSplit.Key 
                    }
}

 }
