<?PHP

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
<? if(( $_REQUEST['type'] == 51) && ($_REQUEST['game'] == 1)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="classic_slot.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="classic_slot.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 51) && ($_REQUEST['game'] == 2)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="fruit_machine.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="fruit_machine.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 51) && ($_REQUEST['game'] == 3)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="golden_sultan.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="golden_sultan.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 51) && ($_REQUEST['game'] == 4)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="medieval.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="medieval.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 51) && ($_REQUEST['game'] == 5)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="hot_nights.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="hot_nights.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 51) && ($_REQUEST['game'] == 6)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="treasure.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="treasure.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 51) && ($_REQUEST['game'] == 7)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="triple_stars.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="triple_stars.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 52) && ($_REQUEST['game'] == 1)){  ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="caribbean_slots.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="caribbean_slots.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 52) && ($_REQUEST['game'] == 2)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="adams_apple_slots.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="adams_apple_slots.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 52) && ($_REQUEST['game'] == 3)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="royal_strike_slots.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="royal_strike_slots.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 53) && ($_REQUEST['game'] == 1)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="old_farm_slots.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="old_farm_slots.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 53) && ($_REQUEST['game'] == 2)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="green_dragon_slots.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="green_dragon_slots.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 54) && ($_REQUEST['game'] == 3)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="s53.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="s53.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 54) && ($_REQUEST['game'] == 4)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="s54.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="s54.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? }else if(( $_REQUEST['type'] == 54) && ($_REQUEST['game'] == 5)){ ?>
<td><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="100%" id="main" align="middle">
<param name="movie" value="s56.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" />
<param name="quality" value="best" />
<param name="menu" value="false" />
<param name="bgcolor" value="#000000" />
<param name="wmode" value="transparent"></param>
<embed src="s56.swf?u=<?=$sid?>&tp=<?=$_REQUEST['type']?>&mode=<?=$_REQUEST['mode']?>" quality="best" menu="false" bgcolor="#000000" width="100%" height="100%" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object></td>
<? } ?>
</tr>
</table>
</body>
</html>