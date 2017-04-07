Clear-host
function adder ([int]$a, [int]$b){
    return $a+$b
}

function suber ([int]$a, [int]$b){
    return $a-$b
}

function diver ([int]$a, [int]$b){
    return $a/$b
}

function inter ([int]$a, [int]$b){
    return $a%$b
}

function exper ([int]$a, [int]$b){
    [int]$result=$a
    for($b; $b -gt 0; $b--){
       $result=$($result*$a)
    }
    return $result
}
function getInput {
    [int]$global:a = Read-Host -prompt "First number "
    [int]$global:b = Read-Host -prompt "Second number "

    }


$looping=$True
write "Welcome to Math $env:username"
Do {
    write "1) Addition"
    write "2) Subtraction"
    write "3) Division"
    write "4) Integer Division"
    write "5) Exponentation"
    write "0) Quit"
    $o = Read-Host -prompt "Choose an operation"
    Clear-host
    switch ($o){
            1 {
            Write-host "Usage: First number + Second number:"
            getInput
            $c = adder $a $b
            write "$a + $b = $c"
            }
            2 {
            Write-host "Usage: First number - Second number:"
            getInput
            $c = suber $a $b
            write "$a - $b = $c"
            }
            3 {
            Write-host "Usage: First number / Second number:"
            getInput
            $c = diver $a $b
            write "$a / $b = $c"
            }
            4 {
            Write-host "Usage: First number % Second number:"
            getInput
            $c = inter $a $b
            write "$a % $b = $c"
            }
            5 {
            write-host "Usage: First number(Base) ^ Second number(Exponent):"
            getInput
            $c = exper $a $b
            write "$a ^ $b = $c"
            }
            0 {
            $looping = $False
            }
      default {Write "Not a valid option"}
    }
write-host `n `r
}
while($looping)
Write-Host "Goodbye"