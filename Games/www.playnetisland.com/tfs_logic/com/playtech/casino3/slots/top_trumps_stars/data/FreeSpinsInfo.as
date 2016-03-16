package com.playtech.casino3.slots.top_trumps_stars.data
{
    import flash.utils.*;

    public class FreeSpinsInfo extends Object
    {
        protected var _multiplier:int = 1;
        protected var _spins:int;
        protected var _has_expanding_wild:Boolean;
        static const T:String = "\t";
        static const N:String = "\n";

        public function FreeSpinsInfo(param1:int, param2:int = 1, param3:Boolean = false) : void
        {
            this._spins = param1;
            this._multiplier = param2;
            this._has_expanding_wild = param3;
            return;
        }// end function

        public function get spins() : int
        {
            return this._spins;
        }// end function

        public function get has_multiplier() : Boolean
        {
            return this._multiplier > 1;
        }// end function

        public function get multiplier() : int
        {
            return this._multiplier;
        }// end function

        public function toString() : String
        {
            var _loc_1:* = "------ DATA " + getQualifiedClassName(FreeSpinsInfo) + " -----" + N;
            _loc_1 = _loc_1 + (T + "SPINS " + this._spins + N);
            _loc_1 = _loc_1 + (T + "MULTIPLIER " + this._multiplier + N);
            _loc_1 = _loc_1 + (T + "HAS EXPANDING WILD " + this._has_expanding_wild + N);
            _loc_1 = _loc_1 + "------ END DATA -----";
            return _loc_1;
        }// end function

        public function get has_expanding_wild() : Boolean
        {
            return this._has_expanding_wild;
        }// end function

    }
}
