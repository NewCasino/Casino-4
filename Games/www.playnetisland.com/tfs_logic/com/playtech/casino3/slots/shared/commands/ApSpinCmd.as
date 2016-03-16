package com.playtech.casino3.slots.shared.commands
{
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.core.*;

    public class ApSpinCmd extends SpinCmd
    {

        public function ApSpinCmd(param1:SlotsBase, param2:Boolean = false)
        {
            super(param1, param2);
            return;
        }// end function

        override public function execute(moneyIn:String) : int
        {
            Console.write("Autoplay spin executed", "[" + GameParameters.shortname + "] ");
            var _loc_2:* = m_base.getRoundInfo();
            var _loc_3:* = _loc_2.getTotalBet();
            var _loc_4:* = _loc_2.moneyIn;
            if (_loc_4 == 0 && !m_base.getModI().reserveCredit(_loc_3) || _loc_3 == 0)
            {
                m_base.getModI().openDialog(SharedDialog.ALERT, m_base.getModI().readAlert(22));
                m_base.getModI().updateStatusBar("novel_infobar_balance");
                m_base.getAP().deactivate();
                m_base.newGameRound();
                return 0;
            }
            m_base.getAP().setApLeft((m_base.getAP().getApLeft() - 1));
            _loc_2.moneyIn = 0;
            m_base.getModI().commitCredit();
            startSpin(_loc_3, _loc_2.getLineBet(false), _loc_2.getActiveBets());
            return 0;
        }// end function

    }
}
