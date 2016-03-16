<?php

	class WinObject {		
		
		public $payline = 0;
		public $startRow = 0;
		public $rowCount = 0;
		public $type = 0;
		public $scatter = false;
		
		
	}
	
	function getWinByPayTable($symbol, $row) {
		$payTable = array(0, array(0, 0, 10, 100, 2000, 15000), array(0, 0, 2, 10, 500, 2000), array(0, 0, 0, 10, 200, 1000), array(0, 0, 0, 10, 100, 500), array(0, 0, 0, 5, 50, 100), array(0, 0, 0, 5, 25, 100), array(0, 0, 0, 5, 25, 100), array(0, 0, 0, 5, 25, 100), array(0, 0, 0, 5, 25, 100), array(0, 0, 0, 5, 25, 100));
		echo "__   payTable[symbol][row]: ".$payTable[$symbol][$row].", symbol: ".$symbol.", row: ".$row.", <br>";
		return $payTable[$symbol][$row];		
	}
	

	function refreshVars() {
		global $symbolSet, $payLines, $n1, $n2, $n3, $n4, $n5, $n6, $n7, $n8, $n9, $n10, $n11, $n12, $n13, $n14, $n15;
		
		$symbolSet = array($n1, $n2, $n3, $n4, $n5, $n6, $n7, $n8, $n9, $n10, $n11, $n12, $n13, $n14, $n15);
		
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
	
	function countBonusWin($array, $maxZeros) {
		$sum = 0;
		$zeros = 0;
		for ($i = 0; $i < count($array); $i++) {
			if ($array[$i] == 0) {
				++$zeros;
				if ($zeros == $maxZeros) {
					return $sum;
				}
			} else {
				$sum = $sum + $array[$i];
			}
		}
		return $sum;
	}
	
	
	$n1 = 11; $n2 = 1; $n3 = 13; $n4 = 3; $n5 = 10; $n6 = 5; $n7 = 2; $n8 = 14; $n9 = 6; $n10 = 4; $n11 = 10; $n12 = 11; $n13 = 10; $n14 = 10; $n15 = 13;
	
	
	
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
	
	
	$win = countResult();
	
	echo "<br/>";
	echo "<pre>";
	echo $n1."&#9;".$n2."&#9;".$n3."&#9;".$n4."&#9;".$n5."<br/>";
	echo $n6."&#9;".$n7."&#9;".$n8."&#9;".$n9."&#9;".$n10."<br/>";
	echo $n11."&#9;".$n12."&#9;".$n13."&#9;".$n14."&#9;".$n15."<br/>";
	echo "<pre/>";
	echo "counter: ".$counter."<br/>";
	
	echo "<br/>".$win;
?>