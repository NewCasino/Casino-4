package com.playtech.casino3.slots.shared.novel.novelComponents
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;

    public class SlotWinTicker extends WinTicker
    {
        private var m_snd_id:int = -1;
        private var m_isTicking:Boolean;
        protected var m_newValue:String;
        protected var m_holdOld:Boolean;
        private var m_snd:String;
        private var m_muted:Boolean;
        private var m_qId:String;
        protected var m_time:int;
        private var m_getState:Function;
        protected var m_mi:IModuleInterface;
        private var m_timer:Timer;
        private static const DELAY:int = 300;

        public function SlotWinTicker(param1:TextField, param2:IModuleInterface, param3:Function)
        {
            super(param1);
            this.m_mi = param2;
            this.m_timer = new Timer(DELAY, 1);
            this.m_timer.addEventListener(TimerEvent.TIMER, this.timerEnd);
            this.m_getState = param3;
            return;
        }// end function

        override public function cancel() : void
        {
            m_TF.stage.removeEventListener(MouseEvent.CLICK, this.stopTicking);
            super.cancel();
            return;
        }// end function

        public function execAnim(com.playtech.casino3:Number, com.playtech.casino3:Number, com.playtech.casino3:int, com.playtech.casino3:int) : void
        {
            if (com.playtech.casino3 - com.playtech.casino3 == 0)
            {
                return;
            }
            this.m_isTicking = true;
            setVariables(com.playtech.casino3, com.playtech.casino3, com.playtech.casino3, com.playtech.casino3);
            startAnim();
            m_TF.stage.addEventListener(MouseEvent.CLICK, this.stopTicking);
            return;
        }// end function

        public function getWaitingTime() : int
        {
            if (this.m_time == 0)
            {
                return this.m_time;
            }
            var _loc_1:* = getTimer() - this.m_time;
            return _loc_1 < DELAY ? (DELAY - _loc_1) : (0);
        }// end function

        public function waitEnd(setText:String) : int
        {
            if (this.m_isTicking)
            {
                this.m_qId = setText;
                return 1;
            }
            return 0;
        }// end function

        override protected function animDone() : void
        {
            m_TF.stage.removeEventListener(MouseEvent.CLICK, this.stopTicking);
            if (this.m_snd_id != -1)
            {
                this.m_mi.stopSoundByID(this.m_snd_id);
                switch(this.m_snd)
                {
                    case NovelSoundMap.FREESPIN_WIN_INCREASE:
                    {
                        this.m_snd = NovelSoundMap.FREESPIN_WIN_INCREASE_END;
                        break;
                    }
                    case NovelSoundMap.NORMAL_WIN_INCREASE:
                    {
                        this.m_snd = NovelSoundMap.NORMAL_WIN_INCREASE_END;
                        break;
                    }
                    case NovelSoundMap.CELEBRATION_WIN_INCREASE:
                    {
                        this.m_snd = NovelSoundMap.CELEBRATION_WIN_INCREASE_END;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this.m_mi.playAsEffect(this.m_snd);
            }
            if (this.m_qId != null)
            {
                QueueEventManager.dispatchEvent(this.m_qId);
            }
            this.m_qId = null;
            this.m_snd_id = -1;
            this.m_isTicking = false;
            return;
        }// end function

        public function continueAnim(com.playtech.casino3:Number, com.playtech.casino3:int, com.playtech.casino3:int) : void
        {
            if (m_current - com.playtech.casino3 == 0)
            {
                startAnim();
                return;
            }
            if (isNaN(m_current))
            {
                m_current = 0;
            }
            this.m_isTicking = true;
            trace("continueAnim " + m_current + " " + com.playtech.casino3);
            setVariables(m_current, com.playtech.casino3, com.playtech.casino3, com.playtech.casino3);
            startAnim();
            m_TF.stage.addEventListener(MouseEvent.CLICK, this.stopTicking);
            return;
        }// end function

        public function stopTicking(event:MouseEvent = null) : void
        {
            if (this.m_isTicking)
            {
                if (event != null && Celebration.isActive())
                {
                    return;
                }
                this.cancel();
                this.animDone();
                this.m_holdOld = true;
                this.m_timer.start();
                this.m_time = getTimer();
            }
            return;
        }// end function

        protected function timerEnd(event:TimerEvent = null) : void
        {
            this.m_holdOld = false;
            this.m_time = 0;
            if (this.m_newValue != null)
            {
                TextResize.setText(m_TF, this.m_newValue);
                this.m_newValue = null;
            }
            return;
        }// end function

        public function playTickSound(com.playtech.casino3:String = null) : void
        {
            if (!this.m_isTicking || Celebration.isActive() || this.m_snd_id != -1)
            {
                return;
            }
            if (com.playtech.casino3 != null)
            {
                this.m_snd = com.playtech.casino3;
            }
            else if (this.m_getState() == GameStates.STATE_FREESPIN)
            {
                this.m_snd = NovelSoundMap.FREESPIN_WIN_INCREASE;
            }
            else if (Celebration.isVisible())
            {
                this.m_snd = NovelSoundMap.CELEBRATION_WIN_INCREASE;
            }
            else
            {
                this.m_snd = NovelSoundMap.NORMAL_WIN_INCREASE;
            }
            this.m_snd_id = this.m_mi.playAsEffect(this.m_snd, null, 16777215);
            if (this.m_muted)
            {
                this.m_mi.muteSoundByID(this.m_snd_id);
            }
            return;
        }// end function

        public function mute(com.playtech.casino3:Boolean) : void
        {
            this.m_muted = com.playtech.casino3;
            this.m_mi.muteSoundByID(this.m_snd_id, com.playtech.casino3);
            return;
        }// end function

        public function isTicking() : Boolean
        {
            return this.m_isTicking;
        }// end function

        public function setValue(com.playtech.casino3:String, com.playtech.casino3:Boolean = false) : void
        {
            if (this.m_holdOld)
            {
                this.m_newValue = com.playtech.casino3;
            }
            else
            {
                TextResize.setText(m_TF, com.playtech.casino3);
                if (com.playtech.casino3)
                {
                    this.m_holdOld = true;
                    this.m_timer.start();
                    this.m_time = getTimer();
                }
            }
            return;
        }// end function

        public function dispose() : void
        {
            if (this.m_timer)
            {
                this.m_timer.stop();
                this.m_timer.removeEventListener(TimerEvent.TIMER, this.timerEnd);
            }
            if (m_TF && m_TF.stage)
            {
                m_TF.stage.removeEventListener(MouseEvent.CLICK, this.stopTicking);
            }
            this.m_timer = null;
            super.clear();
            this.m_mi = null;
            this.m_getState = null;
            return;
        }// end function

    }
}
