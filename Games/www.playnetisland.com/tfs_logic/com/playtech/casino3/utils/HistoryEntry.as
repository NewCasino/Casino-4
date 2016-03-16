package com.playtech.casino3.utils
{
    import __AS3__.vec.*;

    final public class HistoryEntry extends Object
    {
        private var m_jpwin:Number;
        private var m_bet:Number;
        private var m_win:Number;
        private var m_endBalance:Number;
        private var m_ts:String;
        private var m_brokenHistory:Boolean;
        private var m_data:String;
        private static const FIELD_SEPARATOR_CODE:uint = 2;
        private static const ENTRY_SEPARATOR_CODE:uint = 1;

        public function HistoryEntry(param1:Boolean = false)
        {
            var _loc_2:* = new Date();
            var _loc_3:* = _loc_2.getDate();
            if (_loc_3 < 10)
            {
                this.m_ts = "0" + _loc_3;
            }
            else
            {
                this.m_ts = String(_loc_3);
            }
            this.m_ts = this.m_ts + "-";
            _loc_3 = _loc_2.getMonth();
            _loc_3 = _loc_3 + 1;
            if (_loc_3 < 10)
            {
                this.m_ts = this.m_ts + ("0" + _loc_3);
            }
            else
            {
                this.m_ts = this.m_ts + String(_loc_3);
            }
            this.m_ts = this.m_ts + ("-" + _loc_2.getFullYear() + " ");
            _loc_3 = _loc_2.getHours();
            if (_loc_3 < 10)
            {
                this.m_ts = this.m_ts + ("0" + _loc_3);
            }
            else
            {
                this.m_ts = this.m_ts + String(_loc_3);
            }
            this.m_ts = this.m_ts + ":";
            _loc_3 = _loc_2.getMinutes();
            if (_loc_3 < 10)
            {
                this.m_ts = this.m_ts + ("0" + _loc_3);
            }
            else
            {
                this.m_ts = this.m_ts + String(_loc_3);
            }
            this.m_ts = this.m_ts + ":";
            _loc_3 = _loc_2.getSeconds();
            if (_loc_3 < 10)
            {
                this.m_ts = this.m_ts + ("0" + _loc_3);
            }
            else
            {
                this.m_ts = this.m_ts + String(_loc_3);
            }
            this.m_brokenHistory = param1;
            this.m_data = "";
            this.m_win = 0;
            this.m_jpwin = 0;
            this.m_bet = 0;
            this.m_endBalance = 0;
            return;
        }// end function

        public function get endBalance() : Number
        {
            return this.m_endBalance;
        }// end function

        public function set endBalance(Vector:Number) : void
        {
            this.m_endBalance = Vector;
            return;
        }// end function

        public function get bet() : Number
        {
            return this.m_bet;
        }// end function

        public function get broken() : Boolean
        {
            return this.m_brokenHistory;
        }// end function

        public function get jpwin() : Number
        {
            return this.m_jpwin;
        }// end function

        public function set data(Vector:String) : void
        {
            this.m_data = Vector;
            return;
        }// end function

        public function get win() : Number
        {
            return this.m_win;
        }// end function

        public function set bet(Vector:Number) : void
        {
            this.m_bet = Vector;
            return;
        }// end function

        public function get data() : String
        {
            return this.m_data;
        }// end function

        public function set jpwin(Vector:Number) : void
        {
            this.m_jpwin = Vector;
            return;
        }// end function

        public function set win(Vector:Number) : void
        {
            this.m_win = Vector;
            return;
        }// end function

        public static function format(param1:Vector.<HistoryEntry>) : String
        {
            if (param1 == null || param1.length == 0)
            {
                return "";
            }
            var _loc_2:* = String.fromCharCode(ENTRY_SEPARATOR_CODE);
            var _loc_3:* = String.fromCharCode(FIELD_SEPARATOR_CODE);
            var _loc_4:String = "";
            var _loc_5:int = 0;
            while (_loc_5 < param1.length)
            {
                
                _loc_4 = _loc_4 + (param1[_loc_5].m_ts + _loc_3 + param1[_loc_5].m_bet / 100 + _loc_3 + param1[_loc_5].m_win / 100 + _loc_3 + String(param1[_loc_5].m_endBalance / 100) + _loc_3 + param1[_loc_5].m_data + _loc_2);
                _loc_5++;
            }
            return _loc_4;
        }// end function

    }
}
