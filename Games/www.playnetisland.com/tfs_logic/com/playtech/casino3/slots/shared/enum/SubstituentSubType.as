package com.playtech.casino3.slots.shared.enum
{
    import SubstituentSubType.as$214.*;

    final public class SubstituentSubType extends BaseEnumeration
    {
        protected var _type:int;
        public static const SUBSTITUTES:SubstituentSubType = new SubstituentSubType(1, null);
        public static const EXACTLY_THE_SAME:SubstituentSubType = new SubstituentSubType(0, null);

        public function SubstituentSubType(param1:int, param2:block_constructor)
        {
            if (SubstituentSubType)
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
