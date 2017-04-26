$filename = "c:\reg.txt"
#$filepath = Read-Host -Prompt "Save file to?"
echo "" > $filepath
$regKeys = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU ,HCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist,HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders,HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist,HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders,HKCU:\Software\Microsoft\Windows\CurrentVersion\Run,HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce,HKCU:\Software\Microsoft\Windows\CurrentVersion\RunServices,HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows\Run,HKLM:\Software\Microsoft\Active Setup\Installed Components\KeyName,HKLM:\Software\Microsoft\Windows\CurrentVersion\explorer\Shell Folders,HKLM:\Software\Microsoft\Windows\CurrentVersion\explorer\User Shell Folders,HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\Explorer\Run,HKLM:\Software\Microsoft\Windows\CurrentVersion\Run,HKLM:\Software\Microsoft\Windows\CurrentVersion\Runonce,HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce,HKLM:\Software\Microsoft\Windows\CurrentVersion\RunServices,HKLM:\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce,HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell,HKLM:\Software\Microsoft\WZCSVC\Parameters\Interfaces,HKLM:\System\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List,HKLM:\System\ControlSet001\Services\Tcpip\Parameters\Interfaces,HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer,HKLM:\System\ControlSet00x\Enum\USBSTOR,HKLM:\System\MountedDevices"
$regKeys = $regKeys.split(",")
if(!(Test-Path HKCR:\)){
    #New-PSDrive -PSProvider Registry -Name HKCR -Root HKEY_CLASSES_ROOT
    }
if(!(Test-Path HKU:\)){
    #New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
    }
if(!(Test-Path HKCC:\)){
    #New-PSDrive -PSProvider Registry -Name HKCC -Root HKEY_CURRENT_CONFIG
    }



for($i=0; $i -ne $regKeys.Length; $i++){
    $curkEY = $regKeys[$i]
   
    if(Test-Path $curkEY){
        $path = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\'
        Get-RegistryKeyPropertiesAndValues -path $curkEY | Format-table hive,property,value -autosize | out-file -Append $filepath
    }
    else{
    write-host $curkEY " DOES NOT EXIST"
    }

}

C:\reg.txt
Function Get-RegistryKeyPropertiesAndValues($path) {
    Push-Location
    Set-Location -Path $path
    Get-Item $path |
    Select-Object -ExpandProperty property |
    ForEach-Object {
        New-Object psobject -Property @{“property”=$_;
            “Value” = (Get-ItemProperty -Path . -Name $_).$_;
            "Hive" = $path}
    }

     Pop-Location

} 