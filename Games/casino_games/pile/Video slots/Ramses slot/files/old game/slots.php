<?PHP
##############################################################################
# PROGRAM : Casino System                                                    #
# VERSION : 1.05                                                             #
# REVISION: 000										     #
# DATE    : 03/03/2005                                                       #
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

session_start();
require("connect.php");

//test

$_SESSION["userid"]=1;
$_REQUEST['mode']="REAL";
$sitename="test";
$_REQUEST['type']="type";
$_SESSION["enter"]=1;

//end test


if( $_REQUEST['mode']!="DEMO"){
if( !isset($_SESSION["enter"])||!isset($_SESSION["userid"]) ){ header("location: login.php"); }
}


$userid=$_SESSION["userid"];

$sid=session_id();
mysql_query("replace into `session` values('$sid', $userid, ".time()." )");
?>
<html>
<head>
<title>Welcome to <?=$sitename?> <?=$_REQUEST['mode']?>!</title>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#000000">
<!-- window.moveTo(0,0);
self.resizeTo(screen.availWidth,screen.availHeight); -->
<script language="JavaScript">
<!--

function click() {
if (event.button==2) {
alert('Copyright content © by <?=$sitename?>.')
}}
document.onmousedown=click
// -->
</script>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
<tr align="center">
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="800" height="600" id="main" align="middle">
<param name="movie" value="s51.swf" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<PARAM NAME=FlashVars VALUE="u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>">
<embed src="s51.swf" FlashVars="u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="800" height="600" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
</tr>
</table>
</body>
</html>