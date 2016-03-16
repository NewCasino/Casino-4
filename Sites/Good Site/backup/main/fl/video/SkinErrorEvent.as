﻿package fl.video
{
    import flash.events.*;

    public class SkinErrorEvent extends ErrorEvent
    {
        public static const SKIN_ERROR:String = "skinError";

        public function SkinErrorEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = "")
        {
            super(param1, param2, param3, param4);
            return;
        }// end function

        override public function clone() : Event
        {
            return new SkinErrorEvent(type, bubbles, cancelable, text);
        }// end function

    }
}
