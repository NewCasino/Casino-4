package com.playtech.casino3.slots.shared.commands
{
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;

    public class LineBetCmd extends CommandBase implements ICommand
    {
        private var m_base:SlotsBase;
        private var m_step:int = 1;

        public function LineBetCmd(param1:SlotsBase, param2:int = 1)
        {
            this.m_base = param1;
            this.m_step = param2;
            return;
        }// end function

        public function clear() : void
        {
            this.m_base = null;
            return;
        }// end function

        public function execute(base:String) : int
        {
            this.m_base.getModI().updateStatusBar("novel_infobar_clickspin");
            var _loc_2:* = this.m_base.getRoundInfo();
            var _loc_3:* = _loc_2.moneyIn;
            _loc_2.changeLineBet(RoundInfo.LINEBET_STEP, this.m_step);
            var _loc_4:* = _loc_2.getTotalBet();
            var _loc_5:* = _loc_4 - _loc_3;
            if (_loc_5 < 0)
            {
                this.m_base.getModI().reserveCredit(_loc_5);
                _loc_2.moneyIn = _loc_4;
            }
            else if (this.m_base.getModI().reserveCredit(_loc_5))
            {
                _loc_2.moneyIn = _loc_4;
            }
            else
            {
                _loc_2.moneyIn = 0;
                this.m_base.getModI().reserveCredit(-_loc_3);
                this.m_base.getModI().updateStatusBar("novel_infobar_balance");
            }
            this.m_base.updateTField(MainTxtFields.LINE_BET_TF, Money.format(_loc_2.getLineBet()));
            this.m_base.updateTField(MainTxtFields.TOTAL_BET_TF, Money.format(_loc_4));
            this.m_base.updateTField(MainTxtFields.WIN_TF, Money.format(0));
            this.m_base.getRoundInfo().wins.clear();
            var _loc_6:Object = {linebet:_loc_2.getLineBet(false), lines:_loc_2.getActiveBets()};
            this.m_base.getModI().writeUserCookie(SlotsCookie.LAST_GAME_INFO_PREFIX + GameParameters.gamecode, _loc_6);
            return 0;
        }// end function

        override public function isCancelable() : Boolean
        {
            return false;
        }// end function

    }
}
