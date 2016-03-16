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

//if ($_SERVER["SERVER_NAME"] != "www.24hr-bet.com") { exit; }
error_reporting(0);
require('../scripts/connect.php');

///////////////////// functions //////////////////////
function calWinLimit(){
	$result=mysql_query("select * from `settings` where `type`='54'");
	$xdate=mysql_result($result, 0, "date");
	$coef=mysql_result($result, 0, "coef");
	// Get max. win. amount for Location ID
	$locID=LOCID;
	$userid=USERID;
	list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `transactions` WHERE `date`>$xdate AND ((type='w' AND userid='$userid') OR (type='l' AND userid='$userid') OR (type='co' AND comments='$userid'))"));
	$balance=-$balance;
	$maxwin=$balance*$coef/100;
	if($maxwin<0){ $maxwin=0; }
	return $maxwin;
}
//
function Gen(){
	$res=rand(0,100);
	if( $res<=30 ){ $n=6; }
	if( ($res>=30)&&($res<50) ){ $n=5; }
	if( ($res>=50)&&($res<65) ){ $n=4; }
	if( ($res>=65)&&($res<80) ){ $n=3; }
	if( ($res>=80)&&($res<90) ){ $n=2; }
	if($res>=90){ $n=1; }
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
		}else{
			switch ($a){
				case 2: $win+=80*$c_val; break;
				case 3: $win+=60*$c_val; break;
				case 4: $win+=40*$c_val; break;
				case 5: $win+=10*$c_val; break;
			}
		}
	}else{
		if (($a>2)&&($a<6)&&($b>2)&&($b<6)&&($c>2)&&($c<6)){ $win+=4*$c_val; } //Any Bar

	}
}
//
function Game(){
	global $betcc, $n1, $n2, $n3, $n4, $n5, $n6, $n7, $n8, $n9;
	// n1 n2 n3
	// n4 n5 n6
	// n7 n8 n9
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
if(!empty ($result) ){ //Check session
$userid=mysql_result($result, 0, "userid");
}else{ exit; }

$bet=$_POST["b"];
$bet=sprintf ("%01.2f", $bet);
$betcc=$_POST["l"];
$c_val=$_POST["c"];

$total_bet = sprintf ("%01.2f", $bet); 

// Real Time check for user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 
if ($user_balance < $total_bet) { exit; }

//Location ID
define("LOCID", substr($userid,0,3));
define("USERID",$userid);

// Update User
mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");

//Get Jackpot Amount
//TODO Define (Jackpot)
$result=mysql_query("select `amount` from `jackpot` where `type`='54'");
$jackpot=mysql_result($result, 0, "amount");

// start game;
do{
	$win=0;
	$n1=Gen();
	$n2=Gen();
	$n3=Gen();
	$n4=Gen();
	$n5=Gen();
	$n6=Gen();
	$n7=Gen();
	$n8=Gen();
	$n9=Gen();
// Add blanks

// reel 1
	if ($n1!=6) { $n4=6; } // if 1 is not blank, 2 is set to blank
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
	if ($n3!=6) { $n6=6; }
	if (($n3==6)&&($n6==6)){
		do {
			$n6=Gen();
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

	$maxwin=calWinLimit();
}while($win>$maxwin);

//update games and transactions
$win_limit = sprintf ("%01.2f", $maxwin); 
$diff=$win-$bet;
$diff = sprintf ("%01.2f", $diff);
if($diff>=0){$rg="w";}else{$rg="l";
	//auto cashout
	$co_amount=$diff/4;
	$co_amount = sprintf ("%01.2f", $co_amount); 
	$co_amount = -$co_amount;
	$tm=time();
	mysql_query("insert into `transactions` values('', '0', '0', '$tm', 'co', '$co_amount', '$userid')");
}
$tm=time();
mysql_query("insert into `games` values('', '$userid', '$tm', '$bet', '-1', '$rg', '$diff', '54')");
$gameid=mysql_insert_id();
mysql_query("insert into `transactions` values('', '$userid', '$gameid', '$tm', '$rg', '$diff', '$win_limit')");

//Update Jackpot 1/10 of the bet
mysql_query("update `jackpot` set `amount`=`amount`+$bet/10 where `type`='54'");

//Get Jackpot Amount
//TODO Define (Jackpot)
$result=mysql_query("select `amount` from `jackpot` where `type`='54'");
$jackpot=mysql_result($result, 0, "amount");

//user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

// send answer
$answer="&ans=res&ub=".$user_balance."&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9."&jp=".$jackpot;
echo $answer;
?>