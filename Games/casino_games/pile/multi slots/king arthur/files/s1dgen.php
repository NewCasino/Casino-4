<?PHP
##############################################################################
# PROGRAM : Casino System                                                    #
# VERSION : 2.03                                                             #
# REVISION: 015										     #
# DATE    : 01/11/2008                                                       #
##############################################################################
# All source code, images, programs, files included in this package          #
# Copyright (c) 2003-2010                                                    #
#		    XLNET Ltd.		  						     #
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
// demo generator

///////////////////// functions //////////////////////





function Gen() {
	$res = rand(0, 1400);	
	if ($res >= 0 && $res < 100) { $n = 0; }
	elseif ($res >= 100 && $res < 200) { $n = 1; }
	elseif ($res >= 200 && $res < 300) { $n = 2; }
	elseif ($res >= 300 && $res < 400) { $n = 3; }
	elseif ($res >= 400 && $res < 500) { $n = 4; }
	elseif ($res >= 500 && $res < 600) { $n = 5; }
	elseif ($res >= 600 && $res < 700) { $n = 6; }
	elseif ($res >= 700 && $res < 800) { $n = 7; }
	elseif ($res >= 800 && $res < 900) { $n = 8; }
	elseif ($res >= 900 && $res < 1000) { $n = 9; }
	elseif ($res >= 1000 && $res < 1100) { $n = 10; }
	elseif ($res >= 1100) { $n = 11; }
	return $n;
}


function countLine ($a, $b, $c) {
	$symbols = array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);	
	
	$symbols[$a] = $symbols[$a] + 1;	
	$symbols[$b] = $symbols[$b] + 1;	
	$symbols[$c] = $symbols[$c] + 1;
	
	$one1 = -1;
	$one2 = -1;
	$one3 = -1;
	$two = -1;
	$three = -1;
	
	$count = count($symbols);
	
	for ($i = 0; $i < $count; $i++) {
		switch ($symbols[$i]) {
			case 1 : {
				if ($one1 != -1) {
					if ($one2 != -1) {
						$one3 = $i;
						$i = $count + 1;
					} else {
						$one2 = $i;
					}
				} else {					
					$one1 = $i;					
				}
				break;
			}
			case 2 : {
				$two = $i;
				break;
			}
			case 3 : {					
				$three = $i;
				$i = $count + 1;
				break;
			}
		}
	}
	
	if ($three != -1) winSymbol($three, 1);
	elseif ($two == 0) winSymbol($one1, 2);
	elseif ($two != -1 && $one1 == 0) winSymbol($two, 2);
	
	elseif ($one1 > 0 && $one1 < 4 && (($one2 > 0 && $one2 < 4 && $one3 > 0 && $one3 < 4) || ($two > 0 && $two < 4))) winSymbol(15, 1);	//"any golden bars"
	elseif ($one1 == 0 && $one2 > 0 && $one2 < 4 && $one3 > 0 && $one3 < 4) winSymbol(15, 2);											//"any two golden bars + wild"
	elseif ($one1 < 7 && $one1 > 3 && (($one2 < 7 && $one2 > 3 && $one3 < 7 && $one3 > 3) || ($two > 3 && $two < 7))) winSymbol(16, 1);	//"any bars"
	elseif ($one1 == 0 && $one2 < 7 && $one2 > 3 && $one3 < 7 && $one3 > 3) winSymbol(16, 2);											//"any bars + wild"		
	elseif ($one1 < 10 && $one1 > 6 && (($one2 < 10 && $one2 > 6 && $one3 < 10 && $one3 > 6) || ($two > 6 && $two < 10))) winSymbol(17, 1);//"any sevens"
	elseif ($one1 == 0 && $one2 < 10 && $one2 > 6 && $one3 < 10 && $one3 > 6) winSymbol(17, 2);											//"any sevens + wild"	
	elseif ($one1 == 0) winSymbol(19, 1);																							//"one wild"
}

function winSymbol($sym, $multiplier) {
	//echo ($sym."<br>");
	global $win, $bet;
	$lineWin = 0;
	switch ($sym) {
		case 0 : $lineWin = ($bet/3) * 1000; break;
		case 1 : $lineWin = ($bet/3) * 300 * $multiplier; break;
		case 2 : $lineWin = ($bet/3) * 200 * $multiplier; break;
		case 3 : $lineWin = ($bet/3) * 100 * $multiplier; break;
		case 4 : $lineWin = ($bet/3) * 50 * $multiplier; break;
		case 5 : $lineWin = ($bet/3) * 35 * $multiplier; break;
		case 6 : $lineWin = ($bet/3) * 20 * $multiplier; break;
		case 7 : $lineWin = ($bet/3) * 15 * $multiplier; break;
		case 8 : $lineWin = ($bet/3) * 10 * $multiplier; break;
		case 9 : $lineWin = ($bet/3) * 5 * $multiplier; break;
		case 10 : $lineWin = ($bet/3) * 1 * $multiplier; break;
		
		case 15 : $lineWin = ($bet/3) * 20 * $multiplier; break;  		//"any golden bars"
		case 16 : $lineWin = ($bet/3) * 5 * $multiplier; break; 	//"any bars"
		case 17 : $lineWin = ($bet/3) * 2 * $multiplier; break;		//"any sevens"
		case 18 : $lineWin = ($bet/3) * 5 * $multiplier; break;		//"two wilds"
		case 19 : $lineWin = ($bet/3) * 2 * $multiplier; break;		//"one wild"
		
	}
	
	$win = $lineWin + $win;
}

