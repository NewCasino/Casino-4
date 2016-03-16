package com.playtech.casino3.slots.top_trumps_stars.wins.enum
{
    import WinsSpecial.as$139.*;
    import com.playtech.casino3.slots.shared.enum.*;

    final public class WinsSpecial extends BaseEnumeration
    {
        protected var _type:int;
        public static const NOT_SPECIAL:WinsSpecial = new WinsSpecial(0, null);
        public static const FREE_GAMES:WinsSpecial = new WinsSpecial(1, null);

        public function WinsSpecial(param1:int, param2:block_constructor)
        {
            if (WinsSpecial)
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
