<?PHP

	class Card{
		var $worth = -1;		
		var $suit = -1;		
		var $num = -1;
		function Card($w, $s, $n) {		
			$this->worth = $w;			
			$this->suit = $s;			
			$this->num = $n;			
		}
	}
	
	function generateCards() {	
		global $all_cards;
		$card = 0;		
		do {
			$suit = rand(1, 4);			
			$worth = rand(0, 12);			
			switch($worth){
				case 0: $card = new Card( "c_2", $suit, 2); break;				
				case 1: $card = new Card( "c_3", $suit, 3); break;				
				case 2: $card = new Card( "c_4", $suit, 4); break;				
				case 3: $card = new Card( "c_5", $suit, 5); break;				
				case 4: $card = new Card( "c_6", $suit, 6); break;				
				case 5: $card = new Card( "c_7", $suit, 7); break;				
				case 6: $card = new Card( "c_8", $suit, 8); break;				
				case 7: $card = new Card( "c_9", $suit, 9); break;				
				case 8: $card = new Card( "c_10", $suit, 10); break;				
				case 9: $card = new Card( "c_J", $suit, 11); break;				
				case 10: $card = new Card( "c_Q", $suit, 12); break;				
				case 11: $card = new Card( "c_K", $suit, 13); break;				
				case 12: $card = new Card( "c_A", $suit, 14); break; 				
			}

			// check is it unique
			$is_new=true;
			for ($i = 0; $i < count($all_cards); $i++) {			
				if ( ($all_cards[$i]->worth == $card->worth) && ($all_cards[$i]->suit == $card->suit) ) { $is_new = false; }				
			}
		} while (!$is_new); // if card not unique - generate it again		
		array_push($all_cards, $card);		
		return $card;
	}
	
	$all_cards = array();
	$dealer_c = generateCards();
	$player_c = generateCards();
	$cd = "";	
	
	$dcd.= $dealer_c->worth."@".$dealer_c->suit."!";		
	$pcd.= $player_c->worth."@".$player_c->suit."!";	
	
	$user_balance = -1; 
	
	$answer="&ans=Res&pcd=".$pcd."&dcd=".$dcd."&ub=".$user_balance;
	echo $answer;

?>
