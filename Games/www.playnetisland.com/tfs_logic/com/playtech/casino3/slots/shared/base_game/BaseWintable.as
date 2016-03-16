package com.playtech.casino3.slots.shared.base_game
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;

    dynamic public class BaseWintable extends DisposableArray
    {

        public function BaseWintable() : void
        {
            return;
        }// end function

        public function constructSlotsWinFromClass(void:Object, void:int, void:Number, void:Class, void:Object = null, void:SlotWinRule = null, void:int = 0, void:int = -1, void:Vector.<Vector.<int>> = null) : SlotsWin
        {
            if (void == null)
            {
                void = SlotWinRule.LEFT_CONSECUTIVE;
            }
            var _loc_10:* = void.symbol;
            return this.constructGameSpecificSlotsWin(_loc_10, void, void, void, void, void, void, void, void);
        }// end function

        public function constructGameSpecificSlotsWin(void:SlotsSymbol, void:int, void:Number, void:Class, void:Object = null, void:SlotWinRule = null, void:int = 0, void:int = -1, void:Vector.<Vector.<int>> = null) : SlotsWin
        {
            return new SlotsWin(void, void, void, void, void, void.type, void, void, void);
        }// end function

        public function sortDescending() : void
        {
            var _loc_1:* = Array.NUMERIC | Array.DESCENDING;
            sortOn(["payout", "priority", "special", "symbol_index"], [_loc_1, _loc_1, _loc_1, Array.NUMERIC]);
            return;
        }// end function

        public function removeWinsWithSymbol(payout:Object = null) : int
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_6:SlotsSymbol = null;
            var _loc_7:Class = null;
            var _loc_8:Object = null;
            var _loc_4:int = 0;
            var _loc_5:* = payout as Array;
            if (!_loc_5 && payout)
            {
                _loc_5 = [payout];
            }
            _loc_3 = _loc_5.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_8 = _loc_5[_loc_2] as Object;
                _loc_6 = _loc_8 as SlotsSymbol;
                if (_loc_6)
                {
                }
                else
                {
                    _loc_7 = _loc_8 as Class;
                    _loc_6 = _loc_7.symbol;
                }
                _loc_2++;
            }
            _loc_3 = length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                if (_loc_5 && _loc_5.indexOf(this[_loc_2].symbol) == -1)
                {
                }
                else
                {
                    this[_loc_2].dispose();
                    splice(_loc_2, 1);
                    _loc_2 = _loc_2 - 1;
                    _loc_3 = _loc_3 - 1;
                    _loc_4++;
                }
                _loc_2++;
            }
            return _loc_4;
        }// end function

        protected function pushSharedRule(void:Class, void:int, void:Number, void:Class, void:Object = null, void:SlotWinRule = null, void:int = 0, void:int = -1, void:Vector.<Vector.<int>> = null) : SlotsWin
        {
            if (void == null)
            {
                void = SlotWinRule.LEFT_CONSECUTIVE;
            }
            var _loc_10:* = this.constructSlotsWinFromClass(void, void, void, void, void, void, void, void, void);
            push(_loc_10);
            return _loc_10;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            return;
        }// end function

        public function getSimmilarWinWithNSymbols(void:SlotsWin, void:int) : SlotsWin
        {
            var _loc_3:int = 0;
            var _loc_5:SlotsWin = null;
            var _loc_4:* = length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_5 = this[_loc_3] as SlotsWin;
                if (_loc_5.type == void.type && _loc_5.symbol == void.symbol && _loc_5.count == void)
                {
                    return _loc_5;
                }
                _loc_3++;
            }
            return null;
        }// end function

    }
}
