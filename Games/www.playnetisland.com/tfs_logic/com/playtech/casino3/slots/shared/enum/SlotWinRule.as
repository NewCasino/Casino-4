package com.playtech.casino3.slots.shared.enum
{
    import SlotWinRule.as$213.*;

    final public class SlotWinRule extends BaseEnumeration
    {
        protected var _type:int;
        public static const CUSTOM:SlotWinRule = new SlotWinRule(6, null);
        public static const RIGHT_CONSECUTIVE:SlotWinRule = new SlotWinRule(1, null);
        public static const CONSECUTIVE:SlotWinRule = new SlotWinRule(2, null);
        public static const LEFT_CONSECUTIVE:SlotWinRule = new SlotWinRule(0, null);
        public static const FIXED_INDEXES:SlotWinRule = new SlotWinRule(5, null);
        public static const NON_CONSECUTIVE:SlotWinRule = new SlotWinRule(3, null);
        public static const ANYWHERE:SlotWinRule = new SlotWinRule(4, null);

        public function SlotWinRule(param1:int, param2:block_constructor)
        {
            if (SlotWinRule)
            {
                throw new Error(INSTANTIATION_ERROR);
            }
            this._type = param1;
            return;
        }// end function

        override public function get type()
        {
            return this._type;
        }// end function

    }
}
