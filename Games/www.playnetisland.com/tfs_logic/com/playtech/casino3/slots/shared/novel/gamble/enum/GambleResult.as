package com.playtech.casino3.slots.shared.novel.gamble.enum
{
    import GambleResult.as$117.*;
    import com.playtech.casino3.slots.shared.enum.*;

    final public class GambleResult extends BaseEnumeration
    {
        protected var _type:String;
        public static const RESULT_LOST:GambleResult = new GambleResult("RESULT_LOST", null);
        public static const RESULT_WIN:GambleResult = new GambleResult("RESULT_WIN", null);
        public static const RESULT_OTHER:GambleResult = new GambleResult("RESULT_OTHER", null);

        public function GambleResult(param1:String, param2:block_constructor)
        {
            if (GambleResult)
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
