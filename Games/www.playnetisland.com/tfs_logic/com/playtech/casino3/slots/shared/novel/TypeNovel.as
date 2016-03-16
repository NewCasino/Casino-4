package com.playtech.casino3.slots.shared.novel
{
    import __AS3__.vec.*;
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.commands.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.anticipation.*;
    import com.playtech.casino3.slots.shared.novel.gamble.*;
    import com.playtech.casino3.slots.shared.novel.gamble.enum.*;
    import com.playtech.casino3.slots.shared.novel.novelCmd.*;
    import com.playtech.casino3.slots.shared.novel.novelComponents.*;
    import com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.slots.shared.novel.promo.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class TypeNovel extends SlotsBase
    {
        protected var m_celebration:Celebration;
        protected var have_game_started_ticker:Boolean;
        protected var FREE_SPIN_COMMAND:Class;
        protected var SPIN_COMMAND:Class;
        protected var m_cWinAnims:Vector.<IWinAnimation>;
        protected var m_canGamble:Boolean;
        protected var m_anticip:Vector.<AnticipationRules>;
        private var m_ambients:Array;
        protected var mute_ambient_on_win_toggle:Boolean = true;
        protected var m_ambientId:int = -1;
        protected var m_nrOfKind:Boolean;
        protected var m_winticker:SlotWinTicker;
        protected var m_respinsLeft:int;
        protected var m_nrKindMsg:NrOfKindMessage;
        protected var m_reelEff:ReelEffects;
        protected var m_cmdId:Vector.<int>;
        protected var m_gamble:GambleBase;
        protected var m_promo:PromoArea;
        protected var m_forwardJump:int;
        protected var m_fsManager:FreeSpins;
        protected var ButtonsNovelClass:Class;
        private static const NEXT_IS_MORE_SPINS:int = 1;
        private static const NEXT_IS_FEATURE:int = 0;
        private static const NEXT_IS_IDLE:int = 2;
        static const FORWARD_BUTTON:String = "forwardSpin";
        static const FS:String = String.fromCharCode(252);

        public function TypeNovel()
        {
            this.FREE_SPIN_COMMAND = FreeSpinCmd;
            this.SPIN_COMMAND = SpinCmd;
            this.ButtonsNovelClass = ButtonsNovel;
            this.m_cWinAnims = new Vector.<IWinAnimation>;
            this.m_cmdId = new Vector.<int>;
            this.m_ambients = [];
            this.m_anticip = new Vector.<AnticipationRules>;
            NovelParameters.resetParameters();
            GameParameters.library = "novel";
            GameParameters.sound_library = "novel";
            GameParameters.celebration_sound_library = "novel";
            NovelSoundMap.resetParameters();
            return;
        }// end function

        public function getTicker() : SlotWinTicker
        {
            return this.m_winticker;
        }// end function

        override protected function typeSpecificGfxInit() : void
        {
            this.gameSpecificGraphics();
            this.initTextFields();
            this.initReels();
            this.m_reelEff = new ReelEffects(this, m_mainWndGfx);
            m_linesManager = m_linesManager ? (m_linesManager) : (new LinesNovel(m_mainWndGfx));
            this.initButtons();
            m_winAnims = new WinsNovel(m_mi, m_mainWndGfx as Sprite, m_reels.getGlobalPositions(), m_linesManager);
            this.initWinTicker();
            this.m_promo = new PromoArea(m_mainWndGfx.getChildByName("promoArea") as Sprite);
            return;
        }// end function

        override protected function typeRestoreGame(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:int) : void
        {
            if (com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel == GameStates.STATE_AUTOPLAY)
            {
                ButtonsNovel(m_mainButtons).setAP(m_apMaster.getApLeft());
            }
            trace("::::::::::::::::::: typeRestoreGame()");
            this.setGambleEnabled(false);
            return;
        }// end function

        protected function gameBrokenGame(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:Array) : void
        {
            return;
        }// end function

        protected function gameHandleMarvelBroken(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:Array) : void
        {
            return;
        }// end function

        override public function updateTField(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:String, com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:String) : void
        {
            if (com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel == MainTxtFields.WIN_TF)
            {
                this.m_winticker.setValue(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
            }
            else
            {
                Console.write("TextResize.setTextFixY", this);
                TextResize.setTextFixY(TextField(m_mainTF[com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel]), com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
            }
            return;
        }// end function

        protected function endFsCmd() : ICommand
        {
            return new InfoWindowCmd(new FreespinsOutro(m_mi, m_mainWndGfx, this.m_fsManager.getGameWin(), this.m_fsManager.getFSWin()));
        }// end function

        override protected function transSymbols(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:Vector.<int>) : void
        {
            return;
        }// end function

        protected function addBlocker() : void
        {
            m_queue.add(new BlockCmd(ReelEffects.REEL_STOP_ANIMATION_ENDED, this.haveActiveReelStopAnimations));
            return;
        }// end function

        protected function gambleEnd() : void
        {
            Console.write("gambleEnd() " + this.m_gamble.getWin() + " " + m_roundInfo.totalwin, this);
            m_mainButtons.enableAll(true, m_state);
            (m_winAnims as WinsNovel).hideTexts(false);
            trace("::::::::::::::::::: gambleEnd()");
            this.setGambleEnabled(this.m_gamble.regamble());
            if (this.m_gamble.getWin() > 0)
            {
                if (this.m_gamble.getResult() == GambleResult.RESULT_WIN)
                {
                    this.m_winticker.execAnim(m_roundInfo.totalwin, this.m_gamble.getWin(), m_roundInfo.getTotalBet(), m_roundInfo.coinValue);
                    if (this.m_gamble.getWin() > m_roundInfo.totalwin && this.m_celebration.isWinValid(this.m_gamble.getWin(), m_roundInfo.getTotalBet(), m_state))
                    {
                        m_queue.add(new CommandObject(this.m_celebration.playCelebration));
                    }
                    m_queue.add(new CommandFunction(this.m_winticker.playTickSound));
                }
                else
                {
                    this.updateTField(MainTxtFields.WIN_TF, Money.format(this.m_gamble.getWin()));
                }
                m_mi.updateStatusBar("novel_infobar_totalwin", {TW:Money.format(this.m_gamble.getWin())});
                m_server.updateCredit(this.m_gamble.getWin() - m_roundInfo.totalwin);
            }
            else
            {
                m_server.updateCredit(-m_roundInfo.totalwin);
                var _loc_1:int = 0;
                m_roundInfo.totalwin = 0;
                this.updateTField(MainTxtFields.WIN_TF, Money.format(0));
                m_mi.updateStatusBar("novel_infobar_clickspin");
            }
            setInProgress(false);
            return;
        }// end function

        override public function dispose() : void
        {
            if (m_logicDone)
            {
                m_paytable.removeEventListener(PaytableBase.CLOSE_PAYTABLE, this.closePaytable);
                if (this.m_gamble)
                {
                    this.m_gamble.unload();
                    var _loc_3:String = null;
                    this.m_gamble = null;
                }
                this.m_celebration.dispose();
                var _loc_3:String = null;
                this.m_celebration = null;
                EventPool.removeEventListener(GameStates.EVENT_PREV_STATE, this.previousStateBack);
                EventPool.removeEventListener(GameStates.EVENT_NEW_STATE, this.newState);
                EventPool.removeEventListener(MessageWindowInfo.MESSAGE_CLOSING, this.afterFreeSpinMessage);
                EventPool.removeEventListener(GameStates.EVENT_RESET_All, this.resetAll);
            }
            super.dispose();
            this.clearWinAnims();
            var _loc_3:String = null;
            this.m_cWinAnims = null;
            var _loc_3:String = null;
            this.m_ambients = null;
            var _loc_3:String = null;
            this.m_cmdId = null;
            var _loc_1:* = this.m_anticip.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                this.m_anticip[_loc_2].dispose();
                _loc_2++;
            }
            var _loc_3:String = null;
            this.m_anticip = null;
            if (!m_gfxDone)
            {
                return;
            }
            this.m_reelEff.dispose();
            var _loc_3:String = null;
            this.m_reelEff = null;
            if (m_logicDone)
            {
                this.m_fsManager.dispose();
                var _loc_3:String = null;
                this.m_fsManager = null;
            }
            this.m_winticker.dispose();
            var _loc_3:String = null;
            this.m_winticker = null;
            this.m_promo.dispose();
            var _loc_3:String = null;
            this.m_promo = null;
            if (this.m_nrKindMsg != null)
            {
                this.m_nrKindMsg.dispose();
                var _loc_3:String = null;
                this.m_nrKindMsg = null;
            }
            return;
        }// end function

        protected function createWinAnims() : void
        {
            var _loc_1:int = 0;
            var _loc_3:WinInfo = null;
            var _loc_4:SlotsWin = null;
            var _loc_5:IWinAnimation = null;
            var _loc_6:Object = null;
            this.clearWinAnims();
            var _loc_2:* = m_roundInfo.wins.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                var _loc_7:* = m_roundInfo.wins[_loc_1] as WinInfo;
                _loc_3 = m_roundInfo.wins[_loc_1] as WinInfo;
                var _loc_7:* = _loc_3.win;
                _loc_4 = _loc_3.win;
                var _loc_7:* = _loc_4.animArgs;
                _loc_6 = _loc_4.animArgs;
                var _loc_7:* = _loc_3.frames_sufixes;
                _loc_6.frames_sufixes = _loc_3.frames_sufixes;
                var _loc_7:* = new _loc_4.animClass(m_winAnims, _loc_3.win, _loc_3.symbol_indexes, _loc_3.symbols, _loc_3.payline, _loc_6) as IWinAnimation;
                this.m_cWinAnims[_loc_1] = new _loc_4.animClass(m_winAnims, _loc_3.win, _loc_3.symbol_indexes, _loc_3.symbols, _loc_3.payline, _loc_6) as IWinAnimation;
                _loc_1++;
            }
            return;
        }// end function

        override protected function typeAfterSpin() : void
        {
            var _loc_2:WinInfo = null;
            var _loc_3:int = 0;
            m_resultGetter.sortWins(m_roundInfo.wins);
            this.createWinAnims();
            (m_mainButtons as ButtonsNovel).swapButton(GameButtons.STOP_BUTTON, GameButtons.SPIN_BUTTON);
            m_mainButtons.enable(GameButtons.SPIN_BUTTON, true);
            var _loc_1:* = m_roundInfo.wins.length;
            if (_loc_1 > 0)
            {
                this.m_promo.freeze(m_state == GameStates.STATE_FREESPIN ? (PromoEnum.TIME_SHORT_OTHER) : (PromoEnum.TIME_LONG_OTHER));
                if (m_state == GameStates.STATE_FREESPIN || m_state == GameStates.STATE_RESPIN && getPrevState() == GameStates.STATE_FREESPIN)
                {
                    this.m_fsManager.updateWin(m_roundInfo.totalwin);
                }
                _loc_2 = m_roundInfo.wins[(_loc_1 - 1)] as WinInfo;
                if (_loc_2.win.special != 0)
                {
                    m_mainButtons.enableAll(false, m_state);
                    this.beforeWinAnims();
                    this.addWinShowCommands(NEXT_IS_FEATURE);
                    this.beforeFeature(_loc_2.win);
                    m_queue.add(new CommandFunction(this.m_celebration.stopCelebration));
                    _loc_3 = 1;
                    while (_loc_2 != null && _loc_2.win.special != 0)
                    {
                        
                        this.startFeature(_loc_2.win);
                        var _loc_4:* = m_roundInfo.wins[_loc_1 - _loc_3] as WinInfo;
                        _loc_2 = m_roundInfo.wins[_loc_1 - _loc_3] as WinInfo;
                    }
                    m_queue.add(new CommandObject(this.m_winticker.waitEnd), new CommandFunction(this.afterFeature), new CommandTimer(800), new CommandFunction(this.gameEndRound), new CommandFunction(this.endRound, true));
                }
                else if (m_state == GameStates.STATE_NORMAL || m_state == GameStates.STATE_RESPIN && this.m_respinsLeft == 0 && getPrevState() == GameStates.STATE_NORMAL)
                {
                    this.gameEndRound();
                    this.endRound();
                    this.beforeWinAnims();
                    this.addWinShowCommands(NEXT_IS_IDLE);
                }
                else
                {
                    this.beforeWinAnims();
                    this.addWinShowCommands(NEXT_IS_MORE_SPINS);
                    m_queue.add(new CommandObject(this.m_winticker.waitEnd));
                    this.gameEndRound();
                    m_queue.add(new CommandTimer(250));
                    this.endRound();
                }
                if (m_state != GameStates.STATE_FREESPIN)
                {
                    if (this.mute_ambient_on_win_toggle)
                    {
                        m_mi.pauseSoundByID(this.m_ambientId);
                    }
                }
            }
            else
            {
                this.beforeWinAnims();
                this.gameEndRound();
                if (m_state != GameStates.STATE_NORMAL && (m_state != GameStates.STATE_RESPIN || this.m_respinsLeft != 0 || getPrevState() != GameStates.STATE_NORMAL))
                {
                    m_queue.add(new CommandTimer(1000));
                }
                this.endRound();
            }
            this.gameAfterSpin();
            return;
        }// end function

        private function waitClick(SPIN_COMMAND:String) : int
        {
            return 1;
        }// end function

        protected function startFeature(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:SlotsWin) : void
        {
            throw new Error("Cannot start the feature, override featureStart method");
        }// end function

        private function addMarvelJPWin() : void
        {
            var _loc_1:* = this.gameGetMarvelWin();
            var _loc_2:* = m_roundInfo.jpwin + _loc_1;
            m_roundInfo.jpwin = m_roundInfo.jpwin + _loc_1;
            finalizeTotalWin(_loc_1);
            return;
        }// end function

        override protected function typeSpecificLogic() : void
        {
            this.gameSpecificLogic();
            m_lineDef = PaylineDef.getLineDefByLines(GameParameters.maxLines);
            this.m_fsManager = new FreeSpins(m_mainWndGfx, this);
            (m_winAnims as WinsNovel).setRoundInfoObj(m_roundInfo);
            if (m_apMaster == null)
            {
                m_apMaster = new SimpleAP(this);
            }
            (m_mainButtons as ButtonsNovel).setAP(m_apMaster.getApLeft());
            this.m_celebration = new Celebration(m_gfx, m_mi, m_mainTF[MainTxtFields.WIN_TF]);
            m_paytable.addEventListener(PaytableBase.CLOSE_PAYTABLE, this.closePaytable);
            this.playAmbient(GameParameters.shortname + ".game_ambient");
            m_mi.updateStatusBar("novel_infobar_clickspin");
            EventPool.addEventListener(GameStates.EVENT_PREV_STATE, this.previousStateBack);
            EventPool.addEventListener(GameStates.EVENT_NEW_STATE, this.newState);
            EventPool.addEventListener(GameStates.EVENT_RESET_All, this.resetAll);
            return;
        }// end function

        protected function gameEnterMarvelJP() : Boolean
        {
            return false;
        }// end function

        public function gameBeforeMarvelJP(SPIN_COMMAND:String) : int
        {
            return 0;
        }// end function

        private function closePaytable(event:Event) : void
        {
            this.handleButtonEvent(GameButtons.PAYTABLE_CLOSE);
            return;
        }// end function

        protected function handleButtonEvent(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:String, com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel = null) : void
        {
            var _loc_3:ButtonsNovel = null;
            var _loc_4:int = 0;
            var _loc_5:CommandObject = null;
            var _loc_6:ICommand = null;
            var _loc_7:ICommand = null;
            Console.write("handleButtonEvent " + com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel + ", args " + com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel, this);
            this.m_winticker.stopTicking();
            switch(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel)
            {
                case GameButtons.SPIN_BUTTON:
                {
                    m_mi.pauseSoundByID(this.m_ambientId, false);
                    switch(m_state)
                    {
                        case GameStates.STATE_RESPIN:
                        case GameStates.STATE_FREESPIN:
                        {
                            m_queue.add(new this.FREE_SPIN_COMMAND(this));
                            break;
                        }
                        case GameStates.STATE_AUTOPLAY:
                        {
                            m_queue.add(new ApContinueCmd(this));
                            break;
                        }
                        default:
                        {
                            _loc_3 = m_mainButtons as ButtonsNovel;
                            m_mi.playAsEffect(NovelSoundMap.SOUND_SPIN);
                            m_queue.add(new this.SPIN_COMMAND(this));
                            break;
                        }
                    }
                    break;
                }
                case GameButtons.BETMAX_BUTTON:
                {
                    this.updateTField(MainTxtFields.WIN_TF, Money.format(0));
                    m_queue.add(new BetMaxCmd(this));
                    break;
                }
                case GameButtons.LINES_BUTTON:
                {
                    _loc_4 = m_roundInfo.getNumActiveLines();
                    if (_loc_4 == GameParameters.maxLines)
                    {
                        _loc_4 = 0;
                    }
                    m_linesManager.pressbutton(_loc_4);
                    break;
                }
                case GameButtons.LINEBET_BUTTON:
                {
                    m_queue.add(new LineBetCmd(this));
                    this.setGambleEnabled(false);
                    this.m_celebration.stopCelebration();
                    m_winAnims.stopAnim();
                    break;
                }
                case GameButtons.COIN_BUTTON:
                {
                    m_queue.add(new CoinChangeCmd(this, com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel));
                    this.setGambleEnabled(false);
                    this.m_celebration.stopCelebration();
                    m_winAnims.stopAnim();
                    break;
                }
                case GameButtons.LINE_BUTTON:
                {
                    m_queue.add(new LineCmd(this, com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel));
                    this.setGambleEnabled(false);
                    this.m_celebration.stopCelebration();
                    m_winAnims.stopAnim();
                    break;
                }
                case GameButtons.STOP_BUTTON:
                {
                    _loc_5 = new StopCmd(this);
                    _loc_5.execute(null);
                    _loc_5.clear();
                    break;
                }
                case GameButtons.GAMBLE_BUTTON:
                {
                    Console.write("GAMBLE  bet: " + m_roundInfo.totalwin, this);
                    if (this.m_nrKindMsg)
                    {
                        this.m_nrKindMsg.stopSnd();
                    }
                    if (this.m_gamble != null)
                    {
                        setInProgress(true);
                        m_mainButtons.enableAll(false, m_state);
                        this.m_gamble.addEventListener(GambleBase.EVT_CAN_GAMBLE, this.canGamble);
                        this.m_gamble.canGamble(m_roundInfo.totalwin);
                    }
                    else
                    {
                        Console.write("NO GAMBLE for this game", this);
                    }
                    break;
                }
                case FORWARD_BUTTON:
                {
                    (m_mainButtons as ButtonsNovel).swapButton(FORWARD_BUTTON, GameButtons.SPIN_BUTTON);
                    m_queue.jumpToCommand(this.m_forwardJump);
                    break;
                }
                case GameButtons.AP_VALUE:
                {
                    m_apMaster.setApLeft(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
                    break;
                }
                case GameButtons.AUTOSTART_BUTTON:
                {
                    _loc_6 = new ApStartCmd(this);
                    _loc_6.execute(null);
                    _loc_6.clear();
                    break;
                }
                case GameButtons.AUTOSTOP_BUTTON:
                {
                    _loc_7 = new ApStopCmd(this);
                    _loc_7.execute(null);
                    _loc_7.clear();
                    break;
                }
                case GameButtons.PAYTABLE_OPEN:
                {
                    m_mainButtons.enableAll(false, m_state);
                    m_mi.pauseSoundByID(this.m_ambientId);
                    m_winAnims.pause();
                    m_mi.muteSoundBySource();
                    this.m_celebration.hideCelebration(true);
                    this.openPaytable(m_roundInfo.wins);
                    this.m_winticker.mute(true);
                    break;
                }
                case GameButtons.PAYTABLE_CLOSE:
                {
                    m_mainButtons.enableAll(true, m_state);
                    if (this.m_gamble != null && !this.m_canGamble)
                    {
                        m_mainButtons.enable(GameButtons.GAMBLE_BUTTON, false);
                    }
                    this.m_celebration.hideCelebration(false);
                    m_paytable.closePaytable();
                    hideMainGameWnd(false);
                    m_mi.pauseSoundByID(this.m_ambientId, false);
                    m_winAnims.pause(false);
                    m_mi.muteSoundBySource(null, false);
                    this.m_winticker.mute(false);
                    break;
                }
                case GameButtons.START_BUTTON:
                {
                    m_mi.playAsEffect(NovelSoundMap.SOUND_CLICK_TO_START);
                    this.startClicked();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function gameGetLastMarvelWin() : Number
        {
            return 0;
        }// end function

        protected function calculateWinAmouts() : Number
        {
            var _loc_6:Wins = null;
            var _loc_7:int = 0;
            var _loc_9:Number = NaN;
            var _loc_10:WinInfo = null;
            var _loc_11:SlotsWin = null;
            var _loc_1:Number = 0;
            var _loc_2:* = m_state == GameStates.STATE_FREESPIN || m_state == GameStates.STATE_RESPIN && getPrevState() == GameStates.STATE_FREESPIN ? (this.m_fsManager.getMultiplier()) : (1);
            var _loc_3:* = m_roundInfo.getLineBet() * _loc_2;
            var _loc_4:* = m_roundInfo.getTotalBet() * _loc_2;
            var _loc_5:* = SlotsWin.ANYWHERE;
            _loc_6 = m_roundInfo.wins;
            var _loc_8:* = _loc_6.length;
            _loc_7 = 0;
            while (_loc_7 < _loc_8)
            {
                
                var _loc_12:* = _loc_6[_loc_7] as WinInfo;
                _loc_10 = _loc_6[_loc_7] as WinInfo;
                var _loc_12:* = _loc_10.win;
                _loc_11 = _loc_10.win;
                var _loc_12:* = _loc_11.type == _loc_5 ? (_loc_4) : (_loc_3);
                _loc_9 = _loc_11.type == _loc_5 ? (_loc_4) : (_loc_3);
                var _loc_12:* = _loc_9 * _loc_11.payout;
                _loc_9 = _loc_9 * _loc_11.payout;
                var _loc_12:* = _loc_9;
                _loc_11.win = _loc_9;
                var _loc_12:* = _loc_1 + _loc_9;
                _loc_1 = _loc_1 + _loc_9;
                _loc_7++;
            }
            return _loc_1;
        }// end function

        protected function gameGetMarvelWin() : Number
        {
            return 0;
        }// end function

        protected function setGambleEnabled(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:Boolean) : void
        {
            if (!this.m_gamble)
            {
                return;
            }
            Console.write(".setGambleEnabled() -> is_gamble_enabled: " + com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel, this);
            var _loc_2:* = m_roundInfo.totalwin == 0 ? (false) : (com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
            com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel = m_roundInfo.totalwin == 0 ? (false) : (com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
            m_mainButtons.enable(GameButtons.GAMBLE_BUTTON, com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
            var _loc_2:* = com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel;
            this.m_canGamble = com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel;
            return;
        }// end function

        protected function initButtons() : void
        {
            m_mainButtons = new this.ButtonsNovelClass(m_mi, m_mainWndGfx.getChildByName("mainButtons") as DisplayObjectContainer, this.handleButtonEvent, m_linesManager.getButtons());
            return;
        }// end function

        private function winCycle1End(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:int) : void
        {
            var _loc_2:Boolean = false;
            switch(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel)
            {
                case NEXT_IS_IDLE:
                {
                    var _loc_3:Boolean = true;
                    _loc_2 = true;
                    m_mi.pauseSoundByID(this.m_ambientId, false);
                    this.m_winticker.playTickSound();
                    break;
                }
                case NEXT_IS_FEATURE:
                {
                    this.m_winticker.playTickSound(NovelSoundMap.NORMAL_WIN_INCREASE);
                    break;
                }
                case NEXT_IS_MORE_SPINS:
                {
                    m_mi.pauseSoundByID(this.m_ambientId, false);
                    this.m_winticker.playTickSound();
                    var _loc_3:* = this.m_winticker.isTicking() && !this.m_cWinAnims[(this.m_cWinAnims.length - 1)].isBlockingToggle();
                    _loc_2 = this.m_winticker.isTicking() && !this.m_cWinAnims[(this.m_cWinAnims.length - 1)].isBlockingToggle();
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (_loc_2)
            {
                m_winAnims.showWins(this.m_cWinAnims, WinsNovel.PHASE_2, null);
            }
            return;
        }// end function

        protected function gameBeforeWinAnims() : void
        {
            return;
        }// end function

        protected function finishBrokenGame() : void
        {
            m_queue.add(new CommandObject(this.m_winticker.waitEnd), new CommandFunction(this.afterFeature), new CommandFunction(this.endRound, true), new CommandFunction(this.restoreGambleButton));
            return;
        }// end function

        public function gameRunMarvelJP(SPIN_COMMAND:String) : int
        {
            return 0;
        }// end function

        private function beforeBonusStart() : void
        {
            m_winAnims.stopAnim();
            this.m_winticker.stopTicking();
            m_mi.stopSoundsBySource("bonus");
            m_mi.updateStatusBar(null);
            return;
        }// end function

        protected function startRespins(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:int) : void
        {
            var _loc_2:* = com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel;
            this.m_respinsLeft = com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel;
            setState(GameStates.STATE_RESPIN);
            return;
        }// end function

        private function startClicked() : void
        {
            (m_mainButtons as ButtonsNovel).swapButton(GameButtons.START_BUTTON, GameButtons.SPIN_BUTTON);
            m_mainButtons.enable(GameButtons.SPIN_BUTTON, false);
            m_queue.jumpToCommand(this.m_cmdId.shift());
            ServerNovel(m_server).startBonusCmd();
            return;
        }// end function

        final private function endFreespinState() : void
        {
            setPrevStateBack();
            m_winAnims.stopAnim();
            this.clearWinAnims();
            m_roundInfo.wins.clear();
            var _loc_1:* = this.m_fsManager.getGameWin() + this.m_fsManager.getFSWin();
            m_mi.updateStatusBar("novel_infobar_totalwin", {TW:Money.format(_loc_1)});
            m_mi.stopSoundByID(this.m_ambientId);
            m_queue.addParallel(this.endFsCmd());
            return;
        }// end function

        protected function addBonusMoney(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:Number, com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:Boolean = true) : void
        {
            if (com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel == true)
            {
                this.m_winticker.execAnim(m_roundInfo.totalwin, com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel + m_roundInfo.totalwin, m_roundInfo.getTotalBet(), m_roundInfo.coinValue);
                if (m_state == GameStates.STATE_FREESPIN)
                {
                    this.m_fsManager.updateWin(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
                }
            }
            finalizeTotalWin(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
            m_mi.flushPooledCredit();
            return;
        }// end function

        public function getFsManager() : FreeSpins
        {
            return this.m_fsManager;
        }// end function

        override public function toString() : String
        {
            return "[TypeNovel] ";
        }// end function

        protected function initReels() : void
        {
            m_reels = new ReelsNovel(m_mainWndGfx.getChildByName("reels") as Sprite, m_reelstrips);
            return;
        }// end function

        private function endRound(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:Boolean = false) : void
        {
            var _loc_2:ApContinueCmd = null;
            var _loc_3:ICommand = null;
            var _loc_4:ICommand = null;
            var _loc_5:CommandFunction = null;
            var _loc_6:int = 0;
            var _loc_7:Boolean = false;
            var _loc_8:Boolean = false;
            var _loc_9:CommandFunction = null;
            m_mi.allowCreditSync();
            switch(m_state)
            {
                case GameStates.STATE_NORMAL:
                {
                    if (com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel)
                    {
                        this.newGameRound();
                    }
                    else
                    {
                        m_queue.add(new CommandFunction(this.newGameRound));
                    }
                    break;
                }
                case GameStates.STATE_AUTOPLAY:
                {
                    setInProgress(false);
                    if (m_apMaster.getApLeft() == 0)
                    {
                        (m_mainButtons as ButtonsNovel).swapButton(GameButtons.SPIN_BUTTON, FORWARD_BUTTON);
                        m_queue.add(new CommandFunction((m_mainButtons as ButtonsNovel).swapButton, FORWARD_BUTTON, GameButtons.SPIN_BUTTON));
                    }
                    m_queue.add(new CommandObject(TMUFreeze.blocker));
                    _loc_2 = new ApContinueCmd(this, true);
                    m_queue.add(_loc_2);
                    var _loc_10:* = _loc_2.getId();
                    this.m_forwardJump = _loc_2.getId();
                    break;
                }
                case GameStates.STATE_FREESPIN:
                {
                    if (this.m_fsManager.getFS() == 0)
                    {
                        (m_mainButtons as ButtonsNovel).swapButton(GameButtons.SPIN_BUTTON, FORWARD_BUTTON);
                        var _loc_10:* = this.m_fsManager.getFSWin() + this.m_fsManager.getGameWin();
                        m_roundInfo.totalwin = this.m_fsManager.getFSWin() + this.m_fsManager.getGameWin();
                        _loc_3 = new CommandFunction(this.endFreespinState);
                        _loc_4 = new CommandFunction((m_mainButtons as ButtonsNovel).swapButton, FORWARD_BUTTON, GameButtons.SPIN_BUTTON);
                        _loc_5 = new CommandFunction(this.fsWndClosed);
                        EventPool.addEventListener(MessageWindowInfo.MESSAGE_CLOSING, this.afterFreeSpinMessage);
                        _loc_6 = getPrevState();
                        _loc_7 = NovelParameters.fsFullEnd;
                        _loc_8 = this.m_celebration.isWinValid(this.m_fsManager.getGameWin() + this.m_fsManager.getFSWin(), m_roundInfo.getTotalBet(), getPrevState());
                        if (_loc_6 == GameStates.STATE_NORMAL)
                        {
                            if (_loc_7)
                            {
                                m_queue.add(_loc_3, _loc_4, new CommandFunction(m_mainButtons.enableAll, false, GameStates.STATE_FREESPIN));
                                if (_loc_8)
                                {
                                    m_queue.add(new CommandFunction(this.newGameRound), new CommandObject(this.m_celebration.playCelebration, null, this.m_celebration.stopCelebration), _loc_5);
                                    m_queue.add(new CommandFunction(this.m_winticker.playTickSound));
                                }
                                else
                                {
                                    m_queue.add(_loc_5, new CommandFunction(this.newGameRound));
                                }
                            }
                            else if (_loc_8)
                            {
                                m_queue.add(_loc_3, _loc_4, new CommandFunction(this.newGameRound));
                                m_queue.add(new CommandObject(this.m_celebration.playCelebration, null, this.m_celebration.stopCelebration), _loc_5);
                                m_queue.add(new CommandFunction(this.m_winticker.playTickSound));
                            }
                            else
                            {
                                m_queue.add(_loc_3, _loc_4, new CommandFunction(this.newGameRound));
                                m_queue.add(_loc_5);
                            }
                        }
                        else
                        {
                            if (_loc_7)
                            {
                                m_queue.add(_loc_3, _loc_4, new CommandFunction(m_mainButtons.enableAll, false, GameStates.STATE_FREESPIN));
                                m_queue.add(_loc_5);
                                m_queue.add(new CommandFunction(setInProgress, false), new CommandFunction(m_mainButtons.enableAll, false, _loc_6));
                            }
                            else
                            {
                                m_queue.add(_loc_3, _loc_4, new CommandFunction(setInProgress, false), new CommandFunction(m_mainButtons.enableAll, false, _loc_6));
                                m_queue.add(_loc_5);
                            }
                            if (_loc_8)
                            {
                                m_queue.add(new CommandObject(this.m_celebration.playCelebration, null, this.m_celebration.stopCelebration));
                            }
                        }
                        var _loc_10:* = _loc_3.getId();
                        this.m_forwardJump = _loc_3.getId();
                    }
                    else
                    {
                        m_queue.add(new CommandObject(TMUFreeze.blocker));
                        m_queue.add(new this.FREE_SPIN_COMMAND(this, true));
                    }
                    break;
                }
                case GameStates.STATE_RESPIN:
                {
                    if (this.m_respinsLeft == 0)
                    {
                        setPrevStateBack();
                        _loc_9 = new CommandFunction(this.endRound, true);
                        m_queue.add(_loc_9);
                        if (m_state == GameStates.STATE_FREESPIN && this.m_fsManager.getFS() == 0)
                        {
                            (m_mainButtons as ButtonsNovel).swapButton(GameButtons.SPIN_BUTTON, FORWARD_BUTTON);
                            var _loc_10:* = _loc_9.getId();
                            this.m_forwardJump = _loc_9.getId();
                        }
                    }
                    else
                    {
                        m_queue.add(new CommandObject(TMUFreeze.blocker));
                        m_queue.add(new this.FREE_SPIN_COMMAND(this, true));
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function gameStopSpin() : void
        {
            var _loc_1:* = AnticipationCalculator.getResult(m_roundInfo.reelSymbols.symbols, this.m_anticip);
            var _loc_2:* = GameParameters.numReels;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                m_queue.add(new CommandObject(m_reels.stopSpin, [m_roundInfo.results[_loc_3], _loc_3, _loc_1[_loc_3] ? (ReelSpinInfo.ANTICIPATION_STOP) : (ReelSpinInfo.NORMAL_STOP)]));
                _loc_3++;
            }
            return;
        }// end function

        protected function beforeFeature(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:SlotsWin) : void
        {
            throw new Error("Cannot start the feature, override beforeFeature method");
        }// end function

        protected function gameAfterFreeSpinMsg() : void
        {
            return;
        }// end function

        protected function gameSpecificLogic() : void
        {
            throw new Error("Cannot init the game specific logic (paytable etc.), override gameSpecificLogic method");
        }// end function

        protected function gameAfterSpin() : void
        {
            return;
        }// end function

        public function getWinAnims() : Vector.<IWinAnimation>
        {
            return this.m_cWinAnims;
        }// end function

        protected function initTextFields() : void
        {
            m_mainTF[MainTxtFields.LINE_BET_TF] = m_mainWndGfx.getChildByName(MainTxtFields.LINE_BET_TF);
            m_mainTF[MainTxtFields.LINES_TF] = m_mainWndGfx.getChildByName(MainTxtFields.LINES_TF);
            m_mainTF[MainTxtFields.TOTAL_BET_TF] = m_mainWndGfx.getChildByName(MainTxtFields.TOTAL_BET_TF);
            m_mainTF[MainTxtFields.WIN_TF] = m_mainWndGfx.getChildByName(MainTxtFields.WIN_TF);
            TextField(m_mainTF[MainTxtFields.LINE_BET_TF]).mouseEnabled = false;
            TextField(m_mainTF[MainTxtFields.LINES_TF]).mouseEnabled = false;
            TextField(m_mainTF[MainTxtFields.TOTAL_BET_TF]).mouseEnabled = false;
            TextField(m_mainTF[MainTxtFields.WIN_TF]).mouseEnabled = false;
            return;
        }// end function

        protected function gameEndRound() : void
        {
            return;
        }// end function

        protected function afterFeature() : void
        {
            var _loc_1:CommandObject = null;
            if (this.m_celebration.isWinValid(m_roundInfo.totalwin, m_roundInfo.getTotalBet(), m_state))
            {
                _loc_1 = new CommandObject(this.m_celebration.playCelebration, null, this.m_celebration.stopCelebration);
                m_queue.addParallel(_loc_1);
                m_queue.registerListener(_loc_1.getId(), this.m_winticker.playTickSound);
            }
            m_mainButtons.enableAll(true, m_state);
            m_mi.pauseSoundByID(this.m_ambientId, false);
            if (this.m_winticker.isTicking())
            {
                this.clearWinAnims();
                this.m_winticker.playTickSound();
                m_mainButtons.enable(GameButtons.SPIN_BUTTON, true);
            }
            return;
        }// end function

        private function fsEndTick() : void
        {
            var _loc_1:* = this.m_fsManager.getGameWin() + this.m_fsManager.getFSWin();
            this.m_winticker.execAnim(this.m_fsManager.getGameWin(), _loc_1, m_roundInfo.getTotalBet(), m_roundInfo.coinValue);
            this.m_winticker.playTickSound();
            return;
        }// end function

        protected function openPaytable(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:Wins) : void
        {
            hideMainGameWnd();
            m_paytable.openPaytable(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
            return;
        }// end function

        private function canGamble(event:RegularEvent) : void
        {
            Console.write("canGamble() " + event.data, this);
            this.m_gamble.removeEventListener(GambleBase.EVT_CAN_GAMBLE, this.canGamble);
            var _loc_2:* = event.data;
            if (_loc_2 == false)
            {
                Console.write("Can\'t gamble", this);
                setInProgress(false);
                m_mainButtons.enableAll(true, m_state);
                m_mi.openDialog(SharedDialog.ALERT, m_mi.readAlert(19));
                return;
            }
            Console.write("Start the gamble", this);
            (m_winAnims as WinsNovel).hideTexts(true);
            m_mi.updateStatusBar(null);
            var _loc_3:* = new CommandObject(this.m_gamble.start, [m_roundInfo.totalwin, this.m_ambientId, null], null, false);
            m_queue.add(_loc_3);
            m_queue.add(new CommandFunction(this.gambleEnd));
            return;
        }// end function

        override public function typeBrokenHandler(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:Vector.<String>) : void
        {
            var _loc_3:Array = null;
            var _loc_4:String = null;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_11:Array = null;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:String = null;
            var _loc_15:RegExp = null;
            var _loc_16:int = 0;
            var _loc_17:Vector.<int> = null;
            var _loc_18:Array = null;
            var _loc_19:int = 0;
            Console.write("typeBrokenHandler " + com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel, this);
            m_mainButtons.enableAll(false, GameStates.STATE_FREESPIN);
            var _loc_2:* = com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel.length;
            var _loc_5:Array = [];
            var _loc_6:int = 0;
            while (_loc_6 < _loc_2)
            {
                
                var _loc_20:* = com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel.shift().split(FS);
                _loc_3 = com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel.shift().split(FS);
                var _loc_20:* = _loc_3.shift();
                _loc_4 = _loc_3.shift();
                switch(_loc_4)
                {
                    case "reelinfo":
                    {
                        var _loc_20:* = this.Vector.<int>(_loc_3);
                        m_roundInfo.results = this.Vector.<int>(_loc_3);
                        m_reels.showResult(m_roundInfo.results, m_roundInfo.reelSymbols.symbols);
                        break;
                    }
                    case "freespins":
                    {
                        this.m_fsManager.setFS(_loc_3.shift());
                        _loc_7 = _loc_3.shift();
                        var _loc_20:* = _loc_7;
                        m_roundInfo.coinValue = _loc_7;
                        m_mainButtons.setCoinValue(_loc_7);
                        _loc_9 = GameParameters.maxLines;
                        _loc_10 = 0;
                        while (_loc_10 < _loc_9)
                        {
                            
                            var _loc_20:* = _loc_8 + int(_loc_3.shift());
                            _loc_8 = _loc_8 + int(_loc_3.shift());
                            _loc_10++;
                        }
                        m_roundInfo.activateLine(RoundInfo.ACTIVATE_MULTI_ID, (_loc_8 - 1));
                        m_linesManager.updateButtons(m_roundInfo.getActiveBets());
                        _loc_11 = [];
                        _loc_13 = _loc_3.length;
                        _loc_15 = new RegExp("^multiplier=", "i");
                        _loc_16 = 0;
                        while (_loc_16 < _loc_13)
                        {
                            
                            var _loc_20:* = _loc_3.shift();
                            _loc_14 = _loc_3.shift();
                            if (_loc_14.indexOf("coins=") != -1)
                            {
                                m_roundInfo.changeLineBet(RoundInfo.LINEBET_VALUE, int(_loc_14.substr(6)));
                            }
                            else if (_loc_15.test(_loc_14))
                            {
                                this.m_fsManager.setMultiplier(int(_loc_14.substr(11)));
                            }
                            else if (_loc_14.indexOf("mode=") != -1)
                            {
                                var _loc_20:* = int(_loc_14.substr(5));
                                _loc_12 = int(_loc_14.substr(5));
                                _loc_11.push(_loc_14);
                            }
                            else if (_loc_14.indexOf("gamewin=") != -1)
                            {
                                var _loc_20:* = Number(_loc_14.substr(8));
                                m_roundInfo.totalwin = Number(_loc_14.substr(8));
                            }
                            else if (_loc_14.indexOf("freespinwin=") != -1)
                            {
                                this.m_fsManager.setFSWin(Number(_loc_14.substr(12)));
                            }
                            else if (_loc_14.indexOf("freespin_trigger_reels=") != -1)
                            {
                                _loc_17 = this.Vector.<int>(_loc_14.substr(23).split(","));
                                this.m_fsManager.setTriggeredReels(_loc_17, new ReelsSymbolsState(m_reelstrips.getSymbolsFromPositions(_loc_17)));
                            }
                            else
                            {
                                _loc_11.push(_loc_14);
                            }
                            _loc_16++;
                        }
                        this.updateTField(MainTxtFields.LINE_BET_TF, Money.format(m_roundInfo.getLineBet()));
                        this.updateTField(MainTxtFields.LINES_TF, m_roundInfo.getNumActiveLines().toString());
                        this.updateTField(MainTxtFields.TOTAL_BET_TF, Money.format(m_roundInfo.getTotalBet()));
                        if (_loc_11.length != 0)
                        {
                            _loc_11.unshift(_loc_4);
                            _loc_5.push(_loc_11);
                        }
                        break;
                    }
                    case "mrj":
                    {
                        _loc_18 = [];
                        _loc_19 = 0;
                        while (_loc_19 < 4)
                        {
                            
                            var _loc_20:* = com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel.shift();
                            _loc_18[_loc_19] = com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel.shift();
                            _loc_19++;
                        }
                        var _loc_20:* = _loc_2 - 4;
                        _loc_2 = _loc_2 - 4;
                        this.gameHandleMarvelBroken(_loc_18);
                        break;
                    }
                    default:
                    {
                        _loc_3.unshift(_loc_4);
                        _loc_5.push(_loc_3);
                        break;
                    }
                }
                _loc_6++;
            }
            m_mi.updateStatusBar(null);
            m_mi.pauseSoundByID(this.m_ambientId);
            setInProgress(true);
            if (_loc_5.length != 0)
            {
                this.gameBrokenGame(_loc_5);
            }
            this.finishBrokenGame();
            return;
        }// end function

        protected function afterSpinResponse() : void
        {
            this.continueSpinResponse();
            return;
        }// end function

        protected function clearWinAnims() : void
        {
            var _loc_1:IWinAnimation = null;
            for each (_loc_4 in this.m_cWinAnims)
            {
                
                _loc_1 = _loc_3[_loc_2];
                _loc_1.dispose();
            }
            var _loc_2:* = new Vector.<IWinAnimation>;
            this.m_cWinAnims = new Vector.<IWinAnimation>;
            return;
        }// end function

        private function beforeWinAnims() : void
        {
            var _loc_1:int = 0;
            var _loc_2:Function = null;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:int = 0;
            if (NovelParameters.nrOfKind != -1)
            {
                var _loc_6:Boolean = false;
                this.m_nrOfKind = false;
                _loc_1 = this.m_cWinAnims.length;
                _loc_3 = NovelParameters.nrOfKind;
                _loc_4 = -1;
                _loc_5 = 0;
                while (_loc_5 < _loc_1)
                {
                    
                    Console.write(this.m_cWinAnims[_loc_5].slotswin.count + " Nr OF SYMBOLS " + _loc_3);
                    if (this.m_cWinAnims[_loc_5].slotswin.count >= _loc_3)
                    {
                        var _loc_6:* = this.m_cWinAnims[_loc_5].slotswin.count;
                        _loc_3 = this.m_cWinAnims[_loc_5].slotswin.count;
                        var _loc_6:* = _loc_5;
                        _loc_4 = _loc_5;
                        var _loc_6:Boolean = true;
                        this.m_nrOfKind = true;
                    }
                    _loc_5++;
                }
                if (this.m_nrOfKind)
                {
                    var _loc_6:* = _loc_4;
                    _loc_5 = _loc_4;
                    if (this.m_nrKindMsg == null)
                    {
                        var _loc_6:* = new NrOfKindMessage(this.m_promo, m_mi);
                        this.m_nrKindMsg = new NrOfKindMessage(this.m_promo, m_mi);
                    }
                    var _loc_6:* = this.m_cWinAnims[(_loc_1 - 1)].slotswin.special != 0 ? (this.m_nrKindMsg.stopSnd) : (this.m_nrKindMsg.cancel);
                    _loc_2 = this.m_cWinAnims[(_loc_1 - 1)].slotswin.special != 0 ? (this.m_nrKindMsg.stopSnd) : (this.m_nrKindMsg.cancel);
                    m_queue.add(new CommandObject(this.m_nrKindMsg.showMessage, [GameParameters.shortname + ".kind" + this.m_cWinAnims[_loc_5].slotswin.count, m_roundInfo.totalwin], _loc_2));
                }
            }
            this.gameBeforeWinAnims();
            return;
        }// end function

        protected function restoreGambleButton() : void
        {
            if (!this.m_gamble)
            {
                return;
            }
            Console.write(".restoreGambleButton() -> round win: " + m_roundInfo.totalwin + " regamble: " + this.m_gamble.regamble() + " " + this.m_gamble.getResult(), this);
            var _loc_1:* = m_roundInfo.totalwin > 0 && this.m_gamble.getResult() == GambleResult.RESULT_OTHER;
            this.setGambleEnabled(_loc_1);
            return;
        }// end function

        override public function typeStartSpin() : void
        {
            m_winAnims.stopAnim();
            this.m_celebration.stopCelebration();
            m_paytable.reset();
            var _loc_1:* = this.m_winticker.getWaitingTime();
            if (_loc_1 > 50)
            {
                m_queue.add(new CommandTimer(_loc_1 - 40));
                m_queue.add(new CommandFunction(this.activateSpin));
            }
            else
            {
                this.activateSpin();
            }
            return;
        }// end function

        private function addWinShowCommands(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:int) : void
        {
            var _loc_2:* = m_state != GameStates.STATE_AUTOPLAY ? (m_winAnims.stopAnim) : (null);
            var _loc_3:* = new CommandObject(m_winAnims.showWins, [this.m_cWinAnims, WinsNovel.PHASE_1], _loc_2);
            var _loc_4:* = new CommandFunction(this.m_winticker.execAnim, 0, m_roundInfo.totalwin, m_roundInfo.getTotalBet(), m_roundInfo.coinValue);
            if (this.have_game_started_ticker)
            {
                var _loc_6:* = new CommandFunction(this.m_winticker.continueAnim, m_roundInfo.totalwin, m_roundInfo.getTotalBet(), m_roundInfo.coinValue);
                _loc_4 = new CommandFunction(this.m_winticker.continueAnim, m_roundInfo.totalwin, m_roundInfo.getTotalBet(), m_roundInfo.coinValue);
            }
            _loc_4.setDeleteFunc(this.m_winticker.setValue, Money.format(m_roundInfo.totalwin), true);
            var _loc_5:* = this.m_celebration.isWinValid(m_roundInfo.totalwin, m_roundInfo.getTotalBet(), m_state);
            if (_loc_5)
            {
                m_queue.add(new CommandObject(this.m_celebration.playCelebration, null, this.m_celebration.stopCelebration), _loc_4);
                m_queue.add(_loc_3);
            }
            else if (m_state == GameStates.STATE_FREESPIN)
            {
                m_queue.add(_loc_4, _loc_3, new CommandFunction(this.m_winticker.playTickSound));
            }
            else
            {
                m_queue.add(_loc_4, _loc_3);
            }
            m_queue.registerListener(_loc_3.getId(), this.winCycle1End, com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
            return;
        }// end function

        public function playAmbient(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:String) : void
        {
            var _loc_2:int = 0;
            m_mi.stopSoundByID(this.m_ambientId);
            if (com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel === null)
            {
                this.m_ambients.pop();
                _loc_2 = this.m_ambients.length;
                if (_loc_2 > 0)
                {
                    var _loc_3:* = m_mi.playAsAmbient(this.m_ambients[(_loc_2 - 1)]);
                    this.m_ambientId = m_mi.playAsAmbient(this.m_ambients[(_loc_2 - 1)]);
                }
                else
                {
                    var _loc_3:int = -1;
                    this.m_ambientId = -1;
                }
            }
            else
            {
                var _loc_3:* = m_mi.playAsAmbient(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
                this.m_ambientId = m_mi.playAsAmbient(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
                this.m_ambients.push(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel);
            }
            return;
        }// end function

        public function addMarvelJP() : void
        {
            var _loc_1:CommandObject = null;
            var _loc_2:CommandFunction = null;
            if (this.gameEnterMarvelJP())
            {
                this.addMarvelJPWin();
                var _loc_3:* = new CommandObject(this.gameRunMarvelJP);
                _loc_1 = new CommandObject(this.gameRunMarvelJP);
                m_queue.add(new CommandFunction((m_mainButtons as ButtonsNovel).swapButton, GameButtons.STOP_BUTTON, GameButtons.SPIN_BUTTON), new CommandFunction(m_mainButtons.enable, GameButtons.SPIN_BUTTON, false));
                m_queue.add(new CommandObject(this.gameBeforeMarvelJP));
                m_queue.add(new CommandFunction(hideMainGameWnd, true), _loc_1);
                m_queue.add(new CommandFunction(hideMainGameWnd, false));
                if (m_roundInfo.totalwin == this.gameGetLastMarvelWin())
                {
                    _loc_2 = new CommandFunction(this.m_winticker.execAnim, 0, m_roundInfo.totalwin, m_roundInfo.getTotalBet(), m_roundInfo.coinValue);
                    m_queue.add(_loc_2, new CommandFunction(this.m_winticker.playTickSound), new CommandFunction(m_mainButtons.enableAll, true, m_state), new CommandObject(this.m_winticker.waitEnd));
                }
            }
            return;
        }// end function

        private function newState(event:GameStateEvent) : void
        {
            switch(event.newState)
            {
                case GameStates.STATE_AUTOPLAY:
                {
                    (m_mainButtons as ButtonsNovel).swapButton(GameButtons.AUTOSTART_BUTTON, GameButtons.AUTOSTOP_BUTTON);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function resetAll(event:Event) : void
        {
            var _loc_2:* = new Vector.<int>;
            this.m_cmdId = new Vector.<int>;
            this.m_fsManager.dispose();
            var _loc_2:* = new FreeSpins(m_mainWndGfx, this);
            this.m_fsManager = new FreeSpins(m_mainWndGfx, this);
            var _loc_2:int = 0;
            this.m_respinsLeft = 0;
            var _loc_2:* = [];
            this.m_ambients = [];
            this.setGambleEnabled(false);
            this.m_winticker.mute(false);
            (m_mainButtons as ButtonsNovel).setAP(m_apMaster.getApLeft());
            (m_mainButtons as ButtonsNovel).swapButton(GameButtons.AUTOSTOP_BUTTON, GameButtons.AUTOSTART_BUTTON);
            (m_mainButtons as ButtonsNovel).swapButton(GameButtons.STOP_BUTTON, GameButtons.SPIN_BUTTON);
            return;
        }// end function

        private function activateSpin() : void
        {
            var _loc_1:Boolean = false;
            this.have_game_started_ticker = false;
            this.gameStartSpin();
            this.updateTField(MainTxtFields.WIN_TF, Money.format(0));
            switch(m_state)
            {
                case GameStates.STATE_FREESPIN:
                {
                    this.m_fsManager.newRoundStarted();
                    this.m_fsManager.updateHeaderWin();
                    break;
                }
                case GameStates.STATE_AUTOPLAY:
                {
                    (m_mainButtons as ButtonsNovel).setAP(m_apMaster.getApLeft());
                    break;
                }
                case GameStates.STATE_RESPIN:
                {
                    var _loc_1:String = this;
                    _loc_1.m_respinsLeft = this.m_respinsLeft - 1;
                    if (getPrevState() == GameStates.STATE_FREESPIN)
                    {
                        this.m_fsManager.updateHeaderWin();
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function initWinTicker() : void
        {
            this.m_winticker = new SlotWinTicker(m_mainTF[MainTxtFields.WIN_TF], m_mi, getState);
            return;
        }// end function

        public function getCurrentAmbient() : int
        {
            return this.m_ambientId;
        }// end function

        private function previousStateBack(event:GameStateEvent) : void
        {
            switch(event.oldState)
            {
                case GameStates.STATE_AUTOPLAY:
                {
                    (m_mainButtons as ButtonsNovel).swapButton(GameButtons.AUTOSTOP_BUTTON, GameButtons.AUTOSTART_BUTTON);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function afterFreeSpinMessage(event:Event) : void
        {
            EventPool.removeEventListener(MessageWindowInfo.MESSAGE_CLOSING, this.afterFreeSpinMessage);
            if (this.m_fsManager.getFeatureReels() != null)
            {
                m_reels.showResult(this.m_fsManager.getFeatureReels(), this.m_fsManager.getFeatureSymbols());
                var _loc_2:* = this.m_fsManager.getFeatureReels();
                m_roundInfo.results = this.m_fsManager.getFeatureReels();
                this.m_fsManager.setTriggeredReels(null, null);
            }
            this.m_fsManager.removeAssets();
            this.updateTField(MainTxtFields.WIN_TF, Money.format(this.m_fsManager.getGameWin()));
            this.gameAfterFreeSpinMsg();
            return;
        }// end function

        protected function continueSpinResponse() : void
        {
            this.gameStopSpin();
            this.addBlocker();
            this.addMarvelJP();
            m_queue.add(new CommandFunction(afterSpin));
            if (m_state == GameStates.STATE_RESPIN)
            {
                m_mainButtons.enable(GameButtons.SPIN_BUTTON, false);
            }
            else
            {
                (m_mainButtons as ButtonsNovel).swapButton(GameButtons.SPIN_BUTTON, GameButtons.STOP_BUTTON);
                m_mainButtons.enable(GameButtons.STOP_BUTTON, true);
            }
            return;
        }// end function

        private function fsWndClosed() : void
        {
            if (m_state == GameStates.STATE_AUTOPLAY)
            {
                m_queue.add(new CommandFunction(this.fsEndTick), new CommandFunction(m_mainButtons.enable, GameButtons.SPIN_BUTTON, true));
                m_queue.add(new CommandObject(this.m_winticker.waitEnd));
                m_queue.add(new CommandTimer(300));
                m_queue.add(new CommandObject(TMUFreeze.blocker));
                m_queue.add(new ApContinueCmd(this, true));
            }
            else
            {
                this.fsEndTick();
            }
            return;
        }// end function

        protected function gameSpecificGraphics() : void
        {
            return;
        }// end function

        protected function gameStartSpin() : void
        {
            var _loc_1:int = 0;
            while (_loc_1 < GameParameters.numReels)
            {
                
                m_reels.startSpin(0, _loc_1);
                _loc_1++;
            }
            return;
        }// end function

        protected function haveActiveReelStopAnimations() : Boolean
        {
            return this.m_reelEff.have_active_animations;
        }// end function

        override public function newGameRound() : void
        {
            setInProgress(false);
            m_mainButtons.enableAll(true, m_state);
            trace("::::::::::::::::::: newGameRound()");
            this.setGambleEnabled(true);
            if (m_roundInfo.totalwin == 0)
            {
                if (m_mi.getDisplayCredit() - m_roundInfo.getTotalBet() < 0)
                {
                    m_mi.updateStatusBar("novel_infobar_balance");
                }
                else if (!m_roundInfo.wins.last_win || !m_roundInfo.wins.last_win.win.isSpecial)
                {
                    m_mi.updateStatusBar("novel_infobar_clickspin");
                }
            }
            return;
        }// end function

        override protected function typeSpinResponse() : void
        {
            finalizeTotalWin(this.calculateWinAmouts());
            this.afterSpinResponse();
            return;
        }// end function

        protected function clickToStart(com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel:Boolean = true) : void
        {
            (m_mainButtons as ButtonsNovel).swapButton(GameButtons.SPIN_BUTTON, GameButtons.START_BUTTON);
            if (m_state == GameStates.STATE_AUTOPLAY)
            {
                m_mainButtons.enableAll(false, GameStates.STATE_FREESPIN);
            }
            m_mainButtons.enable(GameButtons.START_BUTTON, true);
            if (com.playtech.casino3.slots.shared.novel:TypeNovel/TypeNovel)
            {
                m_queue.add(new CommandObject(this.waitClick));
            }
            else
            {
                m_queue.add(new CommandFunction(this.startClicked));
            }
            var _loc_2:* = new CommandFunction(this.beforeBonusStart);
            m_queue.add(_loc_2);
            this.m_cmdId.push(_loc_2.getId());
            return;
        }// end function

    }
}
