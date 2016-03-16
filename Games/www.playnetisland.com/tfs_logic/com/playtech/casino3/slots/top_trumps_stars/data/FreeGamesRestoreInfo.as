package com.playtech.casino3.slots.top_trumps_stars.data
{
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import flash.utils.*;

    public class FreeGamesRestoreInfo extends BaseRestoreInfo
    {
        protected var _free_spins_win:Number = NaN;
        protected var _is_valid:Boolean = false;
        protected var _is_click_to_start:Boolean = false;
        protected var _is_first_team_in_free_games:Boolean = false;

        public function FreeGamesRestoreInfo(param1:Object, param2:FreeSpins) : void
        {
            this.parse(param1, param2);
            return;
        }// end function

        public function toString() : String
        {
            var _loc_1:* = "------ DATA " + getQualifiedClassName(FreeGamesRestoreInfo) + " -----" + N;
            _loc_1 = _loc_1 + (T + "IS CLICK TO START " + this.is_click_to_start + N);
            _loc_1 = _loc_1 + (T + "IS FIRST TEAM IN FREE GAMES " + this._is_first_team_in_free_games + N);
            _loc_1 = _loc_1 + (T + "FREE SPINS WIN " + this._free_spins_win + N);
            _loc_1 = _loc_1 + "------ END DATA -----";
            return _loc_1;
        }// end function

        public function get is_valid() : Boolean
        {
            return this._is_valid;
        }// end function

        public function get is_click_to_start() : Boolean
        {
            return this._is_click_to_start;
        }// end function

        public function get is_first_team_in_free_games() : Boolean
        {
            return this._is_first_team_in_free_games;
        }// end function

        public function parse(param1:Object, param2:FreeSpins) : void
        {
            this._is_click_to_start = int(param1["startbonus"]) == 0;
            if (this._is_click_to_start && param2.getFS() == 0)
            {
                this._is_click_to_start = false;
            }
            this._is_first_team_in_free_games = int(param1["team"]) == 0;
            this._free_spins_win = this._is_click_to_start ? (0) : (param2.getFSWin());
            this._is_valid = !(int(param1["mode"]) == 0 && param2.getFS() == 0);
            return;
        }// end function

        public function get free_spins_win() : Number
        {
            return this._free_spins_win;
        }// end function

    }
}
