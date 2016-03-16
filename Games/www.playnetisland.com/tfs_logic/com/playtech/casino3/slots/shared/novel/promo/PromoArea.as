package com.playtech.casino3.slots.shared.novel.promo
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class PromoArea extends Object
    {
        private var m_continue:int;
        private var m_timeStart:int;
        private var m_promos:Vector.<PromoInfo>;
        private var m_freezeTimer:Timer;
        private var m_eventTimer:Timer;
        private var m_currentId:int;
        private var m_viewer:PromoViewer;
        private var m_freezeTime:int;
        private var m_showingWinEvent:Boolean;
        private var m_frozen:Boolean;
        private var m_timer:Timer;

        public function PromoArea(param1:Sprite)
        {
            this.m_viewer = new PromoViewer(param1);
            this.m_promos = new Vector.<PromoInfo>;
            this.m_currentId = -1;
            param1.addEventListener(PromoEnum.PROMO_VISIBLE, this.promoVisible);
            return;
        }// end function

        public function getArea() : DisplayObjectContainer
        {
            return this.m_viewer.getArea();
        }// end function

        public function winMessage(com.playtech.casino3.slots.shared.novel.novelEnums:String, com.playtech.casino3.slots.shared.novel.novelEnums:int = -1, com.playtech.casino3.slots.shared.novel.novelEnums:int = -1) : void
        {
            if (!this.m_frozen)
            {
                this.freeze(1);
            }
            this.m_viewer.showNewMessage(null);
            this.eventMessage(com.playtech.casino3.slots.shared.novel.novelEnums, 100000, com.playtech.casino3.slots.shared.novel.novelEnums, com.playtech.casino3.slots.shared.novel.novelEnums);
            this.m_showingWinEvent = true;
            return;
        }// end function

        public function eventMessage(com.playtech.casino3.slots.shared.novel.novelEnums:String, com.playtech.casino3.slots.shared.novel.novelEnums:int, com.playtech.casino3.slots.shared.novel.novelEnums:int = -1, com.playtech.casino3.slots.shared.novel.novelEnums:int = -1) : void
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            if (com.playtech.casino3.slots.shared.novel.novelEnums == -1)
            {
                com.playtech.casino3.slots.shared.novel.novelEnums = PromoEnum.NO_ANIM;
            }
            if (com.playtech.casino3.slots.shared.novel.novelEnums == -1)
            {
                com.playtech.casino3.slots.shared.novel.novelEnums = PromoEnum.SLIDE_DOWN;
            }
            if (this.m_eventTimer == null)
            {
                if (this.m_timer != null)
                {
                    _loc_6 = this.m_promos[this.m_currentId].time;
                    if (this.m_frozen)
                    {
                        _loc_5 = this.m_timer.delay;
                    }
                    else
                    {
                        _loc_7 = getTimer() - this.m_timeStart;
                        _loc_5 = _loc_6 - _loc_7;
                    }
                    if (_loc_5 > _loc_6 / 2)
                    {
                        this.m_continue = _loc_5;
                    }
                    this.m_timer.stop();
                }
                this.m_eventTimer = new Timer(com.playtech.casino3.slots.shared.novel.novelEnums, 1);
                this.m_eventTimer.addEventListener(TimerEvent.TIMER, this.eventMsgEnd);
            }
            else
            {
                this.m_eventTimer.delay = com.playtech.casino3.slots.shared.novel.novelEnums;
                this.m_eventTimer.stop();
            }
            this.m_viewer.showNewMessage(new PromoInfo(com.playtech.casino3.slots.shared.novel.novelEnums, com.playtech.casino3.slots.shared.novel.novelEnums, com.playtech.casino3.slots.shared.novel.novelEnums, com.playtech.casino3.slots.shared.novel.novelEnums));
            return;
        }// end function

        public function reset() : void
        {
            this.m_currentId = 0;
            if (this.m_eventTimer != null)
            {
                this.eventMsgEnd();
            }
            else if (this.m_promos.length > 0)
            {
                this.m_viewer.showNewMessage(this.m_promos[this.m_currentId]);
            }
            return;
        }// end function

        private function disposeEventTimer() : void
        {
            if (this.m_eventTimer != null)
            {
                this.m_eventTimer.removeEventListener(TimerEvent.TIMER, this.eventMsgEnd);
                this.m_eventTimer.stop();
                this.m_eventTimer = null;
            }
            return;
        }// end function

        public function empty() : void
        {
            this.disposeMainTimer();
            this.m_promos = new Vector.<PromoInfo>;
            this.m_currentId = -1;
            this.m_continue = 0;
            return;
        }// end function

        public function freeze(com.playtech.casino3.slots.shared.novel.novelEnums:int = -1) : void
        {
            var _loc_2:Timer = null;
            var _loc_3:int = 0;
            this.m_frozen = true;
            if (this.m_timer != null || this.m_eventTimer != null)
            {
                _loc_2 = this.m_eventTimer != null ? (this.m_eventTimer) : (this.m_timer);
                if (_loc_2.running)
                {
                    _loc_3 = _loc_2.delay - (getTimer() - this.m_timeStart);
                    if (_loc_3 < 1)
                    {
                        _loc_3 = 1;
                    }
                    _loc_2.delay = _loc_3;
                    _loc_2.stop();
                }
                if (com.playtech.casino3.slots.shared.novel.novelEnums > 0)
                {
                    this.m_freezeTime = com.playtech.casino3.slots.shared.novel.novelEnums;
                    this.updateFreezeTimer(com.playtech.casino3.slots.shared.novel.novelEnums);
                }
                else
                {
                    EventPool.addEventListener(ReelSpinInfo.SPIN_START, this.spinStarted);
                }
            }
            else
            {
                EventPool.addEventListener(ReelSpinInfo.SPIN_START, this.spinStarted);
            }
            return;
        }// end function

        private function nextMessage(event:TimerEvent = null) : void
        {
            this.m_timer.stop();
            var _loc_2:String = this;
            var _loc_3:* = this.m_currentId + 1;
            _loc_2.m_currentId = _loc_3;
            if (this.m_currentId == this.m_promos.length)
            {
                this.m_currentId = 0;
            }
            this.m_viewer.showNewMessage(this.m_promos[this.m_currentId]);
            return;
        }// end function

        private function disposeFreezeTimer() : void
        {
            if (this.m_freezeTimer != null)
            {
                this.m_freezeTimer.stop();
                this.m_freezeTimer = null;
            }
            return;
        }// end function

        private function spinStarted(event:Event = null) : void
        {
            var leftTime:int;
            var tmpTimer:Timer;
            var e:* = event;
            EventPool.removeEventListener(ReelSpinInfo.SPIN_START, this.spinStarted);
            this.m_frozen = false;
            if (this.m_freezeTimer == null)
            {
                if (this.m_eventTimer != null)
                {
                    this.m_eventTimer.start();
                }
                else if (this.m_timer != null)
                {
                    this.m_timer.start();
                }
            }
            else if (this.m_freezeTimer.running && !this.m_showingWinEvent)
            {
                leftTime = this.m_freezeTimer.delay - (getTimer() - this.m_timeStart);
                this.disposeFreezeTimer();
                tmpTimer = this.m_eventTimer != null ? (this.m_eventTimer) : (this.m_timer);
                if (tmpTimer != null)
                {
                    try
                    {
                        tmpTimer.delay = leftTime;
                    }
                    catch (error:Error)
                    {
                        trace("Promo Area time delay caused error :" + leftTime);
                        tmpTimer.delay = 1;
                    }
                    this.m_timeStart = getTimer();
                    tmpTimer.start();
                }
            }
            else
            {
                this.disposeFreezeTimer();
                if (this.m_eventTimer != null)
                {
                    this.m_showingWinEvent = false;
                    this.eventMsgEnd();
                }
                else
                {
                    this.nextMessage();
                }
            }
            return;
        }// end function

        private function promoVisible(event:Event) : void
        {
            var _loc_2:Timer = null;
            if (this.m_eventTimer != null)
            {
                _loc_2 = this.m_eventTimer;
            }
            else
            {
                if (this.m_continue != 0)
                {
                    this.m_timer.delay = this.m_continue;
                    this.m_continue = 0;
                }
                else
                {
                    this.m_timer.delay = this.m_promos[this.m_currentId].time;
                }
                _loc_2 = this.m_timer;
            }
            if (this.m_frozen)
            {
                this.updateFreezeTimer(this.m_freezeTime);
            }
            else
            {
                this.m_timeStart = getTimer();
                _loc_2.start();
            }
            return;
        }// end function

        public function addMessage(com.playtech.casino3.slots.shared.novel.novelEnums:String, com.playtech.casino3.slots.shared.novel.novelEnums:int, com.playtech.casino3.slots.shared.novel.novelEnums:int = -1, com.playtech.casino3.slots.shared.novel.novelEnums:int = -1) : void
        {
            if (com.playtech.casino3.slots.shared.novel.novelEnums == -1)
            {
                com.playtech.casino3.slots.shared.novel.novelEnums = PromoEnum.SLIDE_UP;
            }
            if (com.playtech.casino3.slots.shared.novel.novelEnums == -1)
            {
                com.playtech.casino3.slots.shared.novel.novelEnums = PromoEnum.SLIDE_DOWN;
            }
            var _loc_5:* = new PromoInfo(com.playtech.casino3.slots.shared.novel.novelEnums, com.playtech.casino3.slots.shared.novel.novelEnums, com.playtech.casino3.slots.shared.novel.novelEnums, com.playtech.casino3.slots.shared.novel.novelEnums);
            this.m_promos.push(_loc_5);
            if (this.m_timer == null)
            {
                this.createTimer();
                if (this.m_eventTimer == null)
                {
                    this.m_currentId = 0;
                    if (this.m_frozen)
                    {
                        this.disposeFreezeTimer();
                        this.m_frozen = false;
                    }
                    this.m_viewer.showNewMessage(_loc_5);
                }
            }
            return;
        }// end function

        public function dispose() : void
        {
            this.m_viewer.getArea().removeEventListener(PromoEnum.PROMO_VISIBLE, this.promoVisible);
            this.m_viewer.dispose();
            this.m_viewer = null;
            EventPool.removeEventListener(ReelSpinInfo.SPIN_START, this.spinStarted);
            this.disposeMainTimer();
            this.disposeEventTimer();
            this.disposeFreezeTimer();
            return;
        }// end function

        private function createTimer() : void
        {
            this.m_timer = new Timer(10000);
            this.m_timer.addEventListener(TimerEvent.TIMER, this.nextMessage);
            return;
        }// end function

        private function updateFreezeTimer(com.playtech.casino3.slots.shared.novel.novelEnums:int) : void
        {
            this.m_timeStart = getTimer();
            if (this.m_freezeTimer == null)
            {
                this.m_freezeTimer = new Timer(com.playtech.casino3.slots.shared.novel.novelEnums, 1);
                this.m_freezeTimer.start();
                EventPool.addEventListener(ReelSpinInfo.SPIN_START, this.spinStarted);
            }
            else
            {
                this.m_freezeTimer.delay = com.playtech.casino3.slots.shared.novel.novelEnums;
            }
            return;
        }// end function

        private function eventMsgEnd(event:TimerEvent = null) : void
        {
            this.disposeEventTimer();
            if (this.m_timer != null)
            {
                if (this.m_continue == 0)
                {
                    this.nextMessage();
                }
                else
                {
                    this.m_viewer.showNewMessage(this.m_promos[this.m_currentId]);
                }
            }
            else
            {
                this.m_viewer.showNewMessage(null);
            }
            return;
        }// end function

        private function disposeMainTimer() : void
        {
            if (this.m_timer != null)
            {
                this.m_timer.removeEventListener(TimerEvent.TIMER, this.nextMessage);
                this.m_timer.stop();
                this.m_timer = null;
            }
            return;
        }// end function

    }
}
