package com.playtech.casino3.slots.shared.novel
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.button.*;
    import com.playtech.core.*;
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;

    public class ButtonsNovel extends SlotsButtonsBase
    {
        private var m_coinTabInfo:Array;
        protected const DIRECTION_DOWN:int = 1;
        protected const FPS:int = 12;
        protected var m_tween:Tween;
        protected var m_open:Boolean;
        protected var m_coinContainer:Sprite;
        protected var buttons_height:Number;
        protected var defaultHightDelta:Number;
        protected var coins_scroll:Rectangle;
        protected var m_direction:int;
        protected var m_apField:TextField;
        protected var buttons_x:Number;
        protected const DIRECTION_UP:int = 0;
        static const AUTOSPIN_FIELD:String = "spinsAP";
        static const AUTOMINUS_BUTTON:String = "autominus";
        static const DENOMINATION_BUTTON:String = "denomination";
        static const AUTOPLUS_BUTTON:String = "autoplus";

        public function ButtonsNovel(param1:IModuleInterface, param2:DisplayObjectContainer, param3:Function, param4:Array)
        {
            super(param2, param3, param1, param4);
            m_mi.addButtonShortcut(m_tabId, Keyboard.SPACE, m_buttons[GameButtons.SPIN_BUTTON]);
            EventPool.addEventListener(MessageWindowInfo.MESSAGE_SPACE_IN_SERVICE, this.enableSpinShortCut);
            EventPool.addEventListener(MessageWindowInfo.MESSAGE_SPACE_NOT_IN_SERVICE, this.disableSpinShortCut);
            return;
        }// end function

        private function enableSpinShortCut(event:Event) : void
        {
            m_mi.addButtonShortcut(m_tabId, Keyboard.BACKSPACE, m_buttons[GameButtons.SPIN_BUTTON]);
            return;
        }// end function

        private function enableCoinButtons(com.playtech.casino3.slots.shared.novel.novelEnums:Boolean) : void
        {
            var _loc_3:ButtonComponent = null;
            var _loc_2:* = this.m_coinContainer.numChildren;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3 = this.m_coinContainer.getChildAt(_loc_4) as ButtonComponent;
                (_loc_3.getLogic() as IButton).disable(!com.playtech.casino3.slots.shared.novel.novelEnums);
                _loc_4++;
            }
            return;
        }// end function

        protected function initExtraButtons(com.playtech.casino3.slots.shared.novel.novelEnums:Array, com.playtech.casino3.slots.shared.novel.novelEnums:Array) : void
        {
            var _loc_3:ButtonComponent = null;
            var _loc_4:Array = null;
            var _loc_5:String = null;
            var _loc_6:int = 0;
            while (_loc_6 < com.playtech.casino3.slots.shared.novel.novelEnums.length)
            {
                
                _loc_3 = com.playtech.casino3.slots.shared.novel.novelEnums[_loc_6];
                _loc_5 = _loc_3.name;
                m_buttons[_loc_5] = _loc_3;
                com.playtech.casino3.slots.shared.novel.novelEnums.push(_loc_3);
                _loc_4 = _loc_5.split("_");
                (_loc_3.getLogic() as IButton).registerHandler(this.buttonAction, _loc_4[0], _loc_4[1]);
                (_loc_3.getLogic() as IButton).setFreeText(((_loc_6 + 1)).toString());
                _loc_6++;
            }
            return;
        }// end function

        override public function enableAll(com.playtech.casino3.slots.shared.novel.novelEnums:Boolean, com.playtech.casino3.slots.shared.novel.novelEnums:int, ... args) : void
        {
            Console.write("enableAll -> are_enabled " + com.playtech.casino3.slots.shared.novel.novelEnums + " state " + com.playtech.casino3.slots.shared.novel.novelEnums, "[ButtonsNovel] ");
            args = false;
            if (com.playtech.casino3.slots.shared.novel.novelEnums == GameStates.STATE_FREESPIN || com.playtech.casino3.slots.shared.novel.novelEnums == GameStates.STATE_RESPIN)
            {
                super.enableAll.apply(this, [false, com.playtech.casino3.slots.shared.novel.novelEnums].concat(args));
                args = true;
            }
            else if (com.playtech.casino3.slots.shared.novel.novelEnums == GameStates.STATE_AUTOPLAY)
            {
                super.enableAll(false, com.playtech.casino3.slots.shared.novel.novelEnums, m_buttons[AUTOMINUS_BUTTON], m_buttons[AUTOPLUS_BUTTON]);
                super.enable(GameButtons.AUTOSTOP_BUTTON, true);
                this.setAP(int(this.m_apField.text), false);
            }
            else
            {
                super.enableAll.apply(this, [com.playtech.casino3.slots.shared.novel.novelEnums, com.playtech.casino3.slots.shared.novel.novelEnums].concat(args));
                if (com.playtech.casino3.slots.shared.novel.novelEnums)
                {
                    this.setAP(int(this.m_apField.text), false);
                }
                else
                {
                    args = true;
                }
            }
            if (args)
            {
                this.m_apField.mouseEnabled = false;
                this.m_apField.filters = [new ColorMatrixFilter([0.7, 0, 0, 0, 0, 0, 0.7, 0, 0, 0, 0, 0, 0.7, 0, 0, 0, 0, 0, 1, 0])];
            }
            else
            {
                this.m_apField.mouseEnabled = true;
                this.m_apField.filters = null;
            }
            return;
        }// end function

        private function closeDenomination() : void
        {
            if (this.m_coinContainer != null)
            {
                this.m_tween.stop();
                this.removeCoinPanel();
            }
            return;
        }// end function

        protected function buttonAction(com.playtech.casino3.slots.shared.novel.novelEnums:String, com.playtech.casino3.slots.shared.novel.novelEnums = null) : void
        {
            var _loc_3:int = 0;
            switch(com.playtech.casino3.slots.shared.novel.novelEnums)
            {
                case GameButtons.COIN_BUTTON:
                {
                    setCoinValue(com.playtech.casino3.slots.shared.novel.novelEnums);
                }
                case DENOMINATION_BUTTON:
                {
                    this.denomination();
                    break;
                }
                case AUTOMINUS_BUTTON:
                {
                    _loc_3 = int(this.m_apField.text) - 1;
                    this.setAP(_loc_3);
                    this.closeDenomination();
                    com.playtech.casino3.slots.shared.novel.novelEnums = GameButtons.AP_VALUE;
                    com.playtech.casino3.slots.shared.novel.novelEnums = _loc_3;
                    break;
                }
                case AUTOPLUS_BUTTON:
                {
                    _loc_3 = int(this.m_apField.text) + 1;
                    this.setAP(_loc_3);
                    this.closeDenomination();
                    com.playtech.casino3.slots.shared.novel.novelEnums = GameButtons.AP_VALUE;
                    com.playtech.casino3.slots.shared.novel.novelEnums = _loc_3;
                    break;
                }
                default:
                {
                    this.closeDenomination();
                    break;
                }
            }
            m_func(com.playtech.casino3.slots.shared.novel.novelEnums, com.playtech.casino3.slots.shared.novel.novelEnums);
            return;
        }// end function

        private function disableSpinShortCut(event:Event) : void
        {
            m_mi.removeShortcut(m_tabId, Keyboard.BACKSPACE);
            return;
        }// end function

        override protected function initButtons(com.playtech.casino3.slots.shared.enum:Array = null) : Array
        {
            var _loc_2:Array = [];
            this.initExtraButtons(com.playtech.casino3.slots.shared.enum, _loc_2);
            this.initMainButtons(_loc_2);
            var _loc_3:* = m_gfx.getChildByName("denomMask");
            this.defaultHightDelta = _loc_3 ? (m_gfx.y + _loc_3.y - _loc_3.height) : (0);
            this.buttons_x = _loc_3 ? (_loc_3.x) : (0);
            var _loc_4:* = _loc_3 ? (_loc_3.height) : (m_gfx.y);
            if (_loc_3)
            {
                m_gfx.removeChild(_loc_3);
            }
            this.coins_scroll = new Rectangle(0, 0, 800, _loc_4);
            enable(GameButtons.GAMBLE_BUTTON, false);
            this.setDenomDirection();
            return _loc_2;
        }// end function

        private function tweenChange(event:TweenEvent) : void
        {
            this.coins_scroll.y = event.position;
            this.m_coinContainer.scrollRect = this.coins_scroll;
            return;
        }// end function

        protected function removeCoinPanel() : void
        {
            m_mi.removeTabElement.apply(null, this.m_coinTabInfo);
            this.m_coinTabInfo = null;
            this.m_tween.removeEventListener(TweenEvent.MOTION_FINISH, this.removeCoinPanel);
            this.m_tween = null;
            this.m_coinContainer.parent.removeChild(this.m_coinContainer);
            this.m_coinContainer = null;
            return;
        }// end function

        protected function setDenomDirection() : void
        {
            this.m_direction = this.DIRECTION_UP;
            return;
        }// end function

        private function createCoinPanel() : void
        {
            var _loc_1:ButtonComponent = null;
            var _loc_2:IButton = null;
            var _loc_3:* = m_coins.length;
            var _loc_4:* = GameParameters.shortname + ".";
            var _loc_5:* = this.m_direction == this.DIRECTION_UP ? (this.coins_scroll.height) : (0);
            var _loc_6:int = 0;
            this.m_coinContainer = new Sprite();
            this.buttons_height = 0;
            var _loc_7:Boolean = false;
            this.m_coinTabInfo = [];
            var _loc_8:int = 0;
            while (_loc_8 < _loc_3)
            {
                
                _loc_1 = new ButtonComponent();
                this.m_coinTabInfo.push(_loc_1);
                _loc_2 = _loc_1.getLogic() as IButton;
                _loc_2.setGraphicsSize(true);
                _loc_2.setGraphics(_loc_4 + GameButtons.COIN_BUTTON);
                _loc_2.setFreeText(Money.format(m_coins[_loc_8]));
                _loc_2.registerHandler(this.buttonAction, GameButtons.COIN_BUTTON, m_coins[_loc_8]);
                _loc_2.setSound("");
                switch(this.m_direction)
                {
                    case this.DIRECTION_UP:
                    {
                        _loc_5 = _loc_5 - _loc_1.height;
                        if (_loc_5 <= -6)
                        {
                            _loc_5 = this.coins_scroll.height - _loc_1.height;
                            _loc_6 = _loc_6 + _loc_1.width;
                            _loc_7 = true;
                        }
                        break;
                    }
                    case this.DIRECTION_DOWN:
                    {
                        if (_loc_8 > 0)
                        {
                            _loc_5 = _loc_5 + _loc_1.height;
                        }
                        if (_loc_5 >= this.coins_scroll.height - _loc_1.height)
                        {
                            _loc_5 = 0;
                            _loc_6 = _loc_6 + _loc_1.width;
                            _loc_7 = true;
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (!_loc_7)
                {
                    this.buttons_height = this.buttons_height + _loc_1.height;
                }
                _loc_1.y = _loc_5;
                _loc_1.x = _loc_6;
                this.m_coinContainer.addChild(_loc_1);
                _loc_8++;
            }
            this.m_coinContainer.y = this.defaultHightDelta - m_gfx.y;
            this.beforeAddDenominationList();
            m_gfx.addChild(this.m_coinContainer);
            var _loc_9:* = this.m_direction == this.DIRECTION_UP ? (-1) : (1);
            this.coins_scroll.y = this.buttons_height * _loc_9;
            this.m_coinContainer.scrollRect = this.coins_scroll;
            this.m_coinTabInfo.unshift(m_tabId);
            m_mi.addTabElement.apply(null, this.m_coinTabInfo);
            return;
        }// end function

        protected function initMainButtons(com.playtech.casino3.slots.shared.novel.novelEnums:Array) : void
        {
            var _loc_3:ButtonComponent = null;
            var _loc_4:String = null;
            var _loc_2:Array = [DENOMINATION_BUTTON, AUTOMINUS_BUTTON, AUTOSPIN_FIELD, AUTOPLUS_BUTTON, GameButtons.PAYTABLE_OPEN, GameButtons.AUTOSTART_BUTTON, GameButtons.LINES_BUTTON, GameButtons.LINEBET_BUTTON, GameButtons.BETMAX_BUTTON, GameButtons.GAMBLE_BUTTON, GameButtons.SPIN_BUTTON];
            var _loc_5:int = 0;
            while (_loc_5 < _loc_2.length)
            {
                
                if (_loc_2[_loc_5] == AUTOSPIN_FIELD)
                {
                    this.m_apField = m_gfx.getChildByName(_loc_2[_loc_5]) as TextField;
                    this.m_apField.restrict = "0-9";
                    this.m_apField.multiline = false;
                    this.m_apField.addEventListener(Event.CHANGE, this.updateApField);
                    com.playtech.casino3.slots.shared.novel.novelEnums.push(this.m_apField);
                }
                else
                {
                    _loc_4 = _loc_2[_loc_5];
                    _loc_3 = m_gfx.getChildByName(_loc_4) as ButtonComponent;
                    if (_loc_3 != null)
                    {
                        m_buttons[_loc_4] = _loc_3;
                        if (_loc_4 == AUTOMINUS_BUTTON || _loc_4 == AUTOPLUS_BUTTON)
                        {
                            (_loc_3.getLogic() as IButton).registerDownHandler(this.buttonAction, _loc_4, true);
                        }
                        else
                        {
                            (_loc_3.getLogic() as IButton).registerHandler(this.buttonAction, _loc_4);
                        }
                        com.playtech.casino3.slots.shared.novel.novelEnums.push(_loc_3);
                    }
                }
                _loc_5++;
            }
            return;
        }// end function

        private function playDenominationSound(com.playtech.casino3.slots.shared.novel.novelEnums:Boolean) : void
        {
            var _loc_2:* = com.playtech.casino3.slots.shared.novel.novelEnums ? ("denomination_up") : ("denomination_down");
            m_mi.playAsEffect(GameParameters.library + "." + _loc_2);
            return;
        }// end function

        override public function dispose() : void
        {
            this.closeDenomination();
            this.m_apField.removeEventListener(Event.CHANGE, this.updateApField);
            this.m_apField = null;
            EventPool.removeEventListener(MessageWindowInfo.MESSAGE_SPACE_IN_SERVICE, this.enableSpinShortCut);
            EventPool.removeEventListener(MessageWindowInfo.MESSAGE_SPACE_NOT_IN_SERVICE, this.disableSpinShortCut);
            super.dispose();
            return;
        }// end function

        public function setAP(com.playtech.casino3.slots.shared.novel.novelEnums:int, com.playtech.casino3.slots.shared.novel.novelEnums:Boolean = true) : void
        {
            if (com.playtech.casino3.slots.shared.novel.novelEnums)
            {
                this.m_apField.text = com.playtech.casino3.slots.shared.novel.novelEnums.toString();
            }
            if (com.playtech.casino3.slots.shared.novel.novelEnums == 0)
            {
                super.enable(AUTOMINUS_BUTTON, false);
                super.enable(AUTOPLUS_BUTTON, true);
            }
            else if (com.playtech.casino3.slots.shared.novel.novelEnums == 99)
            {
                super.enable(AUTOMINUS_BUTTON, true);
                super.enable(AUTOPLUS_BUTTON, false);
            }
            else
            {
                super.enable(AUTOMINUS_BUTTON, true);
                super.enable(AUTOPLUS_BUTTON, true);
            }
            return;
        }// end function

        protected function updateApField(event:Event) : void
        {
            var _loc_2:* = int(event.target.text);
            this.setAP(_loc_2, false);
            m_func(GameButtons.AP_VALUE, _loc_2);
            return;
        }// end function

        function getButton(MESSAGE_SPACE_IN_SERVICE:String) : ButtonComponent
        {
            return m_buttons[MESSAGE_SPACE_IN_SERVICE] as ButtonComponent;
        }// end function

        protected function beforeAddDenominationList() : void
        {
            return;
        }// end function

        public function swapButton(com.playtech.casino3.slots.shared.novel.novelEnums:String, com.playtech.casino3.slots.shared.novel.novelEnums:String) : void
        {
            var sh:String;
            var tmp:Class;
            var buttonID:* = com.playtech.casino3.slots.shared.novel.novelEnums;
            var newType:* = com.playtech.casino3.slots.shared.novel.novelEnums;
            Console.write("swapButton: " + buttonID + " to " + newType, "[ButtonsNovel] ");
            var b:* = m_buttons[buttonID];
            if (b == null)
            {
                Console.write("Sorry, " + buttonID + " button is not available");
            }
            else
            {
                try
                {
                    sh = GameParameters.shortname;
                    tmp = getDefinitionByName(sh + "." + newType) as Class;
                    (b.getLogic() as IButton).setGraphics(sh + "." + newType);
                }
                catch (e:Error)
                {
                }
                (b.getLogic() as IButton).setLabel("novel_" + newType);
                (b.getLogic() as IButton).registerHandler(this.buttonAction, newType);
                m_buttons[newType] = b;
            }
            return;
        }// end function

        public function toString() : String
        {
            return "[ButtonsNovel] ";
        }// end function

        private function tweenEnded(event:TweenEvent) : void
        {
            if (this.m_open)
            {
                this.enableCoinButtons(true);
            }
            else
            {
                this.removeCoinPanel();
            }
            return;
        }// end function

        private function denomination() : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_1:int = 0;
            if (this.m_coinContainer == null)
            {
                this.createCoinPanel();
                this.m_open = true;
                this.playDenominationSound(this.m_open);
                this.enableCoinButtons(false);
                this.m_tween = new Tween(this.coins_scroll, "y", Regular.easeIn, this.coins_scroll.y, _loc_1, this.FPS);
                this.m_tween.addEventListener(TweenEvent.MOTION_FINISH, this.tweenEnded, false, 0, true);
                this.m_tween.addEventListener(TweenEvent.MOTION_CHANGE, this.tweenChange, false, 0, true);
                return;
            }
            this.m_open = !this.m_open;
            this.playDenominationSound(this.m_open);
            Console.write("m_open: " + this.m_open, this);
            if (!this.m_open)
            {
                if (this.m_tween.isPlaying)
                {
                    _loc_2 = this.FPS - (this.m_tween.duration - this.m_tween.time);
                }
                else
                {
                    this.enableCoinButtons(false);
                    _loc_2 = this.FPS;
                }
                _loc_3 = this.m_direction == this.DIRECTION_UP ? (-1) : (1);
                this.m_tween.continueTo(this.buttons_height * _loc_3, _loc_2);
            }
            else
            {
                _loc_2 = this.FPS - (this.m_tween.duration - this.m_tween.time);
                this.m_tween.continueTo(_loc_1, _loc_2);
            }
            return;
        }// end function

    }
}
