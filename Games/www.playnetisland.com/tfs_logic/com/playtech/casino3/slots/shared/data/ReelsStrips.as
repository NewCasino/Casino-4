package com.playtech.casino3.slots.shared.data
{
    import __AS3__.vec.*;

    public class ReelsStrips extends Object implements IDisposable
    {
        protected var _reels_strips:Vector.<ReelStrip>;

        public function ReelsStrips(param1:Vector.<ReelStrip>) : void
        {
            this._reels_strips = param1;
            return;
        }// end function

        public function get reels_strips() : Vector.<ReelStrip>
        {
            return this._reels_strips;
        }// end function

        public function set reels_strips(param1:Vector.<ReelStrip>) : void
        {
            this._reels_strips = param1;
            return;
        }// end function

        public function getSymbolsFromPositions(void:Vector.<int> = null, void:int = -1, void:int = -1) : Vector.<SlotsSymbol>
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_8:int = 0;
            var _loc_11:Vector.<SlotsSymbol> = null;
            if (!void)
            {
                void = this.Vector.<int>([0, 0, 0, 0, 0]);
            }
            if (void == -1)
            {
                void = GameParameters.numRows;
            }
            if (void == -1)
            {
                void = 1;
            }
            var _loc_7:int = 0;
            var _loc_9:* = this.reels_strips.length;
            var _loc_10:* = new Vector.<SlotsSymbol>(void * _loc_9, true);
            _loc_4 = 0;
            while (_loc_4 < void)
            {
                
                _loc_5 = 0;
                while (_loc_5 < _loc_9)
                {
                    
                    _loc_11 = this.reels_strips[_loc_5].strip;
                    _loc_8 = _loc_11.length;
                    _loc_6 = void[_loc_5] - void + _loc_4;
                    _loc_6 = _loc_6 % _loc_8;
                    if (_loc_6 < 0)
                    {
                        _loc_6 = _loc_8 + _loc_6;
                    }
                    _loc_10[++_loc_7] = _loc_11[_loc_6];
                    _loc_5++;
                }
                _loc_4++;
            }
            return _loc_10;
        }// end function

        public function dispose() : void
        {
            var _loc_1:ReelStrip = null;
            for each (_loc_1 in this.reels_strips)
            {
                
                _loc_1.dispose();
            }
            this._reels_strips = null;
            return;
        }// end function

    }
}
