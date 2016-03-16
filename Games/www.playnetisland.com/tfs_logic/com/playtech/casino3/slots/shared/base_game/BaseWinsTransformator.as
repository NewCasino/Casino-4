package com.playtech.casino3.slots.shared.base_game
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;

    public class BaseWinsTransformator extends Object implements IDisposable
    {
        protected var _freezed_indexes:Vector.<int>;
        protected var _wins:Wins;
        protected var _reel_with_index_expanded:Vector.<Boolean>;

        public function BaseWinsTransformator()
        {
            this._reel_with_index_expanded = new Vector.<Boolean>(GameParameters.numReels, true);
            return;
        }// end function

        public function unExpandedReelWithIndex(com.playtech.casino3.slots.shared.data:uint) : void
        {
            this._reel_with_index_expanded[com.playtech.casino3.slots.shared.data] = false;
            return;
        }// end function

        public function transformWins(com.playtech.casino3.slots.shared.data:Wins) : void
        {
            this._wins = com.playtech.casino3.slots.shared.data;
            this.expandFreezeReelsOnWins();
            return;
        }// end function

        protected function expandFreezeReelsOnWins() : void
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            var _loc_8:* = undefined;
            var _loc_9:* = undefined;
            var _loc_10:* = undefined;
            var _loc_11:* = undefined;
            var _loc_12:int = 0;
            var _loc_13:* = undefined;
            var _loc_14:int = 0;
            var _loc_16:WinInfo = null;
            var _loc_17:Vector.<int> = null;
            var _loc_18:Vector.<String> = null;
            var _loc_19:Object = null;
            var _loc_21:int = 0;
            var _loc_3:Object = {};
            var _loc_4:Object = {};
            var _loc_5:* = GameParameters.numReels;
            var _loc_6:* = GameParameters.numRows;
            var _loc_7:* = Math.floor(GameParameters.numRows / 2);
            _loc_1 = 0;
            while (_loc_1 < _loc_5)
            {
                
                if (!this._reel_with_index_expanded[_loc_1])
                {
                }
                else
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_6)
                    {
                        
                        _loc_3[_loc_5 * _loc_2 + _loc_1] = _loc_1;
                        _loc_2++;
                    }
                }
                _loc_1++;
            }
            if (this._freezed_indexes)
            {
                _loc_21 = this._freezed_indexes.length;
                _loc_9 = 0;
                while (_loc_9 < _loc_21)
                {
                    
                    _loc_4[this._freezed_indexes[_loc_9]] = true;
                    _loc_9 = _loc_9 + 1;
                }
            }
            var _loc_15:* = this._wins.length;
            var _loc_20:String = "_3x";
            _loc_8 = 0;
            while (_loc_8 < _loc_15)
            {
                
                _loc_16 = this._wins[_loc_8] as WinInfo;
                _loc_17 = _loc_16.symbol_indexes;
                _loc_10 = _loc_17.length;
                _loc_13 = 0;
                _loc_14 = 0;
                _loc_18 = new Vector.<String>(_loc_10, true);
                _loc_9 = 0;
                while (_loc_9 < _loc_10)
                {
                    
                    _loc_12 = _loc_17[_loc_9];
                    _loc_19 = _loc_3[_loc_12];
                    _loc_18[_loc_9] = null;
                    if (_loc_19 != null)
                    {
                        _loc_11 = int(_loc_19);
                        _loc_13 = _loc_13 + 1;
                        _loc_17[_loc_9] = _loc_7 * _loc_5 + _loc_11;
                        _loc_18[_loc_9] = _loc_20;
                    }
                    else if (_loc_4[_loc_12])
                    {
                        _loc_14++;
                        _loc_18[_loc_9] = "";
                    }
                    _loc_9 = _loc_9 + 1;
                }
                if (_loc_13 > 0 || _loc_14 > 0)
                {
                    _loc_16.frames_sufixes = _loc_18;
                }
                _loc_8 = _loc_8 + 1;
            }
            return;
        }// end function

        public function unExpandedReels() : void
        {
            var _loc_1:int = 0;
            var _loc_2:* = GameParameters.numReels;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                this._reel_with_index_expanded[_loc_1] = false;
                _loc_1++;
            }
            return;
        }// end function

        public function freezeIndexes(com.playtech.casino3.slots.shared.data:Vector.<int> = null) : void
        {
            var _loc_2:int = 0;
            var _loc_4:int = 0;
            if (!com.playtech.casino3.slots.shared.data)
            {
                return;
            }
            if (!this._freezed_indexes)
            {
                this._freezed_indexes = com.playtech.casino3.slots.shared.data.concat();
                return;
            }
            var _loc_3:* = com.playtech.casino3.slots.shared.data.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = this._freezed_indexes.lastIndexOf(com.playtech.casino3.slots.shared.data[_loc_2]);
                if (_loc_4 != -1)
                {
                }
                else
                {
                    this._freezed_indexes.push(com.playtech.casino3.slots.shared.data[_loc_2]);
                }
                _loc_2++;
            }
            return;
        }// end function

        public function unFreezeIndexes(com.playtech.casino3.slots.shared.data:Vector.<int> = null) : void
        {
            var _loc_2:int = 0;
            var _loc_4:int = 0;
            if (!this._freezed_indexes)
            {
                return;
            }
            if (!com.playtech.casino3.slots.shared.data)
            {
                this._freezed_indexes = null;
                return;
            }
            var _loc_3:* = com.playtech.casino3.slots.shared.data.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = this._freezed_indexes.lastIndexOf(com.playtech.casino3.slots.shared.data[_loc_2]);
                if (_loc_4 == -1)
                {
                }
                else
                {
                    this._freezed_indexes.splice(_loc_4, 1);
                }
                _loc_2++;
            }
            return;
        }// end function

        public function unExpandReelsWithIndexes(com.playtech.casino3.slots.shared.data:Vector.<int>) : void
        {
            var _loc_3:int = 0;
            var _loc_2:* = com.playtech.casino3.slots.shared.data.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                this._reel_with_index_expanded[com.playtech.casino3.slots.shared.data[_loc_3]] = false;
                _loc_3++;
            }
            return;
        }// end function

        public function reelWithIndexIsExpanded(param1:uint) : Boolean
        {
            return this._reel_with_index_expanded[param1];
        }// end function

        public function expandReelWithIndex(com.playtech.casino3.slots.shared.data:uint) : void
        {
            this._reel_with_index_expanded[com.playtech.casino3.slots.shared.data] = true;
            return;
        }// end function

        public function expandReelsWithIndexes(com.playtech.casino3.slots.shared.data:Vector.<int>) : void
        {
            var _loc_3:int = 0;
            var _loc_2:* = com.playtech.casino3.slots.shared.data.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                this._reel_with_index_expanded[com.playtech.casino3.slots.shared.data[_loc_3]] = true;
                _loc_3++;
            }
            return;
        }// end function

        public function dispose() : void
        {
            this._wins = null;
            this._reel_with_index_expanded = null;
            this._freezed_indexes = null;
            return;
        }// end function

    }
}
