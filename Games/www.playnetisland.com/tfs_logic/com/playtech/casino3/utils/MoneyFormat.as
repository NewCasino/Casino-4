package com.playtech.casino3.utils
{

    final class MoneyFormat extends Object
    {
        private var m_isSignPosLeft:Boolean;
        private var m_format:String;
        private var m_sign:String;

        function MoneyFormat(param1:String)
        {
            var _loc_2:* = param1.split("");
            if (_loc_2[(_loc_2.length - 1)] != "0")
            {
                this.m_isSignPosLeft = false;
                this.m_sign = _loc_2.splice((_loc_2.lastIndexOf("0") + 1), _loc_2.length - _loc_2.lastIndexOf("0")).join("");
            }
            else if (_loc_2[0] != "0")
            {
                this.m_isSignPosLeft = true;
                this.m_sign = _loc_2.splice(0, _loc_2.indexOf("0")).join("");
            }
            this.m_format = _loc_2.join("");
            return;
        }// end function

        public function get format() : String
        {
            return this.m_format;
        }// end function

        public function get isSignPosLeft() : Boolean
        {
            return this.m_isSignPosLeft;
        }// end function

        public function get sign() : String
        {
            return this.m_sign;
        }// end function

    }
}
