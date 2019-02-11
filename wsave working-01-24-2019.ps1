##########################################################
## Variable list 
##########################################################
# this section defines the variables that are being used throughout the program.
################################################################################
# Target and credential information 
#     $Mycomputer_name =  defines computer name used throughout the program and in many functions
#     $MySecureCreds =defines the user name and password to use for grabbing data and execution of scripts
#                     this ID should have the ability to read everything.  
#         -$Username = builds $mySecureCreds 
#         -$SecureString = password for username
#     $minUTC =variable used to check against reg ripper
#     $maxUTC =variable used to check against reg ripper
# 
####
# Cylr_pull function
#  This function uses the Cylr.exe to create a triage image on the remote machine in zip format. it also pulls
#  the image back locally from where it is running is uses the $MyComputer_name as the target and $MySecureCreds
# as credentials.
#      $MyClyr_exe = location of the CyLR.exe file 
#    
####
# Zip function
#      $My7Ziplocation = defines the location of the 7- zip executable does not have a prompt
#                        because it should be the same for your organization.
#           -(reuse) $computer_name to unzip the file zip file and set a working directory 
#      $MyexandDir = where the zip file is expanded to c:\temp is the default
#      $myTempDecision = used in the question of expand directory. 
#      $myworkingDirectory = "$MyexandDir\$computer_name" so we dont have to keep hardcoding the path of the 
#                             directory location.
####
# Firewall rules Function
# this function will grab the remote firewall rules it depends on native windows command netsh.exe being
# on the remote system.original code Retrieved from http://powershelldistrict.com/netsh-advfirewall-powershell
# and modified to fit remote collection and only show enabled rules. 
#      $RuleNae = original function could accept a rule name.Left for posterity
#      $Rules = this is an array to hold the command run on the remote computer to capture all the firewall
#               rules.
#      $return= an array to used to return data 
#      $HAsh = an ordered hash used to parse the returned informatio from $rules
#      $Rule = temporary variable for a foreach loop
#      $remote_FWrules = an array to hold the enabled rules. 
# 
####
# Investigation answers Section
#      $UserInvest = User being investigated. This will be used to load the registry files and do searches that are based
#                    on the user.Prior to this an enumeration of the expanded zip file c\users\ will be presented to the 
#                    investigator. *Note* due to this not being passed back correctly. It has been moved outside the  
# 
####
#
# --------------------------------------------------------------------------------
# end of Variable list
# --------------------------------------------------------------------------------

##################################################################################
##################################################################################
# MAIN
##################################################################################

#gather module
################################################################################
##### prompts for user name, machine name and times 
###############################################################################

# Declare Variables for script if they are not supplied at the command line then prompt user
#########################################################
$Mycomputer_name = $args[0]
$MySecureCreds = $args[1]

# Check to see if Computer name was supplied

# if it wasn't then prompt for it 
if ($Mycomputer_name -eq $null) {
$Mycomputer_name=Read-Host -prompt 'computer name not provided on call, computername?'
}
#check to see if secureCreds were passed.
# if not then prompt and set them
if ($MySecureCreds -eq $null) {

#prompt user for a fully qualified user name
$Username = Read-Host -prompt 'Provide user name here suggest using fully qualified name like usa\username'

#prompt the user for the password while also still keeping it secret
#and store it as a securestring. 
$SecureString = Read-Host -prompt 'Provide Password for the account' -AsSecureString

#convert the string into the MySecureCreds variable.
$MySecureCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username,$SecureString
}

################################################################
### get Time frame 
#################################################################

