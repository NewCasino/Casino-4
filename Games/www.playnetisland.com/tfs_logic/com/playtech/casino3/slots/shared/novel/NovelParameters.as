package com.playtech.casino3.slots.shared.novel
{
    import __AS3__.vec.*;

    public class NovelParameters extends Object
    {
        public static var winLimits:Vector.<int>;
        public static var nrOfKind:int;
        public static var celebration:int;
        public static var fsFullEnd:Boolean;

        public function NovelParameters()
        {
            return;
        }// end function

        public static function resetParameters() : void
        {
            winLimits = NovelParameters.Vector.<int>([11, 50, 200, 10000]);
            fsFullEnd = false;
            celebration = 50;
            nrOfKind = 5;
            return;
        }// end function

    }
}
