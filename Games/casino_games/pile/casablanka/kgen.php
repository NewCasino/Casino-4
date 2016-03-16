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
if( isset($_POST["bt"]) ){ $total_bet=$_POST["bt"]; }else{ exit; }
if( isset($_POST["cf"]) ){ $cf=$_POST["cf"]; }else{ exit; }
if ( isset($_POST["tp"]) ){ $game_type=$_POST["tp"]; }else{$game_type=33; }

if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
$userid=mysql_result($result, 0, "userid");

mysql_query("update `users` set `lplay_date`=".time()." where `userid`=$userid");
mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");

//Genuine User Check
if ($userid == 0) { exit; }

/// functions ///
function calWinLimit(){
	if ($_POST["tp"]==31){
		$result=mysql_query("select * from `settings` where `type`='31'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==32){
		$result=mysql_query("select * from `settings` where `type`='32'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==33){
		$result=mysql_query("select * from `settings` where `type`='33'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==34){
		$result=mysql_query("select * from `settings` where `type`='34'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else{
		$result=mysql_query("select * from `settings` where `type`='33'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}

	// Get max. win. amount
	list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `games` where `date`>$xdate"));
	$balance=-$balance;
	list($cashout) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `transactions` where `date`>$xdate AND `type`='co'"));
	$balance=($balance-$cashout);

// Every XX game is lost automatically.
/*
	$result=mysql_query("select * from `transactions` where `date`>$xdate AND (`type`='l' OR `type`='w' OR `type`='co') ");
	$max=mysql_num_rows($result);

	if( !($max%15) ){ $maxwin=-1; } // Every 15th game is lost automatically.
	else{ $maxwin=$balance*$coef/100; }
*/
	$maxwin=$balance*$coef/100;
	if($maxwin<0){ $maxwin=0; }
	return $maxwin;

}
//
function generator(){
	global $hitf;
	do{
		$num=rand(1,80);
		$same=false;
		for($i=0; $i<count($hitf); $i++){
			if($num==$hitf[$i]){ $same=true; break; }
		}
	}while($same);
	return $num;
}

/// variables ///
// Numbers t1-t10 \ Hits 0 - 10
$t1=array(0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0);
$t2=array(0, 1, 9, 0, 0, 0, 0, 0, 0, 0, 0);
$t3=array(0, 0, 3, 37, 0, 0, 0, 0, 0, 0, 0);
$t4=array(0, 0, 2, 7, 66, 0, 0, 0, 0, 0, 0);
$t5=array(0, 0, 1, 3, 23, 200, 0, 0, 0, 0, 0);
$t6=array(0, 0, 0, 2, 12, 90, 400, 0, 0, 0, 0);
$t7=array(0, 0, 0, 1, 6, 36, 165, 500, 0, 0);
$t8=array(0, 0, 0, 1, 3, 14, 65, 360, 900, 0, 0);
$t9=array(0, 0, 0, 0, 2, 12, 38, 130, 480, 950, 0);
$t10=array(0, 0, 0, 0, 1, 5, 25, 86, 360, 900, 1000);
$tt=array($t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9, $t10);

$choosef=explode("!", $cf);
$fields=count($choosef)-1;
$hitf=array();

/// main ///


do{
	for($j=0; $j<20; $j++){
		$hitf[$j]=generator();
	}

	$hits=0;
	for($j=0; $j<$fields; $j++){
		for($k=0; $k<20; $k++){
			if( ($choosef[$j])==($hitf[$k]) ){ $hits++;	 break; }
		}
	}

	$win=$tt[$fields-1][$hits]*$total_bet;
	$diff=$win-$total_bet;
	
	$maxwin=calWinLimit();
}while($diff>$maxwin);

if($diff>0){$rg="w";}else{$rg="l";}
$tm=time();

// Write game/transaction in db
// let's make the db more organised win_limit 10.00 format instead of 10.001
	$win_limit = sprintf ("%01.2f", $maxwin); 
	$diff = sprintf ("%01.2f", $diff);

if($diff>=0){$rg="w";}else{$rg="l";}
$tm=time();
mysql_query("insert into `games` values('', '$userid', '$tm', '$total_bet', '$hitf', '$rg', '$diff', '$game_type')");
$gameid=mysql_insert_id();
mysql_query("insert into `transactions` values('', '$userid', '$gameid', '$tm', '$rg', '$diff', '$win_limit')");

//user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

$balls="";
for($i=0; $i<20; $i++){ $balls.=$hitf[$i]."!"; }
$answer="&ans=Rd&win=".$win."&hit=".$hits."&bll=".$balls."&bl=".$user_balance;
echo $answer;
?>
