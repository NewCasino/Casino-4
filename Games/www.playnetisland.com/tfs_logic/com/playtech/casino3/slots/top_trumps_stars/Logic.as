package com.playtech.casino3.slots.top_trumps_stars
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.slots.shared.novel.anticipation.*;
    import com.playtech.casino3.slots.shared.novel.gamble.*;
    import com.playtech.casino3.slots.shared.novel.novelCmd.*;
    import com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.slots.shared.utils.*;
    import com.playtech.casino3.slots.top_trumps_stars.data.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.slot_symbols.*;
    import com.playtech.casino3.slots.top_trumps_stars.windows.*;
    import com.playtech.casino3.slots.top_trumps_stars.wins.*;
    import com.playtech.casino3.slots.top_trumps_stars.wins.enum.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.events.*;

    public class Logic extends BaseLogic
    {
        var _slot_symbols:SlotSymbols;
        var _wins_calculator:WinsCalculator;
        var _free_spins_header:MovieClip;
        var _promo:Promo;
        protected var _state:GameState;
        var _anticipation:Anticipation;
        var _team_chooser_intro:TeamChooserIntro;
        const NORNAL_BACKGROUND_COLOR:Object = 471808;
        public var freegames_country:Country;
        var _free_spins_info:FreeSpinsInfo;
        const NUM_FREE_SPINS:Number = 12;
        var _team_chooser:TeamChooser;
        var _wins_transformator:WinsTransformator;
        public var country_1:Country;
        public var country_2:Country;
        var _reel_strip:GameReelsStrips;
        var _win_table:Wintable;
        var _current_symbols:GameCurrentSymbols;
        var _server:Server;
        var _reel_stops:ReelStops;
        var _anticipation_grid:AnticipationGrid;

        public function Logic() : void
        {
            this._state = GameState.NORMAL;
            this.country_1 = Country.ARGENTINA;
            this.country_2 = Country.SPAIN;
            Parameters.initialize();
            this._slot_symbols = new SlotSymbols(this);
            this._reel_strip = new GameReelsStrips();
            m_reelstrips = this._reel_strip;
            this._win_table = new Wintable(this);
            m_wintable = this._win_table;
            this._anticipation = new Anticipation();
            m_anticip = this._anticipation.ANTICIPATION_RULES;
            this._reel_stops = new ReelStops(this);
            BACKGROUND_COLOR = this.NORNAL_BACKGROUND_COLOR;
            return;
        }// end function

        override protected function gameBrokenGame(Anticipation:Array) : void
        {
            RESTORE_INFO = new RestoreInfo(Anticipation, m_fsManager);
            this.handleGameRestore();
            return;
        }// end function

        override protected function afterFeature() : void
        {
            if (RESTORE_INFO)
            {
                return;
            }
            RESTORE_INFO = null;
            super.afterFeature();
            return;
        }// end function

        protected function restoreFreeGames() : void
        {
            var _loc_1:* = (RESTORE_INFO as RestoreInfo).free_games_restore_info;
            this.freegames_country = _loc_1.is_first_team_in_free_games ? (this.country_1) : (this.country_2);
            Console.write("restoreFreeGames free games country " + this.freegames_country);
            if (_loc_1.is_click_to_start)
            {
                this.setWinToLastWin();
                return this.startFreeGames();
            }
            this.afterClickTostart(m_fsManager.getFS(), m_fsManager.getMultiplier(), _loc_1.free_spins_win, _round_info.totalwin, true);
            _module_interface.updateStatusBar("");
            return;
        }// end function

        function get state() : GameState
        {
            return this._state;
        }// end function

        function intitFreeSpinsHeader(Anticipation:int, Anticipation:Number = 0) : void
        {
            Console.write("intitFreeSpinsHeader freespins:" + Anticipation + " free_spin_win:" + Anticipation);
            m_fsManager.startAssets(Anticipation, Anticipation);
            this._free_spins_header = m_fsManager.getHeader().getGfx() as MovieClip;
            var _loc_3:* = m_mainWndGfx.getChildIndex(m_promo.getArea());
            m_mainWndGfx.setChildIndex(this._free_spins_header, _loc_3);
            this._free_spins_header.multiplier.visible = false;
            if (this._state == GameState.NORMAL)
            {
                this.state = GameState.FREESPIN;
                RESTORE_INFO = null;
            }
            return;
        }// end function

        protected function afterClickTostart(Anticipation:int = 0, Anticipation:int = 0, Anticipation:Number = 0, Anticipation:Number = 0, Anticipation:Boolean = false) : void
        {
            Console.write("afterClickTostart");
            var _loc_6:* = this.NUM_FREE_SPINS;
            var _loc_7:int = 1;
            var _loc_8:Number = 0;
            var _loc_9:* = _round_info.totalwin;
            if (Anticipation > 0 && Anticipation > 0)
            {
                _loc_6 = Anticipation;
                _loc_7 = Anticipation;
                _loc_8 = Anticipation;
                _loc_9 = Anticipation;
            }
            m_queue.add(new CommandFunction(this._server.sendAfterClickToStart));
            var _loc_10:* = new CommandFunction(this.initFreeSpins, _loc_6, _loc_7, _loc_8, _loc_9);
            var _loc_11:* = Anticipation ? (_loc_10) : (this.FreespinsIntroCommand(_loc_6, _loc_10));
            m_queue.add(_loc_11);
            m_queue.add(new CommandFunction(_wins_animator.pause, true));
            m_queue.add(new CommandFunction(_module_interface.stopSoundsBySource, "peding_free_game"));
            m_queue.add(new CommandFunction(this.intitFreeSpinsHeader, _loc_6, _loc_8));
            m_queue.add(new CommandFunction(m_history.addFreeSpinBonus, _loc_6, _loc_7));
            return;
        }// end function

        protected function onSpinStart(event:Event = null) : void
        {
            this._team_chooser.closeChooser();
            return;
        }// end function

        function set state(Anticipation:GameState) : void
        {
            this._state = Anticipation;
            this._server.state = this._state;
            this._slot_symbols.state = this._state;
            this._reel_strip.state = this._state;
            this._win_table.state = this._state;
            this._wins_calculator.state = this._state;
            this._wins_transformator.state = this._state;
            this._promo.state = this._state;
            this._reel_stops.state = this._state;
            this._anticipation.state = this._state;
            this._current_symbols.state = this._state;
            _reels_effects.setStopSymbols(this._reel_stops.REEL_STOP_RULES);
            _reels_effects.useGameReelSnd();
            _reels_effects.useGameStopSnd();
            _backgrounds.gotoAndStop(this._state.type);
            return;
        }// end function

        override public function dispose() : void
        {
            disposeObjects(this._slot_symbols, this._anticipation, this._promo, this._anticipation_grid, this._wins_transformator, this._reel_stops);
            this._server = null;
            this._win_table = null;
            this._reel_strip = null;
            this._wins_calculator = null;
            this._wins_transformator = null;
            this._current_symbols = null;
            this._promo = null;
            this._anticipation = null;
            this._anticipation_grid = null;
            this._free_spins_info = null;
            this._state = null;
            super.dispose();
            return;
        }// end function

        override protected function endFsCmd() : ICommand
        {
            var _loc_1:* = GetWindowParameters.freespinOutro();
            _loc_1.duration = -1;
            _loc_1.hasContinueBtn = true;
            _loc_1.clickTarget = MessageWindowInfo.NONE;
            var _loc_2:* = new FreeSpinsOutroWindow(m_mi, m_mainWndGfx, m_fsManager.getGameWin(), m_fsManager.getFSWin(), _loc_1);
            _loc_2.middle_callback = this.endFreeSpins;
            return new InfoWindowCmd(_loc_2);
        }// end function

        protected function beforeClickToStart() : void
        {
            var play_pending_sound:Function;
            play_pending_sound = function () : void
            {
                _module_interface.playAsEffect(LINKAGE_PREFIX + "before_free_games_pending_loop", "peding_free_game", 16777215);
                return;
            }// end function
            ;
            Console.write("beforeClickToStart");
            var pending_sound_command:* = new CommandFunction(play_pending_sound);
            pending_sound_command.setDeleteFunc(play_pending_sound);
            m_queue.add(pending_sound_command);
            m_queue.add(new CommandFunction(m_winticker.playTickSound));
            m_queue.add(new CommandObject(m_winticker.waitEnd));
            var main_buttons:* = m_mainButtons as ButtonsNovel;
            m_queue.add(new CommandFunction(main_buttons.enableAll, false, GameStates.STATE_NORMAL, GameButtons.SPIN_BUTTON, GameButtons.START_BUTTON));
            main_buttons.swapButton(GameButtons.SPIN_BUTTON, GameButtons.START_BUTTON);
            main_buttons.enable(GameButtons.START_BUTTON, true);
            return;
        }// end function

        override public function initializeLogic() : void
        {
            m_history = new History(this, _module_interface);
            this._wins_transformator = new WinsTransformator(this);
            this._wins_calculator = new WinsCalculator(this._win_table, this, this._wins_transformator);
            m_resultGetter = this._wins_calculator;
            super.initializeLogic();
            _wins_animator.get_background_from = _backgrounds;
            if (!m_descriptor.broken)
            {
                this._team_chooser_intro = new TeamChooserIntro(this);
            }
            else
            {
                _main_window.removeChild(_main_window.getChildByName("chooser_screen"));
            }
            GameParameters.sound_library = "novel_10_1";
            NovelSoundMap.resetParameters();
            var _loc_1:* = LINKAGE_PREFIX + "sounds.";
            NovelSoundMap.SOUND_WIN_TOP = _loc_1 + "top_win";
            NovelSoundMap.SOUND_WIN_HIGH = _loc_1 + "high_win";
            NovelSoundMap.SOUND_WIN_MID_HIGH = _loc_1 + "middle_high_win";
            NovelSoundMap.SOUND_WIN_MID_LOW = _loc_1 + "middle_low_win";
            NovelSoundMap.SOUND_WIN_LOW = _loc_1 + "low_win";
            return;
        }// end function

        override protected function startFeature(Anticipation:SlotsWin) : void
        {
            if (Anticipation.special == WinsSpecial.FREE_GAMES.type)
            {
                return this.startFreeGames();
            }
            return;
        }// end function

        private function initFreeSpins(Anticipation:int, Anticipation:int, Anticipation:Number = 0, Anticipation:Number = 0) : void
        {
            Console.write("initFreeSpins freespins:" + Anticipation + " multiplier" + Anticipation + " free_spin_win:" + Anticipation + " game_win:" + Anticipation);
            this._team_chooser.hide(true);
            m_fsManager.initFreeSpinValues(Anticipation, Anticipation, Anticipation, Anticipation);
            return;
        }// end function

        override protected function gameBeforeWinAnims() : void
        {
            this._promo.checkForEventDrivenMessages(_round_info);
            var _loc_1:* = _round_info.wins ? (_round_info.wins.last_win) : (null);
            if (_loc_1 && _loc_1.win.special == WinsSpecial.FREE_GAMES.type)
            {
                this.freegames_country = _loc_1.win.symbol == Flag_1.symbol ? (this.country_1) : (this.country_2);
                this._team_chooser.disable = true;
            }
            return;
        }// end function

        function onTeamChanged(event:Event = null) : void
        {
            this._slot_symbols.state = GameState.NORMAL;
            this._win_table.state = GameState.NORMAL;
            this._reel_stops.state = GameState.NORMAL;
            _reels_effects.setStopSymbols(this._reel_stops.REEL_STOP_RULES);
            _reels.showResult(_round_info.results, _round_info.reelSymbols.symbols);
            this._promo.onPromoChange();
            m_celebration.stopCelebration();
            m_winAnims.stopAnim();
            return;
        }// end function

        override protected function handleButtonEvent(Anticipation:String, Anticipation = null) : void
        {
            var _loc_3:* = this.Vector.<String>([GameButtons.BETMAX_BUTTON]);
            if (_loc_3.indexOf(Anticipation) != -1)
            {
                m_mi.playAsEffect(NovelSoundMap.SOUND_SPIN);
            }
            if (Anticipation == "country")
            {
                this._team_chooser.openChooserFromIndex(int(Anticipation));
            }
            super.handleButtonEvent(Anticipation, Anticipation);
            return;
        }// end function

        override public function initializeGraphics(Anticipation:IModuleInterface, Anticipation:Object) : void
        {
            this._current_symbols = new GameCurrentSymbols(this._reel_strip);
            current_symbols = this._current_symbols;
            var _loc_3:* = new Server(this, ServerCommand.LOGIN, ServerCommand.LOGOUT, this, Anticipation, this._reel_strip);
            this._server = new Server(this, ServerCommand.LOGIN, ServerCommand.LOGOUT, this, Anticipation, this._reel_strip);
            _server_base = _loc_3;
            _module_interface = Anticipation;
            this._team_chooser = new TeamChooser(Anticipation.gfxRef.getChildByName("gameWnd").getChildByName("team_chooser") as MovieClip, this);
            this._team_chooser.addEventListener(TeamChooser.TEAM_CHANGED, this.onTeamChanged);
            super.initializeGraphics(Anticipation, Anticipation);
            return;
        }// end function

        override protected function calculateWinAmouts() : Number
        {
            var _loc_1:* = _round_info.wins ? (_round_info.wins.last_win) : (null);
            if (_loc_1 && _loc_1.win.special == WinsSpecial.FREE_GAMES.type)
            {
                this._server.sendBeforeClickToStart();
            }
            return this._wins_calculator.calculateWinAmouts(_round_info);
        }// end function

        protected function FreespinsIntroCommand(String:int, String:CommandFunction) : ICommand
        {
            var _loc_3:* = GetWindowParameters.freespinIntro();
            _loc_3.duration = -1;
            _loc_3.hasContinueBtn = true;
            _loc_3.clickTarget = MessageWindowInfo.NONE;
            _loc_3.inSound = "sounds.windows." + "slide_down";
            _loc_3.outSound = "sounds.windows." + "slide_up";
            var _loc_4:* = new FreeSpinsIntroWindow(this, String, false, _loc_3);
            _loc_4.middle_callback = String;
            return new InfoWindowCmd(_loc_4);
        }// end function

        protected function onTeamsRestored(event:Event) : void
        {
            this._server.removeEventListener(Server.ON_TEAMS_RECIEVED, this.onTeamsRestored);
            this.onTeamChanged();
            this._team_chooser.updateFlags();
            _main_window.mouseChildren = true;
            Console.write("onTeamsRestored " + this.country_1 + " " + this.country_2);
            var _loc_2:* = RESTORE_INFO as RestoreInfo;
            m_queue.add(new CommandFunction(setInProgress, true));
            if (_loc_2.gamble_restore_info)
            {
                this.restoreGamble();
            }
            if (_loc_2.free_games_restore_info)
            {
                this.restoreFreeGames();
            }
            finishBrokenGame();
            EventPool.dispatchEvent(new Event(Server.ON_TEAMS_RECIEVED));
            return;
        }// end function

        protected function restoreTeams() : void
        {
            Console.write("restoreTeams");
            m_queue.add(new BlockCmd(Server.ON_TEAMS_RECIEVED, this.areTeamsLoaded));
            this._team_chooser.hide(true);
            _main_window.mouseChildren = false;
            this._server.addEventListener(Server.ON_TEAMS_RECIEVED, this.onTeamsRestored);
            this._server.getTeams();
            return;
        }// end function

        override protected function initButtons() : void
        {
            var _loc_1:* = m_linesManager.getButtons();
            _loc_1 = _loc_1.concat(this._team_chooser.buttons);
            m_mainButtons = new ButtonsNovel(m_mi, m_mainWndGfx.getChildByName("mainButtons") as DisplayObjectContainer, this.handleButtonEvent, _loc_1);
            return;
        }// end function

        override protected function disposeGameSpecific() : void
        {
            if (this._team_chooser)
            {
                this._team_chooser.removeEventListener(TeamChooser.TEAM_CHANGED, this.onTeamChanged);
            }
            if (this._server)
            {
                this._server.removeEventListener(Server.ON_TEAMS_RECIEVED, this.onTeamsRestored);
            }
            disposeObjects(this._team_chooser, this._team_chooser_intro);
            this._team_chooser = null;
            this._team_chooser_intro = null;
            return;
        }// end function

        public function hideGameWindow(Anticipation:Boolean) : void
        {
            hideMainGameWnd(Anticipation);
            return;
        }// end function

        override protected function gameAfterFreeSpinMsg() : void
        {
            return;
        }// end function

        protected function endFreeSpins() : void
        {
            _wins_animator.pause(false);
            this.state = GameState.NORMAL;
            this._free_spins_header = null;
            this._team_chooser.hide(false);
            return;
        }// end function

        override protected function additionalHistory() : String
        {
            return "";
        }// end function

        protected function setWinToLastWin() : void
        {
            this._win_table.state = GameState.NORMAL;
            this._wins_calculator.getResult(_round_info.reelSymbols.symbols, active_pay_lines);
            this.calculateWinAmouts();
            updateTField(MainTxtFields.WIN_TF, Money.format(this._wins_calculator.total_win));
            return;
        }// end function

        protected function startFreeGames() : void
        {
            Console.write("startFreeGames");
            this.beforeClickToStart();
            clickToStart();
            this.afterClickTostart();
            return;
        }// end function

        protected function handleGameRestore() : void
        {
            this.restoreTeams();
            return;
        }// end function

        protected function areTeamsLoaded() : Boolean
        {
            return this.freegames_country == null;
        }// end function

        public function get is_team_1_started_free_spins() : Boolean
        {
            return this.country_1 == this.freegames_country;
        }// end function

        protected function restoreGamble() : void
        {
            Console.write("restoreGamble");
            var _loc_1:* = (RESTORE_INFO as RestoreInfo).gamble_restore_info;
            var _loc_2:* = new CommandObject(m_gamble.start, _loc_1.getInfoInGambleAceptableFormat(m_ambientId), null, false);
            m_queue.add(_loc_2);
            m_queue.registerListener(_loc_2.getId(), gambleEnd);
            return;
        }// end function

        override protected function gameSpecificLogic() : void
        {
            super.gameSpecificLogic();
            var paytable_parameters:* = new TextSubstitutions();
            paytable_parameters.gambleLimit = Money.format(m_descriptor.chosenLimit.maxPos);
            paytable_parameters.country_1 = function () : Country
            {
                return country_1;
            }// end function
            ;
            paytable_parameters.country_2 = function () : Country
            {
                return country_2;
            }// end function
            ;
            m_paytable = new PayTable(_main_window, _module_interface, paytable_parameters);
            var WHITEN_OTHER_CARDS:Boolean;
            m_gamble = new GambleVP(_module_interface, _main_window, m_descriptor.chosenLimit.maxPos, WHITEN_OTHER_CARDS);
            this._anticipation_grid = new AnticipationGrid(_reels_effects);
            this._promo = new Promo(this, m_promo);
            EventPool.addEventListener(ReelSpinInfo.SPIN_START, this.onSpinStart);
            mute_ambient_on_win_toggle = false;
            return;
        }// end function

        override public function toString() : String
        {
            return "[ Top Tumps Stars ]";
        }// end function

        override protected function typeSpecificGfxInit() : void
        {
            m_linesManager = new Lines(m_mainWndGfx);
            super.typeSpecificGfxInit();
            return;
        }// end function

    }
}
