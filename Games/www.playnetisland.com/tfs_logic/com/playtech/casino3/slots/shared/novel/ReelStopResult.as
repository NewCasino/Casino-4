package com.playtech.casino3.slots.shared.novel
{
    import com.playtech.casino3.slots.shared.data.*;

    public class ReelStopResult extends Object implements IDisposable
    {
        public var index_in_reel:int;
        public var reel_index:int;
        public var video:String;
        public var rule:SymbolReelStop;
        public var symbol:SlotsSymbol;

        public function ReelStopResult(symbol_:SymbolReelStop, symbol_:int, symbol_:SlotsSymbol, symbol_:String, symbol_:int) : void
        {
            this.rule = symbol_;
            this.reel_index = this.reel_index;
            this.symbol = symbol_;
            this.video = symbol_;
            this.index_in_reel = symbol_;
            return;
        }// end function

        public function dispose() : void
        {
            this.rule = null;
            this.symbol = null;
            return;
        }// end function

        public function toString() : String
        {
            return "[ ReelStopResult REEL INDEX: " + this.reel_index + " symbol " + this.symbol + " video " + this.video + " ]";
        }// end function

    }
}
