package com.playtech.casino3.slots.top_trumps_stars
{
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.*;

    public class Parameters extends GameParameters
    {

        public function Parameters()
        {
            return;
        }// end function

        public static function initialize()
        {
            maxLines = 15;
            maxLineBet = 10;
            numRows = 3;
            numReels = 5;
            NovelParameters.fsFullEnd = true;
            NovelParameters.celebration = 50;
            NovelParameters.winLimits = Parameters.Vector.<int>([11, 50, 200, 5000]);
            return;
        }// end function

        public static function toString() : String
        {
            return GameParameters.toString(" NovelParameters.celebration " + NovelParameters.celebration + " NovelParameters.winLimits " + NovelParameters.winLimits);
        }// end function

    }
}
