<?PHP
##############################################################################
# PROGRAM : Online Casino                                                    #
# VERSION : 2.01                                                             #
# REVISION: 006										     #
# DATE    : 01/06/2008                                                       #
##############################################################################
# All source code, images, programs, files included in this package          #
# Copyright (c) 2003-2008                                                    #
#		    GamingWare.		  						     #
#           www.gamingware.co.uk                                             #
#           All Rights Reserved.                                             #
##############################################################################
#                                                                            #
#    While we distribute the source code for our scripts/software and you    #
#    are allowed to edit them to better suit your needs, we do not           #
#    support modified code.  Please see the license prior to changing        #
#    anything. You must agree to the license terms before using this         #
#    software package or any code contained herein.                          #
#                                                                            #
#    Any redistribution without permission of XLNET Ltd.                     #
#    is strictly forbidden.                                                  #
#                                                                            #
##############################################################################

//error_reporting(E_ALL);
error_reporting(0);
require("connect.php");

$mntwokind=10;
$mnthreekind=20;
$mnfourkind= 50;
$mnfivekind = 100;



//_log("<-- uid:"+$_POST["uid"]."pyramid:".$_POST["pyramid"]);


/*
if( isset($_POST["uid"]) ){ $sid=$_POST["uid"]; }else{_log('exited:'. __LINE__); exit; }
$result=mysql_query("select `userid` from `session` where `sid`='$sid'");
if(!empty ($result) ){ //Check session
$userid=mysql_result($result, 0, "userid");
}else{ _log('exited:'. __LINE__); exit; }

*/


$userid=1;  //test
$sid="af88jmqq7g9b46mj2e1094r362";  //test

//gamble test
/*
$_POST['half']=1;//test
$_POST['gamble']=1; 
$_POST['chosencolor']=0;

$_POST["b"]=200;
$_POST["l"]=10;
$_POST["c"]=20;
$_POST["uid"]="9n2pg68jhdg89lec3vnp3u9471";
*/
//end gamble test



//$userid = $_SESSION["userid"];

///////////////////// functions //////////////////////
function calWinLimit(){
	$result=mysql_query("select * from `settings` where `type`='53'");
	$xdate=mysql_result($result, 0, "date");
	$coef=mysql_result($result, 0, "coef");
	// Get max. win. amount for Location ID
	$locID=LOCID;
	list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM `transactions` WHERE `date`>$xdate AND ((type='w'  AND userid LIKE '$locID%') OR (type='l'  AND userid LIKE '$locID%')  OR (type='co'  AND comments LIKE '$locID%'))"));
	$balance=-$balance;
	$maxwin=$balance*$coef/100;
	if($maxwin<0){ $maxwin=0; }
	return $maxwin;
}
//
	
function Gen() {
	$res=rand(0,140);
	if( $res<=10 ){ $n=1; }
	else if( ($res>10)&&($res<=20) ){ $n=2; }
	else if( ($res>20)&&($res<=30) ){ $n=3; }
	else if( ($res>30)&&($res<=40) ){ $n=4; }
	else if( ($res>40)&&($res<=50) ){ $n=5; }
	else if( ($res>50)&& ($res<=60) ){ $n=6; }
	else if( ($res>60)&& ($res<=70) ){ $n=7; }
	else if( ($res>70)&& ($res<=80) ){ $n=8; }
	else if( ($res>80)&&($res<=90) ){ $n=9; }
	else if( ($res>90)&&($res<=100) ){ $n=10; }
	else if( ($res>100)&&($res<=110) ){ $n=11; }
	else if( ($res>110)&&($res<=120) ){ $n=12; }
	else if( ($res>120)&&($res<=130) ){ $n=13; }
	else if( ($res>130)&&($res<=140) ){ $n=14; }
	return $n;
}
//

function allexceptions($arr) {
global $n1,$n2,$n3,$n4,$n5,$n6,$n7,$n8,$n9,$n10,$n11,$n12,$n13,$n14,$n15,$winall; 
$found=false;
$newarr=array();
$ar=array();
for ($i=0;$i<count($arr);$i++) {
$ar = preg_split('/\|/',$arr[$i]);
array_push($newarr,$ar[0]);
}

for ($i=0;$i<count($arr);$i++) {
$ar = preg_split('/\|/',$arr[$i]);

$max=$ar[1]; $val=$ar[0]; $count=0; $n= "n".$val;
for ($k=1;$k<=15;$k++) {
	$n= "n".$k;
	if ($$n == $val)  {
		$count++;
		if ($count > $max) {
		$found=true;
		$count--;
		$$n = $newval = Gen();
		while (in_array($newval,$newarr))  {
			$$n = $newval = Gen();
			}
		
		}
}
}
}
if ($found==true) return true; else return false;
}



