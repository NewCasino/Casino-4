<?PHP
##############################################################################
# PROGRAM : Casino System                                                    #
# VERSION : 1.03                                                             #
# REVISION: 015										     #
# DATE    : 01/11/2004                                                       #
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
// demo generator

///////////////////// functions //////////////////////
function Gen(){
	$res=rand(0, 680);
	if( $res<50 ){ $n=6; }
	if( ($res>=50)&&($res<250) ){ $n=5; }
	if( ($res>=250)&&($res<400) ){ $n=4; }
	if( ($res>=400)&&($res<500) ){ $n=3; }
	if( ($res>=500)&&($res<600) ){ $n=2; }
	if($res>=600){ $n=1; }
	return $n;
}
//

function countLine($a, $b, $c){
	global $win, $bet;
	if( ($a==$b)&&($b==$c) ){
		switch ($a){
			case 1: $win=1000*$bet; break;
			case 2: $win=250*$bet; break;
			case 3: $win=50*$bet; break;
			case 4: $win=25*$bet; break;
			case 5: $win=10*$bet; break;
		}
	}else{
		if( ($a==$b)||($b==$c) ){if($b==5){ $win=2*$bet; }} //2x
		if ( ($a>1)&&($a<5)&&($b>1)&&($b<5)&&($c>1)&&($c<5)){ $win=4*$bet; } //Any Bar
		if( ($a==5)&&($b!=5)||($c==5)&&($b!=5)){ $win=1*$bet; } //1x
	}
}

///////////////////// MAIN //////////////////////
//error_reporting(E_ALL);
//include("../scripts/config.php");
//$connection=mysql_connect($host,$user,$password);
//if(!$connection){ exit; }
//mysql_select_db($dbname);

if( !isset($_POST["b"]) ){ exit; }
$bet=$_POST["b"];
$bet = sprintf ("%01.2f", $bet); 

// start game;
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
//remove 2 blank in a row
	if (($n1==6)&&($n4==6)){$n1=Gen();}
	if (($n4==6)&&($n7==6)){$n7=Gen();}
	if (($n2==6)&&($n5==6)){$n2=Gen();}
	if (($n5==6)&&($n8==6)){$n8=Gen();}
	if (($n3==6)&&($n6==6)){$n3=Gen();}
	if (($n6==6)&&($n9==6)){$n9=Gen();}
	countLine($n4, $n5, $n6);
$win = sprintf ("%01.2f", $win); 
// send answer
$answer="&ans=res&wn=".$win."&n1=".$n1."&n2=".$n2."&n3=".$n3."&n4=".$n4."&n5=".$n5."&n6=".$n6."&n7=".$n7."&n8=".$n8."&n9=".$n9;
echo $answer;
?>