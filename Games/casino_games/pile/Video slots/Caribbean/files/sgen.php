<?PHP

	class WinObject {
		
		public $var = 'a default value';
		public $payline = 0;
		public $startRow = 0;
		public $rowCount = 1;
		public $symbol = 1;
		
		
	}


function Game(){
	global $betcc, $n1, $n2, $n3, $n4, $n5, $n6, $n7, $n8, $n9, $n10, $n11, $n12, $n13, $n14, $n15;
	// n1  n2  n3  n4  n5
	// n6  n7  n8  n9  n10
	// n11 n12 n13 n14 n15
	for ($i = 0; $i < $bet+1; $i++) {
		switch($i) {	
			case $i: if ( countLine($n6, $n7, $n8, $n9, $n10, 1) ) { break; } // count result on line 1
			case $i: if ( countLine($n1, $n2, $n3, $n4, $n5, 1) ) { break; } // count result on line 1
			case $i: if ( countLine($n11, $n12, $n13, $n14, $n15, 1) ) { break; } // count result on line 1
			case $i: if ( countLine($n1, $n7, $n8, $n9, $n5, 1) ) { break; } // count result on line 1
			case $i: if ( countLine($n11, $n7, $n8, $n9, $n15, 1) ) { break; } // count result on line 1
			case $i: if ( countLine($n1, $n2, $n8, $n4, $n5, 1) ) { break; } // count result on line 1
			case $i: if ( countLine($n11, $n12, $n8, $n14, $n15, 1) ) { break; } // count result on line 1
			case $i: if ( countLine($n6, $n2, $n3, $n4, $n10, 1) ) { break; } // count result on line 1
			case $i: if ( countLine($n6, $n12, $n13, $n14, $n15, 1) ) { break; } // count result on line 1
		}	
	}	
}

function countResult():Void {
	// n1  n2  n3  n4  n5
	// n6  n7  n8  n9  n10
	// n11 n12 n13 n14 n15
	global $payLines;
	
	$wins = array();	

	$paylineWins = [];
	for ($i = 0; $i < bet; $i++) {		
		$paylineWins = array();
		$winObj = new WinObject();
		$winObj->payline = $i;
		$winObj->startRow = 0;
		$winObj->rowCount = 1;
		$iStart = 0;
		for ($k = 0; $k < 5; k++) {
			if ($payLines[$i][$k] != JOLLY) {
				$winObj->symbol = $payLines[$i][$k];
				$winObj->rowCount = k+1;
				$iStart = $k + 1;
				$k = 5;
			}
		}

		for ($j = $iStart; $j < 5; j++) {
			if ($payLines[$i][$j] == $payLines[$i][$j - 1] || $payLines[$i][$j] == JOLLY) {
				$winObj->rowCount++;
			} else if ($payLines[$i][$j - 1] == JOLLY) {
				if ($winObj->symbol == $payLines[$i][$j]) {
					$winObj->rowCount++;
				} else {
					if ($winObj->rowCount > 2) {
						$paylineWins[] = $winObj;
					} else if ($winObj->rowCount > 1 && $winObj->symbol < 5) {
						$paylineWins[] = $winObj;
					} else if ($winObj->symbol == 1) {
						$paylineWins[] = $winObj;
					}
					$winObj = new WinObject();
					$winObj->payline = $i;
					$winObj->symbol = $payLines[$i][$j];
					$winObj->rowCount = 2;
					$winObj->startRow = j-1;
				}
			} else {
				if ($winObj->rowCount > 2) {
					$paylineWins[] = $winObj;
				} else if ($winObj->rowCount > 1 && $winObj->symbol < 5) {
					$paylineWins[] = $winObj;
				} else if ($winObj->symbol == 1) {
					$paylineWins[] = $winObj;
				}
				$winObj = new WinObject();
				$winObj->payline = $i;
				$winObj->symbol = $payLines[i][$j];
				$winObj->rowCount = 1;
				$winObj->startRow = j;
			}
			//currentItemNum = payLines[i][$j];
			//symbols[currentItemNum]++;
		}
		
		//trace ("wins.length: "+wins.length);
		if ($winObj->rowCount > 2) {
			$paylineWins[] = $winObj;			
		} else if ($winObj->rowCount > 1 && $winObj->symbol < 5) {
			$paylineWins[] = $winObj;
		} else if ($winObj->symbol == 1) {		
			$paylineWins[] = $winObj;
		}

		if (count($paylineWins) > 2) {
			$wins[] = $paylineWins[0];
		} else if (count($paylineWins) > 1) {			
			var win1:Number = getWinByPayTable($paylineWins[0]->symbol, $paylineWins[0]->rowCount);
			var win2:Number = getWinByPayTable($paylineWins[1]->symbol, $paylineWins[1]->rowCount);
			win1 > win2 ? $wins[] =  $paylineWins[0] : $wins[] = $paylineWins[1];
		} else if (count($paylineWins) > 0) {
			$wins[] = $paylineWins[0];
		}
	}
}