function colexceptions() {
global $n1,$n2,$n3,$n4,$n5,$n6,$n7,$n8,$n9,$n10,$n11,$n12,$n13,$n14,$n15,$winall; 
$found=false;

$colexcludes = Array();
//first 0 = in any column 
$colexcludes[0] = array(0,0,10,10); //pyramid
$colexcludes[1] = array(0,10,0,10); //pyramid
$colexcludes[2] = array(0,10,10,0); //pyramid
$colexcludes[3] = array(0,10,10,10); //pyramid

$colexcludes[4] = array(0,0,11,11); //king bonus
$colexcludes[5] = array(0,11,0,11); //king bonus
$colexcludes[6] = array(0,11,11,0); //kingbonus
$colexcludes[7] = array(0,11,11,11); //kingbonus

$colexcludes[8] = array(0,0,13,13); //free spins
$colexcludes[9] = array(0,13,0,13); //free spins
$colexcludes[10] = array(0,13,13,0); //free spins
$colexcludes[11] = array(0,13,13,13); //free spins


$colexcludes[12] = array(0,0,2,2); //joker
$colexcludes[13] = array(0,2,0,2); //joker
$colexcludes[14] = array(0,2,2,0); //joker
$colexcludes[15] = array(0,2,2,2); //joker



for ($i=0;$i<count($colexcludes);$i++) {

if ($colexcludes[$i][0]!=0) {
$col=$colexcludes[$i][0];

$n= "n".(($col*3)-3+1);
$m= "n".(($col*3)-3+2);
$o= "n".(($col*3)-3+3);

if (($colexcludes[$i][1]==0 || $colexcludes[$i][1]==$$n) && ($colexcludes[$i][2]==0 || $colexcludes[$i][2]==$$m) && ($colexcludes[$i][3]==0 ||$colexcludes[$i][3]==$$o))  {
$found=true;
if ($colexcludes[$i][3]!=0) {
while ($colexcludes[$i][3]==$$o) { $$o = Gen(); }
} else if ($colexcludes[$i][2]!=0) {
while ($colexcludes[$i][2]==$$m) $$m = Gen();
} else if ($colexcludes[$i][1]!=0) {
while ($colexcludes[$i][1]==$$n) $$n = Gen();
}
}
} else {


for ($j=1;$j<=5;$j++) {
$col=$j;

$n= "n".(($col*3)-3+1);
$m= "n".(($col*3)-3+2);
$o= "n".(($col*3)-3+3);

if (($colexcludes[$i][1]==0 || $colexcludes[$i][1]==$$n) && ($colexcludes[$i][2]==0 || $colexcludes[$i][2]==$$m) && ($colexcludes[$i][3]==0 ||$colexcludes[$i][3]==$$o))  {
$found=true;

if ($colexcludes[$i][3]!=0) {
while ($colexcludes[$i][3]==$$o) { $$o = Gen(); }
} else if ($colexcludes[$i][2]!=0) {
while ($colexcludes[$i][2]==$$m) $$m = Gen();
} else if ($colexcludes[$i][1]!=0) {
while ($colexcludes[$i][1]==$$n) $$n = Gen();
}
}
}
}
}
if ($found==true) return true; else return false;
}



