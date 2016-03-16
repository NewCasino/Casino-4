package com.playtech.casino3.slots.shared.data
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.enum.*;

    public class WinInfo extends Object implements IDisposable
    {
        public var frames_sufixes:Vector.<String>;
        public var symbol_indexes:Vector.<int>;
        public var win_amount:Number;
        public var win:SlotsWin;
        public var wins_on_reels:uint;
        public var symbols:Vector.<SlotsSymbol>;
        public var payline:SlotsPayline;
        public var is_substituted:Boolean;

        public function WinInfo(payline_:SlotsWin, payline_:Vector.<int>, payline_:Vector.<SlotsSymbol>, payline_:SlotsPayline = null, payline_:Vector.<String> = null, payline_:uint = 0) : void
        {
            this.win = payline_;
            this.symbol_indexes = payline_;
            this.symbols = payline_;
            this.payline = payline_;
            this.frames_sufixes = payline_;
            this.wins_on_reels = payline_;
            return;
        }// end function

        public function calculateWinAmount(Vector:Number, Vector:Number, Vector:Number) : Number
        {
            var _loc_4:* = this.getBaseValue(Vector, Vector) * this.payout * Vector;
            this.win.win = this.getBaseValue(Vector, Vector) * this.payout * Vector;
            var _loc_4:* = _loc_4;
            this.win_amount = _loc_4;
            return _loc_4;
        }// end function

        public function clone() : WinInfo
        {
            var _loc_1:* = new WinInfo(this.win.clone(), this.symbol_indexes, this.symbols, this.payline, this.frames_sufixes, this.wins_on_reels);
            _loc_1.is_substituted = this.is_substituted;
            return _loc_1;
        }// end function

        public function get payline_id() : int
        {
            return this.payline ? (this.payline.id) : (-1);
        }// end function

        public function dispose() : void
        {
            this.win = null;
            this.symbol_indexes = null;
            this.symbols = null;
            this.payline = null;
            this.frames_sufixes = null;
            return;
        }// end function

        public function get payout() : Number
        {
            return this.win.payout;
        }// end function

        public function toString() : String
        {
            var _loc_1:String = "\n";
            var _loc_2:* = "------------------WIN INFO--------------------" + _loc_1;
            _loc_2 = _loc_2 + (this.win + _loc_1);
            _loc_2 = _loc_2 + ("SYMBOL INDEXES" + _loc_1);
            _loc_2 = _loc_2 + (this.symbol_indexes + _loc_1);
            _loc_2 = _loc_2 + ("SYMBOLS" + _loc_1);
            _loc_2 = _loc_2 + (this.symbols + _loc_1);
            _loc_2 = _loc_2 + ("PAYLINE" + _loc_1);
            _loc_2 = _loc_2 + (this.payline + _loc_1);
            _loc_2 = _loc_2 + ("FRAME SUFIXES" + _loc_1);
            _loc_2 = _loc_2 + (this.frames_sufixes + _loc_1);
            _loc_2 = _loc_2 + ("------------------WIN INFO END-----------------" + _loc_1);
            return _loc_2;
        }// end function

        public function getBaseValue(Vector:Number, Vector:Number) : Number
        {
            return this.win.type == SlotWinRule.ANYWHERE.type ? (Vector) : (Vector);
        }// end function

        public function get win_rule() : int
        {
            return this.win.type;
        }// end function

    }
}
