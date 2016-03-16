<?PHP

error_reporting(0);
require('../scripts/connect.php');
///////////////////// functions //////////////////////
function calWinLimit(){
	$locID=LOCID;
	$userid=USERID;
	$type=$locID."52";


list($coef) = mysql_fetch_row(mysql_query("SELECT coef FROM settings WHERE `type`='$type'"));
list($resetdate) = mysql_fetch_row(mysql_query("SELECT date FROM transactions WHERE gameid=0 AND type='co' AND comments='$userid' ORDER BY transid ASC LIMIT 1"));


	list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `transactions` WHERE `date`>$resetdate AND ((type='w' AND userid='$userid') OR (type='l' AND userid='$userid') OR (type='co' AND comments='$userid'))"));
	$balance=-$balance;
	$maxwin=$balance*$coef/100;
	if($maxwin<0){ $maxwin=0; }else{
	//Force Lost
	$chance=rand(0,99);
	if ($chance > $coef) {
		$maxwin=0;
	}
	}

	return $maxwin;
}

// 
	class WinObject {		
		
		public $payline = 0;
		public $startRow = 0;
		public $rowCount = 0;
		public $symbol = 0;
		
		
	}
	
	function getWinByPayTable($symbol, $row) {
		$payTable = array(0, array(0, 2, 10, 100, 500, 5000), array(0, 0, 5, 50, 250, 2500), array(0, 0, 3, 20, 100, 1000), array(0, 0, 3, 20, 100, 1000), array(0, 0, 0, 10, 30, 500), array(0, 0, 0, 5, 25, 300), array(0, 0, 0, 5, 20, 200), array(0, 0, 0, 5, 20, 200), array(0, 0, 0, 5, 15, 100), array(0, 0, 0, 5, 15, 100));		
		return $payTable[$symbol][$row];		
	}

//

function countResult() {
		// n1  n2  n3  n4  n5
		// n6  n7  n8  n9  n10
		// n11 n12 n13 n14 n15
		global $payLines, $bet;
		$JOLLY = 11;
		$wins = array();
		$paylineWins = array();		
		
		for ($i = 0; $i < $bet; $i++) {		
			$paylineWins = array();
			$winObj = new WinObject();
			$winObj->payline = $i;
			$winObj->startRow = 0;
			$winObj->rowCount = 1;
			$iStart = 0;
			for ($k = 0; $k < 5; $k++) {
				if ($payLines[$i][$k] != $JOLLY) {
					$winObj->symbol = $payLines[$i][$k];					
					$winObj->rowCount = k+1;
					$iStart = $k + 1;
					$k = 5;
				}
			}
			
			for ($j = $iStart; $j < 5; $j++) {			
				
				if ($payLines[$i][$j] == $payLines[$i][$j - 1] || $payLines[$i][$j] == $JOLLY) {
					$winObj->rowCount++;
				} elseif ($payLines[$i][$j - 1] == $JOLLY) {
					if ($winObj->symbol == $payLines[$i][$j]) {
						$winObj->rowCount++;
					} else {
						if ($winObj->rowCount > 2) {
							$paylineWins[] = $winObj;
						} elseif ($winObj->rowCount > 1 && $winObj->symbol < 5) {
							$paylineWins[] = $winObj;
						} elseif ($winObj->symbol == 1) {
							$paylineWins[] = $winObj;
						}
						$winObj = new WinObject();
						$winObj->payline = $i;
						$winObj->symbol = $payLines[$i][$j];						
						$winObj->rowCount = 2;
						$winObj->startRow = $j-1;
					}
				} else {
					if ($winObj->rowCount > 2) {
						$paylineWins[] = $winObj;
					} elseif ($winObj->rowCount > 1 && $winObj->symbol < 5) {
						$paylineWins[] = $winObj;
					} elseif ($winObj->symbol == 1) {
						$paylineWins[] = $winObj;
					}
					$winObj = new WinObject();
					$winObj->payline = $i;
					$winObj->symbol = $payLines[$i][$j];
					$winObj->rowCount = 1;
					$winObj->startRow = $j;
				}
				//currentItemNum = payLines[i][$j];
				//symbols[currentItemNum]++;
			}
			
			//trace ("wins.length: "+wins.length);
			if ($winObj->rowCount > 2) {
				$paylineWins[] = $winObj;			
			} elseif ($winObj->rowCount > 1 && $winObj->symbol < 5) {
				$paylineWins[] = $winObj;
			} elseif ($winObj->symbol == 1) {		
				$paylineWins[] = $winObj;
			}

			if (count($paylineWins) > 2) {
				$wins[] = $paylineWins[0];
			} elseif (count($paylineWins) > 1) {
			
				$win1 = getWinByPayTable($paylineWins[0]->symbol, $paylineWins[0]->rowCount);
				$win2 = getWinByPayTable($paylineWins[1]->symbol, $paylineWins[1]->rowCount);
				
				if ($win1 > $win2) {
					$wins[] =  $paylineWins[0];
				} else {
					$wins[] = $paylineWins[1];
				}
				
			} elseif (count($paylineWins) > 0) {
				$wins[] = $paylineWins[0];
			}
		}
		
		
		//print_r($wins);
		for ($i = 0; $i < count($wins); $i++) {
			$paylineNum = $wins[$i]->payline + 1;
			//echo "__        ".$payTable[$symbol][$row]."     ".$symbol."     ".$row." <br>";
			//echo "__ win  ".getWinByPayTable($wins[$i]->symbol, $wins[$i]->rowCount)."   payline ".$paylineNum."     rowCount  ".$wins[$i]->rowCount."    symbol  ".$wins[$i]->symbol." <br>";
			$totalWin = $totalWin + getWinByPayTable($wins[$i]->symbol, $wins[$i]->rowCount);
		}
		
		return $totalWin;
	}
