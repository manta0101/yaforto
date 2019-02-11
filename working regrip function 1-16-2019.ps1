$userInvest = "boyde"
$myworkingDirectory = "C:\Temp\USAMKBDP3BM72\C\"
$minUTC = 131838120000000000
$maxUTC = 132160392000000000

####added functions for testing
#####################################################
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


#####################################################
Function rip_reg {
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
#$TimeconvertString
#Pause
#we convert our newly formed string into a datetime and then into filetime to compare against our Max and min filetimes
# we use the get-date because it looks to work on the ones we care about.
$timeString2 = get-date("$TimeconvertString")
##testing variables 
#$timeSTring2
#pause
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
            $timeString2
            $minUTC
            $maxUTC
            #testing variables
            ###
            write-host "testing varaible"
            $test
            Write-Host "out2"
            $out2
            Write-host "string-time"
            $stringTime
            Write-host "timestring2"
            $TimeString2
            Write-Host "TimeStringDate"
            $TimeStringDate
            write-host "TimeconvertString"
            $TimeconvertString
            pause

#########
 #end of if statement. 
            }
 #end of foreach function 
 }

 }
## end of test foreach function
return $out2
}
Write-host "running reg Ripper and outputing the data for the report`n you can safely ignore errors"
rip_reg