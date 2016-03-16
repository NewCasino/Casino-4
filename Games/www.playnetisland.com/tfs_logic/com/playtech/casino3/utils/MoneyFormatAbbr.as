package com.playtech.casino3.utils
{
    import __AS3__.vec.*;

    final class MoneyFormatAbbr extends Object
    {
        private var m_powers:Vector.<Number>;
        private var m_format:String;
        private var m_suffixes:Vector.<String>;
        private var m_threshold:Number;

        function MoneyFormatAbbr(param1:String)
        {
            var _loc_3:Array = null;
            var _loc_5:int = 0;
            var _loc_2:* = param1.split(";");
            this.m_format = "0000" + String(_loc_2.pop()) + "00";
            this.m_powers = new Vector.<Number>;
            this.m_suffixes = new Vector.<String>;
            var _loc_4:* = new Array();
            _loc_5 = 0;
            while (_loc_5 < _loc_2.length)
            {
                
                _loc_3 = _loc_2[_loc_5].split(":");
                _loc_4.push({power:Math.pow(10, uint(_loc_3[0])), suffix:_loc_3[1]});
                _loc_5++;
            }
            _loc_4.sortOn("power", Array.NUMERIC | Array.DESCENDING);
            _loc_5 = 0;
            while (_loc_5 < _loc_4.length)
            {
                
                this.m_powers.push(_loc_4[_loc_5].power);
                this.m_suffixes.push(_loc_4[_loc_5].suffix);
                _loc_5++;
            }
            this.m_threshold = this.m_powers[(this.m_powers.length - 1)];
            this.m_powers.fixed = true;
            this.m_suffixes.fixed = true;
            return;
        }// end function

        public function get threshold() : Number
        {
            return this.m_threshold;
        }// end function

        public function get powers() : Vector.<Number>
        {
            return this.m_powers;
        }// end function

        public function get format() : String
        {
            return this.m_format;
        }// end function

        public function get suffixes() : Vector.<String>
        {
            return this.m_suffixes;
        }// end function

    }
}
