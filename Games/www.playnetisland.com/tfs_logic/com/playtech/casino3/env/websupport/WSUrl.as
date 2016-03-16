package com.playtech.casino3.env.websupport
{
    import com.playtech.core.utils.*;

    class WSUrl extends Object
    {
        private var m_state:int;
        private var m_postDataStr:String;
        private var m_name:String;
        private var m_base:String;
        private var m_composed:String;
        private var m_windowParams:String;
        private var m_postTagsMap:HashMap;
        private var m_tagsMap:HashMap;
        private var m_postData:HashMap;
        static const INSPECTED:int = 2;
        static const READY:int = 1;
        static const WAITING:int = 0;

        function WSUrl(param1:String, param2:int)
        {
            this.m_name = param1;
            this.m_state = param2;
            this.m_postData = new HashMap();
            this.m_tagsMap = new HashMap();
            this.m_postTagsMap = new HashMap();
            return;
        }// end function

        function get tagsMap() : HashMap
        {
            return this.m_tagsMap;
        }// end function

        function set state(HashMap:int) : void
        {
            this.m_state = HashMap;
            return;
        }// end function

        function get postDataObject() : Object
        {
            var _loc_3:String = null;
            var _loc_1:Object = null;
            var _loc_2:* = this.m_postData.keys();
            if (_loc_2.length > 0)
            {
                _loc_1 = {};
            }
            for each (_loc_3 in _loc_2)
            {
                
                _loc_1[_loc_3] = this.m_postData.get(_loc_3);
            }
            return _loc_1;
        }// end function

        function get postTagsMap() : HashMap
        {
            return this.m_postTagsMap;
        }// end function

        function get name() : String
        {
            return this.m_name;
        }// end function

        function set tagsMap(HashMap:HashMap) : void
        {
            this.m_tagsMap = HashMap;
            return;
        }// end function

        function get base() : String
        {
            return this.m_base;
        }// end function

        function get composed() : String
        {
            return this.m_composed;
        }// end function

        function get windowParams() : String
        {
            return this.m_windowParams;
        }// end function

        function get state() : int
        {
            return this.m_state;
        }// end function

        function set postTagsMap(HashMap:HashMap) : void
        {
            this.m_postTagsMap = HashMap;
            return;
        }// end function

        function set postDataStr(HashMap:String) : void
        {
            this.m_postDataStr = HashMap;
            return;
        }// end function

        function get postDataStr() : String
        {
            return this.m_postDataStr;
        }// end function

        function set composed(HashMap:String) : void
        {
            this.m_composed = HashMap;
            return;
        }// end function

        function set windowParams(HashMap:String) : void
        {
            this.m_windowParams = HashMap;
            return;
        }// end function

        private function stateToString() : String
        {
            switch(this.m_state)
            {
                case WAITING:
                {
                    return "waiting";
                }
                case READY:
                {
                    return "ready";
                }
                case INSPECTED:
                {
                    return "inspected";
                }
                default:
                {
                    return "unknown";
                    break;
                }
            }
        }// end function

        function get postData() : HashMap
        {
            return this.m_postData;
        }// end function

        function set base(HashMap:String) : void
        {
            this.m_base = HashMap;
            return;
        }// end function

        public function toString() : String
        {
            var _loc_1:* = "[WSUrl] name: " + this.m_name + ", state: " + this.stateToString();
            return _loc_1;
        }// end function

    }
}
