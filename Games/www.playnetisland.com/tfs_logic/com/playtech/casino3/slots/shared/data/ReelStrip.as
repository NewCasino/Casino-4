package com.playtech.casino3.slots.shared.data
{
    import __AS3__.vec.*;

    public class ReelStrip extends Object implements IDisposable
    {
        public var strip:Vector.<SlotsSymbol>;

        public function ReelStrip(param1:Vector.<SlotsSymbol>) : void
        {
            this.strip = param1;
            return;
        }// end function

        public function dispose() : void
        {
            this.strip = null;
            return;
        }// end function

    }
}
