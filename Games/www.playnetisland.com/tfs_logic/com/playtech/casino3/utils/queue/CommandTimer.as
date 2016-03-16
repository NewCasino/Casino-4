package com.playtech.casino3.utils.queue
{
    import flash.events.*;
    import flash.utils.*;

    public class CommandTimer extends CommandBase implements ICommand
    {
        private var m_cancelable:Boolean;
        private var m_gueueId:String;
        private var m_timer:Timer;

        public function CommandTimer(param1:int, param2:Boolean = true)
        {
            this.m_cancelable = param2;
            this.m_timer = new Timer(param1, 1);
            return;
        }// end function

        override public function cancel() : void
        {
            this.m_timer.stop();
            this.m_timer.removeEventListener(TimerEvent.TIMER, this.timerEnd);
            return;
        }// end function

        private function timerEnd(event:TimerEvent) : void
        {
            if (this.m_timer)
            {
                this.m_timer.removeEventListener(TimerEvent.TIMER, this.timerEnd);
            }
            QueueEventManager.dispatchEvent(this.m_gueueId);
            return;
        }// end function

        public function clear() : void
        {
            this.m_timer = null;
            return;
        }// end function

        public function execute(time:String) : int
        {
            this.m_gueueId = time;
            this.m_timer.addEventListener(TimerEvent.TIMER, this.timerEnd, false, 0, true);
            this.m_timer.start();
            return 1;
        }// end function

        override public function isCancelable() : Boolean
        {
            return this.m_cancelable;
        }// end function

    }
}
