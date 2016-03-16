<?PHP
error_reporting(0);
require('../scripts/connect.php');

if( isset($_POST["bt"]) ){ $bet=$_POST["bt"]; }else{ exit; }
$bet_value=$_POST["bv"];
if ( isset($_POST["tp"]) ){ $game_type=$_POST["tp"]; }else{$game_type=1; }
if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
$userid=mysql_result($result, 0, "userid");


// Real Time check for user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 
if ($user_balance < $bet_value) { exit; }

//Location ID
define("LOCID", substr($userid,0,3));
define("USERID",$userid);

// Update User
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
	$locID=LOCID;
	$userid=USERID;
	// получить текущие настройки
	if ($_POST["tp"]==1){
		$type=$locID."1";
		list($coef) = mysql_fetch_row(mysql_query("SELECT coef FROM settings WHERE `type`='$type'"));
	}else if ($_POST["tp"]==2){
		$type=$locID."2";
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
				if( $res==$n ){ $win+=$val*35; }break;
			case "First four 8:1": if( ($res==0)||($res==1)||($res==2)||($res==3) ){ $win+=$val*8; } break;
			case "Three 11:1": $n0=$flds[0]; $n1=$flds[1]; settype($n0,"integer"); settype($n1,"integer");
				if( ($res==0)||($res==$n0)||($res==$n1) ){ $win+=$val*11; } break;
			case "Six number 5:1": $n0=$flds[0]; $n1=$flds[1]; $n2=$flds[2]; $n3=$flds[3]; $n4=$flds[4]; $n5=$flds[5];
				settype($n0,"integer"); settype($n1,"integer"); settype($n2,"integer"); settype($n3,"integer"); settype($n4,"integer"); settype($n5,"integer");
				if( ($res==$n0)||($res==$n1)||($res==$n2)||($res==$n3)||($res==$n4)||($res==$n5) ){	$win+=$val*5; } break;
			case "Street 11:1": $n0=$flds[0]; $n1=$flds[1]; $n2=$flds[2];
				settype($n0,"integer"); settype($n1,"integer"); settype($n2,"integer");
				if( ($res==$n0)||($res==$n1)||($res==$n2) ){ $win+=$val*11; } break;
			case "Corner 8:1": $n0=$flds[0]; $n1=$flds[1]; $n2=$flds[2]; $n3=$flds[3];
				settype($n0,"integer"); settype($n1,"integer"); settype($n2,"integer"); settype($n3,"integer");
				if( ($res==$n0)||($res==$n1)||($res==$n2)||($res==$n3) ){ $win+=$val*8; } break;
			case "Split 17:1": $n0=$flds[0]; $n1=$flds[1]; settype($n0,"integer"); settype($n1,"integer");
				if( ($res==$n0)||($res==$n1) ){	$win+=$val*17; }break;
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

if($diff>=0){$rg="w";}else{$rg="l";
	//auto cashout
	$co_amount=$diff/10;
	$co_amount = sprintf ("%01.2f", $co_amount);
	$co_amount = -$co_amount;
	$tm=time();
	mysql_query("insert into `transactions` values('', '0', '0', '$tm', 'co', '$co_amount', '$userid')");

}
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