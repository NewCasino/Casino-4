package com.playtech.casino3.slots.shared.novel.novelCmd
{
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.commands.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;

    public class ApContinueCmd extends CommandBase implements ICommand
    {
        private var m_base:TypeNovel;
        private var m_cancelable:Boolean;

        public function ApContinueCmd(param1:TypeNovel, param2:Boolean = false)
        {
            this.m_base = param1;
            this.m_cancelable = param2;
            return;
        }// end function

        public function clear() : void
        {
            this.m_base = null;
            return;
        }// end function

        public function execute(getMainButtons:String) : int
        {
            Console.write("Autoplay continue command executed");
            var _loc_2:* = this.m_base.getAP();
            if (!_loc_2.checkContinue() && this.m_base.getState() == GameStates.STATE_AUTOPLAY)
            {
                _loc_2.finish();
                this.m_base.newGameRound();
                ButtonsNovel(this.m_base.getMainButtons()).setAP(_loc_2.getApLeft());
                this.m_base.getQueue().add(new CommandObject(this.m_base.getWinAnimator().showWins, [this.m_base.getWinAnims(), WinsNovel.PHASE_2], this.m_base.getWinAnimator().stopAnim));
            }
            else
            {
                this.m_base.getQueue().add(new ApSpinCmd(this.m_base));
            }
            return 0;
        }// end function

        override public function isCancelable() : Boolean
        {
            return this.m_cancelable;
        }// end function

    }
}
