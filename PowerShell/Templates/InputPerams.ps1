[cmdletBinding()]
Param(
    [Parameter(Mandatory=$true,Position=1)]
    [String]$Dir
)

Get-ChildItem $DIR -Force |
    Where-Object {
        ($_.mode -match "h") -and ($_.LastWriteTime -gt (Get-Date).AddDays(-7))
    }
