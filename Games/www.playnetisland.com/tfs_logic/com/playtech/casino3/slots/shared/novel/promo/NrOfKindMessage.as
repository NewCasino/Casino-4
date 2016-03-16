package com.playtech.casino3.slots.shared.novel.promo
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class NrOfKindMessage extends Object
    {
        private var m_qID:String;
        private var m_timer:Timer;
        private var m_promoarea:PromoArea;
        private var m_inAnimation:int;
        private var m_snd:int;
        private const WAIT_TIME:int = 2000;
        private var m_mc:DisplayObjectContainer;
        private var m_canceled:Boolean;
        private var m_mi:IModuleInterface;

        public function NrOfKindMessage(param1:PromoArea, param2:IModuleInterface)
        {
            this.m_promoarea = param1;
            this.m_mi = param2;
            this.m_mc = this.m_promoarea.getArea();
            this.m_inAnimation = PromoEnum.DEFAULT;
            return;
        }// end function

        public function stopSnd(event:Event = null) : void
        {
            this.m_mi.stopSoundByID(this.m_snd);
            EventPool.removeEventListener(ReelSpinInfo.SPIN_START, this.stopSnd);
            QueueEventManager.dispatchEvent(this.m_qID);
            return;
        }// end function

        public function showMessage(m_timer:String, m_timer:Number, m_timer:String) : int
        {
            this.m_canceled = false;
            this.m_qID = m_timer;
            this.m_promoarea.winMessage(m_timer, PromoEnum.DEFAULT, this.m_inAnimation);
            this.m_snd = this.m_mi.playAsEffect(GameParameters.library + ".fiveOfKind", null, 0, this.sndEnd);
            if (this.m_snd == -1)
            {
                if (this.m_timer == null)
                {
                    this.m_timer = new Timer(this.WAIT_TIME, 1);
                    this.m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.timerEnd);
                }
                this.m_timer.start();
            }
            this.m_mi.updateStatusBar("novel_infobar_totalwin", {TW:Money.format(m_timer)});
            EventPool.addEventListener(ReelSpinInfo.SPIN_START, this.stopSnd);
            return 1;
        }// end function

        private function timerEnd(event:TimerEvent) : void
        {
            EventPool.removeEventListener(ReelSpinInfo.SPIN_START, this.stopSnd);
            if (this.m_canceled)
            {
                return;
            }
            QueueEventManager.dispatchEvent(this.m_qID);
            return;
        }// end function

        public function setInAnimation(timerEnd:int) : void
        {
            this.m_inAnimation = timerEnd;
            return;
        }// end function

        public function dispose() : void
        {
            if (this.m_timer)
            {
                if (this.m_timer.running)
                {
                    this.m_timer.stop();
                }
                this.m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.timerEnd);
            }
            this.m_timer = null;
            EventPool.removeEventListener(ReelSpinInfo.SPIN_START, this.stopSnd);
            this.m_promoarea = null;
            this.m_mi = null;
            this.m_mc = null;
            return;
        }// end function

        private function sndEnd(timerEnd:String, timerEnd:String) : void
        {
            EventPool.removeEventListener(ReelSpinInfo.SPIN_START, this.stopSnd);
            if (this.m_canceled)
            {
                return;
            }
            QueueEventManager.dispatchEvent(this.m_qID);
            return;
        }// end function

        public function cancel() : void
        {
            this.m_canceled = true;
            return;
        }// end function

    }
}