##get time and date and convert to UTC for functions  need to be 
## defined before the functions are called. 
###############################################################
##get time and date and convert to UTC for functions 
$getRange =""
#$getRange =Read-host "11/12/2018 07:20:00 AM"
$getRange= Get-Date $getRange
$chosenTImeZone =""
$targetUTC =""
function timezonetarget{#this is a list of timezones available to the FindtimezonebyID. retreived from 
#https://stackoverflow.com/questions/7908343/list-of-timezone-ids-for-use-with-findtimezonebyid-in-c
# retreived 12-5-18 2018
#formated by me to include in a script so i can convert the target timezone to UTC.  the user can choose  a number from the 97 available. 
Clear
#first Line
Write-host "what is the target timezone? Choose a number."
Write-host "---------------------------------------------"
write-host "1)" -ForegroundColor Red -NoNewline;  Write-host "Dateline Standard Time" -NoNewline;
Write-host " 2)" -ForegroundColor Red -NoNewline; Write-host "UTC-11" -NoNewline ;
write-host " 3)" -ForegroundColor Red -NoNewline; Write-host "Samoa Standard Time"-NoNewline; 
Write-host " 4)" -ForegroundColor Red -NoNewline; Write-Host "Hawaiian Standard Time" -NoNewline
Write-host " 5)" -ForegroundColor Red -NoNewline; Write-Host "Alaskan Standard Time" -NoNewline
write-host " 6)" -ForegroundColor Red -NoNewline; Write-host "Pacific Standard Time (Mexico) "
#2nd line
Write-host " 7)" -ForegroundColor Red -NoNewline; Write-Host "Pacific Standard Time"-NoNewline;
Write-Host " 8)" -ForegroundColor Red -NoNewline; Write-Host "US Mountain Standard Time "-NoNewline;  
Write-Host " 9)" -ForegroundColor Red -NoNewline; Write-Host "Mountain Standard Time (Mexico) " -NoNewline;
Write-Host " 10)"-ForegroundColor Red -NoNewline; Write-Host "Mountain Standard Time "-NoNewline;
Write-Host " 11)"-ForegroundColor Red -NoNewline; Write-Host "Central America Standard Time "
#3rd Line 
Write-Host " 12)"-ForegroundColor Red -NoNewline;Write-Host "Central Standard Time "-NoNewline;
Write-Host " 13)"-ForegroundColor Red -NoNewline;Write-Host "Central Standard Time (Mexico) "-NoNewline;
Write-Host " 14)"-ForegroundColor Red -NoNewline;Write-Host "Canada Central Standard Time "-NoNewline;
Write-Host " 15)"-ForegroundColor Red -NoNewline;Write-Host "SA Pacific Standard Time "-NoNewline;
Write-Host " 16)"-ForegroundColor Red -NoNewline;Write-Host "Eastern Standard Time"

#4th line
Write-Host " 17)"-ForegroundColor Red -NoNewline;Write-Host "US Eastern Standard Time"-NoNewline;
Write-Host " 18)"-ForegroundColor Red -NoNewline;Write-Host "Venezuela Standard Time"-NoNewline;  
Write-Host " 19)"-ForegroundColor Red -NoNewline;Write-Host "Paraguay Standard Time"-NoNewline;
Write-Host " 20)"-ForegroundColor Red -NoNewline;Write-Host "Atlantic Standard Time"-NoNewline;
Write-Host " 21)"-ForegroundColor Red -NoNewline;Write-Host "Central Brazilian Standard Time"
#5th line
Write-Host " 22)"-ForegroundColor Red -NoNewline;Write-Host "SA Western Standard Time "-NoNewline;
Write-Host " 23)"-ForegroundColor Red -NoNewline;Write-Host "Pacific SA Standard Time "-NoNewline;
Write-Host " 24)"-ForegroundColor Red -NoNewline;Write-Host "Newfoundland Standard Time "-NoNewline;
Write-Host " 25)"-ForegroundColor Red -NoNewline;Write-Host "E. South America Standard Time "-NoNewline;
Write-Host " 26)"-ForegroundColor Red -NoNewline;Write-Host "Argentina Standard Time"
#6th line
Write-Host " 27)"-ForegroundColor Red -NoNewline;Write-Host "SA Eastern Standard Time "-NoNewline;
Write-Host " 28)"-ForegroundColor Red -NoNewline;Write-Host "Greenland Standard Time "-NoNewline;
Write-Host " 29)"-ForegroundColor Red -NoNewline;Write-Host "Montevideo Standard Time "-NoNewline;
Write-Host " 30)"-ForegroundColor Red -NoNewline;Write-Host "UTC-02  "-NoNewline;
Write-Host " 31)"-ForegroundColor Red -NoNewline;Write-Host "Mid-Atlantic Standard Time "-NoNewline; 
Write-Host " 32)"-ForegroundColor Red -NoNewline;Write-Host "Azores Standard Time"


#seventh line
Write-Host " 33)"-ForegroundColor Red -NoNewline;Write-Host "Cape Verde Standard Time "-NoNewline;
Write-Host " 34)"-ForegroundColor Red -NoNewline;Write-Host "Morocco Standard Time "-NoNewline;
Write-Host " 35)"-ForegroundColor Red -NoNewline;Write-Host "UTC  "-NoNewline;
Write-Host " 36)"-ForegroundColor Red -NoNewline;Write-Host "GMT Standard Time "-NoNewline;
Write-Host " 37)"-ForegroundColor Red -NoNewline;Write-Host "Greenwich Standard Time "-NoNewline;
Write-Host " 38)"-ForegroundColor Red -NoNewline;Write-Host "W. Europe Standard Time"

#8th line
Write-Host " 39)"-ForegroundColor Red -NoNewline;Write-Host "Central Europe Standard Time "-NoNewline;
Write-Host " 40)"-ForegroundColor Red -NoNewline;Write-Host "Romance Standard Time "-NoNewline;
Write-Host " 41)"-ForegroundColor Red -NoNewline;Write-Host "Central European Standard Time "-NoNewline;
Write-Host " 42)"-ForegroundColor Red -NoNewline;Write-Host "W. Central Africa Standard Time  "-NoNewline;
Write-Host " 43)"-ForegroundColor Red -NoNewline;Write-Host "Namibia Standard Time"

#9th line 
Write-Host " 44)"-ForegroundColor Red -NoNewline;Write-Host "Jordan Standard Time  "-NoNewline;
Write-Host " 45)"-ForegroundColor Red -NoNewline;Write-Host "GTB Standard Time  "-NoNewline;
Write-Host " 46)"-ForegroundColor Red -NoNewline;Write-Host "Middle East Standard Time  "-NoNewline;
Write-Host " 47)"-ForegroundColor Red -NoNewline;Write-Host "Egypt Standard Time  "-NoNewline;
Write-Host " 48)"-ForegroundColor Red -NoNewline;Write-Host "Syria Standard Time  "-NoNewline;
Write-Host " 49)"-ForegroundColor Red -NoNewline;Write-Host "South Africa Standard Time "

#10th line
Write-Host " 50)"-ForegroundColor Red -NoNewline;Write-Host "FLE Standard Time  "-NoNewline;
Write-Host " 51)"-ForegroundColor Red -NoNewline;Write-Host "Israel Standard Time "-NoNewline;
Write-Host " 52)"-ForegroundColor Red -NoNewline;Write-Host "E. Europe Standard Time "-NoNewline;
Write-Host " 53)"-ForegroundColor Red -NoNewline;Write-Host "Arabic Standard Time "-NoNewline;
Write-Host " 54)"-ForegroundColor Red -NoNewline;Write-Host "Arab Standard Time "-NoNewline;
Write-Host " 55)"-ForegroundColor Red -NoNewline;Write-Host "Russian Standard Time"

#12th
Write-Host " 56)"-ForegroundColor Red -NoNewline;Write-Host "E. Africa Standard Time "-NoNewline;
Write-Host " 57)"-ForegroundColor Red -NoNewline;Write-Host "Iran Standard Time "-NoNewline;
Write-Host " 58)"-ForegroundColor Red -NoNewline;Write-Host "Arabian Standard Time "-NoNewline;
Write-Host " 59)"-ForegroundColor Red -NoNewline;Write-Host "Azerbaijan Standard Time "-NoNewline;
Write-Host " 60)"-ForegroundColor Red -NoNewline;Write-Host "Mauritius Standard Time "-NoNewline;
Write-Host " 61)"-ForegroundColor Red -NoNewline;Write-Host "Georgian Standard Time"

#13th
Write-Host " 62)"-ForegroundColor Red -NoNewline;Write-Host "Caucasus Standard Time "-NoNewline;
Write-Host " 63)"-ForegroundColor Red -NoNewline;Write-Host "Afghanistan Standard Time "-NoNewline;
Write-Host " 64)"-ForegroundColor Red -NoNewline;Write-Host "Ekaterinburg Standard Time "-NoNewline;
Write-Host " 65)"-ForegroundColor Red -NoNewline;Write-Host "Pakistan Standard Time "-NoNewline;
Write-Host " 66)"-ForegroundColor Red -NoNewline;Write-Host "West Asia Standard Time"-NoNewline; 
Write-Host " 67)"-ForegroundColor Red -NoNewline;Write-Host "India Standard Time"

#14th
Write-Host " 68)"-ForegroundColor Red -NoNewline;Write-Host "Sri Lanka Standard Time "-NoNewline;
Write-Host " 69)"-ForegroundColor Red -NoNewline;Write-Host "Nepal Standard Time "-NoNewline;
Write-Host " 70)"-ForegroundColor Red -NoNewline;Write-Host "Central Asia Standard Time "-NoNewline;
Write-Host " 71)"-ForegroundColor Red -NoNewline;Write-Host "Bangladesh Standard Time "-NoNewline;
Write-Host " 72)"-ForegroundColor Red -NoNewline;Write-Host "N. Central Asia Standard Time "-NoNewline;
Write-Host " 73)"-ForegroundColor Red -NoNewline;Write-Host "Myanmar Standard Time"

#15th
Write-Host " 74)"-ForegroundColor Red -NoNewline;Write-Host "SE Asia Standard Time "-NoNewline;
Write-Host " 75)"-ForegroundColor Red -NoNewline;Write-Host "North Asia Standard Time "-NoNewline;
Write-Host " 76)"-ForegroundColor Red -NoNewline;Write-Host "China Standard Time "-NoNewline;
Write-Host " 77)"-ForegroundColor Red -NoNewline;Write-Host "North Asia East Standard Time "-NoNewline;
Write-Host " 78)"-ForegroundColor Red -NoNewline;Write-Host "Singapore Standard Time "-NoNewline;
Write-Host " 79)"-ForegroundColor Red -NoNewline;Write-Host "W. Australia Standard Time"

#16th
Write-Host " 80)"-ForegroundColor Red -NoNewline;Write-Host "Taipei Standard Time "-NoNewline;
Write-Host " 81)"-ForegroundColor Red -NoNewline;Write-Host "Ulaanbaatar Standard Time "-NoNewline;
Write-Host " 82)"-ForegroundColor Red -NoNewline;Write-Host "Tokyo Standard Time "-NoNewline;
Write-Host " 83)"-ForegroundColor Red -NoNewline;Write-Host "Korea Standard Time "-NoNewline;
Write-Host " 84)"-ForegroundColor Red -NoNewline;Write-Host "Yakutsk Standard Time "-NoNewline;
Write-Host " 85)"-ForegroundColor Red -NoNewline;Write-Host "Cen. Australia Standard Time"

#17th
Write-Host " 86)"-ForegroundColor Red -NoNewline;Write-Host "AUS Central Standard Time "-NoNewline;
Write-Host " 87)"-ForegroundColor Red -NoNewline;Write-Host "E. Australia Standard Time "-NoNewline;
Write-Host " 88)"-ForegroundColor Red -NoNewline;Write-Host "AUS Eastern Standard Time "-NoNewline;
Write-Host " 89)"-ForegroundColor Red -NoNewline;Write-Host "West Pacific Standard Time "-NoNewline;
Write-Host " 90)"-ForegroundColor Red -NoNewline;Write-Host "Tasmania Standard Time"

#18th
Write-Host " 91)"-ForegroundColor Red -NoNewline;Write-Host "Vladivostok Standard Time "-NoNewline;
Write-Host " 92)"-ForegroundColor Red -NoNewline;Write-Host "Central Pacific Standard Time"-NoNewline; 
Write-Host " 93)"-ForegroundColor Red -NoNewline;Write-Host "New Zealand Standard Time "-NoNewline;
Write-Host " 94)"-ForegroundColor Red -NoNewline;Write-Host "UTC+12 95)Fiji Standard Time "-NoNewline;
Write-Host " 96)"-ForegroundColor Red -NoNewline;Write-Host "Kamchatka Standard Time "-NoNewline;
Write-Host " 97)"-ForegroundColor Red -NoNewline;Write-Host "Tonga Standard Time"
$timeZoneChoice =Read-host "pick your number"

$chosenTImeZone = Switch($timeZoneChoice){ 
1 {"Dateline Standard Time";break }
2 {"UTC-11";break }
3 {"Samoa Standard Time";break }
4 {"Hawaiian Standard Time";break }   
5 {"Alaskan Standard Time";break }   
6 {"Pacific Standard Time (Mexico)";break }
7 {"Pacific Standard Time";break }   
8 {"US Mountain Standard Time";break }  
9 {"Mountain Standard Time (Mexico)";break }  
10 {"Mountain Standard Time";break }   
11 {"Central America Standard Time";break }
12 {"Central Standard Time";break }  
13 {"Central Standard Time (Mexico)";break }
14 {"Canada Central Standard Time";break } 
15 {"SA Pacific Standard Time";break } 
16 {"Eastern Standard Time";break }
17 {"US Eastern Standard Time";break } 
18 {"Venezuela Standard Time";break }   
19 {"Paraguay Standard Time";break }  
20 {"Atlantic Standard Time";break }  
21 {"Central Brazilian Standard Time";break }
22 {"SA Western Standard Time";break } 
23 {"Pacific SA Standard Time";break } 
24 {"Newfoundland Standard Time";break} 
25 {"E. South America Standard Time";break } 
26 {"Argentina Standard Time";break }
27 {"SA Eastern Standard Time";break } 
28 {"Greenland Standard Time";break } 
29 {"Montevideo Standard Time";break } 
30 {"UTC-02";break }  
31 {"Mid-Atlantic Standard Time";break }  
32 {"Azores Standard Time";break }
33 {"Cape Verde Standard Time";break } 
34 {"Morocco Standard Time";break } 
35 {"UTC";break }  
36 {"GMT Standard Time";break } 
37 {"Greenwich Standard Time";break} 
38 {"W. Europe Standard Time";break}
39 {"Central Europe Standard Time";break} 
40 {"Romance Standard Time";break } 
41 {"Central European Standard Time";break} 
42 {"W. Central Africa Standard Time"; break}  
43 {"Namibia Standard Time";break } 
44 {"Jordan Standard Time";break } 
45 {"GTB Standard Time";break } 
46 {"Middle East Standard Time";break } 
47 {"Egypt Standard Time";break } 
48 {"Syria Standard Time";break } 
49 {"South Africa Standard Time";break }
50 {"FLE Standard Time";break }  
51 {"Israel Standard Time";break } 
52 {"E. Europe Standard Time";break } 
53 {"Arabic Standard Time";break } 
54 {"Arab Standard Time";break } 
55 {"Russian Standard Time";break }
56 {"E. Africa Standard Time";break }
57 {"Iran Standard Time";break } 
58 {"Arabian Standard Time";break } 
59 {"Azerbaijan Standard Time";break } 
60 {"Mauritius Standard Time";break } 
61 {"Georgian Standard Time";break }
62 {"Caucasus Standard Time";break } 
63 {"Afghanistan Standard Time";break } 
64 {"Ekaterinburg Standard Time";break } 
65 {"Pakistan Standard Time ";break }
66 {"West Asia Standard Time";break } 
67 {"India Standard Time";break } 
68 {"Sri Lanka Standard Time";break } 
69 {"Nepal Standard Time";break }  
70 {"Central Asia Standard Time";break }  
71 {"Bangladesh Standard Time";break }  
72 {"N. Central Asia Standard Time";break }  
73 {"Myanmar Standard Time";break } 
74 {"SE Asia Standard Time";break }  
75 {"North Asia Standard Time";break }  
76 {"China Standard Time";break }  
77 {"North Asia East Standard Time";break }  
78 {"Singapore Standard Time";break }  
79 {"W. Australia Standard Time";break } 
80 {"Taipei Standard Time";break } 
81 {"Ulaanbaatar Standard Time";break }  
82 {"Tokyo Standard Time";break }  
83 {"Korea Standard Time";break }  
84 {"Yakutsk Standard Time";break }  
85 {"Cen. Australia Standard Time";break } 
86 {"AUS Central Standard Time";break }  
87 {"E. Australia Standard Time";break } 
88 {"AUS Eastern Standard Time";break }  
89 {"West Pacific Standard Time";break }  
90 {"Tasmania Standard Time";break } 
91 {"Vladivostok Standard Time";break }  
92 {"Central Pacific Standard Time";break }  
93 {"New Zealand Standard Time";break }  
94 {"UTC+12";break }  
95 {"Fiji Standard Time ";break } 
96 {"Kamchatka Standard Time";break }  
97 {"Tonga Standard Time";break } 
}
return $chosenTImeZone

}
#for some reason the return variable is just not working as expected.
# to compensate i am creating a temporary variable. 

