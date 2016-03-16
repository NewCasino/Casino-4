package com.playtech.casino3.slots.shared.commands
{
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.core.*;

    public class FreeSpinCmd extends SpinCmd
    {

        public function FreeSpinCmd(param1:SlotsBase, param2:Boolean = false)
        {
            super(param1, param2);
            return;
        }// end function

        override public function execute(] :String) : int
        {
            Console.write("FreeSpin command executed", "[" + GameParameters.shortname + "] ");
            if (!m_base)
            {
                Console.write("Warning FreeSpin command executed", "[" + GameParameters.shortname + "] but command was already cleared !!!");
                return 0;
            }
            var _loc_2:* = m_base.getRoundInfo();
            m_base.updateTField(MainTxtFields.WIN_TF, Money.format(0));
            startSpin(_loc_2.getTotalBet(), _loc_2.getLineBet(false), _loc_2.getActiveBets());
            return 0;
        }// end function

    }
}
