package com.playtech.casino3.slots.shared.novel.novelCmd
{
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.utils.queue.*;

    public class ApStartCmd extends CommandBase implements ICommand
    {
        private var m_base:TypeNovel;

        public function ApStartCmd(param1:TypeNovel)
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

        public function execute(com.playtech.casino3.slots.shared.data:String) : int
        {
            this.m_base.getModI().playAsEffect(GameParameters.library + ".ApStart");
            if (!this.m_base.getAP().activate())
            {
                return 0;
            }
            this.m_base.getModI().updateStatusBar("novel_infobar_autostart", null, 2000);
            var _loc_2:* = new ApContinueCmd(this.m_base);
            _loc_2.execute(null);
            _loc_2.clear();
            return 0;
        }// end function

    }
}