#set up the timezone choice to be used in the Time conversion. 
$chosenTImeZone += timezonetarget
function time-convertUTC{
Param(
 
        [parameter(position=1)]
        $targetTImeZone,
        [parameter(position=0)]
        $getRange
 
        )

$time = get-date -date $getRange
###testing variables###
#Write-host "original"
#$time
#Pause
#####################
$oFromTimeZone= $targetTImeZone
$fromTimeZone = $oFromTimeZone
$oToTimeZone = "UTC"
$toTimeZone = $oToTimeZone
#$time.ToUniversalTime($oFromTimeZone)
#$utc = [System.TimeZoneInfo]::ConvertTimeToUtc($time, $oFromTimeZone)
#“2014-07-29T03:15:00”
$oFromTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($fromTimeZone)
  $oToTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($toTimeZone)
  $utc = [System.TimeZoneInfo]::ConvertTimeToUtc($time, $oFromTimeZone)
  $UTCTime = [System.TimeZoneInfo]::ConvertTime($utc, $oToTimeZone)
 #$oFromTimeZone
 #$oToTimeZone
 #pause
 #$utc
 #pause
 $UTCTime
 }

 #set a temporary target global Variable for the UTC conversion. 
 # note that the function needs a += to work correctly 
 $targetUTC =""
 #read from host a target start date and time
 $getminRange = read-host "Specify a start date in mm/dd/yyyy hh:mm:ss AM/PM format (ex 10/12/2018 12:30:00 PM)"
 #convert it to something we can use to do date math
 [double]$min = (Get-date "$getminRange").ToFileTime()
 #we need to do a seperate conversion for UTC. Note that it was defined in the $chosenTimeZone Variable. 
 $tempMinUTC = (Get-Date "$getminRange")
 ##reset the temp variable. 
 $targetUTC = ""
 $targetUTC += (time-convertUTC $tempMinUTC $chosenTImeZone)
 $minUTC = (Get-date "$targetUTC").ToFileTime()

 $getMaxRange = read-host "Specify a end date in mm/dd/yyyy hh:mm:ss AM/PM format (ex 10/12/2018 12:30:00 PM)"
 [double]$max = (Get-date "$getMaxRange").ToFileTime()
 $targetUTC =""
 $tempMaxUTC = (Get-Date "$getMaxRange")
 $targetUTC += (time-convertUTC $tempMaxUTC $chosenTImeZone)
 $maxUTC = (Get-date "$targetUTC").ToFileTime()
 
 $minUTC
 $maxUTC
 ##################################################End Functon
