# Get-Process | % { $_.Name, $_.Modules } | format-list | Out-file file.txt

Get-Process | % { $_.Modules } |  Sort-Object -unique $_.Modules 

