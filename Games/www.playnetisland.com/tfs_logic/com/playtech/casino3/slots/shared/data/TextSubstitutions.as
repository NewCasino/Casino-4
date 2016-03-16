package com.playtech.casino3.slots.shared.data
{
    import com.playtech.core.*;
    import flash.utils.*;

    dynamic public class TextSubstitutions extends Proxy
    {
        protected var _items:Array;
        protected var _properties:Object;

        public function TextSubstitutions(... args) : void
        {
            args = 0;
            this._properties = {};
            if (!args || !args.length)
            {
                return;
            }
            var _loc_3:* = args.length;
            args = 0;
            while (++args < _loc_3)
            {
                
                this[args[args]] = args[++args];
                ++args++;
            }
            return;
        }// end function

        override function deleteProperty(http://adobe.com/AS3/2006/builtin) : Boolean
        {
            return delete this._properties[http://adobe.com/AS3/2006/builtin];
        }// end function

        override function nextValue(param1:int)
        {
            return this.getPropertyValue(this._items[(param1 - 1)]);
        }// end function

        protected function getPropertyValue(param1:String)
        {
            var _loc_2:* = this._properties[param1];
            var _loc_3:* = _loc_2 as Function;
            _loc_2 = _loc_3 is Function ? (this._loc_3()) : (_loc_2);
            return _loc_2;
        }// end function

        public function get refreshed() : Object
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            var _loc_1:Object = {};
            for (_loc_3 in this._properties)
            {
                
                _loc_1[_loc_3] = this.getPropertyValue(_loc_3);
            }
            return _loc_1;
        }// end function

        override function getProperty(param1)
        {
            return this.getPropertyValue(param1);
        }// end function

        public function toString() : String
        {
            return "[ TextSubstitutions ]";
        }// end function

        override function hasProperty(http://adobe.com/AS3/2006/builtin) : Boolean
        {
            return this._properties.hasOwnProperty(http://adobe.com/AS3/2006/builtin);
        }// end function

        override function nextNameIndex(property:int) : int
        {
            var _loc_2:* = undefined;
            if (property == 0)
            {
                this._items = [];
                for (_loc_2 in this._properties)
                {
                    
                    this._items.push(_loc_2);
                }
            }
            return property < this._items.length ? ((property + 1)) : (0);
        }// end function

        override function callProperty(param1, ... args)
        {
            args = this._properties[param1] as Function;
            if (!(args is Function))
            {
                Console.write("Warning TextSubstitutions.callProperty on non function object !!!");
            }
            this._properties[param1].apply(this, args);
            return;
        }// end function

        override function setProperty(substitutions, substitutions) : void
        {
            this._properties[substitutions] = substitutions;
            return;
        }// end function

        override function nextName(TextSubstitutions.as$90:int) : String
        {
            return this._items[(TextSubstitutions.as$90 - 1)];
        }// end function

        public function dispose() : void
        {
            this._properties = null;
            this._items = null;
            return;
        }// end function

    }
}
