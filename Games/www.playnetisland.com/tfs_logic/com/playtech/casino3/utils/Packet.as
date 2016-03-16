package com.playtech.casino3.utils
{
    import __AS3__.vec.*;
    import flash.utils.*;

    final public class Packet extends Object
    {
        protected var m_errorCode:uint;
        protected var m_windowID:int;
        protected var m_sendInFunMode:Boolean;
        protected var m_isInbound:Boolean;
        protected var m_data:Vector.<String>;
        protected var m_code:uint;
        public static const FS:String = String.fromCharCode(252);

        public function Packet(param1:uint, param2:Boolean = false)
        {
            this.m_sendInFunMode = param2;
            this.m_windowID = -1;
            this.m_errorCode = 0;
            this.m_code = param1;
            this.m_data = new Vector.<String>;
            this.m_isInbound = false;
            return;
        }// end function

        public function get windowID() : int
        {
            return this.m_windowID;
        }// end function

        public function set data(Vector:Vector.<String>) : void
        {
            this.m_data = Vector;
            return;
        }// end function

        public function get errorCode() : uint
        {
            return this.m_errorCode;
        }// end function

        public function set windowID(Vector:int) : void
        {
            this.m_windowID = Vector;
            return;
        }// end function

        public function set code(Vector:uint) : void
        {
            this.m_code = Vector;
            return;
        }// end function

        public function serialize() : ByteArray
        {
            var _loc_1:* = new ByteArray();
            _loc_1.writeUnsignedInt(this.m_code);
            _loc_1.writeUnsignedInt(this.m_errorCode);
            _loc_1.writeBoolean(this.m_sendInFunMode);
            _loc_1.writeBoolean(this.m_isInbound);
            _loc_1.writeInt(this.m_windowID);
            _loc_1.writeObject(this.m_data);
            _loc_1.position = 0;
            _loc_1.compress();
            return _loc_1;
        }// end function

        public function get data() : Vector.<String>
        {
            return this.m_data;
        }// end function

        public function addData(D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as) : Packet
        {
            if (this.m_isInbound == true)
            {
                throw new Error("can\'t add data to an inbound packet!");
            }
            if (D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as == null)
            {
                throw new Error("data can\'t be null!");
            }
            if (D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as is String)
            {
                this.m_data.push(String(D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as));
                return this;
            }
            if (D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as is Number)
            {
                if (isNaN(D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as) == true)
                {
                    throw new Error("value can\'t be NaN!");
                }
                this.m_data.push(String(D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as));
                return this;
            }
            throw new Error("provided data has an unacceptable type (" + (typeof(D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as)) + ")");
        }// end function

        public function toString() : String
        {
            if (this.m_isInbound == true)
            {
                return "<< (" + this.m_code + ", " + this.m_errorCode + ")" + (this.m_data.length != 0 ? (" " + this.m_data.join(",")) : (""));
            }
            else
            {
            }
            return ">> (" + this.m_code + ")" + (this.m_data.length != 0 ? (" " + this.m_data.join(",")) : (""));
        }// end function

        public function get code() : uint
        {
            return this.m_code;
        }// end function

        public function set errorCode(Vector:uint) : void
        {
            this.m_errorCode = Vector;
            return;
        }// end function

        public function set inbound(Vector:Boolean) : void
        {
            this.m_isInbound = Vector;
            return;
        }// end function

        public function get sendInFunMode() : Boolean
        {
            return this.m_sendInFunMode;
        }// end function

        public static function desrialize(D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as:ByteArray) : Packet
        {
            D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as.uncompress();
            D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as.position = 0;
            var _loc_2:* = new Packet(D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as.readUnsignedInt());
            _loc_2.m_errorCode = D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as.readUnsignedInt();
            _loc_2.m_sendInFunMode = D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as.readBoolean();
            _loc_2.m_isInbound = D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as.readBoolean();
            _loc_2.m_windowID = D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as.readInt();
            if (D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as.bytesAvailable > 0)
            {
                _loc_2.m_data = Packet.Vector.<String>(D:\projects\build_10.1\webclient;com\playtech\casino3\utils;Packet.as.readObject());
            }
            return _loc_2;
        }// end function

    }
}
