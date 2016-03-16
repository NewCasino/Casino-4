package com.playtech.casino3.slots.top_trumps_stars.enum
{
    import ServerCommand.as$143.*;
    import com.playtech.casino3.slots.shared.enum.*;

    final public class ServerCommand extends BaseEnumeration
    {
        protected var _type:int;
        public static const LOGIN:ServerCommand = new ServerCommand(11690, null);
        public static const LOGOUT:ServerCommand = new ServerCommand(11691, null);
        public static const BONUS:ServerCommand = new ServerCommand(11692, null);

        public function ServerCommand(param1:int, param2:block_constructor)
        {
            if (ServerCommand)
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