function evalline($d1,$d2,$d3,$d4,$d5,$k) {
global $n1,$n2,$n3,$n4,$n5,$n6,$n7,$n8,$n9,$n10,$n11,$n12,$n13,$n14,$n15,$winall; 
global $mntwokind,$mnthreekind,$mnfourkind,$mnfivekind;

$win=0;
$result=0; 

$ss1 =  "n$d1"; $s1 = $$ss1;
$ss2 =  "n$d2"; $s2 = $$ss2;
$ss3 =  "n$d3"; $s3 = $$ss3;
$ss4 =  "n$d4"; $s4 = $$ss4;
$ss5 =  "n$d5"; $s5 = $$ss5;


if ($s1!=10 && $s1 != 11 && $s1 != 13) {
if ($n4 == 2 || $n5==2 || $n6==2) {$s2 = $s1; } //on  pos 2 a joker 
if ($n7 == 2 || $n8==2 || $n9==2) {$s3 = $s2; } //on  pos 3 a joker 
if ($n10 == 2 || $n11==2 || $n12==2) {$s4 = $s3; } //on  pos 4 a joker 
}

if ($s1 == $s2) {$result = 2; } 
if ($s1 == $s2 && $s2 == $s3) {$result = 3;  } 
if ($s1 == $s2 && $s2 == $s3 && $s3 == $s4) {$result = 4; } 
if ($s1 == $s2 && $s2 == $s3 && $s3 == $s4 && $s4==$s5) {$result = 5; } 


//scatter:
if (($s2==5 && $s3==5 && $s4==5) || ($s2==5 && $s3==5 && $s5==5)  || ($s2==5 && $s4==5 && $s5==5) || ($s3==5 && $s4==5 && $s5==5)) {
$result = 9;
for ($i=1;$i<=5;$i++) { $k= "s$i"; if ($$k != 5)  $$k=0; }
}

if (!$result) return false;

if ($result != 9) {

/*
#set joker ,  no joker by pyramid or king
if ($s1!=10 && $s1 != 11) 
for ($i=$result+1;$i<=5;$i++) { $s =  "s$i";  if ($$s==2) { $result++ ; $k= "s$result"; $$k= $s1;} else break; } 
*/

#the other values 0
for ($i=$result+1;$i<=5;$i++) { $k= "s$i"; $$k=0; }
}

$paytable[8][8][8][8][8] = 15000;
$paytable[8][8][8][8][0] = 2000;
$paytable[8][8][8][0][0] = 100;
$paytable[8][8][0][0][0] = 10;

$paytable[9][9][9][9][9] = 2000;
$paytable[9][9][9][9][0] = 500;
$paytable[9][9][9][0][0] = 10;
$paytable[9][9][0][0][0] = 2;

$paytable[7][7][7][7][7] = 1000;
$paytable[7][7][7][7][0] = 500;
$paytable[7][7][7][0][0] = 50;

$paytable[5][5][5][5][5] = 100;
$paytable[5][5][5][5][0] = 50;
$paytable[5][5][5][0][0] = 5;

$paytable[1][1][1][1][1] = 500;
$paytable[1][1][1][1][0] = 100;
$paytable[1][1][1][0][0] = 10;

//3,4,6,12,14 -->
$paytable[3][3][3][3][3] = 100;
$paytable[3][3][3][3][0] = 25;
$paytable[3][3][3][0][0] = 5;

$paytable[4][4][4][4][4] = 100;
$paytable[4][4][4][4][0] = 25;
$paytable[4][4][4][0][0] = 5;

$paytable[6][6][6][6][6] = 100;
$paytable[6][6][6][6][0] = 25;
$paytable[6][6][6][0][0] = 5;

$paytable[12][12][12][12][12] = 100;
$paytable[12][12][12][12][0] = 25;
$paytable[12][12][12][0][0] = 5;

$paytable[14][14][14][14][14] = 100;
$paytable[14][14][14][14][0] = 25;
$paytable[14][14][14][0][0] = 5;

$paytable[5][5][5][5][5] = 100;

$paytable[5][5][5][5][0] = 50;
$paytable[5][5][5][0][5] = 50;
$paytable[5][5][0][5][5] = 50;
$paytable[5][0][5][5][5] = 50;
$paytable[0][5][5][5][5] = 50;

$paytable[5][5][5][0][0] = 5;
$paytable[5][5][0][5][0] = 5;
$paytable[5][5][0][0][5] = 5;

$paytable[5][0][5][5][0] = 5;
$paytable[5][0][5][0][5] = 5;
$paytable[5][0][0][5][5] = 5;

$paytable[0][5][5][5][0] = 5;
$paytable[0][5][5][0][5] = 5;
$paytable[0][5][0][5][5] = 5;

$win = $paytable[$s1][$s2][$s3][$s4][$s5];

$winall += $win;

_log(" function evalline won s1-s5: $s1 $s2 $s3 $s4 $s5  win:$win result:$result winall:$winall");

}

