<?PHP
$tm=time();

if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{ exit; }
require("connect.php");

$diff=time()-3600;
mysql_query("delete from `session` where `time`<$diff");
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");

if(mysql_num_rows($result)){ // session correct
	$userid=mysql_result($result, 0, "userid");
	mysql_query("update `session` set `time`=".time()." where `sid`='$sid'");

	//user balance
	list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
	$balance = sprintf ("%01.2f", $balance); 

	echo "rbl=valid&bln=".$balance."&u=".$sid;
}else{ // session is over
	mysql_query("delete from `session` where `sid`='$sid'");
	echo "rbl=ivalid";
}
?>