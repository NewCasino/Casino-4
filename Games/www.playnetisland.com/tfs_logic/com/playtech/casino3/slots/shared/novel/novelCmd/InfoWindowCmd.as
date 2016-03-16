package com.playtech.casino3.slots.shared.novel.novelCmd
{
    import com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows.*;
    import com.playtech.casino3.utils.queue.*;

    public class InfoWindowCmd extends CommandBase implements ICommand
    {
        private var m_window:IMessageWindow;
        private var m_qId:String;
        private var m_cancelled:Boolean;

        public function InfoWindowCmd(param1:IMessageWindow)
        {
            this.m_window = param1;
            return;
        }// end function

        override public function cancel() : void
        {
            this.m_cancelled = true;
            this.m_window.cancel();
            return;
        }// end function

        public function clear() : void
        {
            this.m_window.dispose();
            this.m_window = null;
            return;
        }// end function

        private function windowDone() : void
        {
            if (!this.m_cancelled)
            {
                QueueEventManager.dispatchEvent(this.m_qId);
            }
            return;
        }// end function

        public function execute(com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows:String) : int
        {
            this.m_qId = com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows;
            this.m_window.setCallBack(this.windowDone);
            this.m_window.showWindow();
            return 1;
        }// end function

    }
}
