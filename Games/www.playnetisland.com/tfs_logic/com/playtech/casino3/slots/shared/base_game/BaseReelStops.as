package com.playtech.casino3.slots.shared.base_game
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.novel.*;

    public class BaseReelStops extends Object implements IDisposable
    {
        public const REEL_STOP_RULES:Vector.<SymbolReelStop>;

        public function BaseReelStops()
        {
            this.REEL_STOP_RULES = new Vector.<SymbolReelStop>;
            return;
        }// end function

        protected function pushRule(param1:Class, param2:Vector.<int>, param3:String = null, param4:String = null, param5:Boolean = false) : SymbolReelStop
        {
            var _loc_6:* = this.constructReelStopRuleFromClass(param1, param2, param3, param4);
            _loc_6.is_real_count = param5;
            this.REEL_STOP_RULES.push(_loc_6);
            return _loc_6;
        }// end function

        public function constructReelStopRuleFromClass(param1:Class, param2:Vector.<int>, param3:String = null, param4:String = null) : SymbolReelStop
        {
            return new SymbolReelStop(param1.symbol, param2, param3, param4);
        }// end function

        public function clear() : void
        {
            this.REEL_STOP_RULES.splice(0, this.REEL_STOP_RULES.length);
            return;
        }// end function

        public function dispose() : void
        {
            this.clear();
            return;
        }// end function

    }
}
