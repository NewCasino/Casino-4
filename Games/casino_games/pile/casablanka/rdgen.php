<?php
// demo generator
//error_reporting(E_ALL);
//require('../scripts/connect.php');


if( isset($_POST["bt"]) ){ $bet=$_POST["bt"]; }else{ exit; }
//$bet="1st Column 2:1[100[@Split 17:1[100[35 36 @Corner 8:1[100[23 24 21 20 @";
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
// подсчитать выйгрыш
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
				if( $res==$n ){ $win+=$val*36; }break;
			case "First four 8:1": if( ($res==0)||($res==1)||($res=2)||($res=3) ){ $win+=$val*9; } break;
			case "Three 11:1": $n0=$flds[0]; $n1=$flds[1]; settype($n0,"integer"); settype($n1,"integer");
				if( ($res==0)||($res==$n0)||($res==$n1) ){ $win+=$val*12; } break;
			case "Six number 5:1": $n0=$flds[0]; $n1=$flds[1]; $n2=$flds[2]; $n3=$flds[3]; $n4=$flds[4]; $n5=$flds[5];
				settype($n0,"integer"); settype($n1,"integer"); settype($n2,"integer"); settype($n3,"integer"); settype($n4,"integer"); settype($n5,"integer");
				if( ($res==$n0)||($res==$n1)||($res==$n2)||($res==$n3)||($res==$n4)||($res==$n5) ){	$win+=$val*6; } break;
			case "Street 11:1": $n0=$flds[0]; $n1=$flds[1]; $n2=$flds[2];
				settype($n0,"integer"); settype($n1,"integer"); settype($n2,"integer");
				if( ($res==$n0)||($res==$n1)||($res==$n2) ){ $win+=$val*12; } break;
			case "Corner 8:1": $n0=$flds[0]; $n1=$flds[1]; $n2=$flds[2]; $n3=$flds[3];
				settype($n0,"integer"); settype($n1,"integer"); settype($n2,"integer"); settype($n3,"integer");
				if( ($res==$n0)||($res==$n1)||($res==$n2)||($res==$n3) ){ $win+=$val*9; } break;
			case "Split 17:1": $n0=$flds[0]; $n1=$flds[1]; settype($n0,"integer"); settype($n1,"integer");
				if( ($res==$n0)||($res==$n1) ){	$win+=$val*18; }break;
		}
	}	
	$diff=$win+$lost;
	return $diff;
}
///////////////////////////// MAIN     /////////////////////////////////////
// обработать строку ставок - создать массив объектов
$bet=trim($bet);
$l=strlen($bet)-1;
$bet=substr($bet,0,$l);

$bets=explode("@",$bet);
$bets_items=array();
foreach($bets as $value){
	$item=new Bet($value);
	array_push($bets_items, $item);
}

$res=rand(0,36);
$win=0;
$lost=0;
$diff=calWin($res);

// вернуть результат
echo "iv=".$res."&wn=".$win."&ls=".$lost;
?>