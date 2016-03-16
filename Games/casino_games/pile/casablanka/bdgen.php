<?php
error_reporting(E_ALL);
require('../scripts/connect.php');

if( isset($_POST["bt"]) ){ $bet=$_POST["bt"]; }else{ exit; }
$bet_value=$_POST["bv"];

///////////////////////////// objects //////////////////////////////////////
class Bet{
	var $desc="";
	var $val=-1;
	function Bet($str){
		$parts=explode("[",$str);
		$this->desc=$parts[0];
		$this->val=$parts[1];
	}
}
class Card{
	var $worth=-1;
	var $suit=-1;
	var $num=-1;
	function Card($w,$s,$n){
		$this->worth=$w;
		$this->suit=$s;
		$this->num=$n;
	}
}
///////////////////////////// functions ////////////////////////////////////

function generateCards(){
	global $cards;
	do{
		$worth=rand(0,12); // генерировать стоимость
		switch($worth){
			case 0: $num=2; break;
			case 1: $num=3; break;
			case 2: $num=4; break;
			case 3: $num=5; break;
			case 4: $num=6; break;
			case 5: $num=7; break;
			case 6: $num=8; break;
			case 7: $num=9; break;
			case 8: $num=10; break;
			case 9: $num=10; break;
			case 10: $num=10; break;
			case 11: $num=10; break;
			case 12: $num=11; break;
		}
		$suit=rand(1,4); // генерировать масть

		$is_new=true;
		for($i=0; $i<count($cards); $i++){
			if( ($cards[$i]->worth==$worth)&&($cards[$i]->suit==$suit) ){ $is_new=false; }
		}
	}while(!$is_new); // если такая карта есть - генерировать заново
	$ncard=new Card($worth, $suit, $num);	
	array_push($cards, $ncard);
}
function calWin(){ 
	global $bets_items, $win, $bet_value, $cards, $pnum, $bnum, $pneed3, $bneed3;
	$num_bets=count($bets_items);
	// расчитать $pnum $bnum для выпавших карт
	$pnum=($cards[0]->num+$cards[2]->num)%10;
	$bnum=($cards[1]->num+$cards[3]->num)%10;
	// определяем, нужна ли третяя карта игроку
	if($pnum<6){ $pneed3=1; }
	if($bnum>=8){ $pneed3=0; } // натуральные - должен остановиться
	if($pneed3){ $pnum=($cards[0]->num+$cards[2]->num+$cards[4]->num)%10; }
	// определяем, нужна ли третяя карта банкомету
	switch($bnum){
		case 0: $bneed3=1; break;
		case 1: $bneed3=1; break;
		case 2: $bneed3=1; break;
		case 3: $bneed3=1; break;
		case 4: if($pnum>1){ $bneed3=1; }else{ $bneed3=0; } break;
		case 5: if($pnum>4){ $bneed3=1; }else{ $bneed3=0; } break;
		case 6: if($pnum>6){ $bneed3=1; }else{ $bneed3=0; } break;
		case 7: $bneed3=0; break;
		case 8: $bneed3=0; break;
		case 9: $bneed3=0; break;
	}
	if($pnum>=8){ $bneed3=0; } // натуральные - должен остановиться
	if($bneed3){ $bnum=($cards[1]->num+$cards[3]->num+$cards[5]->num)%10; }
	
	for($i=0;$i<$num_bets;$i++){ 
		$descr=$bets_items[$i]->desc;
		$val=$bets_items[$i]->val;
		switch($descr){
			case "Tie 1:8": if( $pnum==$bnum ){ $win+=$val*9;  } break;
			case "Banker 1:1": if( $bnum>$pnum ){ $win+=$val*2-$val*0.05;  } break;
			case "Player 1:1": if( $bnum<$pnum ){ $win+=$val*2;  } break;
		}
	}	
	$diff=$win-$bet_value;
	return $diff;
}
///////////////////////////// MAIN     /////////////////////////////////////
$bet=trim($bet);
$l=strlen($bet)-1;
$bet=substr($bet,0,$l);

$bets=explode("@",$bet);
$bets_items=array();
foreach($bets as $value){
	$item=new Bet($value);
	array_push($bets_items, $item);
}
$pnum=-1;
$bnum=-1;
$pneed3=0;
$bneed3=0;

	$cards=array();
	for($j=0; $j<6; $j++){ generateCards(); }
	$win=0;
	$lost=0;
	$diff=calWin();

$cd=$cards[0]->worth."@".$cards[0]->suit."!";
$cd.=$cards[1]->worth."@".$cards[1]->suit."!";
$cd.=$cards[2]->worth."@".$cards[2]->suit."!";
$cd.=$cards[3]->worth."@".$cards[3]->suit."!";
$cd.=$cards[4]->worth."@".$cards[4]->suit."!";
$cd.=$cards[5]->worth."@".$cards[5]->suit;
echo "&cd=".$cd."&wn=".$win."&pnum=".$pnum."&bnum=".$bnum."&pneed3=".$pneed3."&bneed3=".$bneed3;

?>