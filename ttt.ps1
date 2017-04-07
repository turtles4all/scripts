clear-host
function initialize-board {
	$board = @()
	(1..3) | %{ $board += , @(0,0,0) }
	return $board
}

function print-board($board) { #missing {
	$out = @() #missing $
	for ($y = 0; $y -le 2; $y++) {
		$line = ""
		for ($x = 0; $x -le 2; $x++) {
			if ($board[$x][$y] -eq 0) {
				$line += " "
               }
			elseif ($board[$x][$y] -eq 1) {
				$line += "X"
            }
			elseif ($board[$x][$y] -eq 2) {
				$line += "O"
			}
			if ($x -lt 2) {
				$line += "|"
			}
		}
		$out += $line
		if ($y -lt 2) {
			$out += , "-+-+-"
		}
	}
	write-host "`n---------------`n"
	$out | % { write-host $_ } 
}

function update-board ($board, $num, $player) {
	$num = $num - 1
	$x = $num % 3
	$y = ($num - ($num % 3)) / 3
	$board[$x][$y] = $player
	return $board
}

function validate-move ($board, $num) {
	if (($num -lt 1) -or ($num -gt 9)) {
		return $false
	}
	$num = $num - 1
	$x = $num % 3
	$y = ($num - ($num % 3)) / 3
	if ($board[$x][$y] -eq 0) {
		return $true
	}
	return $false
}

function get-move ($board, $player) {
	while ($true) {
		print-board $board
		write-host "`n1|2|3`n-+-+-`n4|5|6`n-+-+-`n7|8|9`n"
		switch ($player) {
			1 { $xo = "X" }
			2 { $xo = "O" }
		}
		[int] $num = read-host "Player $player, enter move" #replaced xo with player
		if (validate-move $board $num) {
			return $num
		}
		write-host "Invalid move! Select again."
	}
}

function test-win ($board) {
	$win = @(@(@(1,1,1),@(0,0,0),@(0,0,0,0)),@(@(0,0,0),@(1,1,1),@(0,0,0)),@(@(0,0,0),@(0,0,0),@(1,1,1)),@(@(1,0,0),@(1,0,0),@(1,0,0)),@(@(0,1,0),@(0,1,0),@(0,1,0)),@(@(0,0,1),@(0,0,1),@(0,0,1)),@(@(1,0,0),@(0,1,0),@(0,0,1)),@(@(0,0,1),@(0,1,0),@(1,0,0)))
	$win | % { #missing {}??
		$testboard = $board
		$sum = 0
		$count = 0
		for ($y = 0; $y -le 2; $y ++){ 
			for ($x = 0; $x -le 2; $x ++){
				$a = $testboard[$x][$y] * $_[$x][$y]
				if ($a -gt 0) {
					$count = $count + 1
					$sum = $sum + $a
				}
			}
		}
		if ($count -eq 3){ 
			if ($sum -eq 3){
				return 1
			}
			elseif ($sum -eq 6){ 
				return 2
			}
		}
	}
	$count = 0
	for ($y = 0; $y -le 2; $y ++) {
		for ($x = 0; $x -le 2; $x ++) {
			if ($board[$x][$y] -ne 0) {
				$count = $count +1
			}
		}
	}
	if ($count -eq 9) {
		return 3
	}
	return 0
}


$board = initialize-board
$player = 1
$exit = $false
while (-not $exit){ 
	$player = $player % 2
	if ($player -eq 0) {
		$player = 2
	}
	$move = get-move $board $player
	$board = update-board $board $move $player
	$winner = test-win $board
	if ($winner -eq 1) {
		print-board $board
		write-host "`nX Wins!`n"
		$exit = $true
	}
	elseif ($winner -eq 2) {
		print-board $board
		echo "`nO Wins!`n"
		$exit = $true
	}
	elseif ($winner -eq 3) {
		print-board $board
		echo "`nStalemate!`n"
		$exit = $true
	}
	$player = $player + 1
}
