package com.playtech.casino3.slots.top_trumps_stars.slot_symbols
{
    import com.playtech.casino3.slots.shared.base_game.*;

    public class GameSpecificSlotSymbol extends BaseSlotSymbol
    {
        protected var _is_mixed:Boolean;
        protected var _is_from_team_1:Boolean;
        protected var _is_from_team_2:Boolean;
        protected var _player_index:Number;

        public function GameSpecificSlotSymbol(com.playtech.casino3.slots.top_trumps_stars.slot_symbols:GameSpecificSlotSymbol:Array = null, com.playtech.casino3.slots.top_trumps_stars.slot_symbols:GameSpecificSlotSymbol:Boolean = true) : void
        {
            super(com.playtech.casino3.slots.top_trumps_stars.slot_symbols:GameSpecificSlotSymbol, com.playtech.casino3.slots.top_trumps_stars.slot_symbols:GameSpecificSlotSymbol);
            return;
        }// end function

        public function get is_mixed() : Boolean
        {
            return this._is_mixed;
        }// end function

        public function get is_from_team_1() : Boolean
        {
            return this._is_from_team_1;
        }// end function

        public function get is_from_team_2() : Boolean
        {
            return this._is_from_team_2;
        }// end function

        public function get player_index() : Number
        {
            return this._player_index;
        }// end function

    }
}
