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
	$res = rand(0, 750);	
	if ( ($res >= 0) && ($res < 100) ) { $n = 6; }
	if ( ($res >= 100) && ($res < 200) ) { $n = 5; }
	if ( ($res >= 200) && ($res < 300) ) { $n = 4; }
	if ( ($res >= 300) && ($res < 400) ) { $n = 3; }
	if ( ($res >= 400) && ($res < 500) ) { $n = 2; }
	if ($res >= 500 && ($res < 600)) { $n = 1; }
	if ($res >= 600) { $n = 0; }
	return $n;
}
//

function countLine($a, $b, $c, $d) {	
	$symbols = array(0, 0, 0, 0, 0, 0, 0, 0, 0);	
	$symbols[$a] = $symbols[$a] + 1;	
	$symbols[$b] = $symbols[$b] + 1;	
	$symbols[$c] = $symbols[$c] + 1;	
	$symbols[$d] = $symbols[$d] + 1;
	
	$four = 0;
	$three = 0;
	
	$count = count($symbols);
	
	
	for ($i = 0; $i < $count; $i++) {
		
		if ($symbols[$i] > 3) {		
			$four = $i;			
		} else if ($symbols[$i] > 2) {		
			$three = $i;
		}
	}
	
	//trace()
	if ($four != 0) {
		setWinByNum($four, 4);
	} else if ($three != 0) {
		setWinByNum($three, 3);
	}
}

function setWinByNum($num, $numSymbols) {
	global $win, $bet, $multiplier;
	if ($numSymbols == 4) {	
		switch ($num) {
			case 1: $win = 1000 * $bet * $multiplier; break;
			case 2: $win = 320 * $bet * $multiplier; break;
			case 3: $win = 160 * $bet * $multiplier; break;
			case 4: $win = 80 * $bet * $multiplier; break;
			case 5: $win = 40 * $bet * $multiplier; break;
			case 6: $win = 20 * $bet * $multiplier; break;
			case 7: $win = 10 * $bet * $multiplier*2; break;
		}
	} else if ($numSymbols == 3) {
		switch ($num) {
			case 1: $win = 100 * $bet * $multiplier; break;
			case 2: $win = 32 * $bet * $multiplier; break;
			case 3: $win = 16 * $bet * $multiplier; break;
			case 4: $win = 8 * $bet * $multiplier; break;
			case 5: $win = 4 * $bet * $multiplier; break;
			case 6: $win = 2 * $bet * $multiplier; break;
			case 7: $win = 1 * $bet * $multiplier; break;
		}
	}
}

///////////////////// MAIN //////////////////////
//error_reporting(E_ALL);
//include("../scripts/config.php");
//$connection=mysql_connect($host,$user,$password);
//if(!$connection){ exit; }
//mysql_select_db($dbname);

if( !isset($_POST["b"]) ) { exit; }
if( !isset($_POST["et"]) ) { exit; }
if( isset($_POST["m"]) ) { $multiplier = $_POST["m"]; } else { $multiplier = 1; }

$hold = $_POST["et"];
$bet = $_POST["b"];
$bet = sprintf ("%01.2f", $bet); 

// start game;

	if ($hold == 1) {
		if ($_POST["n1"] == "-1") {
			$n1 = Gen();
			$n2 = Gen();
			$n3 = Gen();
		} else {
			$n1 = $_POST["n1"];
			$n2 = $_POST["n2"];
			$n3 = $_POST["n3"];
		}
		if ($_POST["n4"] == "-1") {
			$n4 = Gen();
			$n5 = Gen();
			$n6 = Gen();
		} else {
			$n4 = $_POST["n4"];
			$n5 = $_POST["n5"];
			$n6 = $_POST["n6"];
		}
		if ($_POST["n7"] == "-1") {
			$n7 = Gen();
			$n8 = Gen();
			$n9 = Gen();
		} else {
			$n7 = $_POST["n7"];
			$n8 = $_POST["n8"];
			$n9 = $_POST["n9"];
		}
		if ($_POST["n10"] == "-1") {
			$n10 = Gen();
			$n11 = Gen();
			$n12 = Gen();
		} else {
			$n10 = $_POST["n10"];
			$n11 = $_POST["n11"];
			$n12 = $_POST["n12"];
		}
	} else {
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
	}
	
	
	/*
	Symbol positions
	1 4 7 10
	2 5 8 11
	3 6 9 12
	*/
	
	if ($hold == 0) {
		$n2=6;
		$n5=3;
		$n8=5;
		$n11=2;
	} else {
		$n2=8;
		$n5=8;
		$n8=8;
		$n11=8;
	}
	
	//testing
	/*
	*/
	
	//remove 2 blank in a row
	if (($n1 == 0) && ($n4 == 0)) { $n1 = Gen(); }	
	if (($n4 == 0) && ($n7 == 0)) { $n7 = Gen(); }	
	if (($n2 == 0) && ($n5 == 0)) { $n2 = Gen(); }	
	if (($n5 == 0) && ($n8 == 0)) { $n8 = Gen(); }	
	if (($n3 == 0) && ($n6 == 0)) { $n3 = Gen(); }	
	if (($n6 == 0) && ($n9 == 0)) { $n9 = Gen(); }
	
	//if lv.et is 1 this means second stage where we need to count result
	// lv.et == 0 means just generate all new symbols and let user hold some of them
	if ($hold == 1) {
		countLine($n2, $n5, $n8, $n11);	
		$win = sprintf ("%01.2f", $win); 
	} else {		
		$win = 0;
	}
	
	$bwin = "0,0,0";
	
	if (($n2 == $n5) && ($n8 == $n11) && ($n5 == $n8) && ($n2 == 8)) {
		$bwin = "5,0,10";
	}
	
	// send answer
	$answer="&ans=res&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9."&n10=".$n10."&n11=".$n11."&n12=".$n12."&bwin=".$bwin;
	echo $answer;
?>