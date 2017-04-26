$regKeys = "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"

if(!(Test-Path HKCR:\)){
    #New-PSDrive -PSProvider Registry -Name HKCR -Root HKEY_CLASSES_ROOT
    }
if(!(Test-Path HKU:\)){
    #New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
    }
if(!(Test-Path HKCC:\)){
    #New-PSDrive -PSProvider Registry -Name HKCC -Root HKEY_CURRENT_CONFIG
    }

if(Test-Path $regKeys){
    $telnet = (Get-RegistryKeyPropertiesAndValues -path $regKeys | Where-Object{$($_.value) -match "Rport=23" -and ($_.value -match "Dir=in")})
    format-table -InputObject $telnet property,value
    $curval = ($telnet.Value).Split("|")
    $telnet
    for($i=0; $i -ne $curval.Length; $i++){
        if($curval[$i] -match "Action"){
            $curval[$i] = "Action=Allow"
            }
        if($curval[$i] -match "Active"){
            $curval[$i] = "Active=True"
            }
    }
    $telnet.Value = ($curval -join "|")
    #Set-ItemProperty -Path $telnet.hive -Name $telnet.property -value $telnet.value
}

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]("ConsentPromptBehaviorAdmin"=dword:00000000,"EnableLUA"=dword:00000000




Function Get-RegistryKeyPropertiesAndValues($path) {
    Get-Item $path |
    Select-Object -ExpandProperty property |
    ForEach-Object {
        New-Object psobject -Property @{“property”=$_;
            “Value” = (Get-ItemProperty -Path . -Name $_).$_;
            "Hive" = $path}
    }

} 







# Get-WinEvent -logname "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" | where{$_.timecreated -like "*4/26*" -and ($_.message -match "telnet")} | select -expand Message