//
	function Gen() {
		global $maxJolly, $jolliesGiven;
		
		$again = true;
		while ($again) {
			$n = 0;
			$res = rand(0, 130);			
			if ($res <= 130 && $res >= 125) {
				$n = 11;
			} elseif ($res < 125 && $res >= 105) {
				$n = 10;
			} elseif ($res < 105 && $res >= 90) {
				$n = 9;
			} elseif ($res < 90 && $res >= 70) {
				$n = 8;
			} elseif ($res < 70 && $res >= 55) {
				$n = 7;
			} elseif ($res < 55 && $res >= 42) {
				$n = 6;
			} elseif ($res < 42 && $res >= 30) {
				$n = 5;
			} elseif ($res < 30 && $res >= 20) {
				$n = 4;
			} elseif ($res < 20 && $res >= 12) {
				$n = 3;
			} elseif ($res < 12 && $res >= 5) {
				$n = 2;
			} elseif ($res < 5 && $res >= 0) {
				$n = 1;
			}

			if ($n == 11) {
				if ($jolliesGiven < $maxJolly) {					
					$jolliesGiven = $jolliesGiven + 1;
					$again = false;					
				}				
			} else {
				$again = false;
			}
		}
		
		return $n;
	}

///////////////////// MAIN //////////////////////
if( !isset($_POST["b"]) ){ exit; }
if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
$userid=mysql_result($result, 0, "userid");
$bet = $_POST["b"];
$bet = sprintf ("%01.2f", $bet);	
$c_val = $_POST["c"];
$maxJolly = 2;
$jolliesGiven = 0;

$total_bet = $bet*$c_val;
$total_bet = sprintf ("%01.2f", $total_bet); 

// Real Time check for user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 
//if ($user_balance < $total_bet) { exit; }

//Location ID
define("LOCID", substr($userid,0,3));
define("USERID",$userid);

// Update User
//mysql_query("update `users` set `lplay_date`=".time()." where `userid`=$userid");
mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");

//Genuine User Check
//if ($userid == 0) { exit; }

// start game;
do{
	$c_val = $_POST["c"];
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


	$payLines = array(array($n6, $n7, $n8, $n9, $n10), array($n1, $n2, $n3, $n4, $n5), array($n11, $n12, $n13, $n14, $n15), array($n1, $n7, $n13, $n9, $n5), array($n11, $n7, $n3, $n9, $n15), array($n1, $n2, $n8, $n4, $n5), array($n11, $n12, $n8, $n14, $n15), array($n6, $n2, $n3, $n4, $n10), array($n6, $n12, $n13, $n14, $n10));

	$win = countResult();
	$win = $win * $c_val;
	$win = sprintf ("%01.2f", $win);

	$maxwin=calWinLimit();
}while($win>$maxwin);

//update games and transactions
$win_limit = sprintf ("%01.2f", $maxwin); 
$diff=$win-$total_bet;
$diff = sprintf ("%01.2f", $diff);
if($diff>=0){$rg="w";}else{$rg="l";}
	//auto cashout
	$co_amount=$total_bet/10;
	$co_amount = sprintf ("%01.2f", $co_amount);
//	$co_amount = -$co_amount;
	$tm=time();
	mysql_query("insert into `transactions` values('', '0', '0', '$tm', 'co', '$co_amount', '$userid')");
$tm=time();
mysql_query("insert into `games` values('', '$userid', '$tm', '$total_bet', '-1', '$rg', '$diff', '52')");
$gameid=mysql_insert_id();
mysql_query("insert into `transactions` values('', '$userid', '$gameid', '$tm', '$rg', '$diff', '$win_limit')");

//user balance
//Optimized
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

// send answer
$answer="&ans=res&&ub=".$user_balance."&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9."&n10=".$n10."&n11=".$n11."&n12=".$n12."&n13=".$n13."&n14=".$n14."&n15=".$n15;

echo $answer;
?>
