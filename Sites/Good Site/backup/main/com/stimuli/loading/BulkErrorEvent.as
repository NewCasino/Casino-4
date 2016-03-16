package com.stimuli.loading
{
    import flash.events.*;

    public class BulkErrorEvent extends Event
    {
        public var name:String;
        public var errors:Array;
        public static const ERROR:String = "error";

        public function BulkErrorEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
        {
            super(param1, param2, param3);
            this.name = param1;
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new BulkErrorEvent(name, bubbles, cancelable);
            _loc_1.errors = errors ? (errors.slice()) : ([]);
            return _loc_1;
        }// end function

        override public function toString() : String
        {
            return super.toString();
        }// end function

    }
}
