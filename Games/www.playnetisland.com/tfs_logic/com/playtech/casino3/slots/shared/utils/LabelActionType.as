package com.playtech.casino3.slots.shared.utils
{
    import LabelActionType.as$314.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.core.*;
    import flash.utils.*;

    final public class LabelActionType extends BaseEnumeration
    {
        protected var _type:String;
        public static const TYPES:Dictionary = new Dictionary(true);
        public static const ENUMERATIONS:Dictionary = new Dictionary(true);
        public static const SOUND:LabelActionType = new LabelActionType("SOUND", null);

        public function LabelActionType(param1:String, param2:block_constructor)
        {
            if (LabelActionType)
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

        public static function fromType(TYPES:String, TYPES:Boolean = false) : LabelActionType
        {
            var _loc_3:* = TYPES[TYPES];
            if (!TYPES && !_loc_3)
            {
                Console.write("Warning unknown type in " + LabelActionType + " fromType " + TYPES + "!!!");
            }
            return _loc_3;
        }// end function

        ENUMERATIONS[SOUND] = SOUND.type;
        TYPES[SOUND.type] = SOUND;
    }
}