function countpyrvalues() {
$arrval = Array(10,20,0,40,60,0,100,120,0,180,200);
$vals="";

for ($i=11;$i>0;$i--) {
$rand= rand(1,$i); $val= $arrval[$rand]; $vals.=$val."|";
array_slice($arrval,$rand,1);
}

$vals.=$arrval[0];

}



function countResultCo($lines){

if ($lines>0)  evalline(2,5,8,11,14,1);  //payline1
if ($lines>1)  evalline(1,4,7,10,13,2);  //payline2
if ($lines>2)  evalline(3,6,9,12,15,3);  //payline3
if ($lines>3)  evalline(1,5,9,11,12,4);  //payline4
if ($lines>4)  evalline(3,5,7,11,15,5);  //payline5
if ($lines>5)  evalline(1,4,8,11,13,6);  //payline6
if ($lines>6)  evalline(3,6,8,12,15,7);  //payline7
if ($lines>7)  evalline(2,4,7,10,14,8);  //payline8
if ($lines>8)  evalline(2,6,9,12,14,9);  //payline9
if ($lines>9)  evalline(1,4,8,12,15,10);  //payline10
if ($lines>10)  evalline(3,6,8,10,13,11);  //payline11
if ($lines>11)  evalline(1,5,8,11,13,12);  //payline12
if ($lines>12)  evalline(3,5,8,11,15,13);  //payline13
if ($lines>13)  evalline(2,5,7,11,14,14);  //payline14
if ($lines>14)  evalline(2,5,9,11,14,15);  //payline15
if ($lines>15)  evalline(2,4,8,10,14,16);  //payline16
if ($lines>16)  evalline(2,6,8,12,14,17);  //payline17
if ($lines>17)  evalline(1,5,7,11,13,18);  //payline18
if ($lines>18)  evalline(3,5,9,11,15,19);  //payline19
if ($lines>19)  evalline(3,4,9,10,15,20);  //payline20

}



///////////////////// MAIN //////////////////////



