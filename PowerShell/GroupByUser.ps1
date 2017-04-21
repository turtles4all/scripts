$userArray = @()
$users = $(net user).split("",[System.StringSplitOptions]::RemoveEmptyEntries)
$users | foreach {$userArray += $_}
Write-Output $userArray[5..($userarray.Length - 5)]

