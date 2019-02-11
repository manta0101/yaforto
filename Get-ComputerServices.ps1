##Function to get local or remote Services
Function Get-computerServices{

Param ($computer_name)
if ($computer_name) {

                     Get-Service * -ComputerName $computer_name |select Status,DisplayName,Name,StartType,ServicesDependedOn|Sort-Object -Property Status|Format-Table -AutoSize
                     } 
                            Else {
                                    Write-host "no computer specified assuming localhost" 
                                    Get-Service *|select Status,DisplayName,Name,StartType,ServicesDependedOn|Sort-Object -Property Status|Format-Table -AutoSize
                                  }
                            }
Get-computerServices USAMKBGGD1KC2
