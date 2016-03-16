package com.playtech.casino3.slots.top_trumps_stars.slot_symbols
{

    public class Team_1_Player_3 extends GameSpecificSlotSymbol
    {
        public static const symbol:Team_1_Player_3 = new Team_1_Player_3;

        public function Team_1_Player_3()
        {
            return;
        }// end function

        override protected function init() : void
        {
            _player_index = 3;
            _is_from_team_1 = true;
            return;
        }// end function

    }
}
