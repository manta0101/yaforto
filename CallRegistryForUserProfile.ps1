Clear-Host
###function Get searchable Windows Registry Identifier 
#define the regkey that holds the sids. We recurse this for the profileImagePAth to grab the ProfileImage 
##################################################################################
#variable Definition
###################################################################################
Function fGet_profilist($regKey, $user_name)
    {
    $regKey = $args[0]
    $user_name =$args[1]
    $target = @()


    #Define the method to grba information then assign the output to a foreach loop to parse
    foreach ($sid in (get-childitem $regKey -Recurse)){
    #create a temporary location to store output from the information. Because we are looking for SID with the variable. 
        $temp = $sid |Findstr ProfileImagePath |Findstr -i $user_name

        #for some reason the output needs to be split not once but  twice to be useable.
        $SidName,$b,$sSid= $reg_split.split('\s+ ',[System.StringSplitOptions]::RemoveEmptyEntries)
        $a,$b,$c = $temp.Split(' ')
        $d,$e,$f=$temp2.Split(':')
 
        $reg_query = reg query $sid

    foreach ($sid_key in $regKey) {
            $reg_split = reg query $sid_key |findstr Sid
            $sReg_PrfileTmp = reg query $sid_key |findstr ProfileImagePath
            $sREg_prfName,$a,$sReg_ProfileImagePath = $sReg_PrfileTmp.split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)
            $SidName,$b,$sSid= $reg_split.split('\s+ ',[System.StringSplitOptions]::RemoveEmptyEntries)
            }
    $return_Registry,$junk= $a.split(' ')
    $return_Registry

        }

$regKey = "HKEY_LOCAL_MACHINE\SOFTWARE\microsoft\windows NT\CurrentVersion\profilelist"
$reg_query = reg query $regKey
$user_name ="rayke"
foreach ($sid_key in $reg_query) {
$reg_split = reg query $sid_key |findstr Sid|Findstr -i $user_name 
$sReg_PrfileTmp = reg query $sid_key |findstr ProfileImagePath|Findstr -i $user_name
#$sReg_PrfileTmp
#pause
#$sREg_prfName,$a,$sReg_ProfileImagePath = $sReg_PrfileTmp.split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)

#$sReg_ProfileImagePath
$SidName,$b,$sSid= $reg_split.split('\s+ ',[System.StringSplitOptions]::RemoveEmptyEntries)
$source_sid = "$sReg_ProfileImagePath $SidName $sSid"
        if ($source_sid -ne $target){
        Write-host "$sReg_ProfileImagePath $SidName $sSid"
        $target += $source_sid
         }

}

}#get-childitem $regKey -recurse |select Name

$regKey = "hklm:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\"

fGet_profilist $regKey, rayke