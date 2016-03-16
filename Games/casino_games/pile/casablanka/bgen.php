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

if( isset($_POST["bt"]) ){ $bet=$_POST["bt"]; }else{ exit; }
$bet_value=$_POST["bv"];
if ( isset($_POST["tp"]) ){ $game_type=$_POST["tp"]; }else{$game_type=13; }

if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
$userid=mysql_result($result, 0, "userid");

mysql_query("update `users` set `lplay_date`=".time()." where `userid`=$userid");
mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");

//Genuine User Check
if ($userid == 0) { exit; }

///////////////////////////// objects //////////////////////////////////////
class Bet{
	var $desc="";
	var $val=-1;
	function Bet($str){
		$parts=explode("[",$str);
		$this->desc=$parts[0];
		$this->val=$parts[1];
	}
}
class Card{
	var $worth=-1;
	var $suit=-1;
	var $num=-1;
	function Card($w,$s,$n){
		$this->worth=$w;
		$this->suit=$s;
		$this->num=$n;
	}
}
///////////////////////////// functions ////////////////////////////////////
function calWinLimit(){

	if ($_POST["tp"]==11){
		$result=mysql_query("select * from `settings` where `type`='11'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==12){
		$result=mysql_query("select * from `settings` where `type`='12'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==13){
		$result=mysql_query("select * from `settings` where `type`='13'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==14){
		$result=mysql_query("select * from `settings` where `type`='14'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else{
		$result=mysql_query("select * from `settings` where `type`='13'");
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

function generateCards(){
	global $cards;
	do{
		$worth=rand(0,12);
		switch($worth){
			case 0: $num=2; break;
			case 1: $num=3; break;
			case 2: $num=4; break;
			case 3: $num=5; break;
			case 4: $num=6; break;
			case 5: $num=7; break;
			case 6: $num=8; break;
			case 7: $num=9; break;
			case 8: $num=10; break;
			case 9: $num=10; break;
			case 10: $num=10; break;
			case 11: $num=10; break;
			case 12: $num=11; break;
		}
		$suit=rand(1,4); 

		$is_new=true;
		for($i=0; $i<count($cards); $i++){
			if( ($cards[$i]->worth==$worth)&&($cards[$i]->suit==$suit) ){ $is_new=false; }
		}
	}while(!$is_new);
	$ncard=new Card($worth, $suit, $num);	
	array_push($cards, $ncard);
}

function calWin(){ 
	global $bets_items, $win, $bet_value, $cards, $pnum, $bnum, $pneed3, $bneed3;
	$num_bets=count($bets_items);

	$pnum=($cards[0]->num+$cards[2]->num)%10;
	$bnum=($cards[1]->num+$cards[3]->num)%10;

	if($pnum<6){ $pneed3=1; }
	if($bnum>=8){ $pneed3=0; } 
	if($pneed3){ $pnum=($cards[0]->num+$cards[2]->num+$cards[4]->num)%10; }

	switch($bnum){
		case 0: $bneed3=1; break;
		case 1: $bneed3=1; break;
		case 2: $bneed3=1; break;
		case 3: $bneed3=1; break;
		case 4: if($pnum>1){ $bneed3=1; }else{ $bneed3=0; } break;
		case 5: if($pnum>4){ $bneed3=1; }else{ $bneed3=0; } break;
		case 6: if($pnum>6){ $bneed3=1; }else{ $bneed3=0; } break;
		case 7: $bneed3=0; break;
		case 8: $bneed3=0; break;
		case 9: $bneed3=0; break;
	}
	if($pnum>=8){ $bneed3=0; }
	if($bneed3){ $bnum=($cards[1]->num+$cards[3]->num+$cards[5]->num)%10; }
	
	for($i=0;$i<$num_bets;$i++){ 
		$descr=$bets_items[$i]->desc;
		$val=$bets_items[$i]->val;
		switch($descr){
			case "Tie 1:8": if( $pnum==$bnum ){ $win+=$val*9;  } break;
			case "Banker 1:1": if( $bnum>$pnum ){ $win+=$val*2-$val*0.05;  } break;
			case "Player 1:1": if( $bnum<$pnum ){ $win+=$val*2;  } break;
		}
	}	
	$win = sprintf ("%01.2f", $win); 
	$diff=$win-$bet_value;
	return $diff;
}
///////////////////////////// MAIN     /////////////////////////////////////
$bet=trim($bet);
$l=strlen($bet)-1;
$bet=substr($bet,0,$l);

$bets=explode("@",$bet);
$bets_items=array();
foreach($bets as $value){
	$item=new Bet($value);
	array_push($bets_items, $item);
}
$pnum=-1;
$bnum=-1;
$pneed3=0;
$bneed3=0;

$win_limit=calWinLimit();

do{	
	$cards=array();
	for($j=0; $j<6; $j++){ generateCards(); }
	$win=0;
	$lost=0;
	$diff=calWin();
}while($diff>$win_limit);

$win_limit = sprintf ("%01.2f", $win_limit); 
$diff = sprintf ("%01.2f", $diff);

if($diff>=0){$rg="w";}else{$rg="l";}
$tm=time();


mysql_query("insert into `games` values('', '$userid', '$tm', '$bet', '$res', '$rg', '$diff', '$game_type')");
$gameid=mysql_insert_id();
mysql_query("insert into `transactions` values('', '$userid', '$gameid', '$tm', '$rg', '$diff', '$win_limit')");

//user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

$cd=$cards[0]->worth."@".$cards[0]->suit."!";
$cd.=$cards[1]->worth."@".$cards[1]->suit."!";
$cd.=$cards[2]->worth."@".$cards[2]->suit."!";
$cd.=$cards[3]->worth."@".$cards[3]->suit."!";
$cd.=$cards[4]->worth."@".$cards[4]->suit."!";
$cd.=$cards[5]->worth."@".$cards[5]->suit;
echo "&cd=".$cd."&wn=".$win."&ub=".$user_balance."&pnum=".$pnum."&bnum=".$bnum."&pneed3=".$pneed3."&bneed3=".$bneed3;

?>