$maxtimedelay=500;
if ($_POST['kingbonus']) {  //playing kingbonus game

$result = mysql_query("select * from `games` where userid = '$userid' and date > $date - $maxtimedelay  order by gameid desc limit 1 ");
if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
if (mysql_num_rows($result)) {
$row  = mysql_fetch_array($result);
$gameid = $row['gameid'];
} else {
_log("exited:".__LINE__); exit;
}

$sql = "select * from kingbonus where gameid='$gameid' "; $result=mysql_query($sql);
if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
if (mysql_num_rows($result)) {
$row = mysql_fetch_array($result);
$counter = $row['counter'];
$won = $row['won'];
} else {
 _log("exited:".__LINE__); exit;
 }
 
$newarr = explode(',',$row['selectablearr']); 
$num = $_POST['num'];

$rand= rand(0,count($newarr)-1); $val= $newarr[$rand]; array_splice($newarr,$rand,1);
$newarrdata = implode(',',$newarr);
$winarrdata = $row['winarr'].$val.",";
$wondata = ',won=won+'.$val;
if (count($newarr)==0 || $val==0) {
$winking = $val+$won;
$rg="w"; $diff=0;$tm=time();
$sql = "insert into `transactions` values(transid, '$userid', '$gameid', '$tm', '$rg', '$winking', '$winking')";
$result =  mysql_query($sql);  if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
$sql = "update kingbonus set selectablearr='', counter=counter+1, winarr='$winarrdata' $wondata where gameid='$gameid' and uid='$userid' and type='1' "; $result =  mysql_query($sql);  if (!$result) { _log("sql:$sql exited:".__LINE__ . mysql_error()); exit;}
} else {
$sql = "update kingbonus set selectablearr='$newarrdata', counter=counter+1, winarr='$winarrdata' $wondata where gameid='$gameid' and uid='$userid' and type='1' "; $result =  mysql_query($sql);  if (!$result) { _log("sql:$sql exited:".__LINE__ . mysql_error()); exit;}
}
$enddata = "";
if ($val==0) {
$enddata = "remaining=".$newarrdata;
}
echo "won=$val&$enddata";
exit;
// end kingbonus ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
}
else if ($_POST['pyramid']) {  //playing pyramid game
$result = mysql_query("select * from `games` where userid = '$userid' and date > $date - $maxtimedelay  order by gameid desc limit 1 ");
if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
if (mysql_num_rows($result)) {
$row  = mysql_fetch_array($result);
$gameid = $row['gameid'];
} else {
_log("exited:".__LINE__); exit;
}

$sql = "select * from pyramid where gameid='$gameid' "; $result=mysql_query($sql);
if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
if (mysql_num_rows($result)) {
$row = mysql_fetch_array($result);
$counter = $row['counter'];
$won = $row['won'];
} else {
 _log("exited:".__LINE__); exit;
 }
 
if ($row['nulls'] >=3)  { _log("exited:".__LINE__); exit;}

$newarr = explode(',',$row['selectablearr']); 
$num = $_POST['num'];

$rand= rand(0,count($newarr)-1); $val= $newarr[$rand]; array_splice($newarr,$rand,1);
$newarrdata = implode(',',$newarr);
$winarrdata = $row['winarr'].$val.",";
$nulls=$row['nulls'];
$nullsdata=""; if ($val==0) {$nullsdata= ',nulls=nulls+1'; $nulls++;}
$wondata = ',won=won+'.$val;
$enddata ="";
if ($nulls>2) {
$winpyr = $val+$won;
$rg="w"; $diff=0;$tm=time();
$sql = "insert into `transactions` values(transid, '$userid', '$gameid', '$tm', '$rg', '$winpyr', '$winpyr')";
$result =  mysql_query($sql);  if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
$enddata = "remaining=".$newarrdata;
} else {
$sql = "update pyramid set selectablearr='$newarrdata', winarr='$winarrdata' $nullsdata $wondata where gameid='$gameid' and uid='$userid' and type='1' ";
$result =  mysql_query($sql);  if (!$result) { _log("sql:$sql exited:".__LINE__ . mysql_error()); exit;}
}
echo "won=$val&$enddata";
exit;
// end pyramid ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
} else if ($_POST['gamble']) {  //playing gamble  black/red
_log('gamble');
$date=time();
if ($_POST['collect']) {
$result = mysql_query("select * from `games` where userid = '$userid' and date > $date - $maxtimedelay  order by  gameid desc limit 1 ");
if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
if (mysql_num_rows($result)) {
$row  = mysql_fetch_array($result);
if ($row['result'] != 'w') exit; 
$amount = $row['amount'];
$gameid = $row['gameid'];
$sql = " select * from gamble where gameid = '$gameid' and date > $date - $maxtimedelay order by id desc limit 1 "; 
$result = mysql_query($sql); if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
if (mysql_num_rows($result)) {
$row  = mysql_fetch_array($result);
$amount= $row['amount'];
} else {

//nothing special  was no gamble only collect 
}
$sql = "update `games` set result='e' where gameid = '$gameid' "; 
$result =  mysql_query($sql);  if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
$win_limit = calWinLimit();
$result = mysql_query("insert into `transactions` values(transid, '$userid', '$gameid', '$date', 'w', '$amount', '$win_limit')");
if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
exit;
}  
} else if ($_POST['half']) {  //half
_log('half');
$selected = intval($_POST['chosencolor']); //1: red 0: black
$rand = rand(0,1);
if ($rand==$selected) {
_log('won half');
$rg="w"; $diff=0; $tm=time();
$sql = "select * from `games` where userid = '$userid' and date > $date - $maxtimedelay  order by  gameid desc limit 1 ";
_log($sql);
$result = mysql_query($sql); if (!$result) {_log(mysql_error());exit;}
$row  = mysql_fetch_array($result);
$gameid = $row['gameid'];
$amount = $row['amount'];
if ($row['result'] != 'w') {_log("exited:".__LINE__);  exit;   }
$sql = " select gameid from gamble where gameid = '$gameid' and date > $date - $maxtimedelay order by id desc limit 1 "; 
$result = mysql_query($sql);  if (!$result) {_log("exited:".__LINE__ . mysql_error());exit;}
if (mysql_num_rows($result)) {
$row  = mysql_fetch_array($result);
$amount= $row['amount'];
$cardnum= $row['cardnum']; $cardnum++;
$sql = "insert into gamble set gameid='$gameid', date='$date', amount='$amount',cardnum='$cardnum' "; 
mysql_query($sql);
echo "won"; _log("won exited:".__LINE__); exit;
} else { //first card was turned up
$amount=$amount*2;
$sql = "insert into gamble set gameid='$gameid', date='$date', amount='$amount',cardnum='1' "; 
$result =  mysql_query($sql);  if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
echo "won"; _log("won exited:".__LINE__);  exit;
}
} else {  //the gamble was lost
_log('not won half');
$result = mysql_query("select * from `games` where userid = '$userid' and date > $date - $maxtimedelay  order by  gameid desc limit 1 ");
if (!$result) {_log("exited:".__LINE__ . mysql_error());exit;}
$row  = mysql_fetch_array($result);
if ($row['result'] != 'w') {_log("exited:".__LINE__);  exit;   }
$gameid = $row['gameid'];
$sql= "update `games` set result='f' where gameid = '$gameid' ";
$result =  mysql_query($sql);  if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
echo "lose"; _log("lose exited:".__LINE__);  exit;
}
} else if ($_POST['halfamount']) {  //half the amount
$sql = "select * from `games` where userid = '$userid' and date > $date - $maxtimedelay  order by  gameid desc limit 1 ";
$result = mysql_query($sql); if (!$result) {_log("exited ".mysql_error()." sql: $sql line:".__LINE__);exit;}
$row  = mysql_fetch_array($result);
$gameid = $row['gameid'];
$amount = $row['amount'];
if ($row['result'] != 'w') {_log("exited:".__LINE__);  exit;   }
$sql = " select gameid from gamble where gameid = '$gameid' and date > $date - $maxtimedelay order by id desc limit 1 "; 
$result = mysql_query($sql);  if (!$result) {_log("exited:".__LINE__ . mysql_error());exit;}
if (mysql_num_rows($result)) {
$row  = mysql_fetch_array($result);
$amount0 = $row['amount'];
$amount = intval($amount0/2);
$sql = "insert into gamble set gameid='$gameid', date='$date', amount='$amount',cardnum='$cardnum' "; 
$diff=$amount0-$amount; $tm= time();
$result = mysql_query("insert into `transactions` values(transid, '$userid', '$gameid', '$tm', 'l', '$diff', '$win_limit')");
if (!$result) { _log("exited ".mysql_error()." sql: $sql line:".__LINE__); exit;}
}
} 
}
// end gamble ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

