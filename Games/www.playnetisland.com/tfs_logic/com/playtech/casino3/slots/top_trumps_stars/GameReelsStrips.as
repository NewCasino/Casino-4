package com.playtech.casino3.slots.top_trumps_stars
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;

    public class GameReelsStrips extends ReelsStrips
    {
        protected var NORMAL_REELS:ReelsStrips;
        protected var _state:GameState;
        protected var FREEGAME_REELS:ReelsStrips;

        public function GameReelsStrips() : void
        {
            super(null);
            this.NORMAL_REELS = new ReelsStrips(BaseSlotSymbols.constructReelStripsFromArrays(this.Vector.<Array>([[10, 11, 1, 9, 10, 2, 11, 12, 0, 9, 10, 13, 7, 16, 8, 14, 7, 8, 3, 11, 9, 4, 10, 7, 5, 11, 6, 10, 12, 1, 11, 9, 2, 12, 11, 5, 12, 6, 10, 9, 5, 12, 6, 11, 12, 5, 10, 6, 12, 11, 3, 8, 12, 4, 8, 12, 3, 9, 11, 4], [10, 11, 1, 9, 10, 2, 11, 12, 0, 9, 10, 15, 7, 8, 6, 10, 9, 5, 7, 16, 8, 11, 1, 12, 11, 2, 12, 11, 0, 10, 12, 3, 9, 12, 4, 9, 10, 5, 12, 9, 6, 12, 11, 3, 8, 12, 5, 7, 12, 6, 11, 7, 4, 9, 11, 3, 8, 11, 16, 10, 7, 4], [10, 11, 0, 9, 10, 16, 7, 8, 16, 11, 12, 16, 11, 7, 1, 10, 2, 11, 12, 3, 10, 4, 11, 12, 1, 11, 2, 9, 11, 4, 9, 10, 3, 7, 8, 3, 9, 10, 4, 9, 8, 5, 12, 6, 11, 12, 5, 10, 11, 6, 12, 7, 5, 9, 6, 8, 5, 7, 6], [10, 11, 1, 9, 10, 2, 11, 12, 0, 9, 10, 15, 7, 8, 6, 10, 9, 5, 7, 16, 8, 11, 1, 12, 11, 2, 12, 11, 0, 10, 12, 3, 9, 12, 4, 9, 10, 5, 12, 9, 6, 12, 11, 3, 8, 12, 5, 7, 12, 6, 11, 7, 4, 9, 11, 3, 8, 11, 16, 10, 7, 4], [10, 11, 1, 9, 10, 2, 11, 12, 0, 9, 10, 13, 7, 16, 8, 14, 7, 8, 3, 11, 9, 4, 10, 7, 5, 11, 6, 10, 12, 1, 11, 9, 2, 12, 11, 5, 12, 6, 10, 9, 5, 12, 6, 11, 12, 5, 10, 6, 12, 11, 3, 8, 12, 4, 8, 12, 3, 9, 11, 4]])));
            var _loc_1:* = this.Vector.<Array>([[4, 5, 1, 9, 8, 0, 9, 8, 2, 5, 4, 3, 7, 6, 10, 4, 5, 1, 9, 8, 0, 9, 8, 2, 7, 6, 10, 4, 5, 3, 6, 7, 3, 6, 7, 2, 9, 7, 3, 5, 4, 3, 6, 7, 3, 6, 5, 3, 9, 8, 1, 9, 8, 1, 9, 8, 2, 9, 8, 2, 6, 7, 2], [4, 5, 1, 9, 8, 0, 9, 8, 2, 5, 4, 3, 7, 6, 10, 4, 5, 1, 9, 8, 0, 9, 8, 2, 7, 6, 10, 4, 5, 3, 6, 7, 3, 6, 7, 2, 9, 8, 3, 5, 4, 3, 6, 7, 3, 6, 5, 3, 9, 8, 0, 9, 8, 1, 9, 8, 2, 9, 8, 2, 9, 7, 2], [4, 5, 10, 9, 8, 0, 9, 8, 2, 7, 4, 3, 7, 6, 10, 4, 5, 1, 9, 8, 0, 9, 8, 2, 7, 6, 10, 4, 5, 3, 6, 7, 10, 6, 7, 2, 9, 8, 3, 5, 4, 3, 6, 7, 3, 6, 5, 3, 9, 8, 0, 9, 8, 1, 9, 8, 2, 9, 8, 2, 6, 7, 2], [4, 5, 1, 9, 8, 0, 9, 8, 2, 5, 4, 3, 7, 6, 10, 4, 5, 1, 9, 8, 0, 9, 8, 2, 7, 6, 10, 4, 5, 3, 6, 7, 3, 6, 7, 2, 9, 8, 3, 5, 4, 3, 6, 7, 3, 6, 5, 3, 9, 8, 0, 9, 8, 1, 9, 8, 2, 9, 8, 2, 9, 7, 2], [4, 5, 1, 9, 8, 0, 9, 8, 2, 5, 4, 3, 7, 6, 10, 4, 5, 1, 9, 8, 0, 9, 8, 2, 7, 6, 10, 4, 5, 3, 6, 7, 3, 6, 7, 2, 9, 7, 3, 5, 4, 3, 6, 7, 3, 6, 5, 3, 9, 8, 1, 9, 8, 1, 9, 8, 2, 9, 8, 2, 6, 7, 2]]);
            this.replace(_loc_1, [2, 3, 4, 5, 6, 7, 8, 9, 10], [3, 5, 7, 8, 9, 10, 11, 12, 16]);
            this.FREEGAME_REELS = new ReelsStrips(BaseSlotSymbols.constructReelStripsFromArrays(_loc_1));
            this.state = GameState.NORMAL;
            return;
        }// end function

        public function set state(com.playtech.casino3.slots.shared.interfaces:GameState) : void
        {
            this._state = com.playtech.casino3.slots.shared.interfaces;
            var _loc_2:* = com.playtech.casino3.slots.shared.interfaces == GameState.NORMAL ? (this.NORMAL_REELS) : (this.FREEGAME_REELS);
            _reels_strips = _loc_2.reels_strips;
            return;
        }// end function

        protected function replace(com.playtech.casino3.slots.shared.interfaces:Vector.<Array>, com.playtech.casino3.slots.shared.interfaces:Array, com.playtech.casino3.slots.shared.interfaces:Array) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_7:int = 0;
            var _loc_8:Array = null;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_6:* = com.playtech.casino3.slots.shared.interfaces.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_6)
            {
                
                _loc_8 = com.playtech.casino3.slots.shared.interfaces[_loc_4];
                _loc_7 = _loc_8.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_7)
                {
                    
                    _loc_9 = _loc_8[_loc_5];
                    _loc_10 = com.playtech.casino3.slots.shared.interfaces.indexOf(_loc_9);
                    if (_loc_10 != -1)
                    {
                        _loc_8[_loc_5] = com.playtech.casino3.slots.shared.interfaces[_loc_10];
                    }
                    _loc_5++;
                }
                _loc_4++;
            }
            return;
        }// end function

        public function get state() : GameState
        {
            return this._state;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._state = null;
            this.NORMAL_REELS.dispose();
            this.NORMAL_REELS = null;
            this.FREEGAME_REELS.dispose();
            this.FREEGAME_REELS = null;
            return;
        }// end function

    }
}
