package com.playtech.casino3.slots.shared.base_game
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;
    import flash.utils.*;

    public class BaseSlotSymbols extends Object
    {
        public static var USE_SYMBOL_NAMES:Boolean = false;
        static var SLOT_CLASSES:Dictionary;
        public static var STATIC_SYMBOLS_PACKAGE:String = "";
        public static var SOUND_SYMBOLS_PACKAGE:String = "";
        static var symbol_counter:int;
        static var SLOT_SYMBOLS:DisposableArray;
        public static var VIDEO_SYMBOLS_PACKAGE:String = "";

        public function BaseSlotSymbols()
        {
            return;
        }// end function

        protected function clearSymbols() : void
        {
            var _loc_2:int = 0;
            var _loc_3:BaseSlotSymbol = null;
            var _loc_1:* = SLOT_SYMBOLS.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = SLOT_SYMBOLS[_loc_2] as BaseSlotSymbol;
                _loc_3.clear();
                _loc_3.useBg = true;
                _loc_2++;
            }
            return;
        }// end function

        public function dispose() : void
        {
            BaseSlotSymbols.dispose();
            return;
        }// end function

        public static function dispose() : void
        {
            init();
            return;
        }// end function

        public static function constructReelStripsFromArrays(ReelStrip:Vector.<Array>) : Vector.<ReelStrip>
        {
            var _loc_3:ReelStrip = null;
            var _loc_4:Vector.<SlotsSymbol> = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:Object = null;
            var _loc_11:SlotsSymbol = null;
            var _loc_12:Array = null;
            var _loc_2:* = new Vector.<ReelStrip>;
            var _loc_7:* = ReelStrip.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_7)
            {
                
                _loc_4 = new Vector.<SlotsSymbol>;
                _loc_3 = new ReelStrip(_loc_4);
                _loc_2[_loc_5] = _loc_3;
                _loc_12 = ReelStrip[_loc_5];
                _loc_8 = _loc_12.length;
                _loc_6 = 0;
                while (_loc_6 < _loc_8)
                {
                    
                    _loc_10 = _loc_12[_loc_6];
                    _loc_9 = Number(_loc_10);
                    if (isNaN(_loc_9))
                    {
                        _loc_11 = _loc_10 as SlotsSymbol;
                        if (!_loc_11)
                        {
                            _loc_11 = _loc_10.symbol;
                        }
                    }
                    else
                    {
                        _loc_11 = SLOT_SYMBOLS[_loc_9];
                    }
                    _loc_4[_loc_6] = _loc_11;
                    _loc_6++;
                }
                _loc_5++;
            }
            return _loc_2;
        }// end function

        public static function init() : void
        {
            symbol_counter = 0;
            SLOT_SYMBOLS = new DisposableArray();
            SLOT_CLASSES = new Dictionary();
            STATIC_SYMBOLS_PACKAGE = "";
            VIDEO_SYMBOLS_PACKAGE = "";
            SOUND_SYMBOLS_PACKAGE = "";
            USE_SYMBOL_NAMES = false;
            return;
        }// end function

        static function pushSymbol(NUM_REELS:BaseSlotSymbol) : int
        {
            var _loc_2:* = symbol_counter + 1;
            SLOT_SYMBOLS[_loc_2] = NUM_REELS;
            NUM_REELS.original_type = _loc_2;
            SLOT_CLASSES[NUM_REELS.CLASS] = NUM_REELS;
            return _loc_2;
        }// end function

        init();
    }
}
