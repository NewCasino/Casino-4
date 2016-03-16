package com.playtech.casino3.slots.shared.data
{

    public class GameParameters extends Object
    {
        public static var shortname:String;
        public static var library:String;
        public static var sound_library:String;
        public static var celebration_sound_library:String;
        public static var numReels:int;
        public static var numRows:int;
        public static var maxLineBet:int;
        public static var progressive:Boolean;
        public static var maxLines:int;
        public static var gamecode:String;

        public function GameParameters()
        {
            return;
        }// end function

        public static function resetParameters() : void
        {
            maxLines = 0;
            maxLineBet = 0;
            numRows = 0;
            numReels = 0;
            shortname = null;
            gamecode = null;
            library = null;
            sound_library = null;
            celebration_sound_library = null;
            progressive = false;
            return;
        }// end function

        public static function toString(param1:String = null) : String
        {
            return " [ GameParameters: maxLines " + maxLines + " maxLineBet" + maxLineBet + " numRows " + numRows + " numReels " + numReels + " shortname " + shortname + (param1 ? (" " + param1) : ("")) + " ] ";
        }// end function

    }
}
