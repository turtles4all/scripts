if ($args.Length -eq 0){
   $date = Get-Date
   $time = "$($date.second)$($date.minute)$($date.hour)"
   $file = "Enume-$($time)-$($date.Day)-$($date.Month)-$($date.year).txt"
   }
else {
    for ( $i = 0; $i -lt $args.count; $i++ ) {
        if ($args[ $i ] -eq "-o"){ $fileName=$args[ $i+1 ]}
        }
    }


function fmtOut([string]$title, $output){
    $tiBar = "-------------"
    return "{0}{1}{0}`n{2}" -f $tiBar, $title, $output
}

function dateTime(){
    $title = "System date and time"
    $a = Get-Date 
    fmtOut $title | out-file -Encoding string -append $file
    $a | out-file -Encoding string -append $file
}


function HostName(){
    $title = "Hostname"
    fmtOut $title | out-file -append -Encoding string $file
    $env:COMPUTERNAME | out-file -Encoding string -append $file
    
}


function acctGroup(){
    $title = "User accounts and groups"
    (fmtOut $title) | out-file -Encoding string -append $file
    Get-Localgroup | ForEach-Object { 
         fmtOut $_ | out-file -Encoding string -append $file
        Get-LocalGroupMember $_ | out-file -append -Encoding string $file
        }
}


function lUsers(){
    $title = "Logged on users"
    fmtOut $title | out-file -Encoding string -append $file
    Get-WmiObject Win32_LoggedOnUser | Select Antecedent -Unique | out-file -append -Encoding string $file
}

function Procs(){
    $title = "Running processes"
    $processes = @()
    Get-Process | ForEach-Object { $processes += "{0}-`n" -f $_.Name }
    $processes | out-file -append -Encoding string $file
}

function servicStat(){
    $title = "Services and their states"
    write-host $(fmtOut($title))
    get-service | ForEach-Object { Write-Host $_.Status $_.Name }
}

 
function netInfo(){
    $title = "Network information"
    Get-NetAdapter | ForEach-Object {
        $adapter = $_
        write $adapter
        Get-Member -InputObject $adapter | ForEach-Object {$_.Name} | ForEach-Object {
                        $stat=$_
                        write-host $stat " ----- " $(($adapter).$_)}

        }
}


function netSock(){
    $title = "Listening network sockets"
    Get-NetTCPConnection
}

function confInfo(){
    $title = "System configuration information"
    Get-WmiObject Win32_ComputerSystem

}


function mapedDrives(){
    $title = "Mapped Drives"
    Get-SmbShare
}


function ConfiguredDevices(){
    $title = "Configured devices"
    Get-PnpDevice | ForEach-Object { Get-PnpDevice -FriendlyName $_.friendlyname | Format-List -Property * }
}

function sharedResources(){
    $title = "Shared Resources"

    Get-WmiObject -class win32_share | out-file -Encoding string -append $file
}

function Scheduledtasks(){
    $title = "Scheduled Tasks"
    Get-ScheduledTask | ForEach-Object { $_ | Format-List -Property *} | out-file -Encoding string -append $file
}
Clear-Host
dateTime 
HostName 
acctGroup 
lUsers
Procs
servicStat
NetInfo
netSock
confInfo
mapedDrives 
ConfiguredDevices
sharedResources
Scheduledtasks
Write-Host "Done"

Compare-Object -ReferenceObject (Get-Content $file) -DifferenceObject (Get-Content file2.txt) -IncludeEqual