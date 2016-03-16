package com.playtech.casino3.slots.shared.novel.novelCmd
{
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;

    public class ApStopCmd extends CommandBase implements ICommand
    {
        private var m_base:TypeNovel;

        public function ApStopCmd(param1:TypeNovel)
        {
            this.m_base = param1;
            return;
        }// end function

        public function clear() : void
        {
            this.m_base = null;
            return;
        }// end function

        public function execute(showWins:String) : int
        {
            var _loc_2:Boolean = false;
            Console.write("Autoplay stop command executed");
            this.m_base.getModI().playAsEffect(GameParameters.library + ".ApStop");
            this.m_base.getAP().deactivate(10);
            (this.m_base.getMainButtons() as ButtonsNovel).setAP(this.m_base.getAP().getApLeft());
            if (!this.m_base.isInProgress())
            {
                this.m_base.newGameRound();
                this.m_base.getQueue().addParallel(new CommandObject(this.m_base.getWinAnimator().showWins, [this.m_base.getWinAnims(), WinsNovel.PHASE_2], this.m_base.getWinAnimator().stopAnim));
            }
            else
            {
                _loc_2 = this.m_base.getMainButtons().isEnabled(GameButtons.STOP_BUTTON);
                this.m_base.getMainButtons().enableAll(false, GameStates.STATE_NORMAL);
                if (_loc_2)
                {
                    this.m_base.getMainButtons().enable(GameButtons.STOP_BUTTON, true);
                }
            }
            return 0;
        }// end function

    }
}
