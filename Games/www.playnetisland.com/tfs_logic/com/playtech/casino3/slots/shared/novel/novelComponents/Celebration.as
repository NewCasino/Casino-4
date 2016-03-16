package com.playtech.casino3.slots.shared.novel.novelComponents
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class Celebration extends Object
    {
        private var m_plate:Sprite;
        private var m_soundId:int;
        private var m_finished:Boolean = false;
        private var winAmount:Number;
        private var m_tween:Tween;
        private var m_queueID:String;
        private var m_celebMovie:VideoMovieClip;
        private var m_threshold:int;
        private var m_baseContainer:Sprite;
        private var m_basewinTf:TextField;
        private var m_mi:IModuleInterface;
        private var m_container:Sprite;
        private var m_timer:Timer;
        private var m_hidden:Boolean;
        private var m_text:TextField;
        public static const CELEBRATION_ENDED:String = "CELEBRATION_ENDED";
        private static const STATE_PLATE:uint = 2;
        static const CELEBRATION_PLATE_NAME:String = "celebrationPlate";
        public static const CELEBRATION_STARTED:String = "CELEBRATION_STARTED";
        private static const STATE_COINS:uint = 1;
        static const CELEBRATION_ANIMATION_NAME:String = "celebration";
        private static var m_state:uint;

        public function Celebration(param1:Sprite, param2:IModuleInterface, param3:TextField)
        {
            this.m_threshold = NovelParameters.celebration;
            this.m_baseContainer = param1;
            this.m_mi = param2;
            this.m_basewinTf = param3;
            this.m_container = new Sprite();
            this.m_baseContainer.addChild(this.m_container);
            EventPool.addEventListener(GameStates.EVENT_RESET_All, this.reset);
            return;
        }// end function

        private function updateWinTF(event:RegularEvent) : void
        {
            TextResize.setText(this.m_text, this.m_basewinTf.text);
            return;
        }// end function

        public function isWinValid(celebrationPlate:Number, celebrationPlate:Number, celebrationPlate:int) : Boolean
        {
            this.winAmount = celebrationPlate;
            if (this.m_threshold == -1)
            {
                return false;
            }
            if (this.winAmount < this.m_threshold * celebrationPlate)
            {
                return false;
            }
            if (celebrationPlate == GameStates.STATE_FREESPIN)
            {
                return false;
            }
            return true;
        }// end function

        private function soundEnd(m_queueID:int, m_queueID:String) : void
        {
            this.endCoinAnim(null);
            return;
        }// end function

        private function startFade(event:TimerEvent) : void
        {
            this.clearTimer();
            this.m_tween = new Tween(this.m_celebMovie, "alpha", Strong.easeOut, 1, 0, 15);
            this.m_tween.addEventListener(TweenEvent.MOTION_FINISH, this.tweenEnd);
            this.m_tween.start();
            return;
        }// end function

        private function clearTimer() : void
        {
            this.m_timer.removeEventListener(TimerEvent.TIMER, this.startFade);
            this.m_timer.stop();
            this.m_timer = null;
            return;
        }// end function

        private function frameChange(event:Event) : void
        {
            this.m_container.removeEventListener(Event.ENTER_FRAME, this.frameChange);
            if ((m_state & STATE_COINS) > 0)
            {
                m_state = m_state ^ STATE_COINS;
            }
            if (event != null)
            {
                QueueEventManager.dispatchEvent(this.m_queueID);
            }
            return;
        }// end function

        public function hideCelebration(m_queueID:Boolean) : void
        {
            if (m_queueID)
            {
                this.m_baseContainer.removeChild(this.m_container);
            }
            else
            {
                this.m_baseContainer.addChild(this.m_container);
            }
            this.m_hidden = m_queueID;
            this.m_mi.muteSoundByID(this.m_soundId, m_queueID);
            return;
        }// end function

        public function playCelebration(addChild:String) : int
        {
            Console.write(".playCelebration()");
            var _loc_2:* = GameParameters.shortname + "." + CELEBRATION_ANIMATION_NAME;
            if (!ApplicationDomain.currentDomain.hasDefinition(_loc_2))
            {
                _loc_2 = GameParameters.library + "." + CELEBRATION_ANIMATION_NAME;
            }
            if (!ApplicationDomain.currentDomain.hasDefinition(_loc_2))
            {
                _loc_2 = "novel." + CELEBRATION_ANIMATION_NAME;
            }
            if (!ApplicationDomain.currentDomain.hasDefinition(_loc_2))
            {
                Console.write(".playCelebration() -> SKIPPING CELEBRATION!");
                return 0;
            }
            m_state = STATE_COINS | STATE_PLATE;
            this.m_finished = false;
            this.m_mi.updateStatusBar("novel_infobar_totalwin", {TW:Money.format(this.winAmount)});
            this.m_queueID = addChild;
            this.m_celebMovie = new VideoMovieClip(_loc_2);
            this.m_celebMovie.is_smoothed = true;
            this.m_celebMovie.is_synchronized = false;
            this.m_celebMovie.mouseEnabled = false;
            this.m_celebMovie.mouseChildren = false;
            this.m_container.addChild(this.m_celebMovie);
            this.m_timer = new Timer(2500);
            this.m_timer.addEventListener(TimerEvent.TIMER, this.startFade);
            this.m_timer.start();
            var _loc_3:* = GameParameters.shortname + "." + CELEBRATION_PLATE_NAME;
            if (!ApplicationDomain.currentDomain.hasDefinition(_loc_3))
            {
                _loc_3 = GameParameters.library + "." + CELEBRATION_PLATE_NAME;
            }
            var _loc_4:* = getDefinitionByName(_loc_3) as Class;
            this.m_plate = new _loc_4;
            this.m_text = TextField(this.m_plate.getChildByName("txt"));
            this.m_text.text = Money.format(0);
            this.m_container.addChild(this.m_plate);
            this.m_basewinTf.addEventListener(WinTicker.CHANGE, this.updateWinTF);
            this.m_soundId = this.m_mi.playAsEffect(GameParameters.library + ".celebration_snd", null, 0, this.soundEnd);
            if (this.m_hidden)
            {
                this.m_mi.muteSoundByID(this.m_soundId);
            }
            this.m_baseContainer.addEventListener(MouseEvent.CLICK, this.endCoinAnim);
            EventPool.dispatchEvent(new Event(CELEBRATION_STARTED));
            return 1;
        }// end function

        public function dispose() : void
        {
            this.stopCelebration();
            this.m_container = null;
            this.m_mi = null;
            this.m_basewinTf = null;
            this.m_baseContainer = null;
            m_state = 0;
            EventPool.removeEventListener(GameStates.EVENT_RESET_All, this.reset);
            return;
        }// end function

        private function reset(event:Event) : void
        {
            this.stopCelebration();
            return;
        }// end function

        public function stopCelebration() : void
        {
            if (!isVisible())
            {
                return;
            }
            this.frameChange(null);
            if (this.m_celebMovie != null)
            {
                this.endCoinAnim(null);
            }
            this.endPlateAnim();
            return;
        }// end function

        private function endPlateAnim() : void
        {
            this.m_basewinTf.removeEventListener(WinTicker.CHANGE, this.updateWinTF);
            this.m_container.removeChild(this.m_plate);
            this.m_plate = null;
            this.m_text = null;
            m_state = m_state ^ STATE_PLATE;
            return;
        }// end function

        private function removeCelebMovie() : void
        {
            this.m_container.removeChild(this.m_celebMovie);
            this.m_celebMovie = null;
            return;
        }// end function

        private function tweenEnd(event:TweenEvent) : void
        {
            this.m_tween.removeEventListener(TweenEvent.MOTION_FINISH, this.tweenEnd);
            this.m_tween.stop();
            this.m_tween = null;
            return;
        }// end function

        private function endCoinAnim(event:Event) : void
        {
            if (this.m_finished)
            {
                return;
            }
            this.m_finished = true;
            this.m_mi.stopSoundByID(this.m_soundId);
            this.m_baseContainer.removeEventListener(MouseEvent.CLICK, this.endCoinAnim);
            if (this.m_timer != null)
            {
                this.clearTimer();
            }
            else if (this.m_tween != null)
            {
                this.tweenEnd(null);
            }
            EventPool.dispatchEvent(new Event(CELEBRATION_ENDED));
            this.removeCelebMovie();
            if ((m_state & STATE_COINS) > 0)
            {
                this.m_container.addEventListener(Event.ENTER_FRAME, this.frameChange);
            }
            return;
        }// end function

        public static function isVisible() : Boolean
        {
            return (m_state & STATE_PLATE) > 0;
        }// end function

        public static function isActive() : Boolean
        {
            return (m_state & STATE_COINS) > 0;
        }// end function

    }
}
