<?PHP
##############################################################################
# PROGRAM : Casino System                                                    #
# VERSION : 2.00                                                             #
# REVISION: 000										     #
# DATE    : 01/06/2006                                                       #
##############################################################################
# All source code, images, programs, files included in this package          #
# Copyright (c) 2003-2004                                                    #
#		    XL Corp.		  						     #
#           www.xlcorp.co.uk                                                 #
#           www.start-your-casino.com                                        #
#           All Rights Reserved.                                             #
##############################################################################
#                                                                            #
#    While we distribute the source code for our scripts/software and you    #
#    are allowed to edit them to better suit your needs, we do not           #
#    support modified code.  Please see the license prior to changing        #
#    anything. You must agree to the license terms before using this         #
#    software package or any code contained herein.                          #
#                                                                            #
#    Any redistribution without permission of XL Corp.                       #
#    is strictly forbidden.                                                  #
#                                                                            #
##############################################################################

class {

}

//if ($_SERVER["SERVER_NAME"] != "www.earthgambles.com") { exit; }
error_reporting(0);
require('../scripts/connect.php');

///////////////////// functions //////////////////////
function calWinLimit(){
	$result=mysql_query("select * from `settings` where `type`='53'");
	$xdate=mysql_result($result, 0, "date");
	$coef=mysql_result($result, 0, "coef");
	// Get max. win. amount for Location ID
	$locID=LOCID;
	list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `transactions` WHERE `date`>$xdate AND ((type='w'  AND userid LIKE '$locID%') OR (type='l'  AND userid LIKE '$locID%')  OR (type='co'  AND comments LIKE '$locID%'))"));
	$balance=-$balance;
	$maxwin=$balance*$coef/100;
	if($maxwin<0){ $maxwin=0; }
	return $maxwin;
}
//
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
//
function countLine($a, $b, $c, $line){
	global $win, $c_val;
	if( ($a==$b)&&($b==$c) ){
		if($a==1){ // Highlight field 1, Jackpots
			switch($line){
				case 1: $win+=1000*$c_val; break;
				case 2: $win+=1500*$c_val; break;
				case 3: $win+=2000*$c_val; break;
				case 4: $win+=2500*$c_val; break;
				case 5: $win+=3000*$c_val; break;
			}
		} else {		
			switch ($a) {
				case 2: $win += 80 * $c_val; break;				
				case 3: $win += 60 * $c_val; break;				
				case 4: $win += 40 * $c_val; break;				
				case 5: $win += 10 * $c_val; break;				
			}
		}
	}else{
		if (($a>2)&&($a<6)&&($b>2)&&($b<6)&&($c>2)&&($c<6)){ $win+=4*$c_val; } //Any Bar

	}
}

