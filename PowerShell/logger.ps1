$logpath = "c:\log.txt"
Function install (){
    $installdir = "C:\Windows\System32\logger.ps1"
    Copy-Item logger.ps1 $installdir
    $logb = "powershell.exe -file {0} logboot" -f $installdir
    $logu = "powershell.exe -file {0} userlogin" -f $installdir
    New-Item HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices -Name "logboot" -Value $logb -PropertyType string
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name "userlogin" -Value $logu -PropertyType string

}

Function userlogin (){
    $outfile = @()
    $outfile += "{0}: User `"{1}`" Logged in" -f  $(Get-Date),$env:UserName 
    $outfile >> $logpath
}

Function logboot (){
    $outfile = @()
    $outfile += "{0}: User `"{1}`" System startup" -f  $(Get-Date),$env:UserName 
    $outfile >> $logpath
}


for ( $i = 0; $i -lt $args.count; $i++ ) {
        if ($args[ $i ] -eq "logboot"){ logboot }
        if ($args[ $i ] -eq "userlogin"){ userlogin }
        #else{ install }
}