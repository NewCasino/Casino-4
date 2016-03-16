package com.playtech.casino3.utils
{
    import flash.events.*;

    public class RegularEvent extends Event
    {
        private var m_data:Object;

        public function RegularEvent(param1:String, param2 = null)
        {
            super(param1);
            this.m_data = param2;
            return;
        }// end function

        public function set data(D:\projects\build_10.1\webclient;com\playtech\casino3\utils;RegularEvent.as) : void
        {
            this.m_data = D:\projects\build_10.1\webclient;com\playtech\casino3\utils;RegularEvent.as;
            return;
        }// end function

        public function get data()
        {
            return this.m_data;
        }// end function

        override public function toString() : String
        {
            return formatToString("RegularEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
        }// end function

        override public function clone() : Event
        {
            return new RegularEvent(type, this.data);
        }// end function

    }
}
