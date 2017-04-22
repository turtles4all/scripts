Function getProcess(){    
    $CommandData = @()
    $CommandData += (tasklist)
    # write $CommandData
    $Cols = &{$args} Process PID Session Ring Mem Size
    $Processes = $CommandData | 
     ForEach-Object {
      if ($_ -match '^*K')
        {$Proc = $_ -split '\s+'
        if ($Proc.length -gt 6){
                    #write-host "------------------------------"
                    #write-host $Proc
                    $delta = $Proc.length - 6
                    #Write-Host $delta
                    $procName = @()
                    $ProcName += $($Proc[0..$delta] -join " ").ToString()

                    #write-host $ProcName.Length
                    for ($i=1; $i -le 6; $i++){
                        $ProcName += $Proc[$delta + $i]
                    }
                    #write-host $procName
                    $Proc = $procName
                }
        $Hash = [ordered]@{}
        for ($i=0; $i -le 5; $i++){
            $Hash[$Cols[$i]] = $Proc[$i]}
            [PSCustomObject]$Hash
        }
    }
    return $Processes
}
   getProcess | Format-Table process,pid,session,ring
   #$Processes | foreach {write $_.Process}
   