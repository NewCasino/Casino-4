package com.playtech.casino3.slots.shared.novel.anticipation
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;

    public class AnticipationCalculator extends Object
    {

        public function AnticipationCalculator()
        {
            return;
        }// end function

        public static function getResult(reels_symbols_state:ReelsSymbolsState, reels_symbols_state:Vector.<AnticipationRules>) : Vector.<Boolean>
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:Array = null;
            var _loc_9:int = 0;
            var _loc_3:* = new Vector.<Boolean>(5);
            var _loc_4:* = reels_symbols_state.length;
            var _loc_8:int = 0;
            while (_loc_8 < _loc_4)
            {
                
                _loc_7 = reels_symbols_state[_loc_8].mask;
                _loc_5 = _loc_7.length;
                _loc_6 = 0;
                _loc_9 = 0;
                while (_loc_9 < _loc_5)
                {
                    
                    if (_loc_7[_loc_9] != 0)
                    {
                        if (_loc_6 == _loc_7[_loc_9])
                        {
                            _loc_3[_loc_9] = true;
                        }
                        if (reels_symbols_state.reelContains(reels_symbols_state[_loc_8].symbol, _loc_9))
                        {
                            _loc_6++;
                        }
                    }
                    _loc_9++;
                }
                _loc_8++;
            }
            return _loc_3;
        }// end function

    }
}
