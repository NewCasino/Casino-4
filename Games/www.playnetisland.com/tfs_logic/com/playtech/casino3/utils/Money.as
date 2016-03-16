package com.playtech.casino3.utils
{
    import __AS3__.vec.*;

    final public class Money extends Object
    {
        private static var LONG_FORMAT:MoneyFormat;
        private static var ABBR_FORMAT:MoneyFormatAbbr;
        public static const ZERO:uint = 1;
        public static const ABBR:uint = 4;
        private static var SHORT_FORMAT:MoneyFormat;
        public static const LONG:uint = 2;

        public function Money()
        {
            throw new Error("do not instantiate, use static methods instead!");
        }// end function

        public static function floor(com.playtech.casino3.utils:Number) : Number
        {
            var _loc_2:* = Math.floor(com.playtech.casino3.utils);
            return com.playtech.casino3.utils - _loc_2 >= 0.999999 ? ((_loc_2 + 1)) : (_loc_2);
        }// end function

        public static function format(http://adobe.com/AS3/2006/builtin:Number, http://adobe.com/AS3/2006/builtin:uint = 0) : String
        {
            var _loc_7:int = 0;
            var _loc_11:Number = NaN;
            var _loc_12:Vector.<Number> = null;
            var _loc_13:String = null;
            var _loc_14:String = null;
            var _loc_3:Number = 1;
            if (http://adobe.com/AS3/2006/builtin < 0)
            {
                http://adobe.com/AS3/2006/builtin = http://adobe.com/AS3/2006/builtin * -1;
                _loc_3 = -1;
            }
            var _loc_4:* = ABBR_FORMAT;
            var _loc_5:String = "";
            var _loc_6:String = null;
            if ((http://adobe.com/AS3/2006/builtin & ABBR) != 0)
            {
                if (_loc_4 == null)
                {
                    http://adobe.com/AS3/2006/builtin = http://adobe.com/AS3/2006/builtin ^ ABBR;
                }
                else
                {
                    _loc_11 = http://adobe.com/AS3/2006/builtin / 100;
                    if (_loc_11 >= _loc_4.threshold)
                    {
                        _loc_12 = _loc_4.powers;
                        _loc_7 = 0;
                        while (_loc_7 < _loc_12.length)
                        {
                            
                            if (_loc_12[_loc_7] <= _loc_11)
                            {
                                _loc_12 = null;
                                break;
                            }
                            _loc_7++;
                        }
                        if (_loc_12 == null)
                        {
                            _loc_5 = _loc_4.suffixes[_loc_7];
                            http://adobe.com/AS3/2006/builtin = http://adobe.com/AS3/2006/builtin / _loc_4.powers[_loc_7];
                        }
                        _loc_6 = _loc_4.format;
                    }
                    else
                    {
                        http://adobe.com/AS3/2006/builtin = http://adobe.com/AS3/2006/builtin ^ ABBR;
                    }
                }
            }
            http://adobe.com/AS3/2006/builtin = http://adobe.com/AS3/2006/builtin - http://adobe.com/AS3/2006/builtin % 1;
            var _loc_8:String = "";
            var _loc_9:MoneyFormat = null;
            if ((http://adobe.com/AS3/2006/builtin & LONG) != 0)
            {
                _loc_9 = LONG_FORMAT;
            }
            else
            {
                _loc_9 = SHORT_FORMAT;
            }
            if (_loc_6 == null)
            {
                _loc_6 = _loc_9.format;
            }
            var _loc_10:* = _loc_6.length - 1;
            if (http://adobe.com/AS3/2006/builtin == 0)
            {
                _loc_8 = _loc_6.substr(_loc_10 - 3, 4);
            }
            else if (http://adobe.com/AS3/2006/builtin < 10)
            {
                _loc_8 = _loc_6.substr(_loc_10 - 3, 3) + String(http://adobe.com/AS3/2006/builtin);
            }
            else if (http://adobe.com/AS3/2006/builtin < 100)
            {
                _loc_8 = _loc_6.substr(_loc_10 - 3, 2) + String(http://adobe.com/AS3/2006/builtin);
            }
            else
            {
                _loc_13 = http://adobe.com/AS3/2006/builtin.toString();
                _loc_7 = _loc_13.length - 1;
                while (_loc_7 >= 0)
                {
                    
                    if (_loc_10 > 0)
                    {
                        _loc_14 = _loc_6.charAt(_loc_10--);
                        if (_loc_14 != "0")
                        {
                            _loc_8 = _loc_14 + _loc_8;
                            continue;
                        }
                    }
                    _loc_14 = _loc_13.charAt(_loc_7--);
                    _loc_8 = _loc_14 + _loc_8;
                }
            }
            if ((http://adobe.com/AS3/2006/builtin & ZERO) == 0 && http://adobe.com/AS3/2006/builtin % 100 == 0)
            {
                _loc_8 = _loc_8.substring(0, _loc_8.length - 3);
            }
            if ((http://adobe.com/AS3/2006/builtin & ABBR) != 0)
            {
                _loc_8 = _loc_8 + _loc_5;
            }
            if (_loc_9.isSignPosLeft == true)
            {
                _loc_8 = _loc_9.sign + _loc_8;
            }
            else
            {
                _loc_8 = _loc_8 + _loc_9.sign;
            }
            if (_loc_3 == -1)
            {
                _loc_8 = "-" + _loc_8;
            }
            return _loc_8;
        }// end function

        public static function setFormat(split:String) : void
        {
            LONG_FORMAT = null;
            SHORT_FORMAT = null;
            ABBR_FORMAT = null;
            if (split == null || split == "")
            {
                return;
            }
            var _loc_2:* = split.split("|");
            LONG_FORMAT = new MoneyFormat(_loc_2[0]);
            SHORT_FORMAT = new MoneyFormat(_loc_2[1]);
            if (_loc_2.length > 2 && _loc_2[2] != "")
            {
                ABBR_FORMAT = new MoneyFormatAbbr(_loc_2[2]);
            }
            return;
        }// end function

    }
}
