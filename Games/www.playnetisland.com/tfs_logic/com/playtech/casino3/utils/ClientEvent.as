package com.playtech.casino3.utils
{

    final public class ClientEvent extends Object
    {
        private var m_data:Object;
        private var m_type:String;
        public static const MODULE_ACTIVATED:String = "moduleactivated";
        public static const SESSION_RESET:String = "sessionreset";
        public static const DIALOG_CLOSED:String = "dialogclosed";
        public static const SESSION_RESUMED:String = "sessionresumed";
        public static const SESSION_ESTABLISHED:String = "sessionestablished";
        public static const CREDIT_CHANGED:String = "credchanged";
        public static const SESSION_INTERRUPTED:String = "sessioninterrupted";
        public static const WINDOW_CLOSED:String = "windowclosed";
        public static const MODULE_DEACTIVATED:String = "moduledeactivated";

        public function ClientEvent(param1:String, param2 = null)
        {
            if (param1 == null)
            {
                throw new ArgumentError("type can\'t be null");
            }
            this.m_type = param1;
            this.m_data = param2;
            return;
        }// end function

        public function get type() : String
        {
            return this.m_type;
        }// end function

        public function get data()
        {
            return this.m_data;
        }// end function

    }
}
