<?PHP
error_reporting(0);
require('../scripts/connect.php');

if( isset($_POST["bt"]) ){ $bet=$_POST["bt"]; }else{ exit; }
$bet_value=$_POST["bv"];
if ( isset($_POST["tp"]) ){ $game_type=$_POST["tp"]; }else{$game_type=11; }

if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
$userid=mysql_result($result, 0, "userid");

mysql_query("update `users` set `lplay_date`=".time()." where `userid`=$userid");
mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");

// Real Time check for user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 
if ($user_balance < $bet_value) { exit; }

//Location ID
define("LOCID", substr($userid,0,3));
define("USERID",$userid);

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
	$locID=LOCID;
	$userid=USERID;
	if ($_POST["tp"]==11){
		$type=$locID."11";
		list($coef) = mysql_fetch_row(mysql_query("SELECT coef FROM settings WHERE `type`='$type'"));
	}else if ($_POST["tp"]==12){
		$type=$locID."12";
		list($coef) = mysql_fetch_row(mysql_query("SELECT coef FROM settings WHERE `type`='$type'"));
	}

list($resetdate) = mysql_fetch_row(mysql_query("SELECT date FROM transactions WHERE gameid=0 AND type='co' AND comments='$userid' ORDER BY transid ASC LIMIT 1"));


	// Get max. win. amount for Location ID

	list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `transactions` WHERE `date`>$resetdate AND ((type='w' AND userid='$userid') OR (type='l' AND userid='$userid') OR (type='co' AND comments='$userid'))"));
	$balance=-$balance;

	$maxwin=$balance*$coef/100;
	if($maxwin<0){ $maxwin=0; }else{
	//Force Lost
	$chance=rand(0,99);
	if ($chance > $coef) {
		$maxwin=0;
	}
	}

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
	// Tie 
	if (($pnum==$bnum) && ($diff < 0)) { $diff=0; }

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
	//auto cashout
	$co_amount=$bet_value/10;
	$co_amount = sprintf ("%01.2f", $co_amount); 
	$tm=time();
	mysql_query("insert into `transactions` values('', '0', '0', '$tm', 'co', '$co_amount', '$userid')");
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
// set $diff to 0
if ($diff < 0) { $diff=0; }
echo "&cd=".$cd."&wn=".$diff."&ub=".$user_balance."&pnum=".$pnum."&bnum=".$bnum."&pneed3=".$pneed3."&bneed3=".$bneed3;
?>
