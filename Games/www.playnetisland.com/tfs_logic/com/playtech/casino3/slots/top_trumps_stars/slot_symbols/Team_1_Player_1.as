package com.playtech.casino3.slots.top_trumps_stars.slot_symbols
{

    public class Team_1_Player_1 extends GameSpecificSlotSymbol
    {
        public static const symbol:Team_1_Player_1 = new Team_1_Player_1;

        public function Team_1_Player_1()
        {
            return;
        }// end function

        override protected function init() : void
        {
            _player_index = 1;
            _is_from_team_1 = true;
            return;
        }// end function

    }
}
