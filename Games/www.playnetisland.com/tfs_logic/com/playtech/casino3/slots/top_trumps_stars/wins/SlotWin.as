package com.playtech.casino3.slots.top_trumps_stars.wins
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.wins.enum.*;

    public class SlotWin extends SlotsWin implements IDisposable
    {

        public function SlotWin(win_rule:Object, win_rule:int, win_rule:Number, win_rule:Class, win_rule:Object = null, win_rule:SlotWinRule = null, win_rule:WinsSpecial = null, win_rule:WinsPriority = null, win_rule:Vector.<Vector.<int>> = null) : void
        {
            if (!win_rule)
            {
                win_rule = SlotWinRule.LEFT_CONSECUTIVE;
            }
            if (!win_rule)
            {
                win_rule = WinsSpecial.NOT_SPECIAL;
            }
            if (!win_rule)
            {
                win_rule = WinsPriority.DEFAULT;
            }
            super(win_rule.symbol, win_rule, win_rule, win_rule, win_rule, win_rule.type, win_rule.type, win_rule.type, win_rule);
            return;
        }// end function

    }
}
