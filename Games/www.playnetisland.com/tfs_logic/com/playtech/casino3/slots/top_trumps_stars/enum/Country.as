package com.playtech.casino3.slots.top_trumps_stars.enum
{
    import Country.as$69.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.core.*;
    import flash.utils.*;

    final public class Country extends BaseEnumeration
    {
        protected var _type:String;
        static const TYPES:Dictionary = new Dictionary(true);
        public static const ITALY:Country = new Country("ITALY", null);
        public static const ARGENTINA:Country = new Country("ARGENTINA", null);
        public static const ENGLAND:Country = new Country("ENGLAND", null);
        public static const BRAZIL:Country = new Country("BRAZIL", null);
        public static const SPAIN:Country = new Country("SPAIN", null);
        public static const GERMANY:Country = new Country("GERMANY", null);
        static const SERVER_INDEX_FROM_TYPE:Dictionary = new Dictionary(true);
        public static const FRANCE:Country = new Country("FRANCE", null);
        static const HISTORY_NAMES:Dictionary = new Dictionary(true);
        static const TYPE_FROM_SERVER_INDEX:Dictionary = new Dictionary(true);

        public function Country(param1:String, param2:block_constructor)
        {
            if (Country)
            {
                throw new Error(INSTANTIATION_ERROR);
            }
            this._type = param1;
            return;
        }// end function

        public function get index() : int
        {
            return SERVER_INDEX_FROM_TYPE[this];
        }// end function

        public function get hitory_name() : String
        {
            return HISTORY_NAMES[this];
        }// end function

        override public function get type()
        {
            return this._type;
        }// end function

        public function get history_index() : int
        {
            return this.index;
        }// end function

        public static function fromIndex(HISTORY_NAMES:int, HISTORY_NAMES:Boolean = false) : Country
        {
            var _loc_3:* = TYPE_FROM_SERVER_INDEX[HISTORY_NAMES];
            if (!HISTORY_NAMES && !_loc_3)
            {
                Console.write("Warning unknown type in " + Country + " fromIndex " + HISTORY_NAMES + "!!!");
            }
            return _loc_3;
        }// end function

        public static function fromType(HISTORY_NAMES:String, HISTORY_NAMES:Boolean = false) : Country
        {
            var _loc_3:* = TYPES[HISTORY_NAMES];
            if (!HISTORY_NAMES && !_loc_3)
            {
                Console.write("Warning unknown type in " + Country + " fromType " + HISTORY_NAMES + "!!!");
            }
            return _loc_3;
        }// end function

        TYPES[ARGENTINA.type] = ARGENTINA;
        TYPES[BRAZIL.type] = BRAZIL;
        TYPES[ENGLAND.type] = ENGLAND;
        TYPES[FRANCE.type] = FRANCE;
        TYPES[GERMANY.type] = GERMANY;
        TYPES[ITALY.type] = ITALY;
        TYPES[SPAIN.type] = SPAIN;
        var _loc_2:int = 1;
        SERVER_INDEX_FROM_TYPE[ARGENTINA] = 1;
        var _loc_1:* = _loc_2;
        TYPE_FROM_SERVER_INDEX[_loc_1] = ARGENTINA;
        var _loc_3:int = 2;
        SERVER_INDEX_FROM_TYPE[BRAZIL] = 2;
        var _loc_2:* = _loc_3;
        TYPE_FROM_SERVER_INDEX[_loc_2] = BRAZIL;
        var _loc_4:int = 3;
        SERVER_INDEX_FROM_TYPE[ENGLAND] = 3;
        var _loc_3:* = _loc_4;
        TYPE_FROM_SERVER_INDEX[_loc_3] = ENGLAND;
        var _loc_5:int = 4;
        SERVER_INDEX_FROM_TYPE[FRANCE] = 4;
        var _loc_4:* = _loc_5;
        TYPE_FROM_SERVER_INDEX[_loc_5] = FRANCE;
        var _loc_6:int = 5;
        SERVER_INDEX_FROM_TYPE[GERMANY] = 5;
        var _loc_5:* = _loc_6;
        TYPE_FROM_SERVER_INDEX[_loc_6] = GERMANY;
        var _loc_7:int = 6;
        SERVER_INDEX_FROM_TYPE[ITALY] = 6;
        var _loc_6:* = _loc_7;
        TYPE_FROM_SERVER_INDEX[_loc_7] = ITALY;
        var _loc_8:int = 7;
        SERVER_INDEX_FROM_TYPE[SPAIN] = 7;
        var _loc_7:* = _loc_8;
        TYPE_FROM_SERVER_INDEX[_loc_8] = SPAIN;
        HISTORY_NAMES[ARGENTINA] = "arg";
        HISTORY_NAMES[BRAZIL] = "bra";
        HISTORY_NAMES[ENGLAND] = "eng";
        HISTORY_NAMES[FRANCE] = "fra";
        HISTORY_NAMES[GERMANY] = "deu";
        HISTORY_NAMES[ITALY] = "ita";
        HISTORY_NAMES[SPAIN] = "esp";
    }
}