function rip_reg {
#Local Variables 
#      $mySAMRegWork= Uses $myworkingDirectory + "windows\system32\config\SAM" to access the SAM file
#      $mySYSTEMRegWork   = Uses $myworkingDirectory + "windows\system32\config\SYSTEM" to access the SYSTEM HIVE
#      $mySECURITYRegWork = Uses$myworkingDirectory + "windows\system32\config\SECURITY" to access the SECURITY hive 
#      $mySOFTWARERegWork = Uses$myworkingDirectory + "windows\system32\config\SOFTWARE" to access the SOFTWARE hive 
#      $myUSERRegWork     = Uses $myworkingDirectory+"Users\"+ $UserInvest+"\NTUSER.DAT" 
#      $registryFiles    = array for the above so we can iterate through each collectively
#      $myRegRipperLocation = location of the Regripper command rip.exe
#      $registryFile = Temporary variable for the loop of 
#      $out = array to hold the reg ripper data 
#      $dataSplit = ordered hash to hold the results of both keys and 
##########
$mySAMRegWork= $myworkingDirectory + "windows\system32\config\SAM"
$mySYSTEMRegWork= $myworkingDirectory + "windows\system32\config\SYSTEM"
$mySECURITYRegWork= $myworkingDirectory + "windows\system32\config\SECURITY"
$mySOFTWARERegWork= $myworkingDirectory + "windows\system32\config\SOFTWARE"
$myUSERRegWork = $myworkingDirectory+"Users\"+$UserInvest+"\NTUSER.DAT"

#create an Array to sift through that includes all the Registry files. IF one is missing just add it above and then below
$registryFiles = $mySAMRegWork,$mySYSTEMRegWork,$mySECURITYRegWork,$mySOFTWARERegWork,$myUSERRegWork
#name of executable 
$myRegripperEXE = "rip.exe"
#location of the executabe *need this for the Change directory command to make the plugins work
$myRegRipperDir = "C:\Temp\RegRipper2.8-master\"
# combination of both the exe and directory used to execute the command.
$myRegRipperLocation = $myRegRipperDir+$myRegripperEXE

$minUTC
$maxUTC
write-host " should be two numbers above this line. if not break out"
Pause
#
$returnhash = New-Object -TypeNamePSobject
$returnObje
###############################################################
#looking for entries with the regtime plugin of regripper
###############################################################
# for the plugins to work you need to be in the directory where the Regripper rip.exe is located.
#################################################################################################
& cd $myRegRipperDir 


###########################################
### check for timeframe on all files
############################################
Foreach ($registryFile in $registryFiles) {
$out = @()
Write-host "looking for matching timeframe entries for $registryFile.`n You can safely ignore the error for CMD.exe : Launching regtime plugin ...`n Its an expected handling issue with the PowerShell command line execution"
$out = & cmd /c "$myRegRipperLocation -r $registryFile -p regtime"

$DAtaSplit =[ordered]@{}
$out2 =$out #|Select-String "Key:" 



foreach ($KeyString in $out2) {
#match first part of string (should be write time)
if ($KeyString -match '^\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+'){ 
$Datasplit.LastWriteTime =$Matches[0]
}
#Match second part of the string Should be the Key
#
if ($keystring -match '\s{2,}\S+'){
$DAtaSplit.Key = $Matches[0]
}
#$Datasplit.LastWriteTime, $Datasplit.key  =$KeyString -split '\s{3,}'
#replace because the format is 'Fri Nov 16 18:48:52 2018 Z' we need to convert so we can run a comparison
#$DAtaSplit.LastWriteTime
#because of the output of the regripper command we need to convert it to the corrected date. 
$test= $DAtaSplit.LastWriteTime -replace "^...\s" -replace "Z" -replace "Jan.","01/" -replace "Feb.","02/" -replace "Mar.","03/" -replace "Apr.","04/" -replace "May.","05/" -replace "Jun.","06/" -replace "Jul.","07/" -replace "Aug.","08/" -replace "Sep.","09/" -replace "Oct.","10/" -replace "Nov.","11/"  -replace "Dec.", "12/" -replace "\d\d:\d\d:\d\d","/" -replace " "
#$test
$test = (get-date $test).toFileTime()
#$test to see if it matches the Max and min UTC variables defined in the Investigation section

if (($test -ge $minUTC) -and ($test -le $maxUTC)) {
$DAtaSplit.ActionTKN = "Change,"
$DAtaSplit.Key = $DAtaSplit.Key -replace "\s+"
Write-host $registryFile "," $DAtaSplit.ActionTKN $DAtaSplit.LastWriteTime","$DAtaSplit.Key
                    }
}

 }
 ###################################################################
 #check for deletions
 ###################################################################
 Foreach ($registryFile in $registryFiles) {
$out = @()
Write-host "looking for deleted entries for $registryFile.`n You can safely ignore the error for CMD.exe : Launching del ...`n Its an expected handling issue with the PowerShell command line execution"
$out = & cmd /c "$myRegRipperLocation -r $registryFile -p del"

$DAtaSplit =[ordered]@{}
$out2 =$out |Select-String "Key:" 



foreach ($KeyString in $out2) {
#splitting the string into the two separate parts. 
$Datasplit.key, $Datasplit.LastWriteTime =$KeyString -split 'LW:'
#replace because the format is 'Fri Nov 16 18:48:52 2018 Z' we need to convert so we can run a comparison

$test= $DAtaSplit.LastWriteTime -replace "^...\s" -replace ".Z|Z" -replace "Jan.","01/" -replace "Feb.","02/" -replace "Mar.","03/" -replace "Apr.","04/" -replace "May.","05/" -replace "Jun.","06/" -replace "Jul.","07/" -replace "Aug.","08/" -replace "Sep.","09/" -replace "Oct.","10/" -replace "Nov.","11/"  -replace "Dec.", "12/" -replace "\d\d:\d\d:\d\d","/" -replace " "
$test = (get-date $test).toFileTime()
if (($test -ge $minUTC) -and ($test -le $maxUTC)) {
$DAtaSplit.ActionTKN = "Delete,"
$KeyString
Write-host  $registryFile "," $DAtaSplit.ActionTKN $DAtaSplit.LastWriteTime "," $DAtaSplit.Key 
                    }
}

 }
 ### checking for deleted keys for the time frame
 ################################################

 cd ..
}
##################################################End Function

 pause
 ## end testing
 
