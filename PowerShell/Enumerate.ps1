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

    return $a # | Export-Clixml $file # out-file -Encoding string -append $file
}


function HostName(){
    $title = "Hostname"
    $a = @()
    $a += (fmtOut $title)
    $a += ($env:COMPUTERNAME)
    
    
    return $a # | Export-Clixml -force $file # out-file -Encoding string -append $file
}


function acctGroup(){ # Ouput users in groups
    $title = "User accounts and groups"
    $a = @()
    $a += (fmtOut $title)
    Get-Localgroup | ForEach-Object { 
        $group = $_
        $members = Get-LocalGroupMember $group
        if ($members.Length -gt 0 ){ # if the group does not have assigned users, do not print the group
        $a += (fmtOut $group)# | Export-Clixml $file # out-file -Encoding string -append $file
        $a += ($members| format-list -Property Name,SID) #| Export-Clixml $file # out-file -Encoding string -append $file}
        }
    }


    return $a #| Export-Clixml $file # out-file -Encoding string -append $file
}


function lUsers(){
    $title = "Logged on users"
    $a = @()
    $a += (fmtOut $title)
    $a += (Get-WmiObject Win32_LoggedOnUser | Select Antecedent -Unique)
    
    return $a #| Export-Clixml $file # out-file -Encoding string -append $file
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
    return $a # | Export-Clixml $file # out-file -Encoding string -append $file
}

 
function netInfo(){
    $title = "Network information"
    $a = @()
    $a += fmtOut $title
    $a += (Get-NetAdapter | ForEach-Object {format-list -property * -InputObject $_})

    return $a # | Export-Clixml $file # out-file -Encoding string -append $file
}


function netSock(){
    $title = "Listening network sockets"
    $a = @()
    $a += fmtOut $title
    $a += (Get-NetTCPConnection | Where-Object {$_.State -eq 'Listen'} | Sort-Object @{Expression={$_.localaddress}; a=0},localport | format-table localport,localaddress,state,OwningProcess)

   return $a # | Export-Clixml $file # out-file -Encoding string -append $file
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
    return $a # | Export-Clixml $file # out-file -Encoding string -append $file
}


function ConfiguredDevices(){
    $title = "Configured devices"
    $a = @()
    $a += fmtOut $title
    $a += (Get-PnpDevice | ForEach-Object { $_ | Format-List -Property * })

    return $a # | Export-Clixml $file # out-file -Encoding string -append $file
}

function sharedResources(){
    $title = "Shared Resources"
    $a = @()
    $a += fmtOut $title
    $a += (Get-WmiObject -class win32_share)

    return $a # | Export-Clixml $file # out-file -Encoding string -append $file
}

function Scheduledtasks(){
    $title = "Scheduled Tasks"
    $a = @()
    $a += fmtOut $title
    $a += (Get-ScheduledTask | Sort-Object taskname | format-table -autosize taskname,taskpath,state,version,author)


    return $a # | Export-Clixml $file # out-file -Encoding string -append $file
}
$content = @()
Clear-Host
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
$content
$content > $file
"Results saved to {0}" -f $file

