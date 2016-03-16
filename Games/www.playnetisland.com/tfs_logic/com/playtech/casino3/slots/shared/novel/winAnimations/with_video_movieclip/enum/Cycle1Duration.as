package com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip.enum
{
    import Cycle1Duration.as$310.*;
    import com.playtech.casino3.slots.shared.enum.*;

    final public class Cycle1Duration extends BaseEnumeration
    {
        protected var _type:int;
        public static const CUSTOM_DURATION:Cycle1Duration = new Cycle1Duration(0, null);
        public static const DURATION_OF_THE_SOUND:Cycle1Duration = new Cycle1Duration(-1, null);

        public function Cycle1Duration(param1:int, param2:block_constructor)
        {
            if (Cycle1Duration)
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
