function fmtOut([string]$title){
    $tiBar = "-------------"
    return "{0}{1}{0}" -f $tiBar, $title
}

function Get-dateTime{
    $title = "System date and time"
    $date = Get-Date
    $time = "$($date.hour):$($date.minute):$($date.second)"
    $a = @()
    $a += (fmtOut $title)
    $a += "Date:$($date.Day)-$($date.Month)-$($date.year) - $time" 

    return $a
}

function Get-LogedInUsers{
    $title = "Logged on users"
    $a = @()
    $a += (fmtOut $title)
    $a += (Get-WmiObject Win32_LoggedOnUser | Select Antecedent -Unique)
    
    return $a
}

Function Show-ProcessTree{
    Function Get-ProcessChildren($P,$Depth=1)
    {
        $procs | Where-Object {$_.ParentProcessId -eq $p.ProcessID -and $_.ParentProcessId -ne 0} | ForEach-Object {
            "{0}|--{1} pid={2} ppid={3}" -f (" "*3*$Depth),$_.Name,$_.ProcessID,$_.ParentProcessId
            Get-ProcessChildren $_ (++$Depth)
            $Depth--
        }
    }

    $filter = {-not (Get-Process -Id $_.ParentProcessId -ErrorAction SilentlyContinue) -or $_.ParentProcessId -eq 0}
    $procs = Get-WmiObject Win32_Process
    $top = $procs | Where-Object $filter | Sort-Object ProcessID
    foreach ($p in $top)
    {
        "{0} pid={1}" -f $p.Name, $p.ProcessID
        Get-ProcessChildren $p
    }
}

function Get-Procs{
    $processes = @()
    $title = "Running processes in Session 0"
    $processes += (fmtOut $title)
    $processes += (Get-Process | Sort-Object Name | Where-Object {$_.sessionID -eq 0} | Format-Table -AutoSize Name,ID, sessionID, Path)
    $processes += (fmtOut "Running processes NOT in Session 0")
    $processes += (Get-Process | Sort-Object Name | Where-Object {$_.sessionID -gt 0} | Format-Table -AutoSize Name,ID, sessionID, Path)
    $title = "Rprocess Tree"
    $processes += (fmtOut $title)
    $processes += Show-ProcessTree
    return $processes
}

function Enum-Services(){
    $title = "Services"
    $a = @()
    $Running = @()
    $Stopped = @()
    $a += (fmtOut $title)
    $servs = (Get-Service)
    #Split Services

    foreach ($serv in $servs){
        
        if ($serv.Status -contains "Running")
        {
            $Running += $serv
        }
        else
        {
        $Stopped += $serv
        }
    }
    $a += (fmtOut "Running Services")
    $a += ($Running | Sort-Object StartType,displayName | Format-Table -autosize DisplayName, ServiceName, Status, startType)
    $a += (fmtOut "Stopped Services")
    $a += ($Stopped | Sort-Object StartType,displayName | Format-Table -autosize DisplayName, ServiceName, Status, startType)
    $a += (fmtOut "Service dependencies")

    foreach ($item in ($running | Where-Object {$_.RequiredServices.count -gt 0})){
    $a += (fmtOut ($item.ServiceName).ToString())
        for ($i = 0; $i -lt $item.RequiredServices.Count; $i++)
        { 
            $a += ($item.RequiredServices[$i])
        }
    }
 
    return $a
}
function Enum-Drives{
    $drives = Get-PSDrive | Where-Object {$_.Provider -contains "FileSystem"}
    
    }

function Get-confInfo {
    param($ComputerName = $env:ComputerName)

    $title = "System configuration information"
    $a = @()
    $a += fmtOut $title
      $header = 'Hostname','OSName','OSVersion','OSManufacturer','OSConfig','Buildtype', 'RegisteredOwner','RegisteredOrganization','ProductID','InstallDate', 'StartTime','Manufacturer','Model','Type','Processor','BIOSVersion', 'WindowsFolder' ,'SystemFolder','StartDevice','Culture', 'UICulture', 'TimeZone','PhysicalMemory', 'AvailablePhysicalMemory' , 'MaxVirtualMemory', 'AvailableVirtualMemory','UsedVirtualMemory','PagingFile','Domain' ,'LogonServer','Hotfix','NetworkAdapter' 
      $a += (systeminfo.exe /FO CSV /S $ComputerName | Select-Object -Skip 1 | ConvertFrom-CSV -Header $header)

    return $a
}

function Get-mapedDrives(){
    $title = "Mapped Drives"
    $a = @()
    $a += fmtOut $title
    $a += (Get-WmiObject Win32_MappedLogicalDisk)
    return $a
}

function Invoke-SituationalAwareness
{
    # Declared the situational awareness section has begun executing
    Write-Output "Beginning Situational awareness check."
    # Pulls the current date & time
    Get-dateTime
    # Pulls the hostname
    Get-WmiObject win32_OperatingSystem | fl PSComputerName
    #Pull OS Version 
    (Get-WmiObject win32_operatingSystem).Version
    # Pulls the IP/MAC address
    Get-WmiObject –Class Win32_NetworkAdapterConfiguration | where-object { $_.IPAddress} | Format-Table
    # Pulls the current process
    $PID
    Get-WmiObject win32_processor
    # Pulls the user context
    Get-LogedInUsers
    # Determine if running with administrative privileges
    Write-Output "Currently have administrative rights:"; ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] “Administrator”)
}

