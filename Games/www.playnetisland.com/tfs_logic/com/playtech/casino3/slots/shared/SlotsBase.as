package com.playtech.casino3.slots.shared
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.interfaces.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.events.*;

    public class SlotsBase extends Sprite implements IModule
    {
        protected var m_descriptor:Object;
        protected var m_apMaster:SimpleAP;
        protected var m_inProgress:Boolean;
        protected var m_reelstrips:ReelsStrips;
        protected var m_roundInfo:RoundInfo;
        protected var m_wintable:Array;
        protected var current_symbols:ReelsSymbols;
        protected var m_winAnims:IWinsAnimator;
        protected var m_resultGetter:IWinsCalculator;
        protected var m_lineDef:Array;
        protected var m_prevStates:Vector.<int>;
        protected var m_logicDone:Boolean;
        protected var m_mi:IModuleInterface;
        protected var m_gfx:Sprite;
        protected var m_paytable:PaytableBase;
        protected var m_mainButtons:SlotsButtonsBase;
        protected var m_state:int;
        protected var m_linesManager:LinesBase;
        protected var m_history:SlotsHistory;
        protected var m_queue:CommandQueue;
        protected var m_reels:IReelsAnimator;
        protected var m_gfxDone:Boolean;
        private var m_tmu:TMUFreeze;
        protected var m_server:ServerBase;
        protected var m_mainWndGfx:Sprite;
        protected var m_mainTF:Array;

        public function SlotsBase()
        {
            GameParameters.resetParameters();
            return;
        }// end function

        protected function typeSpecificGfxInit() : void
        {
            throw new Error("Graphics initialization is not completed, override typeSpecificGfxInit method");
        }// end function

        public function firstEntrance() : void
        {
            var _loc_1:* = this.m_roundInfo.getTotalBet();
            if (this.m_mi.reserveCredit(_loc_1))
            {
                this.m_roundInfo.moneyIn = _loc_1;
            }
            else
            {
                this.m_mi.updateStatusBar("novel_infobar_balance");
            }
            return;
        }// end function

        final public function setPrevStateBack() : void
        {
            var _loc_1:int = 0;
            if (this.m_prevStates.length != 0)
            {
                _loc_1 = this.m_state;
                this.m_state = this.m_prevStates.pop();
                EventPool.dispatchEvent(new GameStateEvent(GameStates.EVENT_PREV_STATE, _loc_1, this.m_state));
            }
            return;
        }// end function

        public function updateTField(com.playtech.casino3:IModuleInterface:String, com.playtech.casino3:IModuleInterface:String) : void
        {
            this.m_mainTF[com.playtech.casino3:IModuleInterface].text = com.playtech.casino3:IModuleInterface;
            return;
        }// end function

        public function getReelAnimator() : IReelsAnimator
        {
            return this.m_reels;
        }// end function

        public function newGameRound() : void
        {
            return;
        }// end function

        protected function initServer() : void
        {
            throw new Error("Server initialization is not completed, override initServer method");
        }// end function

        public function getState() : int
        {
            return this.m_state;
        }// end function

        protected function transSymbols(com.playtech.casino3:IModuleInterface:Vector.<int>) : void
        {
            throw new Error("Translating server results is not completed, override transSymbols method");
        }// end function

        public function spinResponse(com.playtech.casino3:IModuleInterface:Vector.<int>) : void
        {
            this.m_roundInfo.results = com.playtech.casino3:IModuleInterface;
            this.transSymbols(com.playtech.casino3:IModuleInterface);
            this.m_mi.writeCasinoCookie(SlotsCookie.LAST_REELINFO_PREFIX + GameParameters.gamecode, com.playtech.casino3:IModuleInterface);
            this.m_queue.add(new CommandFunction(this.calculateWins));
            this.m_queue.add(new CommandFunction(this.typeSpinResponse));
            return;
        }// end function

        private function calculateWins() : void
        {
            var _loc_1:* = this.active_pay_lines;
            this.m_roundInfo.paylines = _loc_1;
            this.m_roundInfo.wins = this.m_resultGetter.getResult(this.m_roundInfo.reelSymbols.symbols, _loc_1);
            return;
        }// end function

        public function getRoundInfo() : RoundInfo
        {
            return this.m_roundInfo;
        }// end function

        protected function typeRestoreGame(com.playtech.casino3:IModuleInterface:int) : void
        {
            return;
        }// end function

        protected function typeAfterSpin() : void
        {
            throw new Error("Spin response is not completed, override typeAfterSpin method");
        }// end function

        public function resume() : void
        {
            this.m_server.reconnect();
            this.m_mi.updateStatusBar(SharedText.TDH_RESUME);
            return;
        }// end function

        protected function get active_pay_lines() : Array
        {
            var _loc_3:int = 0;
            var _loc_1:Array = [];
            var _loc_2:* = this.m_roundInfo.getActiveBets();
            var _loc_4:* = _loc_2.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                if (_loc_2[_loc_3] > 0)
                {
                    _loc_1[_loc_3] = this.m_lineDef[_loc_3];
                }
                _loc_3++;
            }
            return _loc_1;
        }// end function

        protected function typeSpecificLogic() : void
        {
            throw new Error("Logic initialization is not completed, override typeSpecificGfxInit method");
        }// end function

        public function restorePreviousGame(com.playtech.casino3:IModuleInterface:Boolean) : void
        {
            this.m_queue.empty();
            this.m_roundInfo.results = this.m_roundInfo.results;
            this.transSymbols(this.m_roundInfo.results);
            this.m_reels.showResult(this.m_roundInfo.results, this.m_roundInfo.reelSymbols.symbols);
            var _loc_2:* = this.m_roundInfo.getTotalBet();
            this.m_mi.uncommitCredit(_loc_2);
            if (com.playtech.casino3:IModuleInterface)
            {
                this.m_roundInfo.moneyIn = _loc_2;
            }
            else
            {
                this.m_roundInfo.moneyIn = 0;
                this.m_mi.reserveCredit(-_loc_2);
            }
            this.m_mi.updateStatusBar("");
            var _loc_3:* = this.m_state;
            if (this.m_state == GameStates.STATE_AUTOPLAY)
            {
                this.m_apMaster.deactivate((this.m_apMaster.getApLeft() + 1));
            }
            this.m_mainButtons.enableAll(true, this.m_state);
            this.typeRestoreGame(_loc_3);
            this.setInProgress(false);
            return;
        }// end function

        protected function hideMainGameWnd(com.playtech.casino3:IModuleInterface:Boolean = true) : void
        {
            this.m_mainWndGfx.y = com.playtech.casino3:IModuleInterface ? (-2000) : (0);
            this.m_mainWndGfx.visible = !com.playtech.casino3:IModuleInterface;
            return;
        }// end function

        public function initializeGraphics(com.playtech.casino3:IModuleInterface:IModuleInterface, com.playtech.casino3:IModuleInterface:Object) : void
        {
            Console.write("initializeGraphics", this);
            this.m_descriptor = com.playtech.casino3:IModuleInterface;
            GameParameters.shortname = com.playtech.casino3:IModuleInterface.alternativeshortname;
            GameParameters.gamecode = com.playtech.casino3:IModuleInterface.shortname;
            this.m_mi = com.playtech.casino3:IModuleInterface;
            this.m_gfx = com.playtech.casino3:IModuleInterface.gfxRef as Sprite;
            this.m_mainWndGfx = this.m_gfx.getChildByName("gameWnd") as Sprite;
            this.m_mainTF = [];
            this.typeSpecificGfxInit();
            this.initServer();
            this.m_roundInfo = new RoundInfo();
            var _loc_3:* = this.m_mi.readCasinoCookie(SlotsCookie.LAST_REELINFO_PREFIX + GameParameters.gamecode);
            if (_loc_3 == null || _loc_3.length == 0 || !this.m_server.resultIsValid(_loc_3))
            {
                _loc_3 = this.m_server.genResults();
            }
            this.m_roundInfo.results = _loc_3;
            this.m_roundInfo.reelSymbols = this.current_symbols ? (this.current_symbols) : (new ReelsSymbols(this.m_reelstrips, _loc_3));
            this.m_reels.showResult(_loc_3, this.m_roundInfo.reelSymbols.symbols);
            this.m_mi.moduleGraphicsReady(this.m_descriptor);
            this.m_gfxDone = true;
            return;
        }// end function

        public function dispose() : void
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            if (!this.m_gfxDone)
            {
                return;
            }
            this.m_mi.stopSoundsBySource();
            this.m_server.dispose();
            this.m_server = null;
            this.m_roundInfo.dispose();
            this.m_roundInfo = null;
            if (this.m_logicDone)
            {
                this.m_queue.dispose();
                this.m_queue = null;
                this.m_resultGetter.dispose();
                this.m_resultGetter = null;
                this.m_apMaster.dispose();
                this.m_apMaster = null;
                this.m_paytable.dispose();
                this.m_paytable = null;
                _loc_2 = this.m_lineDef.length;
                _loc_1 = 0;
                while (_loc_1 < _loc_2)
                {
                    
                    this.m_lineDef[_loc_1].dispose();
                    _loc_1++;
                }
                this.m_lineDef = null;
                this.m_history.dispose();
                this.m_history = null;
                this.m_prevStates = null;
                this.m_tmu.dispose();
                this.m_tmu = null;
            }
            this.m_gfx = null;
            this.m_mainWndGfx = null;
            this.m_mi = null;
            this.m_descriptor = null;
            this.m_reels.dispose();
            this.m_reels = null;
            this.m_mainButtons.dispose();
            this.m_mainButtons = null;
            this.m_linesManager.dispose();
            this.m_linesManager = null;
            this.m_mainTF = null;
            this.m_reelstrips.dispose();
            this.m_reelstrips = null;
            _loc_2 = this.m_wintable.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                this.m_wintable[_loc_1].dispose();
                _loc_1++;
            }
            this.m_wintable = null;
            this.m_winAnims.com.playtech.casino3.slots.shared.interfaces:IWinsAnimator::dispose();
            this.m_winAnims = null;
            EventPool.dispose();
            PlayMovie.disposeAll();
            return;
        }// end function

        public function isInProgress() : Boolean
        {
            return this.m_inProgress;
        }// end function

        protected function finalizeTotalWin(com.playtech.casino3:IModuleInterface:Number) : void
        {
            this.m_server.updateCredit(com.playtech.casino3:IModuleInterface);
            this.m_mi.poolCredit(com.playtech.casino3:IModuleInterface);
            this.m_roundInfo.totalwin = this.m_roundInfo.totalwin + com.playtech.casino3:IModuleInterface;
            Console.write("finalizeTotalWin " + com.playtech.casino3:IModuleInterface, this);
            return;
        }// end function

        public function typeBrokenHandler(com.playtech.casino3:IModuleInterface:Vector.<String>) : void
        {
            throw new Error("Cannot handle broken game, override typeBrokenHandler method");
        }// end function

        public function getAP() : SimpleAP
        {
            return this.m_apMaster;
        }// end function

        public function typeStartSpin() : void
        {
            throw new Error("Cannot start spinning, override typeStartSpin method");
        }// end function

        public function afterSpin() : void
        {
            this.m_mi.flushPooledCredit();
            this.m_history.addOrdinaryWin(this.m_roundInfo, this.m_state, this.additionalHistory());
            this.typeAfterSpin();
            return;
        }// end function

        final public function setState(com.playtech.casino3:IModuleInterface:int) : void
        {
            var _loc_2:* = this.m_state;
            this.m_prevStates.push(this.m_state);
            this.m_state = com.playtech.casino3:IModuleInterface;
            EventPool.dispatchEvent(new GameStateEvent(GameStates.EVENT_NEW_STATE, _loc_2, this.m_state));
            return;
        }// end function

        public function initializeLogic() : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            this.m_tmu = new TMUFreeze(this.m_mi);
            this.m_state = GameStates.STATE_NORMAL;
            Console.write("initializeLogic", this);
            this.m_queue = new CommandQueue(this.m_gfx.stage);
            this.m_prevStates = new Vector.<int>;
            this.m_mi.createWallet();
            var _loc_1:* = this.m_descriptor.chosenLimit.coins;
            this.m_mainButtons.setCoins(_loc_1);
            var _loc_2:* = _loc_1[this.m_descriptor.chosenLimit.defaultcoinindex];
            this.m_roundInfo.coinValue = _loc_2;
            this.m_mainButtons.setCoinValue(_loc_2);
            var _loc_3:* = this.m_mi.readUserCookie(SlotsCookie.LAST_GAME_INFO_PREFIX + GameParameters.gamecode);
            if (_loc_3 != null)
            {
                this.m_roundInfo.changeLineBet(RoundInfo.LINEBET_VALUE, _loc_3.linebet);
                _loc_4 = _loc_3.lines.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    if (_loc_3.lines[_loc_5] != -1)
                    {
                        this.m_roundInfo.activateLine(RoundInfo.ACTIVATE_SINGLE_ID, _loc_5);
                    }
                    _loc_5++;
                }
            }
            else
            {
                this.m_roundInfo.changeLineBet(RoundInfo.LINEBET_MAX);
                this.m_roundInfo.activateLine(RoundInfo.ACTIVATE_ALL);
            }
            this.m_linesManager.updateButtons(this.m_roundInfo.getActiveBets());
            this.updateTField(MainTxtFields.LINE_BET_TF, Money.format(this.m_roundInfo.getLineBet()));
            this.updateTField(MainTxtFields.LINES_TF, this.m_roundInfo.getNumActiveLines().toString());
            this.updateTField(MainTxtFields.TOTAL_BET_TF, Money.format(this.m_roundInfo.getTotalBet()));
            this.updateTField(MainTxtFields.WIN_TF, Money.format(0));
            this.m_history = this.m_history ? (this.m_history) : (new SlotsHistory(this.m_mi));
            this.typeSpecificLogic();
            if (!this.m_resultGetter)
            {
                this.m_resultGetter = new ResultCalculator(this.m_wintable);
            }
            this.m_logicDone = true;
            this.m_server.finalizeInit();
            this.m_server.login(this.m_descriptor, 200);
            if (this.m_descriptor.broken == true)
            {
                this.m_mainButtons.enableAll(false, GameStates.STATE_FREESPIN);
            }
            else
            {
                this.firstEntrance();
            }
            return;
        }// end function

        protected function typeSpinResponse() : void
        {
            throw new Error("Spin response is not completed, override typeBeginSpinResponse method");
        }// end function

        public function getMainButtons() : SlotsButtonsBase
        {
            return this.m_mainButtons;
        }// end function

        public function getWinAnimator() : IWinsAnimator
        {
            return this.m_winAnims;
        }// end function

        public function getHistory() : SlotsHistory
        {
            return this.m_history;
        }// end function

        public function getModI() : IModuleInterface
        {
            return this.m_mi;
        }// end function

        public function getQueue() : CommandQueue
        {
            return this.m_queue;
        }// end function

        public function getGFX() : Sprite
        {
            return this.m_gfx;
        }// end function

        public function getServer() : ServerBase
        {
            return this.m_server;
        }// end function

        final public function getPrevState() : int
        {
            if (this.m_prevStates.length == 0)
            {
                return GameStates.STATE_NORMAL;
            }
            return this.m_prevStates[(this.m_prevStates.length - 1)];
        }// end function

        public function interrupt() : void
        {
            this.m_queue.empty();
            this.m_reels.showResult(this.m_roundInfo.results, this.m_roundInfo.reelSymbols.symbols);
            this.m_prevStates = new Vector.<int>;
            if (this.m_state == GameStates.STATE_AUTOPLAY)
            {
                this.m_apMaster.deactivate(10);
            }
            this.m_state = GameStates.STATE_NORMAL;
            this.m_mi.updateStatusBar(SharedText.TDH_INTERRUPT);
            this.m_mi.stopSoundsBySource();
            this.m_roundInfo.moneyIn = 0;
            this.m_roundInfo.jpwin = 0;
            this.m_roundInfo.totalwin = 0;
            this.m_roundInfo.wins.clear();
            this.updateTField(MainTxtFields.WIN_TF, Money.format(0));
            this.hideMainGameWnd(false);
            this.m_mainButtons.enableAll(true, this.m_state);
            EventPool.dispatchEvent(new Event(GameStates.EVENT_RESET_All));
            return;
        }// end function

        protected function additionalHistory() : String
        {
            return null;
        }// end function

        override public function toString() : String
        {
            return "[SlotsBase] ";
        }// end function

        public function setInProgress(com.playtech.casino3:IModuleInterface:Boolean) : void
        {
            this.m_inProgress = com.playtech.casino3:IModuleInterface;
            Console.write("setInProgress: " + com.playtech.casino3:IModuleInterface);
            if (com.playtech.casino3:IModuleInterface || this.m_state != GameStates.STATE_AUTOPLAY)
            {
                this.m_mi.updateExitStatus(!com.playtech.casino3:IModuleInterface);
            }
            return;
        }// end function

        public function getLineManager() : LinesBase
        {
            return this.m_linesManager;
        }// end function

        final public function removeState(com.playtech.casino3:IModuleInterface:int) : void
        {
            var _loc_2:* = this.m_prevStates.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this.m_prevStates[_loc_3] == com.playtech.casino3:IModuleInterface)
                {
                    this.m_prevStates.splice(_loc_3, 1);
                    break;
                }
                _loc_3++;
            }
            if (this.m_state == com.playtech.casino3:IModuleInterface)
            {
                if (this.m_prevStates.length != 0)
                {
                    this.m_state = this.m_prevStates.pop();
                }
                else
                {
                    this.m_state = GameStates.STATE_NORMAL;
                }
            }
            return;
        }// end function

    }
}