_log("s5jpgen b: ".$_POST["b"]." l:".$_POST["l"]." c:".$_POST["c"]." uid: ".$_POST["uid"]);

if( !isset($_POST["b"]) ){ exit; }
if( !isset($_POST["l"]) ){ exit; }
if( !isset($_POST["c"]) ){ exit; }

$bet=$_POST["b"];
$bet=sprintf ("%01.2f", $bet);
$betcc=$_POST["l"];  
$c_val=$_POST["c"];

//Location ID
define("LOCID", $userid[0]);

// Update User
mysql_query("update `session` set `time`=".time()." where `userid`='$userid'");

//Get Jackpot Amount
//TODO Define (Jackpot)
$result=mysql_query("select `amount` from `jackpot` where `type`='53'");
$jackpot=mysql_result($result, 0, "amount");

// start game;

$win=0;
$winall =0;
$n1=Gen();
$n2=Gen();
$n3=Gen();
$n4=Gen();
$n5=Gen();
$n6=Gen();
$n7=Gen();
$n8=Gen();
$n9=Gen();
$n10=Gen();
$n11=Gen();
$n12=Gen();
$n13=Gen();
$n14=Gen();
$n15=Gen();
// Add blanks

for ($i=1;$i<=15;$i++) {
$n = "n".$i;
if (in_array($$n,array(10,11,13,2))) {
$$n = Gen();
}
}

//$n4=$n7=$n13 = 5; // test free spins
//$n1=$n6=$n10=10; // test pyr

//$n1=7; $n4=2; $n7=7;
//$n6=$n10=10; // test pyr

//$n1=$n6=$n10=11; // test king

//$n3=$n5=$n9=12; // test pyr

//$n2=$n7=$n14=13; // test free spin

//$n1=9;
//$n5=2; 

//columns : n1 n2 n3 , n4 n5 n6, n7 n8 n9, n10 n11 n12, n13 n14 n15
//rows : n1  n4 n7 n10 n13,  n2  n5 n8 n11 n14, n3 n6 n9 n12 n15 

while (colexceptions()) { } 

countResultCo($c_val);

