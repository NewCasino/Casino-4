package com.playtech.casino3.utils.queue
{
    import com.playtech.casino3.utils.*;
    import flash.events.*;

    public class QueueEventManager extends Object
    {
        private static var m_eventDispatcher:EventDispatcher = new EventDispatcher();

        public function QueueEventManager()
        {
            return;
        }// end function

        public static function dispatchEvent(flash.events:String) : void
        {
            if (flash.events === null)
            {
                return;
            }
            var _loc_2:* = flash.events.split(":");
            m_eventDispatcher.dispatchEvent(new RegularEvent(_loc_2[0], _loc_2[1]));
            return;
        }// end function

        static function removeEventListener(flash.events:String, flash.events:Function) : void
        {
            m_eventDispatcher.removeEventListener(flash.events, flash.events);
            return;
        }// end function

        static function addEventListener(flash.events:String, flash.events:Function) : void
        {
            m_eventDispatcher.addEventListener(flash.events, flash.events);
            return;
        }// end function

    }
}
