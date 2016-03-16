package com.playtech.casino3.slots.shared.data
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.utils.*;

    public class SlotsWin extends Object
    {
        private var m_restriction:Vector.<Vector.<int>>;
        public var win:Number;
        private var m_animArgs:Object;
        protected var m_class:Class;
        private var m_special:int;
        public var frameId:int;
        private var m_symbol:SlotsSymbol;
        private var m_priority:int;
        private var m_payout:Number;
        public var type:int;
        private var m_count:int;
        public static const CUSTOM:int = 6;
        public static const RIGHT_CONSECUTIVE:int = 1;
        public static const CONSECUTIVE:int = 2;
        public static const LEFT_CONSECUTIVE:int = 0;
        public static const FIXED_INDEXES:int = 5;
        public static const NON_CONSECUTIVE:int = 3;
        public static const ANYWHERE:int = 4;

        public function SlotsWin(param1:SlotsSymbol, param2:int, param3:Number, param4:Class, param5:Object = null, param6:int = 0, param7:int = 0, param8:int = -1, param9:Vector.<Vector.<int>> = null)
        {
            this.m_symbol = param1;
            this.m_count = param2;
            this.m_payout = param3;
            this.type = param6;
            this.m_special = param7;
            this.m_priority = param8 == -1 ? (param7) : (param8);
            this.m_restriction = param9;
            this.m_class = param4;
            this.m_animArgs = param5;
            this.win = 0;
            return;
        }// end function

        public function toString() : String
        {
            return "Slots Win Class symbol: " + this.m_symbol + " {" + this.m_count + ", " + this.m_payout + "} " + this.type + "\n";
        }// end function

        private function clearAnimArgs() : void
        {
            var _loc_1:* = undefined;
            if (this.m_animArgs != null)
            {
                for (_loc_1 in this.m_animArgs)
                {
                    
                    delete this.m_animArgs[_loc_1];
                }
            }
            return;
        }// end function

        public function get count() : int
        {
            return this.m_count;
        }// end function

        public function get restriction() : Vector.<Vector.<int>>
        {
            return this.m_restriction;
        }// end function

        public function get animArgs() : Object
        {
            return copyObject(this.m_animArgs);
        }// end function

        public function get isLineSpecific() : Boolean
        {
            return this.type == LEFT_CONSECUTIVE || this.type == RIGHT_CONSECUTIVE || this.type == CONSECUTIVE || this.type == NON_CONSECUTIVE;
        }// end function

        public function get symbol() : SlotsSymbol
        {
            return this.m_symbol;
        }// end function

        public function set animClass(m_animArgs:Class) : void
        {
            this.m_class = m_animArgs;
            return;
        }// end function

        public function dispose() : void
        {
            this.m_symbol = null;
            this.m_restriction = null;
            this.m_class = null;
            this.clearAnimArgs();
            this.m_animArgs = null;
            return;
        }// end function

        public function set animArgs(m_animArgs:Object) : void
        {
            this.clearAnimArgs();
            this.m_animArgs = m_animArgs;
            return;
        }// end function

        public function get priority() : int
        {
            return this.m_priority;
        }// end function

        public function get symbol_index() : uint
        {
            return this.symbol.type;
        }// end function

        public function get payout() : Number
        {
            return this.m_payout;
        }// end function

        public function get animClass() : Class
        {
            return this.m_class;
        }// end function

        public function get isSpecial() : Boolean
        {
            return this.m_special > 0;
        }// end function

        public function clone() : SlotsWin
        {
            return new SlotsWin(this.m_symbol, this.m_count, this.m_payout, this.m_class, this.m_animArgs, this.type, this.m_special, this.m_priority, this.m_restriction);
        }// end function

        public function get special() : int
        {
            return this.m_special;
        }// end function

    }
}