###end of user investigation section

Function TRiageImage{

## triage image grab section
## define the functions for pulling the triage image
## 
Function cylr_pull {
#########################################################
## cylr_pull function uses the cylr.exe file defined inside the function as variable $myClyr_exe 
## create a drive so we can copy the information, Note you must have the ability to map to a Admin share.
#  uses the Mysecurecreds as the credentials
## variables:
#            uses Mycomputer_name previously defined
#            $myClyr_exe =location of Cylr executable 
#            Uses $MySecurecreds as credentials 
##########################################################
$myClyr_exe = "c:\temp\CyLR.exe"
New-PSDrive -Name cylr -PSProvider FileSystem -Root \\$Mycomputer_name\c$  -Credential $MySecureCreds
#changes to the newly created psdrive. not really necessary but will generate an error if it cant be done. 
Write-host "checking drive by Switching to it"
cd cylr:
Write-host "copying $myClyr_exe to the remote c:\temp directory"
Copy-Item -path $myClyr_exe cylr:\temp
Write-host "Invoking the cylr.exe executable using the credentials provided" 
Invoke-Command -ComputerName $Mycomputer_name -ScriptBlock {cmd.exe /C "C:\temp\cylr.exe -od c:\temp" } -Credential $MySecureCreds
#notify the end user what happened. 
Write-host "if successful the $Mycomputer_name.zip file will be in the temp directory on the remote host`n we will move it to the local c:\temp"
Copy-Item cylr:\temp\$Mycomputer_name.zip C:\temp
Write-host "cleaning up the remote host by removing the data and the executable"
Remove-Item cylr:\temp\$Mycomputer_name.zip
Remove-Item cylr:\Temp\cylr.exe
#change back to the local C drive. because we checked to see if we could CD to the PSdrive we need to go back 
# to C: so we can remove the drive. 
c:
# now remove the Drive we created
Remove-PSDrive cylr
#--------------------------------------------------------
# End of Cylar_pull function
#--------------------------------------------------------

}

# -------------------- end of function definitions  for section---------------

#execute our function needed to pull an image
cylr_pull
}
##################################################End Function
Function UnZipIT {
#########################################################
# zip section
#########################################################
# the only function is to unzip the file we just transferred 
# using 7-zip is the easiest.
#declare variable
# where is the current version of 7 zip (using the default install location)
#defatult is $My7Ziplocation ="C:\Program Files\7-Zip\7z.exe"
$My7Ziplocation ="C:\Program Files\7-Zip\7z.exe"
# ask the user if we can expand the Zip file locally at c:\temp
$MyexandDir = "c:\temp"

 $myTempDecision = read-host "Ok to expand the zip in local c:\temp(y/n)?"
 $myTempDecision
if ($myTempDecision -ne "y" -and $myTempDecision -ne "n"){
 do 
 { Write-Host "you must answer y or n"
 $myTempDecision = Read-Host "y or n?" 
 if ($myTempDecision -eq 'y' -or $myTempDecision -eq 'n') { break}

 } while ($myTempDecision -ne 'y' -or $myTempDecision -ne 'n')
 }
 if ($myTempDecision -eq "y") {
 Write-host "using $MyexandDir"} else { $MyexandDir = read-host "supply the path"}
 #create a directory to drop everything while notifying the user.
 Write-Host "Creating the $Mycomputer_name directory under $MyexandDir"
 #create our working directory directory. 
 New-Item -ItemType directory -Path $MyexandDir\$Mycomputer_name
 #assign a new variable to be used later inside other scripts 
 $myworkingDirectory = "$MyexandDir\$Mycomputer_name"

 #run the 7zip command 'x' equals expand all the directories, -o is the output and the rest is self evident
 #& $My7Ziplocation X -y -o"$MyexandDir\$computer_name" C:\temp\$Mycomputer_name.zip
 & $My7Ziplocation X -y -o"$myworkingDirectory" C:\temp\$Mycomputer_name.zip
 #---------------------------------------------------------
 # end of zip section
 #---------------------------------------------------------
 return $myworkingDirectory
 }
