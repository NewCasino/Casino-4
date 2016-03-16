package com.playtech.casino3.slots.shared
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.core.*;
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class PaytableBase extends EventDispatcher
    {
        protected const TYPE_TWEEN:int = 1;
        protected var m_enter:Boolean;
        protected var m_paytableWnd:Sprite;
        private var m_snd:int;
        protected var m_tween:Tween;
        protected const NAME_ANIMATIONS:String = "animations";
        protected var TWEEN_DELTA:int = 0;
        private var m_gfx:Sprite;
        protected var m_nextWnd:Sprite;
        protected var m_mi:IModuleInterface;
        protected var m_transitionType:int;
        protected const DIRECTION_FORWARD:int = 1;
        protected const DIRECTION_BACK:int = 0;
        protected const FPS:int = 12;
        protected var m_maxPages:int;
        protected var m_currentPage:int;
        protected var m_transitionDirection:int;
        protected var m_endingPoint:int;
        protected var m_currentWins:Array;
        protected var m_prevWnd:Sprite;
        protected var m_PageWnd:Sprite;
        protected var m_depth:int;
        protected const TYPE_REGULAR:int = 0;
        public static const CLOSE_PAYTABLE:String = "Paytable_close";

        public function PaytableBase(param1:Sprite, param2:IModuleInterface, param3:int)
        {
            this.m_gfx = param1;
            this.m_mi = param2;
            this.m_maxPages = param3;
            this.setTransitionType();
            this.m_enter = true;
            EventPool.addEventListener(GameStates.EVENT_RESET_All, this.resetAll);
            return;
        }// end function

        public function openPaytable(com.playtech.casino3.slots.shared.enum:Array) : void
        {
            this.m_currentWins = com.playtech.casino3.slots.shared.enum;
            var _loc_2:* = getDefinitionByName(GameParameters.shortname + ".paytableWnd") as Class;
            this.m_paytableWnd = new _loc_2;
            var _loc_3:* = this.m_paytableWnd.getChildByName("pos") as Sprite;
            if (_loc_3 != null)
            {
                this.m_depth = this.m_paytableWnd.getChildIndex(_loc_3);
            }
            this.openFrame(this.m_currentPage);
            this.m_gfx.addChild(this.m_paytableWnd);
            this.initButtons();
            this.m_snd = this.m_mi.playAsAmbient(GameParameters.shortname + ".paytable_ambient");
            return;
        }// end function

        protected function blinkWins(com.playtech.casino3.slots.shared.enum:Sprite, com.playtech.casino3.slots.shared.enum:Array) : void
        {
            var _loc_3:int = 0;
            var _loc_5:String = null;
            var _loc_6:int = 0;
            var _loc_7:MovieClip = null;
            var _loc_8:SlotsWin = null;
            var _loc_9:WinInfo = null;
            if (!com.playtech.casino3.slots.shared.enum)
            {
                return;
            }
            var _loc_4:* = com.playtech.casino3.slots.shared.enum.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_9 = com.playtech.casino3.slots.shared.enum[_loc_3] as WinInfo;
                _loc_8 = _loc_9.win;
                _loc_5 = "s" + _loc_8.symbol.type;
                _loc_6 = _loc_8.count;
                _loc_7 = this.getWinForSymbol(com.playtech.casino3.slots.shared.enum, _loc_5, _loc_6);
                if (_loc_7)
                {
                    _loc_7.gotoAndStop(2);
                }
                _loc_3++;
            }
            return;
        }// end function

        private function closeCurrentFrame() : void
        {
            if (this.m_PageWnd != null)
            {
                this.m_paytableWnd.removeChild(this.m_PageWnd);
                this.m_PageWnd = null;
            }
            return;
        }// end function

        public function dispose() : void
        {
            EventPool.addEventListener(GameStates.EVENT_RESET_All, this.resetAll);
            this.disposeTween();
            this.m_currentWins = null;
            this.m_paytableWnd = null;
            this.m_PageWnd = null;
            this.m_prevWnd = null;
            this.m_nextWnd = null;
            this.m_gfx = null;
            this.m_mi = null;
            return;
        }// end function

        protected function setTransitionType() : void
        {
            this.m_transitionType = this.TYPE_REGULAR;
            return;
        }// end function

        protected function disposeTween() : void
        {
            if (this.m_tween)
            {
                this.m_tween.stop();
                this.m_tween = null;
            }
            return;
        }// end function

        protected function getWinForSymbol(shortname:Sprite, shortname:String, shortname:int) : MovieClip
        {
            var _loc_4:int = 0;
            var _loc_6:MovieClip = null;
            var _loc_7:String = null;
            var _loc_5:* = shortname.numChildren;
            shortname = shortname + "_";
            _loc_4 = 0;
            while (_loc_4 < _loc_5)
            {
                
                _loc_6 = shortname.getChildAt(_loc_4) as MovieClip;
                if (!_loc_6)
                {
                }
                else
                {
                    _loc_7 = _loc_6.name;
                    if (_loc_7.indexOf(shortname) != -1 && _loc_7.indexOf("_" + shortname) != -1)
                    {
                        return _loc_6;
                    }
                }
                _loc_4++;
            }
            Console.write(this + " Warning animation for win symbol " + shortname + " is missing in the paytable !!!");
            return null;
        }// end function

        public function closePaytable() : void
        {
            this.disposeTween();
            if (this.m_paytableWnd)
            {
                this.m_gfx.removeChild(this.m_paytableWnd);
            }
            this.m_paytableWnd = null;
            this.m_PageWnd = null;
            this.m_prevWnd = null;
            this.m_nextWnd = null;
            return;
        }// end function

        private function getFrameGfx(setTransitionType:int) : Sprite
        {
            var _loc_2:* = getDefinitionByName(GameParameters.shortname + ".page_" + setTransitionType) as Class;
            return new _loc_2;
        }// end function

        protected function openFrame(com.playtech.casino3.slots.shared.enum:int) : void
        {
            var _loc_2:Sprite = null;
            if (this.m_transitionType == this.TYPE_REGULAR)
            {
                this.openFrameRegular(com.playtech.casino3.slots.shared.enum);
            }
            else if (this.m_transitionType == this.TYPE_TWEEN)
            {
                if (this.m_enter)
                {
                    this.m_enter = false;
                    this.m_PageWnd = new Sprite();
                    this.m_paytableWnd.addChildAt(this.m_PageWnd, this.m_depth);
                    this.m_currentPage = com.playtech.casino3.slots.shared.enum;
                    this.m_nextWnd = this.getFrameGfx(com.playtech.casino3.slots.shared.enum);
                    this.m_PageWnd.addChild(this.m_nextWnd);
                    _loc_2 = this.m_nextWnd.getChildByName(this.NAME_ANIMATIONS) as Sprite;
                    if (_loc_2 != null)
                    {
                        this.blinkWins(_loc_2, this.m_currentWins);
                    }
                }
                else
                {
                    this.startFrameTransition(com.playtech.casino3.slots.shared.enum);
                }
            }
            return;
        }// end function

        private function transitionFinish(event:TweenEvent) : void
        {
            this.enableBrowseBtns(true);
            if (this.m_prevWnd != null)
            {
                this.m_PageWnd.removeChild(this.m_prevWnd);
                this.m_prevWnd = null;
            }
            this.m_nextWnd.x = 0;
            this.m_PageWnd.x = 0;
            var _loc_2:* = this.m_nextWnd.getChildByName(this.NAME_ANIMATIONS) as Sprite;
            if (_loc_2 != null)
            {
                this.blinkWins(_loc_2, this.m_currentWins);
            }
            return;
        }// end function

        protected function initButtons() : void
        {
            return;
        }// end function

        private function openFrameRegular(com.playtech.casino3.slots.shared.enum:int) : void
        {
            this.closeCurrentFrame();
            this.m_currentPage = com.playtech.casino3.slots.shared.enum;
            this.m_PageWnd = this.getFrameGfx(com.playtech.casino3.slots.shared.enum);
            this.m_paytableWnd.addChildAt(this.m_PageWnd, this.m_depth);
            var _loc_2:* = this.m_PageWnd.getChildByName(this.NAME_ANIMATIONS) as Sprite;
            if (_loc_2 != null)
            {
                this.blinkWins(_loc_2, this.m_currentWins);
            }
            return;
        }// end function

        protected function enableBrowseBtns(com.playtech.casino3.slots.shared.enum:Boolean) : void
        {
            return;
        }// end function

        private function startFrameTransition(com.playtech.casino3.slots.shared.enum:int) : void
        {
            var _loc_2:Boolean = false;
            Console.write("startFrameTransition, page: " + com.playtech.casino3.slots.shared.enum, this);
            Console.write("startFrameTransition, m_currentPage: " + this.m_currentPage, this);
            if (!(this.m_tween && this.m_tween.isPlaying && com.playtech.casino3.slots.shared.enum != this.m_currentPage))
            {
                this.enableBrowseBtns(false);
                _loc_2 = com.playtech.casino3.slots.shared.enum > this.m_currentPage ? (true) : (false);
                this.m_prevWnd = this.m_nextWnd;
                this.m_nextWnd = this.getFrameGfx(com.playtech.casino3.slots.shared.enum);
                if (_loc_2)
                {
                    this.m_transitionDirection = this.DIRECTION_FORWARD;
                    this.m_endingPoint = -this.TWEEN_DELTA;
                    this.m_nextWnd.x = this.m_nextWnd.x + this.TWEEN_DELTA;
                }
                else
                {
                    this.m_transitionDirection = this.DIRECTION_BACK;
                    this.m_endingPoint = this.TWEEN_DELTA;
                    this.m_nextWnd.x = this.m_nextWnd.x - this.TWEEN_DELTA;
                }
                this.m_PageWnd.addChild(this.m_nextWnd);
                this.m_tween = new Tween(this.m_PageWnd, "x", Regular.easeIn, 0, this.m_endingPoint, this.FPS);
                this.m_tween.addEventListener(TweenEvent.MOTION_FINISH, this.transitionFinish, false, 0, true);
                this.m_currentPage = com.playtech.casino3.slots.shared.enum;
            }
            return;
        }// end function

        private function resetAll(event:Event) : void
        {
            this.closePaytable();
            this.reset();
            this.m_enter = true;
            return;
        }// end function

        protected function blinkAllWins(com.playtech.casino3.slots.shared.enum:Sprite, com.playtech.casino3.slots.shared.enum:Boolean = true) : void
        {
            var _loc_3:int = 0;
            var _loc_5:MovieClip = null;
            if (!com.playtech.casino3.slots.shared.enum)
            {
                return;
            }
            var _loc_4:* = com.playtech.casino3.slots.shared.enum.numChildren;
            var _loc_6:* = com.playtech.casino3.slots.shared.enum ? (2) : (1);
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_5 = com.playtech.casino3.slots.shared.enum.getChildAt(_loc_3) as MovieClip;
                if (_loc_5)
                {
                    _loc_5.gotoAndStop(_loc_6);
                }
                _loc_3++;
            }
            return;
        }// end function

        public function reset() : void
        {
            this.m_currentPage = 0;
            return;
        }// end function

        protected function paytableClose() : void
        {
            this.dispatchEvent(new Event(CLOSE_PAYTABLE));
            this.m_mi.stopSoundByID(this.m_snd);
            this.m_enter = true;
            return;
        }// end function

        override public function toString() : String
        {
            return "[PaytableBase] ";
        }// end function

    }
}
