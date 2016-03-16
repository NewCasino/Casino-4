package com.playtech.casino3.slots.shared.enum
{

    public class GameStates extends Object
    {
        public static const STATE_RESPIN:int = 3;
        public static const EVENT_PREV_STATE:String = "Gamestates_previous_state";
        public static const EVENT_RESET_All:String = "Gamestates_reset_all";
        public static const EVENT_NEW_STATE:String = "Gamestates_new_state";
        public static const STATE_AUTOPLAY:int = 2;
        public static const STATE_NORMAL:int = 0;
        public static const STATE_FREESPIN:int = 1;

        public function GameStates()
        {
            return;
        }// end function

    }
}
