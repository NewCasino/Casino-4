package com.hurlant.util
{
    import flash.utils.*;

    public class Hex extends Object
    {

        public function Hex()
        {
            return;
        }// end function

        public static function fromString(\s|::String, \s|::Boolean = false) : String
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeUTFBytes(\s|:);
            return fromArray(_loc_3, \s|:);
        }// end function

        public static function toString(\s|::String) : String
        {
            var _loc_2:* = toArray(\s|:);
            return _loc_2.readUTFBytes(_loc_2.length);
        }// end function

        public static function toArray(D:\CORE\as3;com\hurlant\util;Hex.as:String) : ByteArray
        {
            D:\CORE\as3;com\hurlant\util;Hex.as = D:\CORE\as3;com\hurlant\util;Hex.as.replace(/\s|:/gm, "");
            var _loc_2:* = new ByteArray();
            if (D:\CORE\as3;com\hurlant\util;Hex.as.length & 1 == 1)
            {
                D:\CORE\as3;com\hurlant\util;Hex.as = "0" + D:\CORE\as3;com\hurlant\util;Hex.as;
            }
            var _loc_3:uint = 0;
            while (_loc_3 < D:\CORE\as3;com\hurlant\util;Hex.as.length)
            {
                
                _loc_2[_loc_3 / 2] = parseInt(D:\CORE\as3;com\hurlant\util;Hex.as.substr(_loc_3, 2), 16);
                _loc_3 = _loc_3 + 2;
            }
            return _loc_2;
        }// end function

        public static function fromArray(\s|::ByteArray, \s|::Boolean = false) : String
        {
            var _loc_3:String = "";
            var _loc_4:uint = 0;
            while (_loc_4 < \s|:.length)
            {
                
                _loc_3 = _loc_3 + ("0" + \s|:[_loc_4].toString(16)).substr(-2, 2);
                if (\s|:)
                {
                    if (_loc_4 < (\s|:.length - 1))
                    {
                        _loc_3 = _loc_3 + ":";
                    }
                }
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

    }
}