##################################################End Function
Function FirewallRules{ 
 #############################################################################
 # firewall rules section
 #############################################################################
 # Retrieved from http://powershelldistrict.com/netsh-advfirewall-powershell/
 # 10/30/18
 # modified for use and commented by me to understand it. 
 # start of function
 # original function was Get-NetshFireWallrule. This one will use the invoke command with:  
 # Invoke-Command -ComputerName $Mycomputer_name -ScriptBlock {cmd.exe /C "C:\temp\cylr.exe -od c:\temp" } -Credential $MySecureCreds
 ###
 # first set the remote collection
 # create  a function that gets remote firewall rules. we are using the global credentials $mySecureCreds
 Function Get-remoteFireWallrule  {
    # accept a string Parameter called Rulename 
    Param(
        [String]$RuleName
    )
  #original code will accept a firewall rule name.or just give all
  ##if statement to show if a rule name was passed. If not(else), just give all
  ## if ($RuleName){
  ##      $Rules = netsh advfirewall firewall show rule name="$ruleName"
  ##  }else{
  ##      $Rules = netsh advfirewall firewall show rule name="all"
  ##  }

  # modified variable to remotely capture all the rules. we parse this later to return only enabled rules
  $Rules = Invoke-Command -ComputerName $Mycomputer_name -ScriptBlock {cmd.exe /C "netsh advfirewall firewall show rule name=`"all`"" } -Credential $MySecureCreds
       #set an Array called Return. 
    $return = @()
    #set a ordered Hash
     $HAsh = [Ordered]@{}
     #loop through the $rule Variable and match using Regex
        foreach ($Rule in $Rules){
            #if a specific rulename was not requested
            if ($Rule -match '^Rule Name:\s+(?<RuleName>.+$)'){
              $Hash.RuleName = $Matches.RuleName
            }Else{

              if ($Rule -notmatch "----------------------------------------------------------------------"){
                switch -Regex ($Rule){
                #look for rulename and map it to Rulename
                  '^Rule Name:\s+(?<RuleName>.*$)'{$Hash.RuleName = $MAtches.RuleName;Break}
                  '^Enabled:\s+(?<Enabled>.*$)'{$Hash.Enabled = $MAtches.Enabled;Break}
                  '^Direction:\s+(?<Direction>.*$)'{$Hash.Direction = $MAtches.Direction;Break}
                  '^Profiles:\s+(?<Profiles>.*$)'{$Hash.Profiles = $MAtches.Profiles;Break}
                  '^Grouping:\s+(?<Grouping>.*$)'{$Hash.Grouping = $MAtches.Grouping;Break}
                  '^LocalIP:\s+(?<LocalIP>.*$)'{$Hash.LocalIP = $MAtches.LocalIP;Break}
                  '^RemoteIP:\s+(?<RemoteIP>.*$)'{$Hash.RemoteIP = $MAtches.RemoteIP;Break}
                  '^Protocol:\s+(?<Protocol>.*$)'{$Hash.Protocol = $MAtches.Protocol;Break}
                  '^LocalPort:\s+(?<LocalPort>.*$)'{$Hash.LocalPort = $MAtches.LocalPort;Break}
                  '^RemotePort:\s+(?<RemotePort>.*$)'{$Hash.RemotePort = $MAtches.RemotePort;Break}
                  '^Edge traversal:\s+(?<Edge_traversal>.*$)'{$Hash.Edge_traversal = $MAtches.Edge_traversal;$obj = New-Object psobject -Property $Hash;$return += $obj;Break}
                  default {Break}
                }
                
                
              }
            }

        }
    # returns(uncomment the one you want.)
    #return only those items that are enabled Note:uncomment the select statement 
    #if you only want to grab rulename and Enabled status. 
    return $return|where-object{$_.Enabled -eq 'Yes'}#| select-object Rulename, Enabled 
   # the other option is to return everything regardless this was the original code
   #return $return
   }
   
   #set a new table to hold the enabled rules (calls the Get-remoteFireWallrule)
   $remote_FWrules = Get-remoteFireWallrule
  
   return $remote_FWrules
  
#-----------------------end of Firewall rules section-----------------------  
 }
##################################################End Function
Function MEMtriage{
#############################################################################
##memory grab section
#############################################################################
## first we will define the two types of memory aquisition programs as a 
#  function so the user can have a choice of either.
## Other options can be added as a function using the same format really
###
# function to use dumpit against the $mycomputer_name
#----------------------------------------------------------------------------
 Function runDumpit {  
##############################################################################
# Dumpit section
##############################################################################
New-PSDrive -Name Dumpit -PSProvider FileSystem -Root \\$Mycomputer_name\c$  -Credential $MySecureCreds
#changes to the newly created psdrive. not really necessary but will generate an error if it cant be done. 
Write-host "checking drive by Switching to it"
cd Dumpit:
Write-host "copying the Dumpit.exe from c:\temp to the remote c:\temp directory."
Copy-Item -path C:\temp\Dumpit.exe dumpit:\temp
#note: that on some systems dumpit.exe will generate an error about not being able to install. This is not a scripting 
#error of this script. 
#notify user what we are doing 
Write-host "Invoking the dumpit.exe executable using the credentials provided. This will take a while, be patient!" 
#invoke the command on the remote system
Invoke-Command -ComputerName $Mycomputer_name -ScriptBlock {cmd.exe /C "C:\temp\dumpit.exe /Q /O c:\temp\$Mycomputer_name.raw" } -Credential $MySecureCreds

#testing commands
#get-childitem dumpit:\temp
#Pause
#-----------
#notify the end user what happened. 
Write-host "if successful the .raw file will be in the temp directory on the remote host`n we will move it to the local c:\temp`n Depending on the size this also may take a while."
#dumpit creates a .raw with no name instead of the expected name because the $MyComputer_name is not a local Variable for the invoke command. 
#No matter, we will copy it to c:\temp\ with the computername. 
Copy-Item Dumpit:\temp\.raw C:\temp\$Mycomputer_name.raw
#tell the user our actions
Write-host "cleaning up the remote host by removing the data and the executable"
#remove the .raw file on the remote computer. 
Remove-Item Dumpit:\temp\.raw
#remove the dumpit executable

Remove-Item Dumpit:\Temp\dumpit.exe
#change back to the local C drive. because we checked to see if we could CD to the PSdrive we need to go back 
# to C: so we can remove the drive. 
c:
# now remove the Drive we created
Remove-PSDrive dumpit
#-----------------end of Dumpit section ------------------------------------#
}
#----------------------------------------------------------------------------
###
# function to use winpmem against the $mycomputer_name
#----------------------------------------------------------------------------
 Function runWinpmem {
############################################################################
#Start of Wpmem section (alternative to  Dumpit)
############################################################################
# you can either comment out this part of the script and use
# let user know what is happening '
Write-Host "creating the connection to copy winpmem to the remote"
#create a new PS drive for winpmem
New-PSDrive -Name winpmem -PSProvider FileSystem -Root \\$Mycomputer_name\c$  -Credential $MySecureCreds
#check to see if the drive worked by changing to it. 
# future-put a try here and capture the error codes 
cd winpmem:
#copy the winpmem executable to the temp drive. 
Copy-Item C:\temp\winpmem_1.6.2.exe winpmem:\temp\winpmem.exe
#tell the end user what we are doing. 
Write-Host "starting winpmem dump on remote machine $Mycomputer_name"
#execute the wpmem command remotely using the cmd.exe windows 
Invoke-Command -ComputerName $Mycomputer_name -ScriptBlock {cmd.exe /C "C:\temp\winpmem.exe $Mycomputer_name.raw" } -Credential $MySecureCreds
#tell the user we are moving the raw file locally
Write-Host "copying $Mycomputer_name.raw to local computer`n this may take a while"
#copy the item locally
Copy-Item winpmem:\temp\$Mycomputer_name.raw C:\Temp
#cleanup time 
write-host "doing some clean up"
#remove the winpmem file we created on the remote machine
Remove-Item winpmem:\temp\winpmem.exe
#because we are on the psdrive we created we need to get off it so we can delete it. 
c:
#remove the drive.. 
Remove-PSDrive winpmem

}
#----------------------------------------------------------------------------
# -------------------- end of function definitions  for section---------------

# ask the user which one they are using. Winpmem or dumpit. 
 $my_memorydumper = Read-Host "which memory dump program should we use dumpit(d) or winpmem(w)"
#enter a do.. while loop to prompt for the correct response.. when met we execute either runDumpit or runWinpmem
  do {
#check if d was suppied if so run dumpit
   if ($my_memorydumper -eq 'd') {
    #run the dumpit function. 
    runDumpit
    #without this break statement the process will go into an infinite loop
    break} 
#check if w was supplied if so run winpmem
    elseif ($my_memorydumper -eq 'w') {
     #run the Winpmem function
     runWinpmem
     #without this break statement the process will go into an infinite loop 
     break}
# otherwise keep asking for the correct response
   else {
   $my_memorydumper = Read-Host "you need to supply either w or d"
   }
   }
#the while test, if neither d nor w it should redo the same over and over. 
   while ($my_memorydumper -ne 'd' -or $my_memorydumper -ne 'w') 
#-----------------------end of memory grab section------------------------
}
##################################################End Function
Function Investigation {
##########################################################################
# user and time frame section
##########################################################################
# in this section we determine who we are investigating and the timeframe
# define the user we may want to look at using the $myworkingDirectory. This
# is where we unzipped the Cylr triage image.
###
#user section
 Write-host "here are the users as defined in the triage images"
#use the variable where we unzipped the triage image($myworkingDirectory) and read c\User selecting only
#the name and using format-wide to display
#note: $myworkingDirectory is set in unZip Section.  
 Get-ChildItem $myworkingDirectory\C\Users |format-wide -property Name
 $UserInvest = Read-Host "From the list, which user are we investigating?"
###
#timeframe section
 $getminRange = read-host "Specify a start date in mm/dd/yyyy hh:mm:ss AM/PM format (ex 10/12/2018 12:30:00 PM)"
 [double]$min = (Get-date "$getminRange").ToFileTime()

 $getMaxRange = read-host "Specify a end date in mm/dd/yyyy hh:mm:ss AM/PM format (ex 10/12/2018 12:30:00 PM)"
 [double]$max = (Get-date "$getMaxRange").ToFileTime()
#--------------------End of user and time section-------------------------
}
##################################################End Functon
Function rip_reg {
$ErrorActionPreference = "silentlycontinue"
#dependencies
#############
#function requires:
# -$userInvest, 
# -$myworkingDirectory, 
# -$minUTC, 
# -maxUTC 
# -myworkingDirectory
# 
# be defined
############
#function start
####
##declare variables to work with inside the function. 
$mySAMRegWork= $myworkingDirectory + "windows\system32\config\SAM"
$mySYSTEMRegWork= $myworkingDirectory + "windows\system32\config\SYSTEM"
$mySECURITYRegWork= $myworkingDirectory + "windows\system32\config\SECURITY"
$mySOFTWARERegWork= $myworkingDirectory + "windows\system32\config\SOFTWARE"
$myUSERRegWork = $myworkingDirectory+"Users\"+$UserInvest+"\NTUSER.DAT"

#create an Array to sift through that includes all the Registry files. IF one is missing just add it above and then below
$registryFiles = $mySAMRegWork,$mySYSTEMRegWork,$mySECURITYRegWork,$mySOFTWARERegWork,$myUSERRegWork
#name of executable 
$myRegripperEXE = "rip.exe"
#location of the executabe *need this for the Change directory command to make the plugins work
$myRegRipperDir = "C:\Temp\RegRipper2.8-master\"
# combination of both the exe and directory used to execute the command.
$myRegRipperLocation = $myRegRipperDir+$myRegripperEXE
###
cd $myRegRipperDir

Foreach ($registryFile in $registryFiles) 
{

##### new code
#create a hashtable to store the information
Write-host "running comparison on $registryFile"
$rip_out = & cmd /c $myRegRipperLocation -r $registryFile -p regtime

#$rip_out.output = & C:\Temp\RegRipper2.8-master\rip.exe -r "C:\Temp\USAMKBDP3BM72\c\windows\system32\config\SYSTEM" -p regtime

$out2 = @{}
    foreach ($test in $rip_out) {
#testing value
$test
#$test = "Tue Jul 14 04:45:41 2009Z       CMI-CreateHive{0297523D-E529-4E42-8BE7-E1AABC063C84}\Policy\PolRevision"

#from the testing value pull the Time. Because we are going to replace it with nothing in the out strig to parse the date.
$stringTime = [regex]::Match($test,'\d\d:\d\d:\d\d').captures.groups[0].value
#parse the outString removing unnecessary information and changing the three letter 
$out = $test -replace "^...\s" -replace "Z|Z" -replace "Jan.","01/" -replace "Feb.","02/" -replace "Mar.","03/" -replace "Apr.","04/" -replace "May.","05/" -replace "Jun.","06/" -replace "Jul.","07/" -replace "Aug.","08/" -replace "Sep.","09/" -replace "Oct.","10/" -replace "Nov.","11/"  -replace "Dec.", "12/" -replace "\d\d:\d\d:\d\d","/"  -replace "\s/\s","/" 
$out

# grab the date from the Test string
$TimeStringDate = [regex]::Match($out,'^.*?\s\.*?\s*\s').captures.groups[0].value
# because we are looking for date in MM/DD/YYYY,HH:MM:SS we convert both strings back to the right format. changing one or many spaces to a comma
$TimeconvertString = $TimeStringDate + $stringtime -replace "\s{1,20}","," -replace "/,","/"
#write-host "timeconvertstring"
$TimeconvertString
Pause
#we convert our newly formed string into a datetime and then into filetime to compare against our Max and min filetimes
# we use the get-date because it looks to work on the ones we care about.
$timeString2 = get-date("$TimeconvertString")
##testing variables 
$timeSTring2
pause
#this one worked on a string if we defined it in testing but doesn't work on the loop"

#$timeString2 = [datetime]::ParseExact($TimeconvertString ,"MM/dd/yyyy,hh:mm:ss",$null)
#convert the date string to filetime to compare with out range. 
$timeString2 = $timeString2.ToFileTime()
#
 #       $timeString2
  #      $minUTC
  #      $maxUTC
                
  #Pause
    #using a if-and statement we test to see if the time is between
        if (($timeString2 -ge $minUTC) -and ($timeString2 -le $maxUTC)){
            #testing variables 
            #Write-Host "out"
            $out
            ########
            # we parse the original test variable for the registry entry and add this 
            #to the regstring column of our hash table 
            $out2.regString += $test -replace '^.*?\s\.*?\s*\s'
            #we output the new time format for later use if needed. 
            $out2.date += $TimeconvertString
            #
            #$timeString2
            #$minUTC
            #$maxUTC
            #testing variables
            ###
            #write-host "testing varaible"
            #$test
            #Write-Host "out2"
            #$out2
            #Write-host "string-time"
            #$stringTime
            #Write-host "timestring2"
            #$TimeString2
            #Write-Host "TimeStringDate"
            #$TimeStringDate
            #write-host "TimeconvertString"
            #$TimeconvertString
            #pause

#########
 #end of if statement. 
            }
 #end of foreach function 
 }

 }
## end of test foreach function
return $out2
}
##################################################End Function
#UnZipIT
#$UserInvest= "cusumanov"

Function getFileDatesZip{
###Function to check for files written to the Triage Image that meet the time frame" Uses the previously
##defined varaibles to open the zip file and list the files that meet. Note that the first couple of lines always error 
## will work on getting it better. note this relies on UnzipIT function running first as it uses some of the variables. 
#######################################################
##create a ordered hash to be used to store data
$datedFile = [ordered]@{}

#check the zip file for the dates in question using the list function of the command line. 
#note: this is how to get around the creation date changing when the file is unzipped.
#set a variable for the list
$myFiledateCHecker= & $My7Ziplocation l "$MyexandDir\$Mycomputer_name.zip"

#check each entry and parse the date, and file name
foreach ($myFile in $myFiledateCHecker) {
if ($myFile -match '^\d+-\d+-\d+\s+\d+:\d+:\d+') {$datedFile.Date = $Matches[0]}
#not sure if we need this but kept to make sure 
#if ($myfile -match 'C\\.*') {$datedFile.Fullname = $Matches[0]}
#set a test variable to the date we just got
$test = $datedFile.Date 
#convert it so we can do some date math against it
$test = (get-date $test).toFileTime()
#test if it matches the min and max we set before. 
if (($test -ge $min) -and ($test -le $max)) { $myfile}

}
### end of this function################################################
}

##########################################################################
## registry load section
##########################################################################
# this section will load the registry files we just got from the remote system.
#
# example of how to load a registry file. in this case we use the windows navite command reg load
# to set the file up then we use a new-PSDrive to allow access. 
# Syntax:
#             
#    reg load "hklm\brownda" "c:\temp\c\Users\brownda\NTUSER.DAT"
#    New-PSDrive <name> -PSProvider Registry -Root hklm\brownda
###
Function load_registry{
Write-host "loading registry files using 'reg load'"
#load the registry file for the user we are investigating and..  
reg load HKLM\$UserInvest "C:\Temp\$myComputer_name\C\users\$UserInvest\NTUSER.DAT" 
# then use new-psdrive to map it to its name
New-PSDrive -Name $userInvest  -PSProvider Registry -Root HKLM\$UserInvest
#load the other Registry files
#set a variable to allow loads of the different registry files
$registry_load = $myComputer_name +"_Sam"
#load the registry file
reg load  HKLM\$registry_load "C:\temp\$myComputer_name\C\Windows\System32\config\SAM"
#create a PSDrive
New-PSDrive -name $registry_load -PSProvider Registry -Root HKLM\$registry_load
#reset the value to system
$registry_load = $myComputer_name +"_System"
#load the registry file
reg load  HKLM\$registry_load "C:\temp\$myComputer_name\C\Windows\System32\config\SYSTEM"
# Create a PsDrive 
New-PSDrive -name $registry_load -PSProvider Registry -Root HKLM\$registry_load
#


write-host "beginning to look for files that were touched between the date." 


}
################################################################################################################
###note this section needs to be run after the Zip file has been expanded in order to grab the right information
Write-host "here are the users as defined in the triage images"
#use the variable where we unzipped the triage image($myworkingDirectory) and read c\User selecting only
#the name and using format-wide to display
#note: $myworkingDirectory is set in unZip Section.  
################################################################################################################

##capture
 #TRiageImage
 #MEMtriage
### expand
 #UnZipIT
 ####
 #testing
 $MyexandDir = "c:\temp"
 $myworkingDirectory = "$MyexandDir\$Mycomputer_name\C\"
$myworkingDirectory
 pause
 ## collect
 $TRGFirewwallRules = ""
 $TRGFirewwallRules = FirewallRules
 $TRGRegistry =""
 #testing 
 #####################
 Get-ChildItem $myworkingDirectory\Users |format-wide -property Name
 ######################
 #Get-ChildItem $myworkngDir\Users |format-wide -property Name

 $UserInvest = Read-Host "From the list, which user are we investigating?"

 $TRGRegistry = rip_reg 
 getFileDatesZip

 
 
 