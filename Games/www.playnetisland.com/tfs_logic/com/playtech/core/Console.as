package com.playtech.core
{
    import com.hurlant.util.*;
    import flash.utils.*;

    public class Console extends Object
    {
        private static var _enabled:Boolean = true;
        private static var _showHeaders:Boolean = true;
        private static var _traceObject:Object = null;
        private static var _offsetSymbol:String = "\t";
        private static var _prefix:String = null;
        private static var _showHeaderTime:Boolean = true;

        public function Console()
        {
            return;
        }// end function

        private static function getTime() : String
        {
            var _loc_1:* = new Date();
            return "[" + _loc_1.getHours() + ":" + _loc_1.getMinutes() + ":" + _loc_1.getSeconds() + "] ";
        }// end function

        public static function getOffset(D:\CORE\as3;com\playtech\core;Console.as:uint = 0) : String
        {
            var _loc_3:int = 0;
            var _loc_2:String = "";
            _loc_3 = 0;
            while (_loc_3 < D:\CORE\as3;com\playtech\core;Console.as)
            {
                
                _loc_2 = _loc_2 + _offsetSymbol;
                _loc_3++;
            }
            return _loc_2;
        }// end function

        private static function getObjectTree(D:\CORE\as3;com\playtech\core;Console.as:Object, D:\CORE\as3;com\playtech\core;Console.as:uint = 0, D:\CORE\as3;com\playtech\core;Console.as:String = "[object Object]") : String
        {
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_4:String = "";
            var _loc_5:* = getOffset(D:\CORE\as3;com\playtech\core;Console.as);
            if (typeof(D:\CORE\as3;com\playtech\core;Console.as) == "object")
            {
                _loc_7 = D:\CORE\as3;com\playtech\core;Console.as is Array ? ("array") : (typeof(D:\CORE\as3;com\playtech\core;Console.as));
                _loc_4 = _loc_4 + (_loc_5 + D:\CORE\as3;com\playtech\core;Console.as + " : " + _loc_7 + "\n");
                for (_loc_6 in D:\CORE\as3;com\playtech\core;Console.as)
                {
                    
                    if (typeof(D:\CORE\as3;com\playtech\core;Console.as[_loc_6]) == "object")
                    {
                        _loc_4 = _loc_4 + getObjectTree(D:\CORE\as3;com\playtech\core;Console.as[_loc_6], (D:\CORE\as3;com\playtech\core;Console.as + 1), _loc_6);
                        continue;
                    }
                    _loc_4 = _loc_4 + (getOffset((D:\CORE\as3;com\playtech\core;Console.as + 1)) + _loc_6 + " == " + D:\CORE\as3;com\playtech\core;Console.as[_loc_6] + " : " + (typeof(D:\CORE\as3;com\playtech\core;Console.as[_loc_6])) + "\n");
                }
            }
            return _loc_4;
        }// end function

        public static function set enabled(_prefix:Boolean) : void
        {
            _enabled = _prefix;
            return;
        }// end function

        public static function set showHeaders(_prefix:Boolean) : void
        {
            _showHeaders = _prefix;
            return;
        }// end function

        public static function set offsetSymbol(_prefix:String) : void
        {
            _offsetSymbol = _prefix;
            return;
        }// end function

        public static function debugBytes(_prefix:ByteArray, _prefix:String = null, _prefix:uint = 1) : void
        {
            var _loc_4:* = _prefix == null ? ("") : (_prefix + ": ");
            return;
        }// end function

        public static function write(_prefix, ... args) : void
        {
            args = new activation;
            var body:String;
            var arg:*;
            var arg1:*;
            var arg2:uint;
            var text:* = _prefix;
            var args:* = args;
            if (!_enabled)
            {
                return;
            }
            try
            {
                body =  is String ? () : (toString());
            }
            catch (error:Error)
            {
                body = String(error);
            }
            if (!_showHeaders)
            {
                trace();
                return;
            }
            var header:String;
            if (_prefix != null)
            {
                header = _prefix;
            }
            if (_showHeaderTime)
            {
                header =  + getTime();
            }
            if (length == 1)
            {
                arg = [0];
                header =  + (isNaN() ? (toString()) : (getOffset( as uint)));
            }
            else if (length == 2)
            {
                arg1 = [0];
                arg2 = [1] as uint;
                header =  + toString();
                header =  + getOffset();
            }
            if (_traceObject != null)
            {
                _traceObject.traceString( + );
            }
            trace( + );
            return;
        }// end function

        public static function set prefix(_prefix:String) : void
        {
            _prefix = _prefix;
            return;
        }// end function

        public static function disable() : void
        {
            _enabled = false;
            return;
        }// end function

        public static function setTraceObject(_prefix:Object) : void
        {
            _traceObject = _prefix;
            return;
        }// end function

        public static function getHex(D:\CORE\as3;com\playtech\core;Console.as:ByteArray) : String
        {
            var _loc_2:* = Hex.fromArray(D:\CORE\as3;com\playtech\core;Console.as, true).split(":");
            var _loc_3:* = new Array();
            while (_loc_2.length > 0)
            {
                
                _loc_3.push("\t\t" + _loc_2.splice(0, 8).join(" "));
            }
            return _loc_3.join("\n");
        }// end function

        public static function set showHeaderTime(_prefix:Boolean) : void
        {
            _showHeaderTime = _prefix;
            return;
        }// end function

        public static function debugObject(_prefix:Object, _prefix:uint = 0, _prefix:String = "") : void
        {
            write(getObjectTree(_prefix, _prefix, _prefix), _prefix);
            return;
        }// end function

    }
}
