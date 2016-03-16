<?PHP
##############################################################################
# PROGRAM : Casino System                                                    #
# VERSION : 1.05                                                             #
# REVISION: 000										     #
# DATE    : 01/03/2005                                                       #
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
if ( isset($_POST["tp"]) ){ $game_type=$_POST["tp"]; }else{$game_type=3; }
if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
$userid=mysql_result($result, 0, "userid");

mysql_query("update `users` set `lplay_date`=".time()." where `userid`=$userid");
mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");
///////////////////////////// objects //////////////////////////////////////
class Bet{
	var $desc="";
	var $val=-1;
	var $flds="";
	function Bet($str){
		$parts=explode("[",$str);
		$this->desc=$parts[0];
		$this->val=$parts[1];
		if( isset($parts[2]) ){ $this->flds=$parts[2]; }else{ $this->flds=""; }
	}
}
///////////////////////////// functions ////////////////////////////////////
function calWinLimit(){
	// получить текущие настройки
	if ($_POST["tp"]==1){
		$result=mysql_query("select * from `settings` where `type`='1'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==2){
		$result=mysql_query("select * from `settings` where `type`='2'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==3){
		$result=mysql_query("select * from `settings` where `type`='3'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else if ($_POST["tp"]==4){
		$result=mysql_query("select * from `settings` where `type`='4'");
		$xdate=mysql_result($result, 0, "date");
		$coef=mysql_result($result, 0, "coef");
	}else{
		$result=mysql_query("select * from `settings` where `type`='3'");
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

function calWin($res){ 
	global $bets_items, $win, $lost;
	$red=array(1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36);
	$black=array(2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35);
	$num_bets=count($bets_items);
		
	for($i=0;$i<$num_bets;$i++){ 
		$descr=$bets_items[$i]->desc;
		$val=$bets_items[$i]->val;
		$flds_str=$bets_items[$i]->flds;

		$lost-=$val; // суммируем номинал всех ставок
		$flds=explode(" ",$flds_str);

		switch($descr){
			case "High 1:1": if( ($res>=19)&&($res<=36) ){ $win+=$val*2;  } break;
			case "Low 1:1": if( ($res>=1)&&($res<=18) ){ $win+=$val*2;  } break;
			case "Even 1:1": if( !($res%2)&&($res!=0) ){ $win+=$val*2;  } break;
			case "Odd 1:1": if( $res%2 ){ $win+=$val*2; } break;
			case "Red 1:1": $exist=false;
				for($j=0;$j<18;$j++){ if($res==$red[$j]){$exist=true;} }
				if( $exist ){ $win+=$val*2;	} break;
			case "Black 1:1":
				$exist=false;
				for($j=0;$j<18;$j++){ if($res==$black[$j]){$exist=true;} }
				if( $exist ){ $win+=$val*2; } break;
			case "1st Dozen 2:1": if( ($res>=1)&&($res<=12) ){ $win+=$val*3; } break;
			case "2st Dozen 2:1": if( ($res>=13)&&($res<=24) ){ $win+=$val*3; } break;
			case "3st Dozen 2:1": if( ($res>=25)&&($res<=36) ){ $win+=$val*3; } break;
			case "1st Column 2:1": if( ($res%3)==1 ){ $win+=$val*3; } break;
			case "2st Column 2:1": if( ($res%3)==2 ){ $win+=$val*3; } break;
			case "3st Column 2:1": if( !($res%3)&&($res!=0) ){ $win+=$val*3; } break;
			case "Zero 35:1": if( $res==0 ){ $win+=$val*36;	} break;
			case "Straight 35:1": $n=$flds[0]; settype($n,"integer");
				if( $res==$n ){ $win+=$val*36; }break;
			case "First four 8:1": if( ($res==0)||($res==1)||($res==2)||($res==3) ){ $win+=$val*9; } break;
			case "Three 11:1": $n0=$flds[0]; $n1=$flds[1]; settype($n0,"integer"); settype($n1,"integer");
				if( ($res==0)||($res==$n0)||($res==$n1) ){ $win+=$val*12; } break;
			case "Six number 5:1": $n0=$flds[0]; $n1=$flds[1]; $n2=$flds[2]; $n3=$flds[3]; $n4=$flds[4]; $n5=$flds[5];
				settype($n0,"integer"); settype($n1,"integer"); settype($n2,"integer"); settype($n3,"integer"); settype($n4,"integer"); settype($n5,"integer");
				if( ($res==$n0)||($res==$n1)||($res==$n2)||($res==$n3)||($res==$n4)||($res==$n5) ){	$win+=$val*6; } break;
			case "Street 11:1": $n0=$flds[0]; $n1=$flds[1]; $n2=$flds[2];
				settype($n0,"integer"); settype($n1,"integer"); settype($n2,"integer");
				if( ($res==$n0)||($res==$n1)||($res==$n2) ){ $win+=$val*12; } break;
			case "Corner 8:1": $n0=$flds[0]; $n1=$flds[1]; $n2=$flds[2]; $n3=$flds[3];
				settype($n0,"integer"); settype($n1,"integer"); settype($n2,"integer"); settype($n3,"integer");
				if( ($res==$n0)||($res==$n1)||($res==$n2)||($res==$n3) ){ $win+=$val*9; } break;
			case "Split 17:1": $n0=$flds[0]; $n1=$flds[1]; settype($n0,"integer"); settype($n1,"integer");
				if( ($res==$n0)||($res==$n1) ){	$win+=$val*18; }break;
		}
	}
// let's make the win number 10.00 format instead of 10.001
	$win = sprintf ("%01.2f", $win); 	
	$diff=$win+$lost;
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

$win_limit=calWinLimit();
do{	
	$res=rand(0,36);
	$win=0;
	$lost=0;
	$diff=calWin($res);
}while($diff>$win_limit);

// Write game/transaction in db
// let's make the db more organised win_limit 10.00 format instead of 10.001
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

// Post Back to the game
echo "iv=".$res."&wn=".$win."&ub=".$user_balance;
?>