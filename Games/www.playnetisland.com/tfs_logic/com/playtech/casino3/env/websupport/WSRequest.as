package com.playtech.casino3.env.websupport
{
    import __AS3__.vec.*;

    public class WSRequest extends Object
    {
        protected var m_launchers:Vector.<String>;
        protected var m_cleaners:Vector.<String>;
        protected var m_handlers:Vector.<String>;
        protected var m_data:WSRequestData;
        protected var m_starters:Vector.<String>;

        public function WSRequest()
        {
            this.m_data = new WSRequestData();
            this.m_starters = new Vector.<String>;
            this.m_handlers = new Vector.<String>;
            this.m_launchers = new Vector.<String>;
            this.m_cleaners = new Vector.<String>;
            return;
        }// end function

        function get starters() : Vector.<String>
        {
            return this.m_starters;
        }// end function

        public function addSubstitution(String:String, String:String) : void
        {
            this.m_data.addSubstitution(String, String);
            return;
        }// end function

        function get handlers() : Vector.<String>
        {
            return this.m_handlers;
        }// end function

        function get data() : WSRequestData
        {
            return this.m_data;
        }// end function

        public function toString() : String
        {
            return "[WSRequest] ";
        }// end function

        function get cleaners() : Vector.<String>
        {
            return this.m_cleaners;
        }// end function

        function get launchers() : Vector.<String>
        {
            return this.m_launchers;
        }// end function

        function dispose() : void
        {
            this.m_data.dispose();
            this.m_data = null;
            this.m_starters = null;
            this.m_handlers = null;
            this.m_launchers = null;
            this.m_cleaners = null;
            return;
        }// end function

    }
}