function countResult():Void {
	// n1  n2  n3  n4  n5
	// n6  n7  n8  n9  n10
	// n11 n12 n13 n14 n15
	$payLines = array(array(6, 7, 8, 9, 10), array(1, 2, 3, 4, 5), array(11, 12, 13, 14, 15), array(1, 7, 8, 9, 5), array(11, 7, 8, 9, 15), array(1, 2, 8, 4, 5), array(11, 12, 8, 14, 15), array(6, 2, 3, 4, 10), array(6, 12, 13, 14, 15));
	
	$wins = array();
	$winObj = {};

	$paylineWins = [];
	for ($i = 0; $i < bet; $i++) {		
		$paylineWins = [];
		$winObj = {};
		$winObj.payline = $i;
		$winObj.startRow = 0;
		$winObj.rowCount = 1;
		$iStart = 0;
		for ($k = 0; $k < 5; k++) {
			if ($payLines[$i][$k]._currentframe != JOLLY) {
				$winObj.type = $payLines[$i][$k]._currentframe;
				$winObj.rowCount = k+1;
				$iStart = $k + 1;
				$k = 5;
			}
		}

		for ($j = $iStart; $j < 5; j++) {
			if ($payLines[$i][$j]._currentframe == $payLines[$i][$j - 1]._currentframe || $payLines[$i][$j]._currentframe == JOLLY) {
				$winObj.rowCount++;
			} else if ($payLines[$i][$j - 1]._currentframe == JOLLY) {
				if ($winObj.type == $payLines[$i][$j]._currentframe) {
					$winObj.rowCount++;
				} else {
					if ($winObj.rowCount > 2) {
						$paylineWins.push($winObj);
					} else if ($winObj.rowCount > 1 && $winObj.type < 5) {
						$paylineWins.push($winObj);
					} else if ($winObj.type == 1) {
						$paylineWins.push($winObj);
					}
					$winObj = {};
					$winObj.payline = $i;
					$winObj.type = $payLines[$i][$j]._currentframe;
					$winObj.rowCount = 2;
					$winObj.startRow = j-1;
				}
			} else {
				if ($winObj.rowCount > 2) {
					$paylineWins.push($winObj);
				} else if ($winObj.rowCount > 1 && $winObj.type < 5) {
					$paylineWins.push($winObj);
				} else if ($winObj.type == 1) {
					$paylineWins.push($winObj);
				}
				$winObj = {};
				$winObj.payline = $i;
				$winObj.type = $payLines[i][$j]._currentframe;
				$winObj.rowCount = 1;
				$winObj.startRow = j;
			}
			//currentItemNum = payLines[i][$j]._currentframe;
			//symbols[currentItemNum]++;
		}
		
		//trace ("wins.length: "+wins.length);
		if ($winObj.rowCount > 2) {
			$paylineWins.push($winObj);
		} else if ($winObj.rowCount > 1 && $winObj.type < 5) {
			$paylineWins.push($winObj);
		} else if ($winObj.type == 1) {
			$paylineWins.push($winObj);
		}

		if ($paylineWins.length > 2) {
			wins.push($paylineWins[0]);
		} else if ($paylineWins.length > 1) {			
			var win1:Number = getWinByPayTable($paylineWins[0].type, $paylineWins[0].rowCount);
			var win2:Number = getWinByPayTable($paylineWins[1].type, $paylineWins[1].rowCount);
			win1 > win2 ? $wins.push($paylineWins[0]) : $wins.push($paylineWins[1]);
		} else if ($paylineWins.length > 0) {
			$wins.push($paylineWins[0]);
		}
	}
}

//
function Game(){
	global $betcc, $n1, $n2, $n3, $n4, $n5, $n6, $n7, $n8, $n9, $n10, $n11, $n12, $n13, $n14, $n15;
	// n1  n2  n3  n4  n5
	// n6  n7  n8  n9  n10
	// n11 n12 n13 n14 n15
	switch($betcc){
		case 5: if( countLine($n7, $n5, $n3, 5) ){ break; } // count result on lines 5-1
		case 4: if( countLine($n1, $n5, $n9, 4) ){ break; } // count result on lines 4-1
		case 3: if( countLine($n7, $n8, $n9, 3) ){ break; } // count result on lines 3-1
		case 2: if( countLine($n1, $n2, $n3, 2) ){ break; } // count result on lines 2-1
		case 1: if( countLine($n4, $n5, $n6, 1) ){ break; } // count result on line 1
	}
}

///////////////////// MAIN //////////////////////

if( !isset($_POST["b"]) ){ exit; }
if( !isset($_POST["l"]) ){ exit; }
if( !isset($_POST["c"]) ){ exit; }

if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
if(!empty ($result) ) { //Check session
	$userid=mysql_result($result, 0, "userid");
} else { exit; }

$bet = $_POST["b"];
$bet = sprintf ("%01.2f", $bet);
$betcc = $_POST["l"];
$c_val = $_POST["c"];

//Location ID
define("LOCID", $userid[0]);

// Update User
mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");

//Get Jackpot Amount
//TODO Define (Jackpot)
$result=mysql_query("select `amount` from `jackpot` where `type`='53'");
$jackpot = mysql_result($result, 0, "amount");

//Jolly max symbols, flash is designed for 2 symbols
$maxJolly = 2;
$jolliesGiven = 0;

// start game;
do {
	$win=0;
	$n1 = Gen();	
	$n2 = Gen();	
	$n3=Gen();
	$n4=Gen();
	$n5=Gen();
	$n6=Gen();
	$n7=Gen();
	$n8=Gen();
	$n9 = Gen();
	$n10 = Gen();
	$n11 = Gen();
	$n12 = Gen();
	$n13 = Gen();
	$n14 = Gen();
	$n15 = Gen();
	
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