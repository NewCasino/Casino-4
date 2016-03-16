package com.playtech.casino3.env.websupport
{
    import __AS3__.vec.*;
    import com.playtech.core.*;
    import com.playtech.core.utils.*;

    class WSRequestData extends Object
    {
        private var m_hasPreOpenedWindow:Boolean;
        private var m_replaceMap:HashMap;
        private var m_url:String;
        private var m_name:String;
        private var m_loginToken:String;
        private var m_id:String;
        private var m_errorHandler:Function;
        private var m_windowName:String;
        private var m_lcid:String;
        private var m_as2:Boolean;
        private var m_urls:Vector.<WSUrl>;
        private var m_handler:Function;

        function WSRequestData()
        {
            this.m_urls = new Vector.<WSUrl>;
            this.m_replaceMap = new HashMap();
            return;
        }// end function

        public function set as2(HashMap:Boolean) : void
        {
            this.m_as2 = HashMap;
            return;
        }// end function

        function get hasPreOpenedWindow() : Boolean
        {
            return this.m_hasPreOpenedWindow;
        }// end function

        function set hasPreOpenedWindow(HashMap:Boolean) : void
        {
            this.m_hasPreOpenedWindow = HashMap;
            return;
        }// end function

        function get waitingURLNames() : Vector.<String>
        {
            var _loc_2:WSUrl = null;
            var _loc_1:* = new Vector.<String>;
            for each (_loc_2 in this.urls)
            {
                
                if (_loc_2.state == WSUrl.WAITING)
                {
                    _loc_1.push(_loc_2.name);
                }
            }
            return _loc_1;
        }// end function

        public function get name() : String
        {
            return this.m_name;
        }// end function

        function get loginToken() : String
        {
            return this.m_loginToken;
        }// end function

        public function set name(HashMap:String) : void
        {
            this.m_name = HashMap;
            this.m_lcid = Math.round(Math.random() * 3735927486) + "_" + this.m_name;
            return;
        }// end function

        function getUrlByName(param1:String) : WSUrl
        {
            var _loc_2:WSUrl = null;
            for each (_loc_2 in this.urls)
            {
                
                if (_loc_2.name == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        function dispose() : void
        {
            this.m_urls = null;
            this.m_replaceMap.clear();
            this.m_replaceMap = null;
            return;
        }// end function

        function set loginToken(HashMap:String) : void
        {
            this.m_loginToken = HashMap;
            return;
        }// end function

        public function get windowName() : String
        {
            return this.m_windowName;
        }// end function

        public function set handler(HashMap:Function) : void
        {
            this.m_handler = HashMap;
            return;
        }// end function

        public function get id() : String
        {
            return this.m_id;
        }// end function

        public function get errorHandler() : Function
        {
            return this.m_errorHandler;
        }// end function

        public function set id(HashMap:String) : void
        {
            this.m_id = HashMap;
            return;
        }// end function

        public function set windowName(HashMap:String) : void
        {
            this.m_windowName = HashMap;
            return;
        }// end function

        public function addSubstitution(HashMap:String, HashMap:String) : void
        {
            if (HashMap == null)
            {
                throw new ArgumentError("name can\'t be null");
            }
            if (HashMap == null)
            {
                HashMap = "";
            }
            Console.write("adding substitution " + HashMap + " : " + HashMap, this);
            this.m_replaceMap.put(HashMap, HashMap);
            return;
        }// end function

        public function get as2() : Boolean
        {
            return this.m_as2;
        }// end function

        public function get handler() : Function
        {
            return this.m_handler;
        }// end function

        public function set errorHandler(HashMap:Function) : void
        {
            this.m_errorHandler = HashMap;
            return;
        }// end function

        function get lcid() : String
        {
            return this.m_lcid;
        }// end function

        function isHandledUrl(_:String) : Boolean
        {
            var _loc_2:WSUrl = null;
            for each (_loc_2 in this.urls)
            {
                
                if (_loc_2.name == _)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public function set url(HashMap:String) : void
        {
            this.m_url = HashMap;
            return;
        }// end function

        function get urls() : Vector.<WSUrl>
        {
            return this.m_urls;
        }// end function

        public function get url() : String
        {
            return this.m_url;
        }// end function

        function getSubstitution(http://adobe.com/AS3/2006/builtin:String) : String
        {
            if (http://adobe.com/AS3/2006/builtin == null)
            {
                throw new ArgumentError("name can\'t be null");
            }
            return this.m_replaceMap.get(http://adobe.com/AS3/2006/builtin);
        }// end function

        public function toString() : String
        {
            var _loc_2:WSUrl = null;
            var _loc_1:String = "";
            for each (_loc_2 in this.urls)
            {
                
                _loc_1 = _loc_1 + (_loc_2 + ",");
            }
            if (_loc_1)
            {
                _loc_1 = _loc_1.substr(0, (_loc_1.length - 1));
            }
            return "[WSRequestData] " + _loc_1;
        }// end function

    }
}
