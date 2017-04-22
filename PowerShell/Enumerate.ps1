$date = Get-Date
$time = "$($date.second)$($date.minute)$($date.hour)"
$file = "Enum-$($time)-$($date.Day)-$($date.Month)-$($date.year).txt"
 
function fmtOut([string]$title){
    $tiBar = "-------------"
    return "{0}{1}{0}" -f $tiBar, $title
}

function dateTime(){
    $title = "System date and time"
    $a = @()
    $a += (fmtOut $title)
    $a += Get-Date 

    return $a
}


function HostName(){
    $title = "Hostname"
    $a = @()
    $a += (fmtOut $title)
    $a += ($env:COMPUTERNAME)
   
    return $a
}


function acctGroup(){
    $title = "User accounts and groups"
    $a = @()
    $a += (fmtOut $title)
    Get-Localgroup | ForEach-Object { 
        $group = $_
        $members = Get-LocalGroupMember $group
        if ($members.Length -gt 0 ){
        $a += (fmtOut $group)
        $a += ($members| format-list -Property Name,SID)
        }
    }

    return $a 
}


function lUsers(){
    $title = "Logged on users"
    $a = @()
    $a += (fmtOut $title)
    $a += (Get-WmiObject Win32_LoggedOnUser | Select Antecedent -Unique)
    
    return $a
}

function Procs(){
    $processes = @()
    $title = "Running processes"
    $processes += (fmtOut $title)
    $processes += (Get-Process | Sort-Object Name | Format-Table Name,ID,SI)

    return $processes
}

function servicStat(){
    $title = "Services and their states"
    $a = @()
    $a += (fmtOut $title)
    $a += (get-service | format-table Name,starttype,Status,DependentServices)

    return $a
}

 
function netInfo(){
    $title = "Network information"
    $a = @()
    $a += fmtOut $title
    $a += (Get-NetAdapter | ForEach-Object {format-list -property * -InputObject $_})

    return $a
}


function netSock(){
    $title = "Listening network sockets"
    $a = @()
    $a += fmtOut $title
    $a += (Get-NetTCPConnection | Where-Object {$_.State -eq 'Listen'} | Sort-Object @{Expression={$_.localaddress}; a=0},localport | format-table localport,localaddress,state,OwningProcess)

   return $a
}

function confInfo {
    param($ComputerName = $env:ComputerName)

    $title = "System configuration information"
    $a = @()
    $a += fmtOut $title
      $header = 'Hostname','OSName','OSVersion','OSManufacturer','OSConfig','Buildtype', 'RegisteredOwner','RegisteredOrganization','ProductID','InstallDate', 'StartTime','Manufacturer','Model','Type','Processor','BIOSVersion', 'WindowsFolder' ,'SystemFolder','StartDevice','Culture', 'UICulture', 'TimeZone','PhysicalMemory', 'AvailablePhysicalMemory' , 'MaxVirtualMemory', 'AvailableVirtualMemory','UsedVirtualMemory','PagingFile','Domain' ,'LogonServer','Hotfix','NetworkAdapter' 
      $a += (systeminfo.exe /FO CSV /S $ComputerName | Select-Object -Skip 1 | ConvertFrom-CSV -Header $header)

    return $a
}


function mapedDrives(){
    $title = "Mapped Drives"
    $a = @()
    $a += fmtOut $title
    $drives = (Get-WmiObject Win32_MappedLogicalDisk)
    if ($drives.length -gt 0){
        $a += $drives
        }
    else {
        $a += "NONE"
        }

    return $a
}


function ConfiguredDevices(){
    $title = "Configured devices"
    $a = @()
    $a += fmtOut $title
    $a += (Get-PnpDevice | ForEach-Object { $_ | Format-List -Property * })

    return $a
}

function sharedResources(){
    $title = "Shared Resources"
    $a = @()
    $a += fmtOut $title
    $a += (Get-WmiObject -class win32_share)

    return $a
}

function Scheduledtasks(){
    $title = "Scheduled Tasks"
    $a = @()
    $a += fmtOut $title
    $a += (Get-ScheduledTask | Sort-Object taskname | format-table -autosize taskname,taskpath,state,version,author)

    return $a
}

Clear-Host
write-host "Running..."
$content = @()
$content += dateTime 
$content += HostName 
$content += acctGroup 
$content += lUsers
$content += Procs
$content += servicStat
$content += NetInfo
$content += netSock
$content += confInfo
$content += mapedDrives 
$content += ConfiguredDevices
$content += sharedResources
$content += Scheduledtasks
$content > $file
"Results saved to {0}" -f $file
$looping = 1

while ($looping){
    $print = Read-host -prompt "Show results to terminal? (Y/N)"
    if ($print.ToLower() -ne "y" -or "n"){
        if ($print.ToLower() -eq "y"){
        $content
        break}
        if ($print.ToLower() -eq "n"){break}
        }
    "Must enter Y or N"
}