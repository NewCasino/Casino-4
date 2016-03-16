package com.playtech.casino3.slots.shared.novel.gamble
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.button.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;
    import fl.motion.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

    public class GraphicsVPGamble extends Object
    {
        private var Card0:Card;
        private var Card1:Card;
        private var m_gameShortName:String;
        private var m_game:GambleVP;
        private var Card2:Card;
        private var Card3:Card;
        private var dcHolder:MovieClip;
        private var buttons:Dictionary;
        private var dCard:Card;
        private var m_tf_info:TextField;
        private var m_btnDouble:ButtonComponent;
        private var m_tf_bank:TextField;
        private var whiten_other_cards:Boolean;
        private var m_gfx:MovieClip;
        private var m_mi:IModuleInterface;
        private var c0Holder:MovieClip;
        private var c2Holder:MovieClip;
        private var m_tabId:int;
        private var m_queue:CommandQueue;
        private var m_btnCollect:ButtonComponent;
        private var m_historyCards:Array;
        private var m_soundIdAmbient:int;
        private var m_allCardHolders:Array;
        private var m_winDisplayTimer:Timer;
        private var m_allCards:Object;
        private var m_btnDoubleHalf:ButtonComponent;
        private var m_tf_doublehalfto:TextField;
        private var player_sign:DisplayObject;
        private var m_tf_bet:TextField;
        private const WINDISP_DURATION:int = 3000;
        private var m_tf_doubleto:TextField;
        private const SHUFFLE_INTERVAL:uint = 100;
        private var m_gfxCont:DisplayObjectContainer;
        private var c1Holder:MovieClip;
        private const HISTORYCOUNT:uint = 6;
        private var c3Holder:MovieClip;
        private var m_cardButtons:Array;
        static const DOUBLE_HALF:String = "DOUBLE_HALF";
        static const DOUBLE:String = "DOUBLE";
        static const COLLECT:String = "COLLECT";

        public function GraphicsVPGamble(m_gfxCont:IModuleInterface, m_gfxCont:GambleVP, m_gfxCont:DisplayObjectContainer, m_gfxCont:Boolean = false) : void
        {
            this.m_mi = m_gfxCont;
            this.m_game = m_gfxCont;
            this.m_gfxCont = m_gfxCont;
            this.m_gameShortName = GameParameters.shortname;
            this.m_queue = new CommandQueue(this.m_gfxCont.stage);
            this.whiten_other_cards = m_gfxCont;
            return;
        }// end function

        public function revealCard(m_gfxCont:int, m_gfxCont:String) : void
        {
            Console.write("RevealCard:  " + m_gfxCont + "  ,  " + m_gfxCont, this);
            var _loc_3:* = EnumCard.convertSuitStringToInt(m_gfxCont.charAt(0));
            var _loc_4:* = EnumCard.convertValueStringToInt(m_gfxCont.charAt(1), EnumCard.STRINGTYPE_10IST);
            this.m_allCards[m_gfxCont].suit = _loc_3;
            this.m_allCards[m_gfxCont].value = _loc_4;
            this.m_allCards[m_gfxCont].flipFront();
            return;
        }// end function

        public function unload() : void
        {
            Console.write("unload()", this);
            if (this.m_winDisplayTimer)
            {
                this.m_winDisplayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.winDisplayEnd);
                this.m_winDisplayTimer = null;
            }
            this.m_mi = null;
            this.m_game = null;
            this.m_gfxCont = null;
            return;
        }// end function

        public function attachWindow() : void
        {
            var _loc_3:int = 0;
            var _loc_4:ButtonComponent = null;
            Console.write("attachWindow() -> gamble window attached", this);
            var _loc_1:* = this.m_gameShortName + ".gamble_window";
            var _loc_2:* = getDefinitionByName(_loc_1) as Class;
            if (_loc_2 != null)
            {
                this.m_gfx = new _loc_2 as MovieClip;
                this.m_gfxCont.addChild(this.m_gfx);
            }
            this.m_historyCards = [];
            this.m_allCards = [];
            this.m_allCardHolders = [];
            this.m_cardButtons = [];
            this.m_tf_bet = this.m_gfx.getChildByName("tf_bet") as TextField;
            this.m_tf_doubleto = this.m_gfx.getChildByName("tf_doubleto") as TextField;
            this.m_tf_doublehalfto = this.m_gfx.getChildByName("tf_doublehalfto") as TextField;
            this.m_tf_bank = this.m_gfx.getChildByName("tf_bank") as TextField;
            this.m_tf_info = this.m_gfx.getChildByName("tf_info") as TextField;
            this.dcHolder = this.m_gfx.getChildByName("dc") as MovieClip;
            this.c0Holder = this.m_gfx.getChildByName("c0") as MovieClip;
            this.c1Holder = this.m_gfx.getChildByName("c1") as MovieClip;
            this.c2Holder = this.m_gfx.getChildByName("c2") as MovieClip;
            this.c3Holder = this.m_gfx.getChildByName("c3") as MovieClip;
            this.m_allCardHolders.push(this.dcHolder, this.c0Holder, this.c1Holder, this.c2Holder, this.c3Holder);
            this.m_tabId = this.m_mi.createKeyboardSet();
            _loc_3 = 0;
            while (_loc_3 < 4)
            {
                
                _loc_4 = this.m_gfx.getChildByName("btn_card" + _loc_3) as ButtonComponent;
                _loc_4.getLogic().registerHandler(this.onPick, _loc_3);
                this.m_cardButtons.push(_loc_4);
                this.m_mi.addTabElement(this.m_tabId, _loc_4);
                _loc_3++;
            }
            this.m_btnCollect = this.m_gfx.getChildByName("btn_collect") as ButtonComponent;
            this.m_btnCollect.getLogic().registerHandler(this.onCollect);
            this.m_btnDoubleHalf = this.m_gfx.getChildByName("btn_doublehalf") as ButtonComponent;
            this.m_btnDoubleHalf.getLogic().registerHandler(this.onDoubleHalf);
            this.m_btnDouble = this.m_gfx.getChildByName("btn_double") as ButtonComponent;
            this.m_btnDouble.getLogic().registerHandler(this.onDouble);
            this.m_mi.addTabElement(this.m_tabId, this.m_btnCollect);
            this.m_mi.addTabElement(this.m_tabId, this.m_btnDoubleHalf);
            this.m_mi.addTabElement(this.m_tabId, this.m_btnDouble);
            this.buttons = new Dictionary(true);
            this.buttons[COLLECT] = this.m_btnCollect;
            this.buttons[DOUBLE_HALF] = this.m_btnDoubleHalf;
            this.buttons[DOUBLE] = this.m_btnDouble;
            this.dCard = new Card(EnumCard.NOT_SET, EnumCard.NOT_SET, true, "gamblecommon.", this.m_gameShortName + ".gamble_");
            this.Card0 = new Card(EnumCard.NOT_SET, EnumCard.NOT_SET, true, "gamblecommon.", this.m_gameShortName + ".gamble_");
            this.Card1 = new Card(EnumCard.NOT_SET, EnumCard.NOT_SET, true, "gamblecommon.", this.m_gameShortName + ".gamble_");
            this.Card2 = new Card(EnumCard.NOT_SET, EnumCard.NOT_SET, true, "gamblecommon.", this.m_gameShortName + ".gamble_");
            this.Card3 = new Card(EnumCard.NOT_SET, EnumCard.NOT_SET, true, "gamblecommon.", this.m_gameShortName + ".gamble_");
            this.m_allCards.push(this.dCard, this.Card0, this.Card1, this.Card2, this.Card3);
            _loc_3 = 0;
            while (_loc_3 < 5)
            {
                
                this.m_allCardHolders[_loc_3].addChild(this.m_allCards[_loc_3]);
                _loc_3++;
            }
            this.player_sign = this.m_gfx.getChildByName("player_sign") as DisplayObject;
            if (this.player_sign)
            {
                this.player_sign.visible = false;
            }
            return;
        }// end function

        public function showPlayerSign(m_gfxCont:int) : void
        {
            if (this.player_sign)
            {
                this.player_sign.visible = true;
                this.player_sign.x = this.m_allCardHolders[(m_gfxCont + 1)].x;
            }
            return;
        }// end function

        public function removeWindow() : void
        {
            var _loc_1:int = 0;
            var _loc_2:uint = 0;
            Console.write("gamble removeWindow()", this);
            this.m_mi.stopSoundByID(this.m_soundIdAmbient);
            this.m_mi.removeKeyboardSet(this.m_tabId);
            this.m_gfxCont.removeChild(this.m_gfx);
            this.m_gfx = null;
            this.m_tf_bet = null;
            this.m_tf_doubleto = null;
            this.m_tf_doublehalfto = null;
            this.m_tf_bank = null;
            this.m_tf_info = null;
            this.buttons = null;
            this.dcHolder = null;
            this.c0Holder = null;
            this.c1Holder = null;
            this.c2Holder = null;
            this.c3Holder = null;
            this.m_allCards = null;
            if (this.m_cardButtons)
            {
                _loc_1 = 0;
                while (_loc_1 < 4)
                {
                    
                    this.m_cardButtons[_loc_1] = null;
                    _loc_1++;
                }
            }
            this.m_cardButtons = null;
            if (this.m_historyCards)
            {
                _loc_2 = 0;
                while (_loc_2 < this.HISTORYCOUNT)
                {
                    
                    this.m_historyCards[_loc_2] = null;
                    _loc_2 = _loc_2 + 1;
                }
            }
            this.m_historyCards = null;
            return;
        }// end function

        public function btnDisabled(m_gfxCont:ButtonComponent, m_gfxCont:Boolean) : void
        {
            m_gfxCont.getLogic().disable(m_gfxCont);
            return;
        }// end function

        public function btnDisabledAll(m_gfxCont:Boolean) : void
        {
            this.btnDisabled(this.m_btnCollect, m_gfxCont);
            this.btnDisabled(this.m_btnDouble, m_gfxCont);
            this.btnDisabled(this.m_btnDoubleHalf, m_gfxCont);
            return;
        }// end function

        private function onDouble() : void
        {
            Console.write("onDouble()", this);
            this.m_game.onDouble(1);
            return;
        }// end function

        private function onPick(m_gfxCont:int) : void
        {
            this.m_game.onPick(m_gfxCont);
            return;
        }// end function

        private function winDisplayEnd(event:TimerEvent) : void
        {
            this.m_winDisplayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.winDisplayEnd);
            this.m_winDisplayTimer = null;
            this.m_game.winDisplayEnd();
            return;
        }// end function

        public function showDoubleToSum(m_gfxCont:String) : void
        {
            this.m_tf_doubleto.text = m_gfxCont;
            return;
        }// end function

        public function flipCardBack(m_gfxCont:Card) : void
        {
            m_gfxCont.flipBack();
            m_gfxCont.suit = EnumCard.NOT_SET;
            m_gfxCont.value = EnumCard.NOT_SET;
            return;
        }// end function

        public function btnDisabledByType(m_gfxCont:String, m_gfxCont:Boolean) : void
        {
            this.buttons[m_gfxCont].getLogic().disable(m_gfxCont);
            return;
        }// end function

        public function btnDisabledCards(m_gfxCont:Boolean) : void
        {
            var _loc_2:int = 0;
            _loc_2 = 0;
            while (_loc_2 < 4)
            {
                
                this.btnDisabled(this.m_cardButtons[_loc_2], m_gfxCont);
                _loc_2++;
            }
            return;
        }// end function

        public function showDoubleHalfToSum(m_gfxCont:String) : void
        {
            this.m_tf_doublehalfto.text = m_gfxCont;
            return;
        }// end function

        public function revealAllCards(m_gfxCont:int, m_gfxCont:Vector.<String>) : void
        {
            var _loc_6:CommandFunction = null;
            var _loc_8:int = 0;
            Console.write("revealAllCards(index:" + m_gfxCont + " cards:" + m_gfxCont, this);
            var _loc_3:* = m_gfxCont[m_gfxCont];
            var _loc_4:* = EnumCard.convertSuitStringToInt(_loc_3.charAt(0));
            var _loc_5:* = EnumCard.convertValueStringToInt(_loc_3.charAt(1), EnumCard.STRINGTYPE_10IST);
            this.m_allCards[(m_gfxCont + 1)].suit = _loc_4;
            this.m_allCards[(m_gfxCont + 1)].value = _loc_5;
            this.m_allCards[(m_gfxCont + 1)].flipFront();
            var _loc_7:* = new CommandTimer(1500);
            this.m_queue.add(_loc_7);
            _loc_8 = 0;
            while (_loc_8 < m_gfxCont.length)
            {
                
                if (_loc_8 != m_gfxCont)
                {
                    _loc_3 = m_gfxCont[_loc_8];
                    _loc_4 = EnumCard.convertSuitStringToInt(_loc_3.charAt(0));
                    _loc_5 = EnumCard.convertValueStringToInt(_loc_3.charAt(1), EnumCard.STRINGTYPE_10IST);
                    this.m_allCards[(_loc_8 + 1)].suit = _loc_4;
                    this.m_allCards[(_loc_8 + 1)].value = _loc_5;
                    _loc_6 = new CommandFunction(this.m_allCards[(_loc_8 + 1)].flipFront);
                    if (this.whiten_other_cards)
                    {
                        this.m_queue.add(new CommandFunction(this.m_mi.playAsEffect, "gamblecommon.snd_turn"), _loc_6, new CommandFunction(this.transformToWhite, this.m_allCards[(_loc_8 + 1)]));
                    }
                    else
                    {
                        this.m_queue.add(new CommandFunction(this.m_mi.playAsEffect, "gamblecommon.snd_turn"), _loc_6);
                    }
                    _loc_7 = new CommandTimer(200);
                    this.m_queue.add(_loc_7);
                }
                _loc_8++;
            }
            this.m_winDisplayTimer = new Timer(this.WINDISP_DURATION, 1);
            this.m_winDisplayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.winDisplayEnd);
            this.m_winDisplayTimer.start();
            return;
        }// end function

        public function showInfo(m_gfxCont:String) : void
        {
            this.m_tf_info.text = m_gfxCont;
            return;
        }// end function

        public function showBank(m_gfxCont:String) : void
        {
            this.m_tf_bank.text = m_gfxCont;
            return;
        }// end function

        private function transformToWhite(c3Holder:DisplayObject) : int
        {
            var _loc_2:* = new Color();
            _loc_2.setTint(16777215, 0.8);
            c3Holder.transform.colorTransform = _loc_2;
            return 1;
        }// end function

        public function convertCardString(onPick:String) : Object
        {
            var _loc_2:* = EnumCard.convertSuitStringToInt(onPick.charAt(0));
            var _loc_3:* = EnumCard.convertValueStringToInt(onPick.charAt(1), EnumCard.STRINGTYPE_10IST);
            var _loc_4:* = new Object();
            _loc_4.suit = _loc_2;
            _loc_4.value = _loc_3;
            return _loc_4;
        }// end function

        public function flipAllCardsBack() : void
        {
            var _loc_1:int = 0;
            while (_loc_1 < 5)
            {
                
                this.flipCardBack(this.m_allCards[_loc_1]);
                if (this.whiten_other_cards)
                {
                    this.m_allCards[_loc_1].transform.colorTransform = new ColorTransform();
                }
                _loc_1++;
            }
            if (this.player_sign)
            {
                this.player_sign.visible = false;
            }
            return;
        }// end function

        private function onDoubleHalf() : void
        {
            Console.write("onDoubleHalf()", this);
            this.m_game.onDouble(0.5);
            return;
        }// end function

        public function showBet(m_gfxCont:String) : void
        {
            this.m_tf_bet.text = m_gfxCont;
            return;
        }// end function

        private function onCollect() : void
        {
            Console.write("onCollect()", this);
            this.m_game.onCollect();
            return;
        }// end function

    }
}
