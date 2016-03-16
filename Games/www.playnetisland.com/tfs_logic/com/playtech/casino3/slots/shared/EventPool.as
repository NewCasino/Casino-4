package com.playtech.casino3.slots.shared
{
    import __AS3__.vec.*;
    import flash.events.*;

    public class EventPool extends Object
    {
        private static var event_dispatcher:EventDispatcher = new EventDispatcher();
        private static var types:Vector.<String> = new Vector.<String>;
        private static var functions:Vector.<Function> = new Vector.<Function>;

        public function EventPool()
        {
            return;
        }// end function

        public static function dispatchEvent(event:Event) : Boolean
        {
            return event_dispatcher.dispatchEvent(event);
        }// end function

        public static function clearListeners() : void
        {
            var _loc_1:int = 0;
            var _loc_2:String = null;
            var _loc_3:Function = null;
            var _loc_4:* = functions.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_4)
            {
                
                _loc_2 = types[_loc_1];
                _loc_3 = functions[_loc_1] as Function;
                event_dispatcher.removeEventListener(_loc_2, _loc_3, true);
                event_dispatcher.removeEventListener(_loc_2, _loc_3, false);
                _loc_1++;
            }
            types.splice(0, types.length);
            functions.splice(0, functions.length);
            return;
        }// end function

        public static function willTrigger(Object:String) : Boolean
        {
            return event_dispatcher.willTrigger(Object);
        }// end function

        public static function removeEventListener(http://adobe.com/AS3/2006/builtin:String, http://adobe.com/AS3/2006/builtin:Function, http://adobe.com/AS3/2006/builtin:Boolean = false) : void
        {
            var _loc_5:int = 0;
            var _loc_4:* = functions.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                if (types[_loc_5] != http://adobe.com/AS3/2006/builtin || functions[_loc_5] != http://adobe.com/AS3/2006/builtin)
                {
                }
                else
                {
                    functions.splice(_loc_5, 1);
                    types.splice(_loc_5, 1);
                    _loc_5 = _loc_5 - 1;
                    _loc_4 = _loc_4 - 1;
                }
                _loc_5++;
            }
            event_dispatcher.removeEventListener(http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin, true);
            event_dispatcher.removeEventListener(http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin, false);
            return;
        }// end function

        public static function addEventListener(http://adobe.com/AS3/2006/builtin:String, http://adobe.com/AS3/2006/builtin:Function, http://adobe.com/AS3/2006/builtin:Boolean = false, http://adobe.com/AS3/2006/builtin:int = 0, http://adobe.com/AS3/2006/builtin:Boolean = false) : void
        {
            functions.push(http://adobe.com/AS3/2006/builtin);
            types.push(http://adobe.com/AS3/2006/builtin);
            event_dispatcher.addEventListener(http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin);
            return;
        }// end function

        public static function hasEventListener(Object:String) : Boolean
        {
            return event_dispatcher.hasEventListener(Object);
        }// end function

        public static function dispose() : void
        {
            clearListeners();
            return;
        }// end function

    }
}
