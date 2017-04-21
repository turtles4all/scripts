function getChildren($curitem){
        $children = ($procs | Where-Object { $_.parentProcessID -eq $curitem.processID })
        return $children
    }

$procs = (Get-WMIObject -Class Win32_Process | Sort-Object ProcessId)
$pevPPID = 0
$procs | ForEach-Object {
    $prevPPID = $_.parrentProcessID
    $curitem = $_
    # if ($_.parentProcessID -ne $prevPPID){}
    if ($_.processID -ne $_.parentProcessID){
        $children = getChildren($curitem)    
        if ($children.Length -gt 0){
            write-host ($_).processID ($_).processName
            $children | foreach { Write-Host "\",$_.processID, $_.processName, $_.parrentProcessID}
            }
       
        }
    
    else{
        write-host "|",$_.processName," PID :"$_.processID 
        }
    }
#$procs | Format-Table processid,ParentProcessId
