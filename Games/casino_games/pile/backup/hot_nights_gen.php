<?PHP
error_reporting(0);
require('../scripts/connect.php');
///////////////////// functions //////////////////////
function calWinLimit(){
	$locID=LOCID;
	$userid=USERID;
	$type=$locID."51";


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
	$res = rand(0, 680);
	if ( $res < 50 ) { $n = 6; }
	if ( ($res >= 50) && ($res < 175) ) { $n = 7; }
	if ( ($res >= 175) && ($res < 250) ) { $n = 5; }
	if ( ($res >= 250) && ($res < 400) ) { $n = 4; }
	if ( ($res >= 400) && ($res < 500) ) { $n = 3; }
	if ( ($res >= 500) && ($res < 600) ) { $n = 2; }
	if ($res >= 600 && ($res < 650)) { $n = 1; }
	if ($res >= 650) { $n = 0; }
	return $n;
}
//

function countLine($a, $b, $c) {
	global $win, $bet;
	if (($a == $b) && ($b == $c)) {
		setWinByNum($a);
	} elseif (($a == $b) && ($c == 2) || ($b == $c) && ($a == 2)) {
		// wild - any 2 eq symbols
		setWinByNum($b);
	} elseif (($a == $c) && ($b == 2)) {
		// wild - any 2 eq symbols	
		setWinByNum($c);
	} elseif (($a == $c) && ($a == 2)) {
		// wild - any - wild
		setWinByNum($b);
	} elseif (($b == $c) && ($b == 2)) {
		// any - wild - wild
		setWinByNum($a);
	} elseif (($b == $a) && ($b == 2)) {
		// wild - wild - any
		setWinByNum($c);
	} else {
		
		if ($a == 2 && $b == 2 && $c != 2)								   						{ setWinByNum($c); }  //wild - wild - any symbol
		elseif ($a == 2 && $c == 2 && $b != 2)								   					{ setWinByNum($b); }  //wild - wild - any symbol
		elseif ($b == 2 && $c == 2 && $a != 2)								   					{ setWinByNum($a); }  //wild - wild - any symbol
		
		elseif ($a == 2 && $c == 3 && ($b < 2 || $b > 3))			   							{ $win = 5 * $bet; }  //wild - S - any symbol (like any two S)
		elseif ($a == 2 && $b == 3 && ($c < 2 || $c > 3))			   							{ $win = 5 * $bet; }  //wild - S - any symbol (like any two S)
			
		elseif ($b == 2 && $a == 3 && ($c < 2 || $c > 3))		   								{ $win = 5 * $bet; }  //wild - S - any symbol (like any two S)
		elseif ($b == 2 && $c == 3 && ($a < 2 || $a > 3))		   								{ $win = 5 * $bet; }  //wild - S - any symbol (like any two S)
		
		elseif ($c == 2 && $a == 3 && ($b < 2 || $b > 3))		   								{ $win = 5 * $bet; }  //wild - S - any symbol (like any two S)
		elseif ($c == 2 && $b == 3 && ($a < 2 || $a > 3))		   								{ $win = 5 * $bet; }  //wild - S - any symbol (like any two S)
		
		elseif ($a == 2 && $b > 3 && $b < 7 && $c > 3 && $c < 7 && $c != $b) 					{ $win = 5 * $bet; } //wild - anygem - anygem
		elseif ($a > 3 && $a < 7 && $b == 2 && $c > 3 && $c < 7 && $c != $a) 					{ $win = 5 * $bet; } //anygem - anygem - wild
		elseif ($a > 3 && $a < 7 && $b > 3 && $b < 7 && $c == 2 && $a != $b) 					{ $win = 5 * $bet; } //anygem - wild - anygem
		
		elseif ($a > 3 && $a < 7 && $b > 3 && $b < 7 && $c > 3 && $c < 7 && $a != $b && $b != $c && $a != $c )	{ $win = 5 * $bet; } //anygem - anygem - anygem
		
		elseif (($a == $b) && ($b == 3) || ($b == $c) && ($b == 3) || ($a == $c) && ($a == 3)) 	{ $win = 5 * $bet; } //Any 2 S
		elseif (($a == 3) || ($b == 3) || ($c == 3)) 											{ $win = 1 * $bet; } //Any 1 S   		
	}
}

function setWinByNum($num) {
	global $win, $bet;
	switch ($num) {
		case 1: $win = 1000 * $bet; break;
		case 2: $win = 200 * $bet; break;
		case 3: $win = 100 * $bet; break;
		case 4: $win = 30 * $bet; break;
		case 5: $win = 20 * $bet; break;
		case 6: $win = 10 * $bet; break;
		case 7: $win = 10 * $bet; break;		
	}
}

///////////////////// MAIN //////////////////////
if( !isset($_POST["b"]) ){ exit; }
if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
$userid=mysql_result($result, 0, "userid");
$bet=$_POST["b"];

$total_bet = sprintf ("%01.2f", $bet); 

// Real Time check for user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 
if ($user_balance < $total_bet) { exit; }

//Location ID
define("LOCID", substr($userid,0,3));
define("USERID",$userid);

// Update User
//mysql_query("update `users` set `lplay_date`=".time()." where `userid`=$userid");
mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");

//Genuine User Check
//if ($userid == 0) { exit; }

/// start game;
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

//remove blanks from 1st and 3rd lines
	if ($n1==0){ $n1=Gen();}
	if ($n2==0){ $n2=Gen();}
	if ($n3==0){ $n3=Gen();}
	if ($n7==0){ $n7=Gen();}
	if ($n8==0){ $n8=Gen();}
	if ($n9==0){ $n9=Gen();}

// Test mode. Disable!
//	$n4=7;
//	$n5=2;
//	$n6=3;
// Test mode. Disable!

	countLine($n4, $n5, $n6);
	$maxwin=calWinLimit();
}while($win>$maxwin);

//update games and transactions
$win_limit = sprintf ("%01.2f", $maxwin); 
$diff=$win-$bet;
$diff = sprintf ("%01.2f", $diff);
if($diff>=0){$rg="w";}else{$rg="l";}
	//auto cashout
	$co_amount=$bet/10;
	$co_amount = sprintf ("%01.2f", $co_amount);
//	$co_amount = -$co_amount;
	$tm=time();
	mysql_query("insert into `transactions` values('', '0', '0', '$tm', 'co', '$co_amount', '$userid')");
$tm=time();
mysql_query("insert into `games` values('', '$userid', '$tm', '$bet', '-1', '$rg', '$diff', '51')");
$gameid=mysql_insert_id();
mysql_query("insert into `transactions` values('', '$userid', '$gameid', '$tm', '$rg', '$diff', '$win_limit')");

//user balance
//Optimized
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

// send answer
$answer="&ans=res&ub=".$user_balance."&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9;
echo $answer;
?>
