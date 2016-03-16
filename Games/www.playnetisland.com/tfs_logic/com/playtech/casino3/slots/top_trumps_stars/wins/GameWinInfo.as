package com.playtech.casino3.slots.top_trumps_stars.wins
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.top_trumps_stars.slot_symbols.*;

    public class GameWinInfo extends WinInfo
    {
        public var other_win:GameWinInfo;

        public function GameWinInfo(com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo:SlotsWin, com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo:Vector.<int>, com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo:Vector.<SlotsSymbol>, com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo:SlotsPayline = null, com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo:Vector.<String> = null, com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo:uint = 0) : void
        {
            super(com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo, com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo, com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo, com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo, com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo, com.playtech.casino3.slots.top_trumps_stars.wins:GameWinInfo);
            return;
        }// end function

        override public function getBaseValue(int:Number, int:Number) : Number
        {
            if (win.symbol == Ball.symbol)
            {
                return int * 3;
            }
            return super.getBaseValue(int, int);
        }// end function

        override public function clone() : WinInfo
        {
            var _loc_1:* = new GameWinInfo(win.clone(), symbol_indexes, symbols, payline, frames_sufixes, wins_on_reels);
            _loc_1.is_substituted = is_substituted;
            return _loc_1;
        }// end function

        public function get is_mixed() : Boolean
        {
            return (win.symbol as GameSpecificSlotSymbol).is_mixed;
        }// end function

    }
}
