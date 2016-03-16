package com.playtech.casino3.slots.top_trumps_stars
{
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.slot_symbols.*;

    public class Anticipation extends BaseAnticipation
    {
        protected var _state:GameState;

        public function Anticipation()
        {
            return;
        }// end function

        public function get state() : GameState
        {
            return this._state;
        }// end function

        protected function anticipationNormalGame() : void
        {
            var _loc_1:Array = [1, 0, 0, 0, 1];
            pushRule(Flag_1, _loc_1);
            pushRule(Flag_2, _loc_1);
            return;
        }// end function

        public function set state(state_:GameState) : void
        {
            this._state = state_;
            clear();
            if (state_ == GameState.NORMAL)
            {
                this.anticipationNormalGame();
            }
            if (state_ == GameState.FREESPIN)
            {
                this.anticipatioFreeGame();
            }
            return;
        }// end function

        protected function anticipatioFreeGame() : void
        {
            return;
        }// end function

    }
}
