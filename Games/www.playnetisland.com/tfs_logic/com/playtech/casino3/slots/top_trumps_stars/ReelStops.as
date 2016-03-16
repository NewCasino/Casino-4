package com.playtech.casino3.slots.top_trumps_stars
{
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.slot_symbols.*;

    class ReelStops extends BaseReelStops
    {
        protected var _state:GameState;
        protected var _logic:Logic;

        function ReelStops(param1:Logic) : void
        {
            this._logic = param1;
            return;
        }// end function

        protected function reelStopsNormalGame() : void
        {
            var _loc_1:* = BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE + ".flags." + this._logic.country_1.type.toLowerCase() + ".stop";
            var _loc_2:* = BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE + ".flags." + this._logic.country_2.type.toLowerCase() + ".stop";
            var _loc_3:String = "reelstop_flag";
            pushRule(Flag_1, this.Vector.<int>([0, 0, 0, 0, 1]), _loc_1, _loc_3);
            pushRule(Flag_2, this.Vector.<int>([0, 0, 0, 0, 1]), _loc_2, _loc_3);
            return;
        }// end function

        public function get state() : GameState
        {
            return this._state;
        }// end function

        protected function reelStopsFreeGame() : void
        {
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._logic = null;
            return;
        }// end function

        public function set state(param1:GameState) : void
        {
            this._state = param1;
            clear();
            if (this._state == GameState.NORMAL)
            {
                this.reelStopsNormalGame();
            }
            return;
        }// end function

    }
}
