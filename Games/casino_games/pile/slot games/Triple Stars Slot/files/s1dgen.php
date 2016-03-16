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

function countLine($a, $b, $c) {
	global $win, $bet;
	if (($a == $b) && ($b == $c)) {
		setWinByNum($a);
	} elseif ((($a == $b) && ($c == 1) || ($b == $c) && ($a == 1)) && ($b != 0)) {
		// wild - any 2 eq symbols
		setWinByNum($b);
	} elseif (($a == $c) && ($b == 1)) {
		// wild - any 2 eq symbols	
		setWinByNum($c);
	} elseif (($a == $c) && ($a == 1)) {
		// wild - any - wild
		if ($b != 0) {
			setWinByNum($b);
		} else {
			setWinByNum(7);
		}
		setWinByNum($b);
	} elseif (($b == $c) && ($b == 1)) {
		// any - wild - wild
		if ($a != 0) {
			setWinByNum($a);
		} else {
			setWinByNum(7);
		}
	} elseif (($b == $a) && ($b == 1)) {
		// wild - wild - any
		if ($c != 0) {
			setWinByNum($c);
		} else {
			setWinByNum(7);
		}
	} else {
		if ($a > 0 && $b > 0 && $c > 0) {
			setWinByNum(8);
		//Any one wild
		} else if ($a == 1 || $b == 1 || $c == 1) {
			setWinByNum(9);
		}
	}
}

function setWinByNum($num) {
	global $win, $bet;
	switch ($num) {
		case 1: $win = 1500 * $bet; break;
		case 2: $win = 150 * $bet; break;
		case 3: $win = 80 * $bet; break;
		case 4: $win = 40 * $bet; break;
		case 5: $win = 25 * $bet; break;
		case 6: $win = 20 * $bet; break;
		case 7: $win = 10 * $bet; break;
		case 8: $win = 5 * $bet; break;
		case 9: $win = 2 * $bet; break;
	}
}

///////////////////// MAIN //////////////////////
//error_reporting(E_ALL);
//include("../scripts/config.php");
//$connection=mysql_connect($host,$user,$password);
//if(!$connection){ exit; }
//mysql_select_db($dbname);

if( !isset($_POST["b"]) ){ exit; }
$bet=$_POST["b"];
$bet = sprintf ("%01.2f", $bet); 

// start game;
	$win=0;
	$n1=Gen();
	$n2=Gen();
	$n3=Gen();
	$n4=Gen();
	$n5=Gen();
	$n6=Gen();
	$n7=Gen();
	$n8=Gen();
	$n9 = Gen();	
	
	
	//testing
	/*$n4=1;
	$n5=2;
	$n6=1;*/
	
	
//remove 2 blank in a row
	if (($n1==0)&&($n4==0)){$n1=Gen();}
	if (($n4==0)&&($n7==0)){$n7=Gen();}
	if (($n2==0)&&($n5==0)){$n2=Gen();}
	if (($n5==0)&&($n8==0)){$n8=Gen();}
	if (($n3==0)&&($n6==0)){$n3=Gen();}
	if (($n6==0)&&($n9==0)){$n9=Gen();}
	countLine($n4, $n5, $n6);
$win = sprintf ("%01.2f", $win); 
// send answer
$answer="&ans=res&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9;
echo $answer;
?>