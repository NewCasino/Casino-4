package com.playtech.casino3.slots.top_trumps_stars.wins.enum
{
    import WinsPriority.as$222.*;
    import com.playtech.casino3.slots.shared.enum.*;

    final public class WinsPriority extends BaseEnumeration
    {
        protected var _type:int;
        public static const DEFAULT:WinsPriority = new WinsPriority(-1, null);
        public static const LEFT_BALL:WinsPriority = new WinsPriority(-3, null);
        public static const RIGHT_BALL:WinsPriority = new WinsPriority(-2, null);

        public function WinsPriority(param1:int, param2:block_constructor)
        {
            if (WinsPriority)
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
