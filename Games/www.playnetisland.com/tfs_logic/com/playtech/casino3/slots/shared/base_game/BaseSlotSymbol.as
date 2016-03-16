package com.playtech.casino3.slots.shared.base_game
{
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.core.*;
    import flash.utils.*;

    public class BaseSlotSymbol extends SlotsSymbol
    {
        protected const SYMBOL_CLASS:Class;
        const CLASS_NAME:String;
        const QUALIFIED_CLASS_NAME:String;
        const CLASS:Class;

        public function BaseSlotSymbol(param1:Array = null, param2:Boolean = false)
        {
            this.QUALIFIED_CLASS_NAME = getQualifiedClassName(this);
            this.CLASS_NAME = this.QUALIFIED_CLASS_NAME.substring((this.QUALIFIED_CLASS_NAME.lastIndexOf(":") + 1));
            this.CLASS = (this as Object).constructor;
            this.SYMBOL_CLASS = this.CLASS;
            super(-1, param1, param2);
            this.init();
            return;
        }// end function

        public function set original_type(substring:int) : void
        {
            var _loc_2:* = substring;
            m_origType = substring;
            type = _loc_2;
            addSubstituent(this, 1);
            Console.write(this);
            return;
        }// end function

        override public function toString() : String
        {
            var _loc_3:int = 0;
            var _loc_1:int = 25;
            var _loc_2:* = this.CLASS_NAME;
            _loc_2 = " [ " + type + (type < 10 ? ("  ") : (" ")) + this.CLASS_NAME + " ]";
            _loc_3 = _loc_2.length;
            while (_loc_3 < _loc_1)
            {
                
                _loc_2 = _loc_2 + " ";
                _loc_3++;
            }
            return _loc_2;
        }// end function

        protected function init() : void
        {
            return;
        }// end function

        public function addTypedSubstituent(substring, substring:SubstituentSubType = null) : void
        {
            if (!substring)
            {
                return;
            }
            if (!substring)
            {
                substring = SubstituentSubType.EXACTLY_THE_SAME;
            }
            addSubstituent(substring.symbol, substring.type);
            return;
        }// end function

        public function addTypedSubstituents(substring, substring:SubstituentSubType = null, ... args) : void
        {
            args = 0;
            var _loc_5:Object = null;
            var _loc_6:BaseSlotSymbol = null;
            var _loc_7:SubstituentSubType = null;
            if (!args)
            {
                args = [];
            }
            if (!substring)
            {
                substring = SubstituentSubType.EXACTLY_THE_SAME;
            }
            args.unshift(substring);
            args.unshift(substring);
            var _loc_8:* = args.length;
            args = 0;
            while (args < _loc_8)
            {
                
                _loc_5 = args[args];
                _loc_6 = _loc_5 as BaseSlotSymbol;
                if (!_loc_6 && _loc_5)
                {
                    _loc_6 = _loc_5.symbol;
                }
                if (!_loc_6)
                {
                    args.splice(args, 2);
                    args++;
                }
                else
                {
                    args[args] = _loc_6;
                    args++;
                    _loc_7 = args[args] as SubstituentSubType;
                    if (_loc_7)
                    {
                        args[args] = _loc_7.type;
                    }
                }
                args++;
            }
            super.addSubstituents.apply(this, args);
            return;
        }// end function

        override public function get image() : String
        {
            if (BaseSlotSymbols.USE_SYMBOL_NAMES)
            {
                return BaseSlotSymbols.STATIC_SYMBOLS_PACKAGE + "." + this.CLASS_NAME.toLowerCase();
            }
            if (!_image)
            {
                return null;
            }
            return (_image.indexOf(".") == -1 ? (BaseSlotSymbols.STATIC_SYMBOLS_PACKAGE ? (BaseSlotSymbols.STATIC_SYMBOLS_PACKAGE + ".") : ("")) : ("")) + _image;
        }// end function

        override public function get winvideo() : String
        {
            if (BaseSlotSymbols.USE_SYMBOL_NAMES)
            {
                return BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE + "." + this.CLASS_NAME.toLowerCase();
            }
            if (!_winvideo)
            {
                return null;
            }
            return (_winvideo.indexOf(".") == -1 ? (BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE ? (BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE + ".") : ("")) : ("")) + _winvideo;
        }// end function

    }
}
