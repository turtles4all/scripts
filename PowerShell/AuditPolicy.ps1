Clear-Host
$FirewallRules = "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"

#returns property in custom format
Function Get-RegistryKeytable($path) { 
    Get-Item $path |
    Select-Object -ExpandProperty property |
    ForEach-Object {
        New-Object psobject -Property @{“property”=$_;
            “Value” = (Get-ItemProperty -Path . -Name $_).$_;
            "Hive" = $path}
    }

}

$telnet = (Get-RegistryKeytable -path $FirewallRules | Where-Object{$($_.value) -like "*Action=Block*Dir=in*Lport=23*"}) #search for telnet inbound rule 
format-table -InputObject $telnet property,value
    
if($telnet){ #change values if rule exists
    
    $curval = ($telnet.Value).Split("|")
    
    for($i=0; $i -ne $curval.Length; $i++){
        if($curval[$i] -match "Action"){
            $curval[$i] = "Action=Allow"
            }
        if($curval[$i] -match "Active"){
            $curval[$i] = "Active=True"
            }
    }
    $telnet.Value = ($curval -join "|")
    Set-ItemProperty  -Path $telnet.hive -Name $telnet.property -type string -value $telnet.value
}

else{ # if the rule does not exist then create the rule
    Set-ItemProperty -Path $FirewallRules -Name "Telnet" -type string -value "v2.26|Action=Allow|Active=True|Dir=In|Protocol=6|LPort=23|Name=TELNET|"
}      

#Disable Credential Validation
auditpol.exe /set /subcategory:"Credential Validation" /success:disable /failure:disable

#Retrieve the firewall logs for today's date

Get-WinEvent -logname "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" | 
    where{$_.timecreated -like $(get-date -UFormat "*%m/%d*") -and ($_.message -match "telnet")} | 
    select -expand Message