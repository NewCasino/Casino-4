
<?PHP
	
	class WinObject {		
		
		public $payline = 0;
		public $startRow = 0;
		public $rowCount = 0;
		public $type = 0;
		public $scatter = false;
		
		
	}
	
	
	//FUNCTIONS
	function getWinByPayTable($symbol, $row) {
		$payTable = array(0, array(0, 0, 10, 100, 2000, 15000), array(0, 0, 2, 10, 500, 2000), array(0, 0, 0, 10, 200, 1000), array(0, 0, 0, 10, 100, 500), array(0, 0, 0, 5, 50, 100), array(0, 0, 0, 5, 25, 100), array(0, 0, 0, 5, 25, 100), array(0, 0, 0, 5, 25, 100), array(0, 0, 0, 5, 25, 100), array(0, 0, 0, 5, 25, 100));
		return $payTable[$symbol][$row];		
	}
	
	function getFreeSpinsNum($symbols) {
		if ($symbols < 3) {
			return 0;
		}
		switch ($symbols) { 
			case 3: return 10;	
			case 4: return 15;
			default : return 25;
		}
	}
	
	function countResult() {
		// n1  n2  n3  n4  n5
		// n6  n7  n8  n9  n10
		// n11 n12 n13 n14 n15
		
		global $b_game, $nLines, $symbolSet, $payLines, $pyramidBonus, $kingBonus;
		
		
		$pyramidBonus = false;
		$kingBonus = false;
		
		if (!isset($nLines)) {
			$nLines = 20;
		}
		
		$JACKPOT = 11;
		$KING_BONUS = 12;
		$PYRAMID_BONUS = 13;
		$FREE_SPIN = 14;
		$SCATTER = 5;
		
		
		$symHistogram = array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
		for ($i = 0; $i < 15; $i++) {
			$curSymbol = $symbolSet[$i];				
			$symHistogram[$curSymbol] = $symHistogram[$curSymbol] + 1;
		}			
		if ($symHistogram [$JACKPOT] == count($symHistogram)) {
			//jackpot logic here
			return;
		}
		
		if ($symHistogram[$KING_BONUS] > 2) {
			//king bonus logic here
			$kingBonus = true;
		}			
		
		if ($symHistogram[$PYRAMID_BONUS] > 2) {
			//pyramid bonus logic here	
			$pyramidBonus = true;
		}
	
		$freeSpinsNum = getFreeSpinsNum($symHistogram[$FREE_SPIN]);
		
		
		
		$wins = array();
		$winObj = new WinObject();
		$paylineWins = array();
		$wildReels = array(false, false, false, false, false);



		//if we have jackpot symbol on 2,3, or 4 reel it will act as wild on that reel
		if ($symHistogram [$JACKPOT] > 0) {
			//where they are?
			for ($i = 0; $i < 15; $i++) {
				$reel = $i % 5;
				if ($symbolSet[$i] == $JACKPOT && ($reel > 0 && $reel < 4)) {
					$wildReels[$reel] = true;
				}
			}
		}
		
		
		
		for ($i = 0; $i < $nLines; $i++) {
			$lineHistogram = array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			for ($ii = 0; $ii < 5; $ii++) {
				$curFrame = $payLines[$i][$ii];				
				echo $curFrame."<br>";
				//$curSymbol = $symbolSet[$curFrame];
				$lineHistogram[$curFrame] = $lineHistogram[$curFrame] + 1;
			}
			
			
			//check scatter
			$scatters = $lineHistogram[$SCATTER] + $lineHistogram[$JACKPOT];
			print_r($lineHistogram);
			echo $i."<br>";
			
			if ($scatters > 2) {			
				$winObj = new WinObject();
				$winObj->type = $SCATTER;
				$winObj->payline = $i;
				$winObj->scatter = true;
				$winObj->rowCount = $scatters;
				$wins[] = $winObj;
				continue;
			}
			
			//echo "<br>winObj->type: ".$winObj->type;
			
			$symNum = $payLines[$i][0];

			if ($symNum >= $JACKPOT || $symNum == $SCATTER) {
				continue;
			}

			$winObj = new WinObject();
			$winObj->payline = $i;
			$winObj->startRow = 0;
			$winObj->type = $symNum;
			
			
			
			
			for ($j = 1; $j < 5; $j++) {
				$currentSym = $payLines[$i][$j];
				if ($currentSym != $winObj->type && !$wildReels[$j]) {				
					$win = getWinByPayTable($winObj->type, $j);
					if ($win > 0) {
						$winObj->rowCount = $j;
						$wins[] = $winObj;						
					}
					break;
				}
			}
		}
		
		$totalWin  = 0;
		
		for ($i = 0; $i < count($wins); $i++) {
			$paylineNum = $wins[$i]->payline + 1;
			//echo "__        ".$payTable[$symbol][$row]."     ".$symbol."     ".$row." <br>";
			//echo "__ win  ".getWinByPayTable($wins[$i]->symbol, $wins[$i]->rowCount)."   payline ".$paylineNum."     rowCount  ".$wins[$i]->rowCount."    symbol  ".$wins[$i]->symbol." <br>";
			$totalWin = $totalWin + getWinByPayTable($wins[$i]->type, $wins[$i]->rowCount);
		}
		
		return $totalWin;
	}
	
	function makeRandomArray($length, $maxNumber, $zeroQty) {
		if (!$zeroQty) {
			$zeroQty = 0;
		}
		
		$arr = array();
		$indexes = array();
		for ($i = 0; $i < $length; $i++) {
			$arr[] = rand(1, $maxNumber);
			$indexes[] = $i;
		}
		
		for ($i = 0; $i < $zeroQty; $i++) {
			$index = rand(0, count($indexes)-1);			
			$index2 = $indexes[$index];
			$arr[$index2] = 0;
			unset($indexes[$index]);
			$indexes = array_values($indexes);			
		}
		
		
		return $arr;
	}
	
	function arrayToString($array) {
		$str = '';
		for ($i = 0; $i < count($array); $i++) {
			$str = $str.$array[$i];
			if ($i + 1 != count($array)) {
				$str = $str.'!';
			}
		}
		return $str;
	}
	
	function Gen() {
		global $maxJolly, $jolliesGiven;
		
		$again = true;
		while ($again) {
			$n = 0;
			$res = rand(0, 120);			
			if ($res < 120 && $res >= 114) {
				$n = 14;
			} elseif ($res < 114 && $res >= 108) {
				$n = 13;
			} elseif ($res < 108 && $res >= 102) {
				$n = 12;
			} elseif ($res <= 102 && $res >= 96) {
				$n = 11;
			} elseif ($res < 96 && $res >= 90) {
				$n = 10;
			} elseif ($res < 90 && $res >= 80) {
				$n = 9;
			} elseif ($res < 80 && $res >= 70) {
				$n = 8;
			} elseif ($res < 70 && $res >= 60) {
				$n = 7;
			} elseif ($res < 60 && $res >= 50) {
				$n = 6;
			} elseif ($res < 50 && $res >= 40) {
				$n = 5;
			} elseif ($res < 40 && $res >= 30) {
				$n = 4;
			} elseif ($res < 30 && $res >= 20) {
				$n = 3;
			} elseif ($res < 20 && $res >= 10) {
				$n = 2;
			} elseif ($res < 10 && $res >= 0) {
				$n = 1;
			}

			if ($n == 16) {
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
	
	function calWinLimit() {	
		$locID = LOCID;		
		$userid = USERID;		
		$type = $locID."53";		
		list($coef) = mysql_fetch_row(mysql_query("SELECT coef FROM settings WHERE `type`='$type'"));		
		list($resetdate) = mysql_fetch_row(mysql_query("SELECT date FROM transactions WHERE gameid=0 AND type='co' AND comments='$userid' ORDER BY transid ASC LIMIT 1"));
		list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `transactions` WHERE `date`>$resetdate AND ((type='w' AND userid='$userid') OR (type='l' AND userid='$userid') OR (type='co' AND comments='$userid'))"));
		$balance = -$balance;		
		$maxwin = $balance * $coef / 100;		
		if ($maxwin < 0) { 
			$maxwin = 0; 
		} else {		
			//Force Lost
			$chance = rand(0, 99);			
			if ($chance > $coef) {			
				$maxwin = 0;				
			}
		}
		return $maxwin;
	}
	//
	
	/*
	
	// MAIN SCRIPT FLOW
	error_reporting(0);
	require('../scripts/connect.php');
	
	
	if ( !isset($_POST["tb"]) ) { exit; }	
	if ( !isset($_POST["l"]) ) { exit; }
	
	$bet = $_POST["b"];
	$bet = sprintf ("%01.2f", $bet);	
	$c_val = $_POST["c"];
	*/
	
			//legend
			/*
			//INPUT DATA
			
			lv.bs = bonus spin (1 or 0);
			lv.tb = total bet
			lv.l = number of bet lines
			lv.a = auto mode (1 or 0);
			lv.dg = double game 0 - half, 1- collect, 2 - double
			lv.dr = double result 0/1
			lv.et = game stage 1 - spin mode, 2 - double game;
			lv.w = win in double game
			
			//OUTPUT DATA
			lv.jp - jackpot number
			lv.gn - gamble numbers, format:"1!0!1!1!1"
			lv.pb - pyramid bonus numbers three stops as 0, format: "23!100!0!5!2111!0!45!11!42!465!0"
			lv.kb - king bonus numbers. one stop as 0, format: "23!100!0!5!2111"
			lv.ub - user balance number
			lv.nX - symbols
			*/
	
	$bet = $_POST["b"];
	$bet = sprintf ("%01.2f", $bet);	
	$c_val = $_POST["c"];
	$nLines = $_POST["c"];
	$auto = $_POST["a"];
	
	if ( !isset($_POST["b"]) ) { $bet = 9; };	
	if ( !isset($_POST["c"]) ) { $c_val = 1; };
	
	
	if (!isset($_POST["bs"])) {
		$b_game = false;
	} else {
		$b_game = $_POST["bs"];
	};
	
	$maxJolly = 2;
	$jolliesGiven = 0;
	$kingBonus = false;
	$pyramidBonus = false;
	
	
	
	
	
	///////////////////changes/////////////////////
	
	if ($_POST["et"] == 2) {
		switch ($_POST["dg"]) { 
			// player wants make half in double game
			case 0: {				
				//TO DO: make half
				//as i can see in the poker game you take the win back from swf this can be easily cheated
				
				//swf makes half and waits for OK and UB, so ltes give it
				
				//demo sample
				echo "&ans=OK2&ub=".$_POST["ub"];
			}
			// player collects win
			case 1: {
				//TO DO: make collect
				
				
				//demo sample
				$balance = $_POST["ub"] + $_POST["w"];				
				echo "&ans=OK2&ub=".$balance;
			}
			// player plays double
			case 2: {
				
				$doubleResult = rand(0,1);
				echo "&ans=OK2&dr=".$doubleResult."&ub=".$_POST["ub"];
			}
		}
	} else {
	
		$win = 0;
		if (!$b_game) {
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
		} else {
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
		}
		
		
		
		// n1  n2  n3  n4  n5
		// n6  n7  n8  n9  n10
		// n11 n12 n13 n14 n15
		$payLines = array(array($n6, $n7, $n8, $n9, $n10), 
						array($n1, $n2, $n3, $n4, $n5), 
						array($n11, $n12, $n13, $n14, $n15), 
						array($n1, $n7, $n13, $n9, $n5), 
						array($n11, $n7, $n3, $n9, $n15), 
						array($n1, $n2, $n8, $n4, $n5), 
						array($n11, $n12, $n8, $n14, $n15), 
						array($n6, $n2, $n3, $n4, $n10), 
						array($n6, $n12, $n13, $n14, $n10), 
						array($n1, $n2, $n8, $n14, $n15), 
						array($n11, $n12, $n8, $n4, $n5),
						array($n1, $n7, $n8, $n9, $n5), 
						array($n11, $n7, $n8, $n9, $n15),
						array($n6, $n7, $n3, $n9, $n10), 
						array($n6, $n7, $n13, $n9, $n10),
						array($n6, $n2, $n8, $n4, $n10), 
						array($n6, $n12, $n8, $n14, $n10),
						array($n1, $n7, $n3, $n9, $n5), 
						array($n11, $n7, $n13, $n9, $n15),
						array($n11, $n2, $n13, $n4, $n15));
						
		$symbolSet = array($n1, $n2, $n3, $n4, $n5, $n6, $n7, $n8, $n9, $n10, $n11, $n12, $n13, $n14, $n15);
		
		$gambleNums = array();
		$pyramidNums = array();	
		$kingNums = array();
		
		$gambleStr = '';
		$pyramidStr = '';
		$kingStr = '';
		
		$win = countResult();
		$win = $win * $c_val;
		
		
		
		
		
		if ($win > 0) {
			$gambleNums = makeRandomArray(5, 1, 1);
			$gambleStr = arrayToString($gambleNums);		
		}
		
		if ($kingBonus) {
			$kingNums = makeRandomArray(5, 100, 1);		
			$kingStr = arrayToString($kingNums);
		}
		
		if ($pyramidBonus) {
			$pyramidNums = makeRandomArray(11, 100, 3);		
			$pyramidStr = arrayToString($pyramidNums);
		}
		
		$win = sprintf ("%01.2f", $win);
		$answer="&ans=res&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9."&n10=".$n10."&n11=".$n11."&n12=".$n12."&n13=".$n13."&n14=".$n14."&n15=".$n15."&gn=".$gambleStr."&kb=".$kingStr."&pb=".$pyramidStr;
		echo $answer;
	}
?>

