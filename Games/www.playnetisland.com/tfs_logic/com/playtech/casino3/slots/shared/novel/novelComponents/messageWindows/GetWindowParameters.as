package com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows
{
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;

    public class GetWindowParameters extends Object
    {

        public function GetWindowParameters()
        {
            return;
        }// end function

        public static function freespinMore() : WindowParameters
        {
            var _loc_1:* = new WindowParameters();
            _loc_1.linkageName = "FS_more_spins";
            _loc_1.inAnimation = MessageWindowInfo.FADE_ANIM;
            _loc_1.outAnimation = MessageWindowInfo.FADE_ANIM;
            _loc_1.clickTarget = MessageWindowInfo.FULL_WINDOW;
            _loc_1.duration = 2000;
            return _loc_1;
        }// end function

        public static function bonusInstructions() : WindowParameters
        {
            var _loc_1:* = new WindowParameters();
            _loc_1.linkageName = "bonus_instructions";
            _loc_1.hasContinueBtn = true;
            _loc_1.inAnimation = MessageWindowInfo.MOVE_ANIM;
            _loc_1.outAnimation = MessageWindowInfo.MOVE_ANIM;
            _loc_1.inSound = "window_down_snd";
            _loc_1.outSound = "window_up_snd";
            return _loc_1;
        }// end function

        public static function freespinOutro() : WindowParameters
        {
            var _loc_1:* = new WindowParameters();
            _loc_1.linkageName = "FS_outro_window";
            _loc_1.hasContinueBtn = true;
            _loc_1.inAnimation = MessageWindowInfo.MOVE_ANIM;
            _loc_1.outAnimation = MessageWindowInfo.MOVE_ANIM;
            _loc_1.inSound = "window_down_snd";
            _loc_1.outSound = "window_up_snd";
            return _loc_1;
        }// end function

        public static function freespinIntro() : WindowParameters
        {
            var _loc_1:* = new WindowParameters();
            _loc_1.linkageName = "FS_intro_window";
            _loc_1.inAnimation = MessageWindowInfo.MOVE_ANIM;
            _loc_1.outAnimation = MessageWindowInfo.MOVE_ANIM;
            _loc_1.clickTarget = MessageWindowInfo.FULL_WINDOW;
            _loc_1.duration = 2000;
            _loc_1.inSound = "window_down_snd";
            _loc_1.outSound = "window_up_snd";
            return _loc_1;
        }// end function

    }
}
