package com.playtech.casino3.slots.shared.novel.promo
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.utils.queue.*;
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class PromoViewer extends Object
    {
        private var m_usedMsgs:Vector.<Sprite>;
        private var m_event:Event;
        private var m_firstMessage:Boolean = true;
        private var m_currentPromoEvent:String;
        private var m_showingDelay:Timer;
        private var m_waitingPromoEvent:String;
        private var m_current:PromoInfo;
        private var m_tween:Tween;
        private var m_gfx:DisplayObjectContainer;
        private var m_promosInQueue:Number = 0;
        private var m_tweenEndEvent:String;
        private var m_queue:CommandQueue;
        private static const TWEEN_DURATION:Number = 0.25;
        private static const SHOWING_TIME:Number = 3;

        public function PromoViewer(param1:DisplayObjectContainer)
        {
            this.m_gfx = param1;
            this.m_usedMsgs = new Vector.<Sprite>;
            this.m_event = new Event(PromoEnum.PROMO_VISIBLE);
            this.m_queue = new CommandQueue(this.m_gfx.stage);
            return;
        }// end function

        private function keepShowing(com.playtech.casino3.slots.shared.novel.promo:PromoViewer/private:getRidOfWaiting:String) : int
        {
            this.m_showingDelay = new Timer(SHOWING_TIME, 1);
            this.m_showingDelay.addEventListener(TimerEvent.TIMER_COMPLETE, this.showingDone);
            this.m_showingDelay.start();
            this.m_currentPromoEvent = com.playtech.casino3.slots.shared.novel.promo:PromoViewer/private:getRidOfWaiting;
            return 1;
        }// end function

        public function getArea() : DisplayObjectContainer
        {
            return this.m_gfx;
        }// end function

        private function cleanUp() : void
        {
            this.m_queue.empty();
            this.m_promosInQueue = 0;
            while (this.m_gfx.numChildren > 0)
            {
                
                this.m_gfx.removeChildAt(0);
            }
            if (this.m_showingDelay != null)
            {
                this.m_showingDelay.removeEventListener(TimerEvent.TIMER_COMPLETE, this.showingDone);
                this.m_showingDelay = null;
            }
            this.m_waitingPromoEvent = null;
            this.m_currentPromoEvent = null;
            if (this.m_tween != null)
            {
                this.m_tween.removeEventListener(TweenEvent.MOTION_FINISH, this.tweenDownDone);
                this.m_tween.removeEventListener(TweenEvent.MOTION_FINISH, this.tweenUpDone);
                this.m_tween = null;
            }
            this.m_current = null;
            return;
        }// end function

        private function getMsgGfx(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\promo;PromoViewer.as:String) : Sprite
        {
            var _loc_3:Class = null;
            var _loc_4:Sprite = null;
            var _loc_2:* = this.m_usedMsgs.indexOf(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\promo;PromoViewer.as);
            if (_loc_2 == -1)
            {
                _loc_3 = getDefinitionByName(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\promo;PromoViewer.as) as Class;
                _loc_4 = new _loc_3;
                _loc_4.name = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\promo;PromoViewer.as;
                _loc_4.cacheAsBitmap = true;
                this.m_usedMsgs.push(_loc_4);
                return _loc_4;
            }
            return this.m_usedMsgs[_loc_2];
        }// end function

        private function showMessage(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\promo;PromoViewer.as:PromoInfo) : Sprite
        {
            var _loc_2:* = this.getMsgGfx(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\promo;PromoViewer.as.name);
            this.m_gfx.addChild(_loc_2);
            this.m_gfx.dispatchEvent(this.m_event);
            this.m_current = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\promo;PromoViewer.as;
            return _loc_2;
        }// end function

        private function tweenDownDone(... args) : void
        {
            this.m_tween.removeEventListener(TweenEvent.MOTION_FINISH, this.tweenDownDone);
            QueueEventManager.dispatchEvent(this.m_tweenEndEvent);
            this.m_tween = null;
            return;
        }// end function

        private function tweenUp(com.playtech.casino3.slots.shared.novel.promo:PromoViewer/private:getRidOfWaiting:PromoInfo, com.playtech.casino3.slots.shared.novel.promo:PromoViewer/private:getRidOfWaiting:String) : int
        {
            var _loc_3:* = this.m_gfx.getChildAt(0);
            this.m_tween = new Tween(_loc_3, "y", Regular.easeOut, _loc_3.y, _loc_3.y - this.m_gfx.localToGlobal(new Point(_loc_3.x, _loc_3.y)).y - _loc_3.height, TWEEN_DURATION, true);
            this.m_tween.addEventListener(TweenEvent.MOTION_FINISH, this.tweenUpDone);
            this.m_tweenEndEvent = com.playtech.casino3.slots.shared.novel.promo:PromoViewer/private:getRidOfWaiting;
            return 1;
        }// end function

        private function showingDone(... args) : void
        {
            this.m_showingDelay.removeEventListener(TimerEvent.TIMER_COMPLETE, this.showingDone);
            this.m_showingDelay = null;
            if (this.m_promosInQueue == 1)
            {
                this.m_waitingPromoEvent = this.m_currentPromoEvent;
            }
            else
            {
                QueueEventManager.dispatchEvent(this.m_currentPromoEvent);
            }
            return;
        }// end function

        private function getRidOfWaiting() : void
        {
            if (this.m_waitingPromoEvent != null)
            {
                QueueEventManager.dispatchEvent(this.m_waitingPromoEvent);
                this.m_waitingPromoEvent = null;
            }
            return;
        }// end function

        private function removeMessage() : void
        {
            this.m_gfx.removeChildAt(0);
            var _loc_1:String = this;
            var _loc_2:* = this.m_promosInQueue - 1;
            _loc_1.m_promosInQueue = _loc_2;
            return;
        }// end function

        private function tweenUpDone(... args) : void
        {
            this.m_tween.removeEventListener(TweenEvent.MOTION_FINISH, this.tweenUpDone);
            this.removeMessage();
            QueueEventManager.dispatchEvent(this.m_tweenEndEvent);
            this.m_tween = null;
            return;
        }// end function

        public function showNewMessage(DisplayObjectContainer:PromoInfo) : void
        {
            if (this.m_firstMessage)
            {
                while (this.m_gfx.numChildren > 0)
                {
                    
                    this.m_gfx.removeChildAt(0);
                }
            }
            if (DisplayObjectContainer != null && this.m_current != null && this.m_current.name == DisplayObjectContainer.name)
            {
                this.m_gfx.dispatchEvent(this.m_event);
                return;
            }
            this.getRidOfWaiting();
            if (DisplayObjectContainer == null)
            {
                this.cleanUp();
                return;
            }
            var _loc_2:String = this;
            var _loc_3:* = this.m_promosInQueue + 1;
            _loc_2.m_promosInQueue = _loc_3;
            this.m_queue.add(this.getIntroCommand(DisplayObjectContainer));
            this.m_queue.add(this.getShowingCommand(DisplayObjectContainer));
            this.m_queue.add(this.getOutroCommand(DisplayObjectContainer));
            return;
        }// end function

        private function tweenDown(com.playtech.casino3.slots.shared.novel.promo:PromoViewer/private:getRidOfWaiting:PromoInfo, com.playtech.casino3.slots.shared.novel.promo:PromoViewer/private:getRidOfWaiting:String) : int
        {
            var _loc_3:* = this.showMessage(com.playtech.casino3.slots.shared.novel.promo:PromoViewer/private:getRidOfWaiting);
            _loc_3.y = _loc_3.y - this.m_gfx.localToGlobal(new Point(_loc_3.x, _loc_3.y)).y - _loc_3.height;
            this.m_tween = new Tween(_loc_3, "y", Regular.easeIn, _loc_3.y, 0, TWEEN_DURATION, true);
            this.m_tween.addEventListener(TweenEvent.MOTION_FINISH, this.tweenDownDone);
            this.m_tweenEndEvent = com.playtech.casino3.slots.shared.novel.promo:PromoViewer/private:getRidOfWaiting;
            return 1;
        }// end function

        private function getIntroCommand(showingDone:PromoInfo) : ICommand
        {
            if (this.m_firstMessage)
            {
                this.m_firstMessage = false;
                return new CommandFunction(this.showMessage, showingDone);
            }
            switch(showingDone.inAnimationType)
            {
                case PromoEnum.SLIDE_DOWN:
                {
                    return new CommandObject(this.tweenDown, showingDone);
                }
                default:
                {
                    return new CommandFunction(this.showMessage, showingDone);
                    break;
                }
            }
        }// end function

        public function dispose() : void
        {
            while (this.m_gfx.numChildren > 0)
            {
                
                this.m_gfx.removeChildAt(0);
            }
            if (this.m_showingDelay != null)
            {
                this.m_showingDelay.removeEventListener(TimerEvent.TIMER_COMPLETE, this.showingDone);
                this.m_showingDelay = null;
            }
            this.m_waitingPromoEvent = null;
            this.m_currentPromoEvent = null;
            if (this.m_tween != null)
            {
                this.m_tween.removeEventListener(TweenEvent.MOTION_FINISH, this.tweenDownDone);
                this.m_tween.removeEventListener(TweenEvent.MOTION_FINISH, this.tweenUpDone);
                this.m_tween = null;
            }
            this.m_queue.dispose();
            this.m_queue = null;
            this.m_current = null;
            this.m_gfx = null;
            this.m_usedMsgs = null;
            this.m_event = null;
            return;
        }// end function

        private function getShowingCommand(showingDone:PromoInfo) : ICommand
        {
            return new CommandObject(this.keepShowing);
        }// end function

        private function getOutroCommand(showingDone:PromoInfo) : ICommand
        {
            switch(showingDone.outAnimationType)
            {
                case PromoEnum.SLIDE_UP:
                {
                    return new CommandObject(this.tweenUp, showingDone);
                }
                default:
                {
                    return new CommandFunction(this.removeMessage);
                    break;
                }
            }
        }// end function

    }
}
