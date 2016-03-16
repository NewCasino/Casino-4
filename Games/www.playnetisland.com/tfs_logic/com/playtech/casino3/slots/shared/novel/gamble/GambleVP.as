package com.playtech.casino3.slots.shared.novel.gamble
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.gamble.enum.*;
    import com.playtech.casino3.table.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class GambleVP extends GambleBase
    {
        private const CMD_DOUBLEUP_HIGHCARD:uint = 11131;
        protected const DOUBLE_RATE:Number = 1;
        private const CMD_DOUBLEUP_HIGHCARD_PICK:uint = 11142;
        protected const NO_RATE:Number = 0;
        private var m_gfx:GraphicsVPGamble;
        private var m_result:GambleResult;
        private var m_win_sound_count:int;
        private var m_roundCount:int;
        private var m_brokenInfo:Array;
        private var m_error:Boolean;
        private var m_cheatCard:String;
        public const CardGamble1:uint = 1;
        public const CardGamble2:uint = 2;
        public const CardGamble3:uint = 3;
        private var m_isCanGamble:Boolean;
        public const CardGamble0:uint = 0;
        private var m_queueId:String;
        private var m_bankAmount:uint;
        private var m_deck:Deck;
        private const WINDISP_DURATION:int = 3000;
        private var m_dealerCard:int;
        private var end_timer:Timer;
        private var m_isMorePicksOffline:int;
        private var m_dealerHandString:String;
        protected const HALF_RATE:Number = 0.5;
        protected var current_rate:Number;
        private var m_betAmount:uint;

        public function GambleVP(param1:IModuleInterface, param2:DisplayObjectContainer, param3:Number, param4:Boolean = false)
        {
            this.m_result = GambleResult.RESULT_OTHER;
            Console.write("GambleVP() -> GambleVP constructor " + arguments, this);
            super(param1, param2, param3);
            this.m_betAmount = 0;
            this.m_bankAmount = 0;
            this.current_rate = this.NO_RATE;
            this.m_win_sound_count = 0;
            this.m_gfx = new GraphicsVPGamble(param1, this, param2, param4);
            m_mi.listenGS(CMD_DOUBLEUP_CHECK, this.onCheckResponse);
            m_mi.listenGS(this.CMD_DOUBLEUP_HIGHCARD, this.onDoubleResponse);
            m_mi.listenGS(this.CMD_DOUBLEUP_HIGHCARD_PICK, this.onPickResponse);
            return;
        }// end function

        private function onPickResponse(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:Packet) : void
        {
            var _loc_2:Object = null;
            var _loc_3:int = 0;
            var _loc_4:Vector.<String> = null;
            var _loc_8:Object = null;
            Console.write("onPickResponse() -> params: " + _loc_4, this);
            this.m_gfx.btnDisabledCards(true);
            m_mi.hideSandglass();
            if (SharedError.isRGError(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.errorCode))
            {
                m_mi.showLastRGError();
                return;
            }
            if (com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.errorCode != SharedError.ERR_OK)
            {
                Console.write("onPickResponse() -> Server error: " + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.errorCode, this);
                return;
            }
            _loc_4 = com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.data;
            var _loc_5:* = _loc_4.shift();
            var _loc_6:* = this.m_betAmount;
            var _loc_7:* = this.m_bankAmount;
            _loc_2 = this.m_gfx.convertCardString(_loc_4[_loc_5]);
            _loc_3 = _loc_2.value;
            Console.write("onPickResponse() -> dealer_card: " + this.m_dealerCard + " selected_card: " + _loc_3, this);
            if (_loc_4.pop() > 0)
            {
                this.m_isCanGamble = true;
                if (this.m_dealerCard == _loc_3)
                {
                    Console.write("onPickResponse() -> draw beacuse the cards are equal value", this);
                    this.m_gfx.showInfo(m_mi.readText("novel_gamble_push"));
                    this.playSound("draw");
                    this.m_bankAmount = this.m_bankAmount + this.m_betAmount;
                    this.m_betAmount = 0;
                }
                else
                {
                    Console.write("onPickResponse() -> win", this);
                    _loc_8 = {amount:Money.format(this.m_betAmount * 2)};
                    this.m_gfx.showInfo(m_mi.readText("novel_gamble_win", _loc_8));
                    this.playSound("win");
                    this.m_bankAmount = this.current_win;
                    this.m_betAmount = 0;
                }
            }
            else
            {
                if (this.m_dealerCard < _loc_3)
                {
                    Console.write("onPickResponse() -> limit reached", this);
                    this.m_bankAmount = this.current_win;
                    this.m_betAmount = 0;
                    this.m_gfx.showInfo(m_mi.readText("novel_gamble_limitreached"));
                }
                else
                {
                    Console.write("onPickResponse() -> loose", this);
                    this.m_isMorePicksOffline = 0;
                    this.m_betAmount = 0;
                    this.m_gfx.showInfo("");
                    m_mi.stopSoundByID(m_gambleAmbient);
                    this.playSound("loose");
                }
                this.m_isCanGamble = false;
            }
            this.addHistoryEntry(_loc_5, this.m_dealerHandString, _loc_4, _loc_6, _loc_7, this.m_bankAmount);
            this.m_gfx.revealAllCards(_loc_5, _loc_4);
            return;
        }// end function

        private function generateDoubleCheck() : Packet
        {
            var _loc_1:* = new Packet(CMD_DOUBLEUP_CHECK);
            this.m_isCanGamble = false;
            if (this.m_bankAmount >= m_gambleLimit)
            {
                this.m_isMorePicksOffline = 0;
            }
            _loc_1.addData(String(this.m_isMorePicksOffline));
            return _loc_1;
        }// end function

        private function addHistoryEntry(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:int, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:String, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:Vector.<String>, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:Number, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:Number, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:Number) : void
        {
            var _loc_8:Vector.<String> = null;
            var _loc_9:String = null;
            var _loc_10:int = 0;
            Console.write("addHistoryEntry(index: " + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP + " , dealerHand: " + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP + ", cards: " + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP + ", bet:" + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP + ", bank:" + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP + ", win: " + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP);
            var _loc_7:* = new HistoryEntry();
            _loc_7.endBalance = m_mi.getDisplayCredit() + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP;
            _loc_7.bet = com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP;
            _loc_7.win = com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP;
            _loc_8 = com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.slice(0, 4);
            _loc_8.unshift(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP);
            var _loc_11:* = _loc_8.length;
            _loc_10 = 0;
            while (_loc_10 < _loc_11)
            {
                
                _loc_9 = _loc_8[_loc_10];
                _loc_8[_loc_10] = _loc_9.charAt(0) + EnumCard.convertToNormalValue(_loc_9.substring(1));
                _loc_10++;
            }
            var _loc_12:* = new Vector.<Object>;
            _loc_12.push((com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP + 1));
            _loc_12.push(_loc_8.join(","));
            _loc_12.push(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP + "|" + GameParameters.shortname + "_d");
            _loc_7.data = _loc_12.join(";");
            Console.write("addHistoryEntry() -> data chunk: " + _loc_7.data);
            m_mi.writeRoundHistory(_loc_7);
            return;
        }// end function

        private function end(event:TimerEvent = null) : void
        {
            if (this.end_timer)
            {
                this.end_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.end);
                this.end_timer = null;
            }
            Console.write("end() -> win: " + this.m_bankAmount, this);
            startGameAmbientSound();
            m_mi.poolCredit(this.m_betAmount);
            m_mi.poolCredit(this.m_bankAmount);
            this.flushCredit();
            QueueEventManager.dispatchEvent(this.m_queueId);
            this.m_gfx.removeWindow();
            return;
        }// end function

        private function onDoubleResponse(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:Packet) : void
        {
            m_mi.hideSandglass();
            if (com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.errorCode != SharedError.ERR_OK)
            {
                if (SharedError.isRGError(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.errorCode))
                {
                    this.m_error = true;
                    this.m_gfx.btnDisabledAll(false);
                    m_mi.showLastRGError();
                }
                else if (SharedError.ERR_BALANCE_LOW == com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.errorCode)
                {
                    m_mi.uncommitCredit();
                    m_mi.reserveCredit(-this.m_betAmount);
                    m_mi.openDialog(SharedDialog.ALERT_SE, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.errorCode);
                    this.m_result = GambleResult.RESULT_OTHER;
                    this.end();
                }
                else
                {
                    m_mi.exitModuleImmediately(m_mi.getActiveDescriptor(), com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.errorCode);
                }
                return;
            }
            var _loc_2:* = com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.data;
            Console.write("onDoubleResponse() -> params: " + _loc_2, this);
            this.m_dealerHandString = _loc_2[0];
            var _loc_3:* = this.m_gfx.convertCardString(_loc_2[0]);
            this.m_gfx.revealCard(0, _loc_2[0]);
            this.m_gfx.btnDisabledCards(false);
            this.m_dealerCard = _loc_3.value;
            this.m_gfx.showInfo(m_mi.readText("novel_gamble_pickhigher"));
            return;
        }// end function

        private function generateOnDoublePacket() : Packet
        {
            var _loc_1:* = new Packet(this.CMD_DOUBLEUP_HIGHCARD);
            Console.write("generateOnDoublePacket() -> generate Double Up Offline Packet()", this);
            var _loc_2:* = this.getOfflineCard();
            _loc_1.addData(_loc_2);
            Console.write("generateOnDoublePacket() -> OFFLINE card: " + _loc_2, this);
            if (this.m_betAmount >= m_gambleLimit)
            {
                Console.write("generateOnDoublePacket() -> offline gamble limit reached m_betAmount : " + this.m_betAmount + " m_gambleLimit: " + m_gambleLimit, this);
                this.m_isMorePicksOffline = 0;
            }
            else
            {
                Console.write("generateOnDoublePacket() -> offline, can continue next round", this);
                this.m_isMorePicksOffline = 1;
            }
            return _loc_1;
        }// end function

        public function onDouble(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:Number) : void
        {
            var _loc_3:Packet = null;
            var _loc_2:int = 0;
            this.m_gfx.showBet("");
            this.current_rate = com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP;
            if (this.current_rate == this.HALF_RATE)
            {
                this.m_betAmount = this.current_bet;
                this.m_bankAmount = this.m_bankAmount - this.m_betAmount;
                this.m_gfx.showBank(Money.format(this.m_bankAmount));
                this.m_gfx.showBet(Money.format(this.m_betAmount));
                this.m_gfx.showDoubleHalfToSum(Money.format(this.current_win));
                this.m_gfx.showDoubleToSum("");
            }
            if (this.current_rate == this.DOUBLE_RATE)
            {
                this.m_betAmount = this.current_bet;
                this.m_bankAmount = 0;
                this.m_gfx.showBank("");
                this.m_gfx.showBet(Money.format(this.m_betAmount));
                this.m_gfx.showDoubleToSum(Money.format(this.current_win));
                this.m_gfx.showDoubleHalfToSum("");
            }
            m_mi.showSandglass();
            this.m_gfx.btnDisabledAll(true);
            if (m_mi.getMode() != ClientMode.REAL)
            {
                _loc_3 = this.generateOnDoublePacket();
            }
            _loc_2 = 1;
            sendCommand(this.CMD_DOUBLEUP_HIGHCARD, [com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP, _loc_2], _loc_3);
            return;
        }// end function

        override public function getResult() : GambleResult
        {
            return this.m_result;
        }// end function

        protected function get current_win() : uint
        {
            return this.m_bankAmount + this.m_betAmount * 2;
        }// end function

        protected function get double_half_to() : uint
        {
            return this.m_bankAmount + this.double_half_bet;
        }// end function

        private function flushCredit() : void
        {
            m_mi.flushPooledCredit();
            Console.write("flushCredit() - > CREDIT flushed ", this);
            return;
        }// end function

        override public function canGamble(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:Number) : void
        {
            var _loc_2:Packet = null;
            var _loc_3:int = 0;
            m_mi.showSandglass();
            this.m_isCanGamble = true;
            if (m_mi.getMode() != ClientMode.REAL)
            {
                _loc_3 = 1;
                if (com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP >= m_gambleLimit)
                {
                    _loc_3 = 0;
                }
                _loc_2 = new Packet(CMD_DOUBLEUP_CHECK);
                _loc_2.addData(_loc_3);
                this.onCheckResponse(_loc_2);
                return;
            }
            sendCommand(CMD_DOUBLEUP_CHECK, null, _loc_2);
            return;
        }// end function

        public function onPick(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:int) : void
        {
            var _loc_2:Packet = null;
            Console.write("onPick() -> index: " + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP, this);
            this.m_gfx.showPlayerSign(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP);
            if (m_mi.getMode() != ClientMode.REAL)
            {
                _loc_2 = this.generateOnPickPacket(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP);
            }
            sendCommand(this.CMD_DOUBLEUP_HIGHCARD_PICK, [com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP], _loc_2);
            return;
        }// end function

        protected function get double_bet() : uint
        {
            return this.m_bankAmount;
        }// end function

        override public function getWin() : Number
        {
            return this.m_bankAmount;
        }// end function

        protected function get double_to() : uint
        {
            return this.m_bankAmount + this.double_bet;
        }// end function

        public function winDisplayEnd() : void
        {
            Console.write("winDisplayEnd() ", this);
            this.beginRound();
            return;
        }// end function

        private function onCheckResponse(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:Packet = null) : void
        {
            var _loc_2:Boolean = false;
            var _loc_4:RegularEvent = null;
            Console.write("onCheckResponse() -> packet : " + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP, this);
            m_mi.hideSandglass();
            if (SharedError.isRGError(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.errorCode))
            {
                m_mi.showLastRGError();
                return;
            }
            var _loc_3:* = com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.data;
            _loc_2 = int(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.data[0]) == 1 ? (true) : (false);
            if (com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.errorCode != SharedError.ERR_OK)
            {
                m_mi.exitModuleImmediately(m_mi.getActiveDescriptor(), com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP.errorCode);
                return;
            }
            Console.write("onCheckResponse() -> isMorePicks : " + _loc_2 + " m_isCanGamble : " + this.m_isCanGamble, this);
            if (this.m_isCanGamble)
            {
                Console.write("onCheckResponse() -> can gamble isMorePicks: " + _loc_2, this);
                _loc_4 = new RegularEvent(GambleBase.EVT_CAN_GAMBLE, _loc_2);
                dispatchEvent(_loc_4);
                return;
            }
            if (this.m_bankAmount == 0)
            {
                _loc_2 = false;
            }
            if (!_loc_2)
            {
                Console.write("onCheckResponse() -> no more picks gamble has ended !!!", this);
                if (this.m_bankAmount > 0)
                {
                    Console.write("onCheckResponse() -> limit reached !!!", this);
                    if (this.m_bankAmount > m_gambleLimit)
                    {
                        this.m_result = GambleResult.RESULT_WIN;
                        m_mi.openDialog(SharedDialog.ALERT, m_mi.readAlert(19));
                    }
                    else
                    {
                        this.m_result = GambleResult.RESULT_LOST;
                    }
                }
                else
                {
                    Console.write("onCheckResponse() -> lost !!!", this);
                    this.m_result = GambleResult.RESULT_LOST;
                    this.m_betAmount = 0;
                }
                this.end_timer = new Timer(2000, 1);
                this.end_timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.end, false, 0, true);
                this.end_timer.start();
                return;
            }
            var _loc_5:String = this;
            var _loc_6:* = this.m_roundCount + 1;
            _loc_5.m_roundCount = _loc_6;
            this.showStartInfo();
            this.m_gfx.showBank(Money.format(this.m_bankAmount));
            this.m_gfx.flipAllCardsBack();
            this.m_gfx.btnDisabledAll(false);
            this.m_gfx.btnDisabledByType(GraphicsVPGamble.DOUBLE_HALF, this.m_bankAmount <= 1);
            this.m_gfx.btnDisabledCards(true);
            Console.write("onCheckResponse() -> can continue gamble, waiting for choice", this);
            return;
        }// end function

        protected function get current_bet() : uint
        {
            var _loc_1:uint = 0;
            switch(this.current_rate)
            {
                case this.DOUBLE_RATE:
                {
                    _loc_1 = this.double_bet;
                    break;
                }
                case this.HALF_RATE:
                {
                    _loc_1 = this.double_half_bet;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_1;
        }// end function

        private function playSound(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:String) : void
        {
            switch(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP)
            {
                case "draw":
                {
                    if (!this.m_win_sound_count || this.m_win_sound_count == 0)
                    {
                        m_mi.playAsEffect("gamblecommon.snd_win1");
                    }
                    else
                    {
                        m_mi.playAsEffect("gamblecommon.snd_win" + this.m_win_sound_count);
                    }
                    break;
                }
                case "win":
                {
                    if (this.m_win_sound_count < 5)
                    {
                        var _loc_2:String = this;
                        var _loc_3:* = this.m_win_sound_count + 1;
                        _loc_2.m_win_sound_count = _loc_3;
                        m_mi.playAsEffect("gamblecommon.snd_win" + this.m_win_sound_count);
                    }
                    else
                    {
                        m_mi.playAsEffect("gamblecommon.snd_win5");
                    }
                    break;
                }
                case "loose":
                {
                    m_mi.playAsEffect("gamblecommon.snd_loose");
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function onCollect() : void
        {
            Console.write("onCollect()", this);
            this.m_result = GambleResult.RESULT_WIN;
            if (m_mi.getMode() == ClientMode.REAL)
            {
                sendCommand(CMD_DOUBLEUP_COLLECT, null);
            }
            if (this.m_error)
            {
                this.m_error = false;
            }
            this.end();
            return;
        }// end function

        private function getCheatCard() : void
        {
            var _loc_2:Object = null;
            this.m_cheatCard = null;
            var _loc_1:* = m_mi.readSession(SharedSession.CHEAT);
            Console.write("getCheatCards() -> cheatString: " + _loc_1, this);
            if (_loc_1 != null)
            {
                _loc_2 = this.m_gfx.convertCardString(_loc_1);
                if (_loc_2.suit != EnumCard.NOT_SET && _loc_2.value != EnumCard.NOT_SET)
                {
                    this.m_cheatCard = _loc_1;
                }
            }
            Console.write("getCheatCard() -> cheat card: " + this.m_cheatCard, this);
            return;
        }// end function

        private function generateOnPickPacket(com.playtech.casino3.slots.shared.novel.gamble:GambleBase:int) : Packet
        {
            var _loc_3:Object = null;
            var _loc_4:int = 0;
            var _loc_2:* = new Packet(this.CMD_DOUBLEUP_HIGHCARD_PICK);
            _loc_2.addData(String(com.playtech.casino3.slots.shared.novel.gamble:GambleBase));
            var _loc_5:int = 0;
            while (_loc_5 < 4)
            {
                
                _loc_2.addData(String(this.getOfflineCard()));
                _loc_5++;
            }
            _loc_3 = this.m_gfx.convertCardString(_loc_2.data[(com.playtech.casino3.slots.shared.novel.gamble:GambleBase + 1)]);
            _loc_4 = _loc_3.value;
            if (this.m_dealerCard > _loc_4)
            {
                _loc_2.addData("0");
                this.m_isMorePicksOffline = 0;
            }
            else
            {
                _loc_2.addData("1");
            }
            return _loc_2;
        }// end function

        protected function get double_half_bet() : uint
        {
            return Math.floor(this.m_bankAmount * this.HALF_RATE);
        }// end function

        private function getOfflineCard() : String
        {
            var _loc_1:String = null;
            var _loc_2:Array = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            if (this.m_deck)
            {
                this.getCheatCard();
                if (this.m_cheatCard != null)
                {
                    _loc_1 = this.m_cheatCard;
                }
                else
                {
                    _loc_2 = this.m_deck.giveCard().split(EnumCard.FS);
                    _loc_3 = EnumCard.convertSuitIntToString(_loc_2[0]);
                    _loc_4 = EnumCard.convertValueIntToString(_loc_2[1], EnumCard.STRINGTYPE_10IST);
                    _loc_1 = _loc_3 + _loc_4;
                }
            }
            return _loc_1;
        }// end function

        private function beginRound(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP:Boolean = false) : void
        {
            Console.write("beginRound() -> send_check_to_server: " + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP, this);
            m_mi.showSandglass();
            var _loc_2:* = this.generateDoubleCheck();
            if (com.playtech.casino3.slots.shared.novel.gamble:GambleVP/GambleVP)
            {
                if (m_mi.getMode() == ClientMode.REAL)
                {
                    _loc_2 = null;
                }
                sendCommand(CMD_DOUBLEUP_CHECK, null, _loc_2);
                return;
            }
            this.onCheckResponse(_loc_2);
            return;
        }// end function

        override public function start(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get:Number, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get:int = -1, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get:Array = null, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get:String = null) : int
        {
            var _loc_5:Boolean = false;
            var _loc_6:Number = NaN;
            var _loc_7:String = null;
            var _loc_8:int = 0;
            var _loc_9:* = undefined;
            Console.write("start() ->  bet : " + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get + " queueID : " + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get, this);
            this.m_win_sound_count = 0;
            this.m_queueId = com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get;
            this.m_brokenInfo = com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get;
            this.m_bankAmount = com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get;
            this.current_rate = this.NO_RATE;
            if (!this.m_brokenInfo)
            {
                _loc_5 = m_mi.reserveCredit(this.m_bankAmount);
                Console.write("start() -> CREDIT reserve: " + this.m_bankAmount, this);
                if (_loc_5 == false)
                {
                    this.m_result = GambleResult.RESULT_OTHER;
                    m_mi.openDialog(SharedDialog.ALERT, m_mi.readAlert(17));
                    this.end();
                    m_regamble = true;
                    return 0;
                }
                m_mi.commitCredit();
                Console.write("start() -> CREDIT bet commited", this);
            }
            if (m_mi.getMode() != ClientMode.REAL)
            {
                Console.write("start() -> Offline, creating deck");
                this.m_deck = new Deck();
            }
            this.m_isMorePicksOffline = 1;
            this.m_roundCount = 0;
            this.m_gfx.attachWindow();
            this.m_gfx.btnDisabledAll(true);
            this.showStartInfo();
            this.m_gfx.showBank(Money.format(this.m_bankAmount));
            if (this.m_brokenInfo != null)
            {
                _loc_6 = this.m_brokenInfo[0];
                _loc_7 = this.m_brokenInfo[1];
                this.m_bankAmount = int(this.m_brokenInfo[2]);
                this.current_rate = _loc_6;
                _loc_8 = this.m_brokenInfo[3];
                Console.write("start() -> Broken gamble bet: " + com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get + ", rate: " + _loc_6 + ", card: " + _loc_7 + ", bankAmount: " + this.m_bankAmount + ", roundCount: " + _loc_8, this);
                this.m_roundCount = _loc_8;
                this.m_gfx.showDoubleToSum("");
                this.m_gfx.showDoubleHalfToSum("");
                this.m_gfx.showBet("");
                if (_loc_6 == this.HALF_RATE)
                {
                    this.m_betAmount = uint(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get / 2);
                    this.m_gfx.showBet(Money.format(this.m_betAmount));
                    this.m_gfx.showDoubleHalfToSum(Money.format(this.current_win));
                    this.m_gfx.showDoubleToSum("");
                    this.m_gfx.showBank(Money.format(this.m_bankAmount));
                }
                if (_loc_6 == this.DOUBLE_RATE)
                {
                    this.m_betAmount = com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get;
                    this.m_gfx.showBet(Money.format(this.m_betAmount));
                    this.m_gfx.showDoubleHalfToSum("");
                    this.m_gfx.showDoubleToSum(Money.format(Money.floor(this.current_win)));
                    this.m_gfx.showBank("");
                    this.m_bankAmount = 0;
                }
                _loc_9 = new Packet(this.CMD_DOUBLEUP_HIGHCARD);
                _loc_9.addData(_loc_7);
                this.onDoubleResponse(_loc_9);
                super.start(this.m_bankAmount, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get);
                return 1;
            }
            this.beginRound(true);
            super.start(com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get, com.playtech.casino3.slots.shared.novel.gamble:GambleVP/protected:current_bet/get);
            return 1;
        }// end function

        private function showStartInfo() : void
        {
            this.m_gfx.showBet("");
            this.current_rate = this.NO_RATE;
            this.m_gfx.showDoubleToSum(Money.format(this.double_to));
            this.m_gfx.showDoubleHalfToSum(Money.format(this.double_half_to));
            this.m_gfx.showInfo(m_mi.readText("novel_gamble_choosedoublehalf"));
            return;
        }// end function

        override public function unload() : void
        {
            Console.write("unload()", this);
            m_mi.unlistenGS(CMD_DOUBLEUP_CHECK, this.onCheckResponse);
            m_mi.unlistenGS(this.CMD_DOUBLEUP_HIGHCARD, this.onDoubleResponse);
            this.flushCredit();
            this.m_cheatCard = null;
            if (this.m_deck != null)
            {
                this.m_deck.dispose();
                this.m_deck = null;
            }
            this.m_bankAmount = 0;
            this.m_dealerHandString = "";
            this.m_dealerCard = 0;
            this.m_gfx.unload();
            this.m_gfx = null;
            super.unload();
            return;
        }// end function

    }
}
