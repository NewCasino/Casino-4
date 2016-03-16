package com.playtech.casino3.slots.top_trumps_stars.enum
{
    import GameState.as$73.*;
    import com.playtech.casino3.slots.shared.enum.*;

    final public class GameState extends BaseEnumeration
    {
        protected var _type:String;
        public static const FREESPIN:GameState = new GameState("FREESPIN", null);
        public static const NORMAL:GameState = new GameState("NORMAL", null);

        public function GameState(param1:String, param2:block_constructor)
        {
            if (GameState)
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
