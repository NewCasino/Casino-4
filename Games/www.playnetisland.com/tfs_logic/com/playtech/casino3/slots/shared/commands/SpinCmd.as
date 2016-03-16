package com.playtech.casino3.slots.shared.commands
{
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;

    public class SpinCmd extends CommandBase implements ICommand
    {
        protected var m_base:SlotsBase;
        private var m_cancelable:Boolean;

        public function SpinCmd(param1:SlotsBase, param2:Boolean = false)
        {
            this.m_base = param1;
            this.m_cancelable = param2;
            return;
        }// end function

        protected function startSpin(readAlert:int, readAlert:int, readAlert:Array) : void
        {
            var _loc_4:* = this.m_base.getState();
            this.m_base.getHistory().createNewEntry();
            this.m_base.getRoundInfo().totalwin = 0;
            this.m_base.getRoundInfo().jpwin = 0;
            this.m_base.getModI().updateStatusBar("novel_infobar_luck");
            this.m_base.setInProgress(true);
            this.m_base.getMainButtons().enableAll(false, _loc_4);
            this.m_base.getServer().spin(readAlert, readAlert, readAlert, _loc_4);
            this.m_base.typeStartSpin();
            return;
        }// end function

        override public function hasFrameChange() : Boolean
        {
            return false;
        }// end function

        public function clear() : void
        {
            this.m_base = null;
            return;
        }// end function

        public function execute(getModI:String) : int
        {
            Console.write("Spin command executed", "[" + GameParameters.shortname + "] ");
            var _loc_2:* = this.m_base.getRoundInfo();
            var _loc_3:* = _loc_2.getTotalBet();
            var _loc_4:* = _loc_2.moneyIn;
            if (_loc_4 == 0 && !this.m_base.getModI().reserveCredit(_loc_3) || _loc_3 == 0)
            {
                this.m_base.updateTField(MainTxtFields.WIN_TF, Money.format(0));
                this.m_base.getModI().openDialog(SharedDialog.ALERT, this.m_base.getModI().readAlert(17));
                this.m_base.getModI().updateStatusBar("novel_infobar_balance");
                return 0;
            }
            _loc_2.moneyIn = 0;
            this.m_base.getModI().commitCredit();
            this.startSpin(_loc_3, _loc_2.getLineBet(false), _loc_2.getActiveBets());
            return 0;
        }// end function

        override public function isCancelable() : Boolean
        {
            return this.m_cancelable;
        }// end function

    }
}
