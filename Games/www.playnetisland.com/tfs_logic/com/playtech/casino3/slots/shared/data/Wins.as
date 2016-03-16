package com.playtech.casino3.slots.shared.data
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.utils.*;

    dynamic public class Wins extends DisposableArray
    {
        protected var _reels_winning:Vector.<Boolean>;

        public function Wins() : void
        {
            return;
        }// end function

        public function hasInWinsKindOf(length:int) : Boolean
        {
            var _loc_3:int = 0;
            var _loc_4:WinInfo = null;
            var _loc_2:* = length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this[_loc_3] as WinInfo;
                if (_loc_4.win.count == length)
                {
                    return true;
                }
                _loc_3++;
            }
            return false;
        }// end function

        public function get reels_winning() : Vector.<Boolean>
        {
            return this._reels_winning.concat();
        }// end function

        public function get first_win() : WinInfo
        {
            return this[0] as WinInfo;
        }// end function

        public function calculateWinningReels() : Vector.<Boolean>
        {
            var _loc_1:* = Wins.calculateWinningReels(this);
            var _loc_2:* = byteToVectorBoolean(_loc_1, GameParameters.numReels);
            this._reels_winning = byteToVectorBoolean(_loc_1, GameParameters.numReels);
            return _loc_2;
        }// end function

        public function get last_win() : WinInfo
        {
            return this[(length - 1)] as WinInfo;
        }// end function

        public function set reels_winning(index:Vector.<Boolean>) : void
        {
            this._reels_winning = index.concat();
            return;
        }// end function

        public function get is_empty() : Boolean
        {
            return length == 0;
        }// end function

        public function hasLineSpecificWin() : Boolean
        {
            var _loc_2:int = 0;
            var _loc_3:WinInfo = null;
            var _loc_1:* = length;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this[_loc_2] as WinInfo;
                if (_loc_3.win.isLineSpecific)
                {
                    return true;
                }
                _loc_2++;
            }
            return false;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this.reels_winning = null;
            return;
        }// end function

        public static function calculateWinningReels(WinInfo:Wins) : uint
        {
            var _loc_2:int = 0;
            var _loc_4:WinInfo = null;
            var _loc_3:* = WinInfo.length;
            var _loc_5:int = 0;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = WinInfo[_loc_2] as WinInfo;
                _loc_5 = _loc_5 | _loc_4.wins_on_reels;
                _loc_2++;
            }
            return _loc_5;
        }// end function

    }
}