function weHaveBonus($a,$b,$c) {
	$bon = true;
	if (($a != "11" && $a != "0") || ($b != "11" && $b != "0") || ($c != "11" && $c != "0") || (($a == "0") && ($b == "0") && ($c == "0"))) {
		$bon = false;
	}
	
	//check if bet is enough for bonus game
	/*if (c_val < 0.5) {
		$bon = false;
	}*/
	
	return $bon;
}

///////////////////// MAIN //////////////////////
//error_reporting(E_ALL);
//include("../scripts/config.php");
//$connection=mysql_connect($host,$user,$password);
//if(!$connection){ exit; }
//mysql_select_db($dbname);

if( !isset($_POST["b"]) ) { $bet = 1; } else {$bet = $_POST["b"];};
if( !isset($_POST["et"]) ) { $hold = 1; } else {$hold = $_POST["et"];};
if( isset($_POST["m"]) ) { $multiplier = $_POST["m"]; } else { $multiplier = 1; };



$bet = sprintf ("%01.2f", $bet); 
$win = 0;
// start game;

	if ($hold == 1) {
		if ($_POST["hc1"] != "1") {
			$n1 = Gen();
			$n4 = Gen();
			$n7 = Gen();
			$n10 = Gen();
			$n13 = Gen();
		} else {
			$n1 = $_POST["n1"];
			$n4 = $_POST["n1"];
			$n7 = $_POST["n1"];
			$n10 = $_POST["n1"];
			$n13 = $_POST["n1"];
		}
		if ($_POST["hc2"] != "1") {
			$n2 = Gen();
			$n5 = Gen();
			$n8 = Gen();
			$n11 = Gen();
			$n14 = Gen();
		} else {
			$n2 = $_POST["n2"];
			$n5 = $_POST["n2"];
			$n8 = $_POST["n2"];
			$n11 = $_POST["n2"];
			$n14 = $_POST["n2"];
		}
		if ($_POST["hc3"] != "1") {
			$n3 = Gen();
			$n6 = Gen();
			$n9 = Gen();
			$n12 = Gen();
			$n15 = Gen();
		} else {
			$n3 = $_POST["n3"];
			$n6 = $_POST["n3"];
			$n9 = $_POST["n3"];
			$n12 = $_POST["n3"];
			$n15 = $_POST["n3"];
		}
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
	
	
	
	//testing
	/*
	Symbol positions
	
	13 14 15
	10 11 12
	7  8  9
	4  5  6
	1  2  3
	*/
	/*
	if ($hold == 0) {
		$n1=11;
		$n2=11;
		$n3=0;
		
	} else {
		
	}
	*/
	
	//remove 2 blank in a row
	/*
	if (($n1 == 0) && ($n4 == 0)) { $n1 = Gen(); }	
	if (($n4 == 0) && ($n7 == 0)) { $n7 = Gen(); }	
	if (($n2 == 0) && ($n5 == 0)) { $n2 = Gen(); }	
	if (($n5 == 0) && ($n8 == 0)) { $n8 = Gen(); }	
	if (($n3 == 0) && ($n6 == 0)) { $n3 = Gen(); }	
	if (($n6 == 0) && ($n9 == 0)) { $n9 = Gen(); }*/
	
	//if lv.et is 1 this means second stage where we need to count result
	// lv.et == 0 means just generate all new symbols and let user hold some of them
	if ($hold == 1) {
		countLine($n1, $n2, $n3);
		countLine($n4, $n5, $n6);
		countLine($n7, $n8, $n9);		
		$win = sprintf ("%01.2f", $win); 
	} else {		
		$win = 0;
	}
	
	
	$bwin = "0,0,0";
	
	if (weHaveBonus($n1, $n2, $n3) || weHaveBonus($n4, $n5, $n6) || weHaveBonus($n7, $n8, $n9)) {
		//only integers 0-15 here
		$bwin = "1,2,3,5,1,5,10";
	}
	
	// send answer
	$answer="&ans=res&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9."&n10=".$n10."&n11=".$n11."&n12=".$n12."&bwin=".$bwin;
	echo $answer;
?>