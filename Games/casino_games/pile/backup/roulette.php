<?PHP
error_reporting(0);
session_start();
require('../scripts/connect.php');

if( $_REQUEST['mode']!="DEMO"){
if( !isset($_SESSION["enter"])||!isset($_SESSION["userid"]) ){ header("location:$siteurl/login.php"); }
}
$userid=$_SESSION["userid"];

$sid=session_id();
//mysql_query("replace into `session` values('$sid', $userid, ".time()." )");

?>
<html>
<head>
<title>Welcome to <?=$sitename?> <?=$_REQUEST['mode']?>!</title>
<style type="text/css">
<!--
body {overflow: hidden; margin:0;}
-->
</style>
</head>
<body bgcolor="#000000">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
<tr align="center">
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="roulette.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>&lmt=<?=$_REQUEST['lmt']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="roulette.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>&lmt=<?=$_REQUEST['lmt']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
</tr>
</table>
</body>
</html>