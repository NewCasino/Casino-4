package com.playtech.casino3.slots.shared.data
{

    public class SlotsSymbol extends Object implements IDisposable
    {
        public var type:int;
        public var sub_type_1:uint = 0;
        protected var m_tempvalue:SlotsSymbol;
        public var frameSuf:String;
        public var sub_type:uint = 0;
        public var _image:String;
        public var useBg:Boolean;
        protected var m_origType:int;
        public var equal_1:uint = 0;
        public var winsound:String;
        public var equal:uint = 0;
        public var _winvideo:String;

        public function SlotsSymbol(param1:int, param2:Array = null, param3:Boolean = false)
        {
            var _loc_4:* = param1;
            this.m_origType = param1;
            this.type = _loc_4;
            this.useBg = param3;
            if (param2)
            {
                this.addSubstituents.apply(this, param2);
            }
            this.addSubstituent(this, 1);
            return;
        }// end function

        public function removeAlias() : void
        {
            this.m_tempvalue = null;
            this.type = this.m_origType;
            return;
        }// end function

        public function removeSubstituent(com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol:SlotsSymbol) : void
        {
            var _loc_2:uint = 0;
            if (com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol == this)
            {
                return;
            }
            _loc_2 = com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol.type;
            var _loc_3:* = _loc_2 < 32 ? (_loc_2) : (_loc_2 - 32);
            var _loc_4:* = 1 << _loc_3;
            if (_loc_2 < 32)
            {
                this.equal = this.equal & ~_loc_4;
            }
            else
            {
                this.equal_1 = this.equal_1 & ~_loc_4;
            }
            return;
        }// end function

        public function addSubstituent(com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol:SlotsSymbol, com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol:int = 0) : void
        {
            var _loc_3:uint = 0;
            _loc_3 = com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol.type;
            var _loc_4:* = _loc_3 < 32 ? (_loc_3) : (_loc_3 - 32);
            var _loc_5:* = 1 << _loc_4;
            var _loc_6:* = _loc_3 < 32 ? (this.equal) : (this.equal_1);
            var _loc_7:* = _loc_3 < 32 ? (this.sub_type) : (this.sub_type_1);
            _loc_6 = _loc_6 | _loc_5;
            _loc_7 = _loc_7 & ~_loc_5 | com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol << _loc_4;
            if (_loc_3 < 32)
            {
                this.equal = _loc_6;
                this.sub_type = _loc_7;
            }
            else
            {
                this.equal_1 = _loc_6;
                this.sub_type_1 = _loc_7;
            }
            return;
        }// end function

        public function clearSubstituents() : void
        {
            this.equal = 0;
            this.sub_type = 0;
            this.equal_1 = 0;
            this.sub_type_1 = 0;
            this.addSubstituent(this, 1);
            return;
        }// end function

        public function setAlias(com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol:SlotsSymbol) : void
        {
            this.m_tempvalue = com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol;
            this.type = com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol.type;
            return;
        }// end function

        public function clear() : void
        {
            this.useBg = false;
            this.frameSuf = null;
            this.winsound = null;
            this.winvideo = null;
            this.image = null;
            this.clearSubstituents();
            this.m_origType = this.type;
            this.m_tempvalue = null;
            return;
        }// end function

        public function get image() : String
        {
            return this._image;
        }// end function

        public function get winvideo() : String
        {
            return this._winvideo;
        }// end function

        public function set winvideo(com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol:String) : void
        {
            this._winvideo = com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol;
            return;
        }// end function

        public function addSubstituents(... args) : void
        {
            args = 0;
            var _loc_4:SlotsSymbol = null;
            var _loc_5:Object = null;
            var _loc_6:uint = 0;
            var _loc_3:* = args.length;
            var _loc_7:* = args[0] as SlotsSymbol;
            var _loc_8:* = args[1];
            if (!args || args.length == 0)
            {
                return this.addSubstituent(_loc_7, _loc_8);
            }
            args = 0;
            while (args < _loc_3)
            {
                
                _loc_4 = args[args] as SlotsSymbol;
                _loc_5 = args[(args + 1)];
                _loc_6 = int(_loc_5);
                if (isNaN(Number(_loc_5)))
                {
                    _loc_6 = 0;
                }
                else
                {
                    args++;
                }
                _loc_7 = _loc_4 as SlotsSymbol;
                this.addSubstituent(_loc_7, _loc_6);
                args++;
            }
            return;
        }// end function

        public function toString() : String
        {
            return "SlotsSymbol {" + this.type + "}";
        }// end function

        public function getAlias() : SlotsSymbol
        {
            return this.m_tempvalue;
        }// end function

        public function set image(com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol:String) : void
        {
            this._image = com.playtech.casino3.slots.shared.data:SlotsSymbol/com.playtech.casino3.slots.shared.data:SlotsSymbol;
            return;
        }// end function

        public function dispose() : void
        {
            this.m_tempvalue = null;
            return;
        }// end function

        public function equals(m_origType:int) : int
        {
            if (m_origType == this.type)
            {
                return 1;
            }
            var _loc_2:* = m_origType;
            if (m_origType >= 32)
            {
                m_origType = m_origType - 32;
            }
            var _loc_3:* = _loc_2 < 32 ? (this.equal) : (this.equal_1);
            var _loc_4:* = _loc_2 < 32 ? (this.sub_type) : (this.sub_type_1);
            if (!(_loc_3 >>> m_origType & 1))
            {
                return -1;
            }
            return _loc_4 >>> m_origType & 1;
        }// end function

    }
}