function Gen() {
	global $maxJolly, $jolliesGiven;
	
	$again = true;
	do {
		
		$res = rand() * 110;
		
		if ($res < 110 && $res >= 100) {
			$n = 11;
		} else if ($res < 100 && $res >= 90) {
			$n = 10;
		} else if ($res < 90 && $res >= 80) {
			$n = 9;
		} else if ($res < 80 && $res >= 70) {
			$n = 8;
		} else if ($res < 70 && $res >= 60) {
			$n = 7;
		} else if ($res < 60 && $res >= 50) {
			$n = 6;
		} else if ($res < 50 && $res >= 40) {
			$n = 5;
		} else if ($res < 40 && $res >= 30) {
			$n = 4;
		} else if ($res < 30 && $res >= 20) {
			$n = 3;
		} else if ($res < 20 && $res >= 10) {
			$n = 2;
		} else if ($res < 10 && $res >= 0) {
			$n = 1;
		}

		if ($n == 11 && $jolliesGiven < $maxJolly) {		
			$jolliesGiven++;
			$again = false;
		} else {
			$again = false;
		}
	} while ($again);

	return $n;
}

//Jolly max symbols, flash is designed for 2 symbols
$maxJolly = 2;
$jolliesGiven = 0;

do {
	$win=0;
	$n1 = Gen();	
	$n2 = Gen();	
	$n3 = Gen();	
	$n4 = Gen();	
	$n5 = Gen();	
	$n6 = Gen();	
	$n7 = Gen();	
	$n8 = Gen();	
	$n9 = Gen();
	$n10 = Gen();
	$n11 = Gen();
	$n12 = Gen();
	$n13 = Gen();
	$n14 = Gen();
	$n15 = Gen();
	
	$payLines = array(array($n6, $n7, $n8, $n9, $n10), array($n1, $n2, $n3, $n4, $n5), array($n11, $n12, $n13, $n14, $n15), array($n1, $n7, $n8, $n9, $n5), array($n11, $n7, $n8, $n9, $n15), array($n1, $n2, $n8, $n4, $n5), array($n11, $n12, $n8, $n14, $n15), array($n6, $n2, $n3, $n4, $n10), array($n6, $n12, $n13, $n14, $n15));
// Add blanks

// reel 1
	if ($n1 != 6) { $n4 = 6; } // if 1 is not blank, 2 is set to blank	
	if (($n1==6)&&($n4==6)){ // if 1 and 2 are blank generate 2 to be != blank
		do {
			$n4=Gen();
		} while ($n4 == 6);
	}
	if (($n4!=6)&&($n1==6)) { $n7=6; } // if 2 is not blank and 1 is blank, set 3 to blank
	if (($n4==6)&&($n7==6)){ //if 2 and 3 are blank generate 3 to be != bank
		do {
			$n7=Gen();
		} while ($n7 == 6);
	}
	if (($n1==$n7)&&($n1!=6)){ //if 1 == 3, generate 3 to be != 1 and !=6
		do {
			$n7=Gen();
		} while (($n7 == 6)&&($n1!=$n7));
	}	
// Reel 2
	if ($n2!=6) { $n5=6; } // if 1 is not blank, 2 is set to blank
	if (($n2==6)&&($n5==6)){ // if 1 and 2 are blank generate 2 to be != blank
		do {
			$n5=Gen();
		} while ($n5 == 6);
	}

	if (($n5!=6)&&($n2==6)) { $n8=6; } // if 2 is not blank and 1 is blank, set 3 to blank
	if (($n5==6)&&($n8==6)){ //if 2 and 3 are blank generate 3 to be != bank
		do {
			$n8=Gen();
		} while ($n8==6);
	}
	if (($n2==$n8)&&($n2!=6)){ //if 1 == 3, generate 3 to be != 1 and !=6
		do {
			$n8=Gen();
		} while (($n8 == 6)&&($n2!=$n8));
	}
// Reel 3
	if ($n3 != 6) { $n6 = 6; }	
	if (($n3 == 6) && ($n6 == 6)) {	
		do {
			$n6 = Gen();			
		} while ($n6 == 6);
	}
	if (($n6!=6)&&($n3==6)) { $n9=6; }
	if (($n6==6)&&($n9==6)){
		do {
			$n9=Gen();
		} while ($n9 == 6);
	}
	if (($n3==$n9)&&($n3!=6)){ //if 1 == 3, generate 3 to be != 1 and !=6
		do {
			$n9=Gen();
		} while (($n9 == 6)&&($n3!=$n9));
	}
	Game();

	$maxwin = calWinLimit();	
} while ($win > $maxwin);

//update games and transactions
$win_limit = sprintf ("%01.2f", $maxwin); 
$diff=$win-$bet;
$diff = sprintf ("%01.2f", $diff);
if($diff>=0){$rg="w";}else{$rg="l";}
$tm=time();
mysql_query("insert into `games` values('', '$userid', '$tm', '$bet', '-1', '$rg', '$diff', '53')");
$gameid=mysql_insert_id();
mysql_query("insert into `transactions` values('', '$userid', '$gameid', '$tm', '$rg', '$diff', '$win_limit')");

//Update Jackpot 1/10 of the bet
mysql_query("update `jackpot` set `amount`=`amount`+$bet/10 where `type`='53'");

//user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

// send answer
$answer="&ans=res&ub=".$user_balance."&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9."&jp=".$jackpot;
echo $answer;
?>