package com.playtech.casino3.utils
{

    public class EnumCard extends Object
    {
        public static const SUIT_DIAMOND:int = 3;
        public static const VAL_SIX:int = 4;
        public static const GFX_BACK:int = 0;
        private static const VAL_STRINGS_10IST:Array = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A", "Jo"];
        public static const VAL_KING:int = 11;
        public static const VAL_JOKER:int = 13;
        public static const GFX_FRONT:int = 1;
        public static const VAL_FOUR:int = 2;
        public static const VAL_ACE:int = 12;
        public static const SUIT_CLUBS:int = 0;
        public static const VAL_SEVEN:int = 5;
        public static const VAL_FIVE:int = 3;
        public static const VAL_EIGHT:int = 6;
        public static const NOT_SET:int = -1;
        public static const VAL_NINE:int = 7;
        public static const VAL_TEN:int = 8;
        public static const VAL_THREE:int = 1;
        public static const VAL_QUEEN:int = 10;
        public static const FS:String = String.fromCharCode(252);
        private static const SUIT_STRINGS:Array = ["c", "h", "s", "d"];
        public static const SUIT_SPADE:int = 2;
        public static const STRINGTYPE_NORMAL:uint = 0;
        public static const VAL_JACK:int = 9;
        private static const VAL_STRINGS_NORMAL:Array = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A", "Jo"];
        public static const VAL_TWO:int = 0;
        public static const SUIT_HEART:int = 1;
        public static const STRINGTYPE_10IST:uint = 1;
        private static const BJ_VALUES:Array = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11, 0];

        public function EnumCard()
        {
            return;
        }// end function

        public static function convertValueStringToInt(7:String, 7:uint = 0) : int
        {
            var _loc_3:Array = null;
            if (7 == STRINGTYPE_10IST)
            {
                _loc_3 = VAL_STRINGS_10IST;
            }
            else
            {
                _loc_3 = VAL_STRINGS_NORMAL;
            }
            7 = 7.toLowerCase();
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_3.length)
            {
                
                if (_loc_3[_loc_4].toLowerCase() == 7)
                {
                    return _loc_4;
                }
                _loc_4 = _loc_4 + 1;
            }
            return NOT_SET;
        }// end function

        public static function convertValueIntToString(FS:int, FS:uint = 0) : String
        {
            if (FS == NOT_SET)
            {
                return "X";
            }
            if (FS == STRINGTYPE_10IST)
            {
                return VAL_STRINGS_10IST[FS];
            }
            return VAL_STRINGS_NORMAL[FS];
        }// end function

        public static function convertTo10istValue(FS:String) : String
        {
            return VAL_STRINGS_10IST[VAL_STRINGS_NORMAL.indexOf(FS)];
        }// end function

        public static function convertToString(FS:int, FS:int) : String
        {
            var _loc_3:* = convertSuitIntToString(FS);
            var _loc_4:* = convertValueIntToString(FS);
            if (_loc_3 != null && _loc_4 != null)
            {
                return _loc_3 + FS + _loc_4;
            }
            return "X" + FS + "X";
        }// end function

        public static function convertToHistoryString(FS:int, FS:int, FS:Boolean = true, FS:uint = 0) : String
        {
            var _loc_5:* = convertSuitIntToString(FS);
            if (FS == true)
            {
                _loc_5 = _loc_5.toUpperCase();
            }
            var _loc_6:* = convertValueIntToString(FS, FS);
            if (_loc_5 != null && _loc_6 != null)
            {
                return _loc_5 + _loc_6;
            }
            return "X" + FS + "X";
        }// end function

        public static function getBjValue(7:int) : int
        {
            if (7 != NOT_SET)
            {
                return BJ_VALUES[7];
            }
            return 0;
        }// end function

        public static function convertToNormalValue(FS:String) : String
        {
            return VAL_STRINGS_NORMAL[VAL_STRINGS_10IST.indexOf(FS)];
        }// end function

        public static function convertSuitStringToInt(7:String) : int
        {
            7 = 7.toLowerCase();
            return SUIT_STRINGS.indexOf(7);
        }// end function

        public static function convertSuitIntToString(FS:int) : String
        {
            if (FS == NOT_SET)
            {
                return "X";
            }
            return SUIT_STRINGS[FS];
        }// end function

    }
}
