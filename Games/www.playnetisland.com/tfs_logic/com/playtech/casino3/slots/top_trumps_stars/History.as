package com.playtech.casino3.slots.top_trumps_stars
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;

    public class History extends SlotsHistory implements IDisposable
    {
        protected var _logic:Logic;

        public function History(logic_:Logic, logic_:IModuleInterface) : void
        {
            this._logic = logic_;
            super(logic_);
            FREE_SPINS_NAME = "bonus free ";
            FREE_SPINS_SEPARATOR = "";
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._logic = null;
            return;
        }// end function

        override protected function processPaylineWins(logic_:Array) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Vector.<WinInfo> = null;
            for each (_loc_2 in logic_)
            {
                
                _loc_3 = _loc_2 as Vector.<WinInfo>;
                if (!_loc_3)
                {
                    continue;
                }
                _loc_3.sort(this.sortAscendingByWinRule);
            }
            return;
        }// end function

        override protected function lineWinChunk(com.playtech.casino3.slots.shared:Vector.<WinInfo>, com.playtech.casino3.slots.shared:int, com.playtech.casino3.slots.shared:int, com.playtech.casino3.slots.shared:int) : String
        {
            var _loc_7:int = 0;
            var _loc_9:SlotsWin = null;
            var _loc_10:String = null;
            var _loc_5:String = "";
            var _loc_6:String = "";
            var _loc_8:* = com.playtech.casino3.slots.shared ? (com.playtech.casino3.slots.shared.length) : (1);
            _loc_7 = 0;
            while (_loc_7 < _loc_8)
            {
                
                _loc_9 = com.playtech.casino3.slots.shared ? (com.playtech.casino3.slots.shared[_loc_7].win) : (null);
                _loc_5 = _loc_5 + (this.singleWinOnLine(com.playtech.casino3.slots.shared, com.playtech.casino3.slots.shared, _loc_9 ? (_loc_9.win) : (0)) + LINE_WINS_SEPARATOR);
                _loc_7++;
            }
            if (_loc_8 == 1)
            {
                _loc_10 = this.singleWinOnLine(com.playtech.casino3.slots.shared, com.playtech.casino3.slots.shared, 0) + LINE_WINS_SEPARATOR;
                _loc_5 = _loc_9 && _loc_9.type == SlotWinRule.LEFT_CONSECUTIVE.type ? (_loc_5 + _loc_10) : (_loc_10 + _loc_5);
            }
            if (com.playtech.casino3.slots.shared == (com.playtech.casino3.slots.shared - 1))
            {
                _loc_5 = _loc_5.substr(0, (_loc_5.length - 1));
            }
            return _loc_5;
        }// end function

        protected function constructBallWinChunk(com.playtech.casino3.slots.shared:Vector.<GameWinInfo>) : String
        {
            var _loc_3:int = 0;
            var _loc_2:String = "";
            var _loc_4:* = com.playtech.casino3.slots.shared.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_2 = _loc_2 + com.playtech.casino3.slots.shared[_loc_3].win_amount;
                _loc_3++;
            }
            return _loc_2;
        }// end function

        override protected function createAdditionalChunk() : String
        {
            var _loc_1:String = ";";
            var _loc_2:String = "";
            var _loc_3:* = this._logic.state == GameState.NORMAL ? (0) : (this._logic.freegames_country.history_index);
            var _loc_4:* = this._logic.country_1.history_index + "," + this._logic.country_2.history_index;
            var _loc_5:* = this.constructBallWinChunk(this._logic._wins_calculator.BALL_WINS);
            _loc_2 = _loc_3 + _loc_1 + _loc_4 + _loc_1 + _loc_5;
            return _loc_2;
        }// end function

        protected function sortAscendingByWinRule(IModuleInterface:WinInfo, IModuleInterface:WinInfo) : int
        {
            var _loc_3:int = -1;
            var _loc_4:int = 1;
            var _loc_5:int = 0;
            if (IModuleInterface.win_rule < IModuleInterface.win_rule)
            {
                return _loc_3;
            }
            if (IModuleInterface.win_rule > IModuleInterface.win_rule)
            {
                return _loc_4;
            }
            return _loc_5;
        }// end function

        protected function singleWinOnLine(com.playtech.casino3.slots.shared:int, com.playtech.casino3.slots.shared:Number, com.playtech.casino3.slots.shared:Number) : String
        {
            var _loc_4:String = "";
            _loc_4 = (com.playtech.casino3.slots.shared + 1) + LINE_WIN_PARAMETERS_SEPARATOR + com.playtech.casino3.slots.shared + LINE_WIN_PARAMETERS_SEPARATOR + com.playtech.casino3.slots.shared;
            return _loc_4;
        }// end function

        override protected function createExtraFreeSpinsMultiplierChunk(com.playtech.casino3.slots.shared:int) : String
        {
            return " " + com.playtech.casino3.slots.shared;
        }// end function

        override protected function createExtraFreeSpinsBonusChunk() : String
        {
            return this._logic.freegames_country.hitory_name;
        }// end function

    }
}
