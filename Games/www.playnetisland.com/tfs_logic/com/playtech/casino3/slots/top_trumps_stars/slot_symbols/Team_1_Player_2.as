package com.playtech.casino3.slots.top_trumps_stars.slot_symbols
{

    public class Team_1_Player_2 extends GameSpecificSlotSymbol
    {
        public static const symbol:Team_1_Player_2 = new Team_1_Player_2;

        public function Team_1_Player_2()
        {
            return;
        }// end function

        override protected function init() : void
        {
            _player_index = 2;
            _is_from_team_1 = true;
            return;
        }// end function

    }
}