function Invoke-SecurityCheck
{
    # Declared the security section has begun executing
    Write-Output "Beginning security check."
    # Pulls the list of running processes
    Get-Procs
    # Pulls the list of running services
    Enum-Services
    # Verifies security auditing is enabled
    Get-LogProperties Security | Format-List enabled
    # Displays the audit categories & settings
    &"C:\Windows\System32\auditpol.exe" /get /category:*
    # Pulls the 20 most recent entries
    &"C:\Windows\System32\wevtutil.exe" qe security /c:20 /rd:true /f:text
}

function Invoke-HostInfo
{
    # Declared the Host info section has begun executing
    Write-Output "Beginning Host Info check."
    # Pulls general computer information
    &"C:\Windows\System32\cmd.exe" /C systeminfo
    # Pulls hard drive information
    Get-WmiObject –Class Win32_LogicalDisk  -Filter ‘DriveType=3’| Format-Table -Autosize DeviceID, Size, FreeSpace
    # Pulls processor load
    (Get-WmiObject win32_processor).LoadPercentage
    # Pulls memory load
    
    # Pulls network connections & sockets
    &"C:\windows\system32\netstat.exe" -ano
}

function Invoke-PersistenceCheck
{
    # Declared the persistence section has begun executing
    Write-Output "Beginning persistence check."
    # Pulls the HKLM Run key
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Run
    # Pulls the HKLM RunOnce key
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce
    # Pulls the HKLM Winlogon key
    Get-ItemProperty “HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon”
    # Pulls the HKCU Run key
    Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run
    # Pulls the HKCU RunOnce key
    Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce
    # Pulls the HKCU Winlogon key
    
    # Pulls all at jobs
    at
    # Pulls all scheduled tasks
    schtasks /query  /V /FO list
    # Pulls host startup folder

    # Pulls startup folder for each user
    $names = Get-ChildItem C:\Users | where { $_.Name -ne "Public" -and $_.Name -ne "installer" } | select { $_.Name }    
    foreach ($name in $names) { 
        $test = Get-ChildItem ('c:\Users\' + ($name.' $_.Name ') + '\Appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup') -ErrorAction SilentlyContinue
        if($test -ne $null)
        {                
            Get-ChildItem ('c:\Users\' + ($name.' $_.Name ') + '\Appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup')
        }
    }
    # Pulls all autostart services
    
}

function Invoke-LogCheck
{
    # Declared the logging check section has begun executing
    Write-Output "Beginning Log check."
    # Pulls every file which has updated in the last hour
    ((Get-ChildItem -Path c:\ -Recurse | Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-1)})) 2> $null
}


<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Invoke-HostSurvey
{
    [CmdletBinding()]
    Param
    (
        # A switch to run through all functions without breakpoints
        [Switch]$Noninteractive
    )

    Begin
    {
    }
    Process
    {
        # An If statement that determines behvior if the -noninteractive switch was used
        If($noninteractive)
        {
            Invoke-SituationalAwareness
            Invoke-SecurityCheck
            Invoke-HostInfo
            Invoke-PersistenceCheck
            Invoke-LogCheck
        }
        # Else - default behavior, including breakpoints
        else
        {
            # Runs the Situational awareness function
            Invoke-SituationalAwareness
            # A breakpoint to determine if the user wishes to continue
            $bp1 = Read-Host "Do you wish to continue? (Y or N)"
                # If statement to determine if to continue
                if($bp1 -eq 'Y')
                {
                    # Runs the security check function
                    Invoke-SecurityCheck
                    # A breakpoint to determine if the user wishes to continue
                    $bp2 = Read-Host "Do you wish to continue? (Y or N)"
                        # If statement to determine if to continue
                        if($bp2 -eq 'Y')
                        {
                            # Runs the host info function
                            Invoke-HostInfo
                            # A breakpoint to determine if the user wishes to continue
                            $bp3 = Read-Host "Do you wish to continue? (Y or N)"
                                # If statement to determine if to continue
                                if($bp3 -eq 'Y')
                                {
                                    # Runs the persistence function
                                    Invoke-PersistenceCheck
                                    # A breakpoint to determine if the user wishes to continue
                                    $bp4 = Read-Host "Do you wish to continue? (Y or N)"
                                        # If statement to determine if to continue
                                        if($bp4 -eq 'Y')
                                        {
                                            # Runs the log check function
                                            Invoke-LogCheck
                                        }
                                }
                                else
                                {
                                    Write-Output "Survey terminated by operator."
                                }
                        }
                        else
                        {
                            Write-Output "Survey terminated by operator."
                        }
                }
                else
                {
                    Write-Output "Survey terminated by operator."
                }

        }
    }
    End
    {
    }
}

