package com.playtech.casino3.slots.top_trumps_stars.enum
{
    import BonusCommandType.as$233.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.core.*;
    import flash.utils.*;

    final public class BonusCommandType extends BaseEnumeration
    {
        protected var _type:String;
        public static const INVALID_GAME_NAME:BonusCommandType = new BonusCommandType("invalid_game_name", null);
        public static const ENUMERATIONS:Dictionary = new Dictionary(true);
        public static const CLICK_TO_START:BonusCommandType = new BonusCommandType("click2start", null);
        public static const TEAMS:BonusCommandType = new BonusCommandType("teams", null);
        public static const TYPES:Dictionary = new Dictionary(true);

        public function BonusCommandType(param1:String, param2:block_constructor)
        {
            if (BonusCommandType)
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

        public static function fromType(ENUMERATIONS:String, ENUMERATIONS:Boolean = false) : BonusCommandType
        {
            var _loc_3:* = TYPES[ENUMERATIONS];
            if (!ENUMERATIONS && !_loc_3)
            {
                Console.write("Warning unknown type in " + BonusCommandType + " fromType " + ENUMERATIONS + "!!!");
            }
            return _loc_3;
        }// end function

        ENUMERATIONS[CLICK_TO_START] = CLICK_TO_START.type;
        ENUMERATIONS[INVALID_GAME_NAME] = INVALID_GAME_NAME.type;
        ENUMERATIONS[TEAMS] = TEAMS.type;
        TYPES[CLICK_TO_START.type] = CLICK_TO_START;
        TYPES[INVALID_GAME_NAME.type] = INVALID_GAME_NAME;
        TYPES[TEAMS.type] = TEAMS;
    }
}
