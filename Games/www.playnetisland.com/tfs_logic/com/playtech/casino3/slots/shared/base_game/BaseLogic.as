package com.playtech.casino3.slots.shared.base_game
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.*;
    import com.playtech.casino3.slots.shared.utils.debug.*;
    import com.playtech.casino3.utils.*;
    import flash.display.*;
    import flash.events.*;

    public class BaseLogic extends TypeNovel implements IDisposable
    {
        public var _module_interface:IModuleInterface;
        public var _server_base:ServerNovel;
        public var _effects_below_reels:MovieClip;
        public var _wins_animator:WinsNovel;
        public var _reels:ReelsNovel;
        protected const ENABLE_ENVIRONMENT_TRACE:Boolean = true;
        public var _game_window:MovieClip;
        protected const DEBUG:Boolean = false;
        protected var _runtime_elements_loader:RuntimeElsLoader;
        public const EFFECTS_DOWN_MOVIE_NAME:String = "longTimeEffectsDown";
        public var _reels_movie_clip:MovieClip;
        public var _backgrounds:MovieClip;
        public var _button_novel:ButtonsNovel;
        public var _history:SlotsHistory;
        public var _reels_effects:ReelEffects;
        public var _round_info:RoundInfo;
        protected var RESTORE_INFO:Object;
        public const REELS_MOVIE_NAME:String = "reels";
        public const EFFECTS_UP_MOVIE_NAME:String = "longTimeEffectsUp";
        public var _free_spins_manager:FreeSpins;
        public var LINKAGE_PREFIX:String;
        public var BACKGROUND_COLOR:uint = 0;
        public const BACKGROUNDS_MOVIE_NAME:String = "backgrounds";
        public var _main_window:MovieClip;
        public var _effects_above_reels:MovieClip;

        public function BaseLogic() : void
        {
            return;
        }// end function

        protected function disposeGameSpecific() : void
        {
            return;
        }// end function

        override public function dispose() : void
        {
            this.disposeGameSpecific();
            this.removeRuntimeElementsLoader();
            VideoMovieClip.dispose();
            EventPool.removeEventListener(GameStates.EVENT_PREV_STATE, this.prevStateBack);
            EventPool.removeEventListener(GameStates.EVENT_NEW_STATE, this.newStateChange);
            this._module_interface = null;
            this._round_info = null;
            this._button_novel = null;
            this._reels = null;
            this._reels_effects = null;
            this._wins_animator = null;
            this._free_spins_manager = null;
            this._main_window = null;
            this._game_window = null;
            this._reels_movie_clip = null;
            this._effects_above_reels = null;
            this._effects_below_reels = null;
            this._backgrounds = null;
            this.RESTORE_INFO = null;
            super.dispose();
            return;
        }// end function

        protected function prevStateBack(event:GameStateEvent) : void
        {
            return;
        }// end function

        override public function initializeLogic() : void
        {
            super.initializeLogic();
            this._history = m_history;
            this._button_novel = m_mainButtons as ButtonsNovel;
            this._wins_animator = m_winAnims as WinsNovel;
            this._wins_animator.use_video_movieclip = true;
            this._wins_animator.use_smoothing_for_video_movieclip = true;
            this._reels = m_reels as ReelsNovel;
            this._free_spins_manager = m_fsManager as FreeSpins;
            if (this.DEBUG)
            {
                new ForTesting(this._module_interface, this, m_queue, this.ENABLE_ENVIRONMENT_TRACE);
            }
            return;
        }// end function

        override public function initializeGraphics(com.playtech.casino3.slots.shared.base_game:BaseLogic:IModuleInterface, com.playtech.casino3.slots.shared.base_game:BaseLogic:Object) : void
        {
            this._module_interface = com.playtech.casino3.slots.shared.base_game:BaseLogic;
            this._main_window = com.playtech.casino3.slots.shared.base_game:BaseLogic.gfxRef as MovieClip;
            this._game_window = this._main_window.getChildByName("gameWnd") as MovieClip;
            super.initializeGraphics(this._module_interface, com.playtech.casino3.slots.shared.base_game:BaseLogic);
            this.LINKAGE_PREFIX = GameParameters.shortname + ".";
            this._round_info = m_roundInfo;
            this._reels_effects = m_reelEff as ReelEffects;
            this._reels_effects.use_video_movieclip = true;
            this._reels_effects.use_smoothing_for_video_movieclip = true;
            this._reels_movie_clip = this._game_window.getChildByName(this.REELS_MOVIE_NAME) as MovieClip;
            this._effects_above_reels = this._game_window.getChildByName(this.EFFECTS_UP_MOVIE_NAME) as MovieClip;
            this._effects_below_reels = this._game_window.getChildByName(this.EFFECTS_DOWN_MOVIE_NAME) as MovieClip;
            this._backgrounds = this._game_window.getChildByName(this.BACKGROUNDS_MOVIE_NAME) as MovieClip;
            this._main_window.opaqueBackground = this.BACKGROUND_COLOR;
            return;
        }// end function

        protected function removeRuntimeElementsLoader() : void
        {
            if (!this._runtime_elements_loader)
            {
                return;
            }
            this._runtime_elements_loader.removeEventListener(RuntimeElsLoader.EVT_FINISHED, this.onRuntimeElementsLoaded);
            this._runtime_elements_loader.dispose();
            this._runtime_elements_loader = null;
            return;
        }// end function

        override protected function startFeature(com.playtech.casino3.slots.shared.base_game:BaseLogic:SlotsWin) : void
        {
            return;
        }// end function

        protected function handleNamedChunkData(flash.display:DisplayObjectContainer:Array) : Object
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:int = 0;
            var _loc_2:Object = {};
            do
            {
                
                _loc_6 = _loc_3.indexOf("=");
                if (_loc_6 == -1)
                {
                }
                else
                {
                    _loc_5 = _loc_3.substring(0, _loc_6);
                    _loc_4 = _loc_3.substring((_loc_6 + 1));
                    _loc_2[_loc_5] = _loc_4;
                }
                var _loc_7:* = flash.display:DisplayObjectContainer.shift();
                _loc_3 = flash.display:DisplayObjectContainer.shift();
            }while (_loc_7)
            return _loc_2;
        }// end function

        protected function onRuntimeElementsLoaded(event:Event) : void
        {
            this.removeRuntimeElementsLoader();
            return;
        }// end function

        override protected function additionalHistory() : String
        {
            return "" + (m_state == GameStates.STATE_FREESPIN ? (1) : (0));
        }// end function

        protected function newStateChange(event:GameStateEvent) : void
        {
            return;
        }// end function

        override protected function initServer() : void
        {
            m_server = this._server_base;
            return;
        }// end function

        override protected function gameBrokenGame(com.playtech.casino3.slots.shared.base_game:BaseLogic:Array) : void
        {
            if (this.DEBUG)
            {
                trace("gameBrokenGame " + com.playtech.casino3.slots.shared.base_game:BaseLogic.join("|"));
            }
            var _loc_2:* = com.playtech.casino3.slots.shared.base_game:BaseLogic.shift() as Array;
            var _loc_3:* = _loc_2.shift();
            var _loc_4:String = "freespins";
            if (_loc_3 != _loc_4)
            {
                throw new Error("BaseLogic.gameBrokenGame  - freespins chunk is not the first chunk error in assuming that !!!");
            }
            this.RESTORE_INFO = this.handleNamedChunkData(_loc_2);
            var _loc_5:* = int(this.RESTORE_INFO["startbonus"]) != 0;
            if (this.DEBUG)
            {
                trace("IS_CLICK_TO_START " + _loc_5);
            }
            return;
        }// end function

        override protected function gameSpecificLogic() : void
        {
            EventPool.addEventListener(GameStates.EVENT_PREV_STATE, this.prevStateBack);
            EventPool.addEventListener(GameStates.EVENT_NEW_STATE, this.newStateChange);
            return;
        }// end function

        override protected function beforeFeature(com.playtech.casino3.slots.shared.base_game:BaseLogic:SlotsWin) : void
        {
            return;
        }// end function

    }
}
