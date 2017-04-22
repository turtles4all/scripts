Clear-Host
$baseline = Read-Host -Prompt "Baseline file "
$compTo = Read-Host -Prompt "File to compare to "

$Origin = (Get-Content $baseline)
$Compare = (Get-Content $compTo)
Compare-Object -ReferenceObject ($Origin) -DifferenceObject ($Compare)