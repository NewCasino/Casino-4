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

if ($_SERVER["SERVER_NAME"] != "www.casablanca-casino.co.uk") { exit; }
error_reporting(0);
require('../scripts/connect.php');
///////////////////// functions //////////////////////
function calWinLimit(){
	$result=mysql_query("select * from `settings` where `type`='54'");
	$xdate=mysql_result($result, 0, "date");
	$coef=mysql_result($result, 0, "coef");

	// Get max. win. amount
	list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `games` where `date`>$xdate"));
	$balance=-$balance;
	list($cashout) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `transactions` where `date`>$xdate AND `type`='co'"));
	$balance=($balance-$cashout);

	$maxwin=$balance*$coef/100;
	if($maxwin<0){ $maxwin=0; }
	return $maxwin;
}
//
function Gen(){
	$res=rand(0, 100);
	if( $res<10 ){ $n=6; }
	if( ($res>=10)&&($res<25) ){ $n=5; }
	if( ($res>=25)&&($res<55) ){ $n=4; }
	if( ($res>=55)&&($res<60) ){ $n=3; }
	if( ($res>=60)&&($res<80) ){ $n=2; }
	if($res>=80){ $n=1; }
	return $n;
}
//
function countLine($a, $b, $c){
	global $win, $bet;
	if( ($a==$b)&&($b==$c) ){
		switch ($a){
			case 1: $win=1000*$bet; break;
			case 2: $win=250*$bet; break;
			case 3: $win=50*$bet; break;
			case 4: $win=25*$bet; break;
			case 5: $win=10*$bet; break;
		}
	}else{
		if( ($a==$b)||($b==$c) ){if($b==5){ $win=2*$bet; }} //2x
		if ( ($a>1)&&($a<5)&&($b>1)&&($b<5)&&($c>1)&&($c<5)){ $win=4*$bet; } //Any Bar
		if( ($a==5)&&($b!=5)||($c==5)&&($b!=5)){ $win=1*$bet; } //1x
	}
}

///////////////////// MAIN //////////////////////
if( !isset($_POST["b"]) ){ exit; }
if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
if(!empty ($result) ){ //Check session
$userid=mysql_result($result, 0, "userid");
if ($userid==0) { exit; }
}else{ exit; }
$bet=$_POST["b"];
$bet=sprintf ("%01.2f", $bet);

// Update User
mysql_query("update `users` set `lplay_date`=".time()." where `userid`=$userid");
mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");

//Genuine User Check
if ($userid == 0) { exit; }

//Get Jackpot Amount
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
//remove 2 blank in a reel 
	if (($n1==6)&&($n4==6)){$n1=Gen();}
	if (($n4==6)&&($n7==6)){$n7=Gen();}
	if (($n1==6)&&($n7==6)){$n1=Gen(); $n7=Gen();}

	if (($n2==6)&&($n5==6)){$n2=Gen();}
	if (($n5==6)&&($n8==6)){$n8=Gen();}
	if (($n2==6)&&($n8==6)){$n2=Gen(); $n8=Gen();}

	if (($n3==6)&&($n6==6)){$n3=Gen();}
	if (($n6==6)&&($n9==6)){$n9=Gen();}
	if (($n3==6)&&($n9==6)){$n3=Gen(); $n9=Gen();}

//remove 2 blank on the pay line
	if (($n4==6)&&($n5==6)) {$n4=Gen(); $n5=Gen();}
	if (($n5==6)&&($n6==6)) {$n5=Gen(); $n6=Gen();}
	if (($n4==6)&&($n6==6)) {$n4=Gen(); $n6=Gen();}

	countLine($n4, $n5, $n6);
//Check if JP is won.
	if (($win/1000)==$bet){
		if (($bet==0.75) OR ($bet==1.50) OR ($bet==3.00) OR ($bet==15.00)){
		$win=$jackpot;
// No one will win anyway
//		mysql_query("update `jackpot` set `amount`=`amount`-$jackpot where `type`='54'");
		}
	}
	$maxwin=calWinLimit();
}while($win>$maxwin);

//update games and transactions
$win_limit = sprintf ("%01.2f", $maxwin); 
$diff=$win-$bet;
$diff = sprintf ("%01.2f", $diff);
if($diff>0){$rg="w";}else{$rg="l";}
$tm=time();
mysql_query("insert into `games` values('', '$userid', '$tm', '$bet', '-1', '$rg', '$diff', '54')");
$gameid=mysql_insert_id();
mysql_query("insert into `transactions` values('', '$userid', '$gameid', '$tm', '$rg', '$diff', '$win_limit')");

//Update Jackpot 1/10 of the bet
mysql_query("update `jackpot` set `amount`=`amount`+$bet/10 where `type`='54'");

//user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

// send answer
$answer="&ans=res&ub=".$user_balance."&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9;
echo $answer;
?>