$freespin=0;
//if freespin
if ($_POST['freespins']) {

$arr=  array();
$arr[0]="10|2";
$arr[1]="11|2";
$arr[2]="13|2";
while (allexceptions($arr) & colexceptions()) { } 

_log('freesopin');
$tm=time();
$sql="select * from freespins where uid='$userid' and counter > 0 and  date < $tm+5000 order by id desc";  $result= mysql_query($sql); if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;} else {
if (mysql_num_rows($result)) {
$row  = mysql_fetch_array($result);
$id = $row['id'];
$gameid = $row['gameid'];
$freespin=1; 
$sql="update freespins set  counter=counter-1 where id='$id' ";  $result= mysql_query($sql);
if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit; }
$sql="select betl from games where gameid='$gameid' ";  $result= mysql_query($sql);
if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit; }
$row  = mysql_fetch_array($result);
$betcc = $row['betl'];
$win= $winall*$betcc;
if ($win) {$sql="update freespins set  won=won+$win where id='$id' ";  $result= mysql_query($sql); if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit; }  
_log("betfreespin:"+$betcc);
$sql = "update `games` set  amount=amount+$win where gameid = '$gameid' ";
_log($sql);
$result= mysql_query($sql); if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
}
} else {
//_log("exited:".__LINE__); exit;
}
} 
}


$win= $winall*$betcc;
_log("winall:".$winall." betcc:".$betcc);
$maxwin=calWinLimit();


//update games and transactions
$win_limit = sprintf ("%01.2f", $maxwin); 
$diff=$win-$bet;
$diff = sprintf ("%01.2f", $diff);
if($bet>=0){$rg="w";}else{$rg="l";}
$tm=time();
if (!$freespin) {
$sql = "insert into `games` values(gameid, '$userid', '$tm', '$bet','$betcc', '-1', '$rg', '$win', '53')";
_log($sql);
$result= mysql_query($sql); if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
$gameid=mysql_insert_id();
} else {

}




//pyramid
$pyramidcnt=0; for ($k=0;$k<=15;$k++) { $var= "n$k"; if ($$var == 10) $pyramidcnt++;  }  //count pyramids
if ($pyramidcnt>=3) {
$winarr=array(0,0,0,1,2,4,6,8,10,12,16);
for ($i=0;$i<count($winarr);$i++) {$winarr[$i] = intval($winarr[$i]*($bet/5)); } $pyrvals = implode(',',$winarr);
$sql="insert into pyramid set selectablearr='$pyrvals', gameid='$gameid', date='$tm', type='1', uid='$userid' "; $result= mysql_query($sql); if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;} } //insert pyramids


//king bonus
$kingbonuscnt=0; for ($k=0;$k<=15;$k++) { $var= "n$k"; if ($$var == 11) $kingbonuscnt++;  }  //count pyramids
if ($kingbonuscnt>=3) {
$winarr=array(10,12,0,16,18);
for ($i=0;$i<count($winarr);$i++) {$winarr[$i] = intval($winarr[$i]*($bet/5)); } $kingvals = implode(',',$winarr);
$sql="insert into kingbonus set selectablearr='$kingvals', gameid='$gameid', date='$tm', type='1', uid='$userid' "; $result= mysql_query($sql); if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;} } //insert kingbonus

//check if  next will be freespins
$freespinscnt=0; for ($k=0;$k<=15;$k++) { $var= "n$k"; if ($$var == 13) $freespinscnt++;  }  //count 
if ($freespinscnt>=3) {   $type="freespin";
$sql="insert into freespins set  gameid='$gameid', uid='$userid', date='$tm',counter=10 ";  $result= mysql_query($sql); if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;} } //insert freespins



if (!$freespin) {
$result = mysql_query("insert into `transactions` values(transid, '$userid', '$gameid', '$tm', 'l', '-$bet', '$win_limit')");
if (!$result) { _log("exited:".__LINE__ . mysql_error()); exit;}
}


//Update Jackpot 1/10 of the bet
mysql_query("update `jackpot` set `amount`=`amount`+$bet/10 where `type`='53'");

//user balance
list($user_balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$user_balance = sprintf ("%01.2f", $user_balance); 

// send answer
$answer="&slottype=$type&ans=res&ub=".$user_balance."&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9."&n10=".$n10."&n11=".$n11."&n12=".$n12."&n13=".$n13."&n14=".$n14."&n15=".$n15."&jp=".$jackpot;
_log("answ:".$answer);
echo $answer;
?>