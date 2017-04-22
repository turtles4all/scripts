$date = Get-Date
$time = "$($date.second)$($date.minute)$($date.hour)"
$file = "Comp-Results-$($time)-$($date.Day)-$($date.Month)-$($date.year).txt"
Clear-Host
$baseline = Read-Host -Prompt "Baseline file "
$compTo = Read-Host -Prompt "File to compare to "

$Origin = (Get-Content $baseline)
$Compare = (Get-Content $compTo)
$content = @()
$content += (Compare-Object -ReferenceObject ($Origin) -DifferenceObject ($Compare))
$content > $file
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