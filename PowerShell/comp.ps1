$date = Get-Date
$time = "$($date.second)$($date.minute)$($date.hour)"
$file = "Comp-Results-$($time)-$($date.Day)-$($date.Month)-$($date.year).txt"
Clear-Host

if ($args.Length -ne 4){
   Write-host "Usage: comp.ps1 -b baseline.txt -c compareTo.txt
               Must provide baseline and Compare files
               -b baseline
               -c Compare to"
   }

if($args.Length -eq 4) {
    for ( $i = 0; $i -lt $args.count; $i++ ) {
        if ($args[ $i ] -eq "-b"){ $Origin=$args[ $i+1 ]}
        if ($args[ $i ] -eq "-c"){ $Compare=$args[ $i+1 ]}

        }
    }

else{
    $baseline = Read-Host -Prompt "Baseline file "
    $compTo = Read-Host -Prompt "File to compare to "
    }

$Origin = (Get-Content $baseline)
$Compare = (Get-Content $compTo)
$content = (Compare-Object -ReferenceObject ($Origin) -DifferenceObject ($Compare))
Out-File -InputObject $content $file
"`nResults saved to {0}" -f $file

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