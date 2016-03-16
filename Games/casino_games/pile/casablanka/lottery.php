<?PHP
##############################################################################
# PROGRAM : GamingWare Casino System                                         #
# VERSION : 2.01                                                             #
# REVISION: 001										     #
# DATE    : 31/03/2008                                                       #
##############################################################################
# All source code, images, programs, files included in this package          #
# Copyright (c) 2003-2008 GAMINGWARE All Rights Reserved.  	     		     #
# www.gamingware.co.uk							     		     #
##############################################################################
#                                                                            #
#    While we distribute the source code for our scripts/software and you    #
#    are allowed to edit them to better suit your needs, we do not           #
#    support modified code.  Please see the license prior to changing        #
#    anything. You must agree to the license terms before using this         #
#    software package or any code contained herein.                          #
#                                                                            #
#    Any redistribution without permission of GamingWare.                    #
#    is strictly forbidden.                                                  #
#                                                                            #
##############################################################################

if ($_SERVER["SERVER_NAME"] != "www.casablanca-casino.co.uk") { exit; }
$tm=time();
$dm=date("m", $tm);

session_start();
require('../scripts/connect.php');

if( !isset($_SESSION["enter"])||!isset($_SESSION["userid"]) ){ echo "ERROR!!"; exit; }
$userid=$_SESSION["userid"];
$sid=session_id();
mysql_query("replace into `session` values('$sid', $userid, ".time()." )");

mysql_query("update `users` set `lplay_date`=".time()." where `userid`=$userid");

list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$balance = sprintf ("%01.2f", $balance);
if ($balance<=1){ 
?>
<script language="Javascript">
<!--
alert ("Your balance is <?=$balance?>")
//-->
</script>
<? }

$error_mssg = "<small>Your ticket will be logged in automatically</small>";
// Ticket Sumbitted
if (isset($_GET['numbers'])){
if ($balance<=0){
$error_mssg = "<small>Your balance is ".$balance."</small>";
}else{
$myVar = $_GET['numbers'];
$ticket_array = explode(',',$myVar);
//print_r($tok);
//$ticket_array=$_GET['numbers'];
sort($ticket_array);

$tm=time();

//Log Ticket
$result=mysql_query("insert into `lottery_tickets` values ('','$ticket_array[0]','$ticket_array[1]','$ticket_array[2]','$ticket_array[3]','$ticket_array[4]','$ticket_array[5]','$ticket_array[6]','$userid','$tm','$CURRENT_DRAW')");
$ticket_id=mysql_insert_id();

//Log Transaction
mysql_query("insert into `transactions` values('', '$userid', '$ticket_id', '$tm', 'l', '-$ticket_price', '$CURRENT_DRAW')");

list($balance) = mysql_fetch_row(mysql_query("SELECT SUM(amount) FROM transactions WHERE userid='$userid'"));
$balance = sprintf ("%01.2f", $balance);
$logged=1;
$error_mssg = "<small>Ticket Purchased: ".$ticket_id."<br>".$ticket_array[0].",".$ticket_array[1].",".$ticket_array[2].",".$ticket_array[3].",".$ticket_array[4].",".$ticket_array[5].",".$ticket_array[6]."</small>";
}
}
include('../html/ticket.php');
?>