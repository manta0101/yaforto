#Retrieved from http://powershelldistrict.com/netsh-advfirewall-powershell/
# 10/30/18
# modified for use and commented by me to understand it. 
# start of function
Function Get-NetshFireWallrule  {
    # accept a string Parameter called Rulename 
    Param(
        [String]$RuleName
    )
    #if statement to show if a rule name was passed. If not(else), just give all
    if ($RuleName){
        $Rules = netsh advfirewall firewall show rule name="$ruleName"
    }else{
        $Rules = netsh advfirewall firewall show rule name="all"
    }
    #set an Array called Return. 
    $return = @()
    #set a ordered Hash
     $HAsh = [Ordered]@{}
     #loop through the $rule Variable and match using Regex
        foreach ($Rule in $Rules){
            if ($Rule -match '^Rule Name:\s+(?<RuleName>.+$)'){
              $Hash.RuleName = $Matches.RuleName
            }Else{
              if ($Rule -notmatch "----------------------------------------------------------------------"){
                switch -Regex ($Rule){
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
    

    return $return
}
## End of Function
##################################################

#set an Array to all the rules. This can then be parsed by element. 
$AllRules = Get-NetshFireWallrule

$AllRules |select RuleName,Enabled,Direction,Profiles,GRouping,LocalIP,Protocol,LocalPort,RemotePort,Edge_traversal
 
