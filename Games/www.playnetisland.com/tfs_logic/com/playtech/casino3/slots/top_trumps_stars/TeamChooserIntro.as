package com.playtech.casino3.slots.top_trumps_stars
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import com.playtech.casino3.utils.button.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.display.*;
    import flash.events.*;

    public class TeamChooserIntro extends EventDispatcher implements IDisposable
    {
        protected var _module_interface:IModuleInterface;
        protected var _country_1:MovieClip;
        protected var _continue_button:ButtonComponent;
        protected var _country_2:MovieClip;
        protected var _queue:CommandQueue;
        protected var _logic:Logic;
        protected var _tab_set_id:int;
        protected var _graphics:MovieClip;
        protected var _choice_1:String;
        protected var _choice_2:String;

        public function TeamChooserIntro(_logic:Logic) : void
        {
            this._logic = _logic;
            this._module_interface = this._logic._module_interface;
            this.initialize();
            return;
        }// end function

        protected function updateSelection(_logic:Boolean = false) : void
        {
            this.resetButtons(this._country_1);
            this.resetButtons(this._country_2);
            if (this._logic.country_1)
            {
                this._choice_1 = this._logic.country_1.type;
                this.selectCouple(this._logic.country_1, true);
            }
            if (this._logic.country_2)
            {
                this._choice_2 = this._logic.country_2.type;
                this.selectCouple(this._logic.country_2, false);
            }
            if (_logic && this._choice_1 && this._choice_2)
            {
                this._logic._server.setTeams();
            }
            this._continue_button.getLogic().disable(!this._choice_1 || !this._choice_2);
            return;
        }// end function

        protected function onInit(event:Event = null) : void
        {
            this._tab_set_id = this._module_interface.createKeyboardSet();
            this._country_1 = this._graphics.getChildByName("country_1") as MovieClip;
            this._country_2 = this._graphics.getChildByName("country_2") as MovieClip;
            this.initializeCountry(this._country_1);
            this.initializeCountry(this._country_2);
            this._continue_button = this._graphics.getChildByName("continue_button") as ButtonComponent;
            this._continue_button.getLogic().registerHandler(this.closeChooser);
            this._continue_button.getLogic().disable(true);
            this._logic._server.addEventListener(Server.ON_TEAMS_RECIEVED, this.onTeamsRecieved);
            this._logic._server.getTeams();
            return;
        }// end function

        protected function initialize() : void
        {
            this._graphics = this._logic._main_window.getChildByName("chooser_screen") as MovieClip;
            this._logic._button_novel.enableAll(false, GameStates.STATE_NORMAL);
            this._logic.hideGameWindow(true);
            (this._module_interface as IServiceInterface).hideCommonUI(true);
            this.onInit();
            return;
        }// end function

        protected function selectCouple(_logic:Country, _logic:Boolean) : void
        {
            var _loc_3:ButtonComponent = null;
            var _loc_4:IButton = null;
            _loc_3 = this._country_1.getChildByName(_logic.type.toLowerCase()) as ButtonComponent;
            _loc_4 = _loc_3.getLogic() as IButton;
            _loc_4.select(_logic);
            _loc_4.disable(true);
            _loc_3 = this._country_2.getChildByName(_logic.type.toLowerCase()) as ButtonComponent;
            _loc_4 = _loc_3.getLogic() as IButton;
            _loc_4.select(!_logic);
            _loc_4.disable(true);
            return;
        }// end function

        protected function onTeamsRecieved(event:Event) : void
        {
            this._logic.removeEventListener(Server.ON_TEAMS_RECIEVED, this.onTeamsRecieved);
            this.updateSelection();
            this._module_interface.addTabElement(this._tab_set_id, this._continue_button);
            return;
        }// end function

        public function closeChooser() : void
        {
            this._logic._module_interface.enableKeyboardSet(this._tab_set_id, false);
            this._graphics.mouseChildren = false;
            var _loc_1:* = this._logic.LINKAGE_PREFIX + "team_chooser.sounds.";
            this._queue = new CommandQueue();
            this._queue.add(new CommandTimer(500));
            this._queue.add(new CommandObject(this.playSound, _loc_1 + "countries." + this._logic.country_1.type.toLowerCase()));
            this._queue.add(new CommandObject(this.playSound, _loc_1 + "vs"));
            this._queue.add(new CommandObject(this.playSound, _loc_1 + "countries." + this._logic.country_2.type.toLowerCase()));
            this._queue.add(new CommandTimer(500));
            this._queue.add(new CommandFunction(this.onClose));
            this._queue.add(new CommandFunction(this.dispose));
            return;
        }// end function

        protected function onClose() : void
        {
            this._logic.state = GameState.NORMAL;
            this._logic._button_novel.enableAll(true, GameStates.STATE_NORMAL);
            this._logic._button_novel.enable(GameButtons.GAMBLE_BUTTON, false);
            this._logic.hideGameWindow(false);
            this._logic._main_window.removeChild(this._graphics);
            this._logic._team_chooser.updateFlags();
            this._logic.onTeamChanged();
            (this._module_interface as IServiceInterface).hideCommonUI(false);
            return;
        }// end function

        protected function initializeCountry(_logic:MovieClip) : void
        {
            var _loc_2:ButtonComponent = null;
            var _loc_3:int = 0;
            var _loc_5:MovieClip = null;
            var _loc_6:MovieClip = null;
            var _loc_7:MovieClip = null;
            var _loc_8:String = null;
            var _loc_4:* = _logic.numChildren;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_2 = _logic.getChildAt(_loc_3) as ButtonComponent;
                this._module_interface.addTabElement(this._tab_set_id, _loc_2);
                _loc_2.getLogic().registerHandler(this.buttonHandler, _logic, _loc_2);
                _loc_8 = _loc_2.name.toUpperCase();
                _loc_5 = _loc_2.icon as MovieClip;
                _loc_6 = _loc_5.getChildByName("flag") as MovieClip;
                _loc_6 = _loc_6.getChildAt(0) as MovieClip;
                _loc_6.gotoAndStop(_loc_8);
                _loc_7 = _loc_5.getChildByName("names") as MovieClip;
                _loc_7.gotoAndStop(_loc_8);
                _loc_3++;
            }
            return;
        }// end function

        public function dispose() : void
        {
            if (this._module_interface)
            {
                this._module_interface.removeKeyboardSet(this._tab_set_id);
            }
            if (this._logic)
            {
                this._logic.removeEventListener(Server.ON_TEAMS_RECIEVED, this.onTeamsRecieved);
            }
            if (this._queue)
            {
                this._queue.dispose();
            }
            this._queue = null;
            this._graphics = null;
            this._logic = null;
            this._module_interface = null;
            this._continue_button = null;
            this._country_1 = null;
            this._country_2 = null;
            return;
        }// end function

        protected function buttonHandler(_logic:MovieClip, _logic:ButtonComponent) : void
        {
            if (_logic == this._country_1)
            {
                this._logic.country_1 = Country.fromType(_logic.name.toUpperCase());
                this._choice_1 = this._logic.country_1.type;
            }
            if (_logic == this._country_2)
            {
                this._logic.country_2 = Country.fromType(_logic.name.toUpperCase());
                this._choice_2 = this._logic.country_2.type;
            }
            this.updateSelection(true);
            return;
        }// end function

        protected function resetButtons(_logic:MovieClip) : void
        {
            var _loc_2:ButtonComponent = null;
            var _loc_3:IButton = null;
            var _loc_4:int = 0;
            var _loc_5:* = _logic.numChildren;
            _loc_4 = 0;
            while (_loc_4 < _loc_5)
            {
                
                _loc_2 = _logic.getChildAt(_loc_4) as ButtonComponent;
                if (!_loc_2)
                {
                }
                else
                {
                    _loc_3 = _loc_2.getLogic() as IButton;
                    _loc_3.select(false);
                    _loc_3.disable(false);
                }
                _loc_4++;
            }
            return;
        }// end function

        protected function playSound(toLowerCase:String, toLowerCase:String) : int
        {
            var sound_comlete:CommandFunction;
            var sound_linkage:* = toLowerCase;
            var queue_id:* = toLowerCase;
            sound_comlete = new CommandFunction(QueueEventManager.dispatchEvent, queue_id);
            with ({})
            {
                {}.onSoundComplete = function (... args) : void
            {
                sound_comlete.execute("");
                return;
            }// end function
            ;
            }
            var sound_complet_handler:* = function (... args) : void
            {
                sound_comlete.execute("");
                return;
            }// end function
            ;
            return this._logic._module_interface.playAsEffect(sound_linkage, null, 0, sound_complet_handler) == -1 ? (0) : (1);
        }// end function

    }
}
