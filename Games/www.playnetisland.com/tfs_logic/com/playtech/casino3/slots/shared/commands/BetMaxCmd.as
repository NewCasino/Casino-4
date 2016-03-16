package com.playtech.casino3.slots.shared.commands
{
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;

    public class BetMaxCmd extends CommandBase implements ICommand
    {
        private var m_base:SlotsBase;

        public function BetMaxCmd(param1:SlotsBase)
        {
            this.m_base = param1;
            return;
        }// end function

        override public function isCancelable() : Boolean
        {
            return false;
        }// end function

        public function clear() : void
        {
            this.m_base = null;
            return;
        }// end function

        public function execute(TOTAL_BET_TF:String) : int
        {
            var _loc_5:Object = null;
            var _loc_6:SpinCmd = null;
            var _loc_2:* = this.m_base.getRoundInfo();
            _loc_2.backupInfo();
            var _loc_3:* = _loc_2.moneyIn;
            _loc_2.changeLineBet(RoundInfo.LINEBET_MAX);
            _loc_2.activateLine(RoundInfo.ACTIVATE_ALL);
            var _loc_4:* = _loc_2.getTotalBet();
            if (this.m_base.getModI().reserveCredit(_loc_4 - _loc_3))
            {
                _loc_2.moneyIn = _loc_4;
                this.m_base.updateTField(MainTxtFields.LINE_BET_TF, Money.format(_loc_2.getLineBet()));
                this.m_base.updateTField(MainTxtFields.LINES_TF, _loc_2.getNumActiveLines().toString());
                this.m_base.updateTField(MainTxtFields.TOTAL_BET_TF, Money.format(_loc_4));
                this.m_base.getLineManager().updateButtons(_loc_2.getActiveBets());
                this.m_base.getRoundInfo().wins.clear();
                _loc_5 = {linebet:_loc_2.getLineBet(false), lines:_loc_2.getActiveBets()};
                this.m_base.getModI().writeUserCookie(SlotsCookie.LAST_GAME_INFO_PREFIX + GameParameters.gamecode, _loc_5);
                _loc_6 = new SpinCmd(this.m_base);
                _loc_6.execute(null);
                _loc_6.clear();
            }
            else
            {
                _loc_2.moneyIn = 0;
                this.m_base.getModI().reserveCredit(-_loc_3);
                _loc_2.restoreInfo();
                this.m_base.getModI().openDialog(SharedDialog.ALERT, this.m_base.getModI().readAlert(17));
                this.m_base.getModI().updateStatusBar("novel_infobar_balance");
            }
            return 0;
        }// end function

    }
}
