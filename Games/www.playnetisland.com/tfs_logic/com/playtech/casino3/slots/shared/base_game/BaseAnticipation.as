package com.playtech.casino3.slots.shared.base_game
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.novel.anticipation.*;

    public class BaseAnticipation extends Object implements IDisposable
    {
        public const ANTICIPATION_RULES:Vector.<AnticipationRules>;

        public function BaseAnticipation()
        {
            this.ANTICIPATION_RULES = new Vector.<AnticipationRules>;
            return;
        }// end function

        protected function pushRule(param1:Class, param2:Array) : AnticipationRules
        {
            var _loc_3:* = this.constructAnticipationRuleFromClass(param1, param2);
            this.ANTICIPATION_RULES.push(_loc_3);
            return _loc_3;
        }// end function

        public function clear() : void
        {
            this.ANTICIPATION_RULES.splice(0, this.ANTICIPATION_RULES.length);
            return;
        }// end function

        public function constructAnticipationRuleFromClass(param1:Class, param2:Array) : AnticipationRules
        {
            return new AnticipationRules(param1.symbol, param2);
        }// end function

        public function dispose() : void
        {
            this.clear();
            return;
        }// end function

    }
}
