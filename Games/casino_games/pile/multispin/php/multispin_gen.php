<?PHP

error_reporting(0);
require('../scripts/connect.php');

//foreach ( $_REQUEST as $key => $value ) { $mssg.= $key . " " . "=" . " " . $value. "\n"; }
//$f=file_put_contents("log.txt", $mssg); // (PHP 5) 
//mail("webmaster@xlnet.ltd.uk", "Post Data", $mssg, "From: $adminemail\nMIME-Version: 1.0\nContent-Type: text/plain; charset=us-ascii\nContent-Transfer-Encoding: 7bit\n" );


///////////////////// functions //////////////////////
function calWinLimit(){
	$locID=LOCID;
	$userid=USERID;
	$type=$locID."53";


list($coef) = mysql_fetch_row(mysql_query("SELECT coef FROM settings WHERE `type`='$type'"));
list($resetdate) = mysql_fetch_row(mysql_query("SELECT date FROM transactions WHERE gameid=0 AND type='co' AND comments='$userid' ORDER BY transid ASC LIMIT 1"));


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
//
function Gen() {
	$res = rand(0, 150);
	if ( $res < 25 ) { $n = 7; }
	if ( ($res >= 25) && ($res < 50) ) { $n = 6; }
	if ( ($res >= 50) && ($res < 70) ) { $n = 5; }
	if ( ($res >= 70) && ($res < 85) ) { $n = 4; }
	if ( ($res >= 85) && ($res < 100) ) { $n = 3; }
	if ( ($res >= 100) && ($res < 120) ) { $n = 2; }
	if ($res >= 120 && ($res < 130)) { $n = 1; }
//	if ($res >= 130 && ($res < 140)) { $n = 0; }
	if ($res > 130) { $n = 8; }
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
			case 7: $win = 10 * $bet * $multiplier; break;
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
if( !isset($_POST["b"]) ){ exit; }
if( !isset($_POST["et"]) ) { exit; }
if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
if( isset($_POST["m"]) ) { $multiplier = $_POST["m"]; } else { $multiplier = 1; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
$userid=mysql_result($result, 0, "userid");

$hold = $_POST["et"];
$bet = $_POST["b"];
$bet = sprintf ("%01.2f", $bet); 
$total_bet = sprintf ("%01.2f", $bet); 

// Real Time check for user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 
//if ($user_balance < $total_bet) { exit; }

//Location ID
define("LOCID", substr($userid,0,3));
define("USERID",$userid);

// Update User
//mysql_query("update `users` set `lplay_date`=".time()." where `userid`=$userid");
mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");

//Genuine User Check
//if ($userid == 0) { exit; }

// start game;

if ($hold == 1) {
	if( !isset($_POST["ti"]) ){ exit; }
	$trans_id=$_POST["ti"];
	$result=mysql_query("select * from `transactions` where `transid`='$trans_id'");
	$maxwin=mysql_result($result, 0, "comments");
}else{
	$maxwin=calWinLimit();
}

do{
	$win=0;
	if ($hold == 1) {
		if ($_POST["n2"] == "-1") {
			$n1 = rand(1, 8);
			$n2 = Gen();
			$n3 = rand(1, 8);
		} else {
			$n1 = $_POST["n1"];
			$n2 = $_POST["n2"];
			$n3 = $_POST["n3"];
		}
		if ($_POST["n5"] == "-1") {
			$n4 = rand(1, 8);
			$n5 = Gen();
			$n6 = rand(1, 8);
		} else {
			$n4 = $_POST["n4"];
			$n5 = $_POST["n5"];
			$n6 = $_POST["n6"];
		}
		if ($_POST["n8"] == "-1") {
			$n7 = rand(1, 8);
			$n8 = Gen();
			$n9 = rand(1, 8);
		} else {
			$n7 = $_POST["n7"];
			$n8 = $_POST["n8"];
			$n9 = $_POST["n9"];
		}
		if ($_POST["n11"] == "-1") {
			$n10 = rand(1, 8);
			$n11 = Gen();
			$n12 = rand(1, 8);
		} else {
			$n10 = $_POST["n10"];
			$n11 = $_POST["n11"];
			$n12 = $_POST["n12"];
		}
	} else {
		$n1 = rand(1, 8);
		$n2 = Gen();
		$n3 = rand(1, 8);
		$n4 = rand(1, 8);
		$n5 = Gen();
		$n6 = rand(1, 8);
		$n7 = rand(1, 8);
		$n8 = Gen();
		$n9 = rand(1, 8);
		$n10 = rand(1, 8);
		$n11 = Gen();
		$n12 = rand(1, 8);
	}
	
	
	/*
	Symbol positions
	1 4 7 10
	2 5 8 11
	3 6 9 12
	*/
	
	//
	//testing
	//$n2=8;
	//$n5=8;
	//$n8=8;
	//$n11=8;
	//
	
	//remove 2 blank in a row
/*
	if (($n1 == 0) && ($n2 == 0)) { $n1 = rand(1, 8); }	
	if (($n2 == 0) && ($n3 == 0)) { $n3 = rand(1, 8); }	
	if (($n4 == 0) && ($n5 == 0)) { $n4 = rand(1, 8); }	
	if (($n5 == 0) && ($n5 == 0)) { $n6 = rand(1, 8); }	
	if (($n7 == 0) && ($n8 == 0)) { $n7 = rand(1, 8); }	
	if (($n8 == 0) && ($n9 == 0)) { $n9 = rand(1, 8); }
	if (($n10 == 0) && ($n11 == 0)) { $n10 = rand(1, 8); }	
	if (($n11 == 0) && ($n12 == 0)) { $n12 = rand(1, 8); }
*/
	
	if ($n2 == 0) { $n2 = rand(1, 8); }	
	if ($n5 == 0) { $n5 = rand(1, 8); }	
	if ($n8 == 0) { $n8 = rand(1, 8); }	
	if ($n11 == 0) { $n11 = rand(1, 8); }

	countLine($n2, $n5, $n8, $n11);

	$bwin = "0,0,0";
	
	if (($n2 == $n5) && ($n8 == $n11) && ($n5 == $n8) && ($n2 == 8) && ($total_bet>0.49)) {
	$b1 = rand(0, 10);
	$b2 = rand(0, 10);
	$b3 = rand(0, 10);
//	$b1=1;
//	$b2=2;
//	$b3=5;

		$bwin = $b1.",".$b2.",".$b3;
	$win=$win+($b1+$b2+$b3)*$total_bet;
	}

	$win = sprintf ("%01.2f", $win); 
	$diff=$win-$total_bet;
}while($diff>$maxwin); 


//update games and transactions

if ($hold == 1) {
	if( !isset($_POST["ti"]) ){ exit; }
	$trans_id=$_POST["ti"];
	$diff = sprintf ("%01.2f", $diff);
	$tm=time();
	if($diff>=0){$rg="w";}else{$rg="l";}
	//auto cashout
	$co_amount=$bet/10;
	$co_amount = sprintf ("%01.2f", $co_amount);
//	$co_amount = -$co_amount;
	$tm=time();
	mysql_query("insert into `transactions` values('', '0', '0', '$tm', 'co', '$co_amount', '$userid')");
	mysql_query("update `transactions` set `amount`='$diff', `type`='$rg' where `transid`='$trans_id'");

//user balance
//Optimized
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

	$answer="&ans=res&ub=".$user_balance."&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9."&n10=".$n10."&n11=".$n11."&n12=".$n12."&bwin=".$bwin;
}else{
	$win_limit = sprintf ("%01.2f", $maxwin); 
	$tm=time();
	mysql_query("insert into `games` values('', '$userid', '$tm', '$bet', '$n2,$n5,$n8,$n11', 'l', '-$bet', '53')");
	$gameid=mysql_insert_id();
	mysql_query("insert into `transactions` values('', '$userid', '$gameid', '$tm', 'l', '-$bet', '$win_limit')");
	$trans_id=mysql_insert_id();
	$answer="&ans=res&ti=".$trans_id."&ub=".$user_balance."&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9."&n10=".$n10."&n11=".$n11."&n12=".$n12;
}

// send answer
echo $answer;
?>
