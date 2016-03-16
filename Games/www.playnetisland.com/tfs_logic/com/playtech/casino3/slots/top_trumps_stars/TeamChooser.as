package com.playtech.casino3.slots.top_trumps_stars
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.utils.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import com.playtech.casino3.utils.button.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class TeamChooser extends EventDispatcher implements IDisposable
    {
        protected var _module_interface:IModuleInterface;
        protected var _country_2_chooser:MovieClip;
        protected var _country_1:ButtonComponent;
        protected var _country_1_chooser:MovieClip;
        protected var _tab_set_2_id:int;
        protected var stage:Stage;
        protected var _country_2:ButtonComponent;
        protected var _logic:Logic;
        protected var _tab_set_id:int;
        protected var _countries_1:MovieClipController;
        protected var _countries_2:MovieClipController;
        protected var _graphics:MovieClip;
        protected var _tab_set_1_id:int;
        protected var _flag_1:MovieClip;
        protected var _flag_2:MovieClip;
        public static const TEAM_CHANGED:String = getQualifiedClassName(TeamChooser) + ".TEAM_CHANGED";

        public function TeamChooser(_graphics:MovieClip, _graphics:Logic) : void
        {
            this._graphics = _graphics;
            this._logic = _graphics;
            this._module_interface = this._logic._module_interface;
            this.stage = this._graphics.stage;
            this.initialize();
            return;
        }// end function

        public function get buttons() : Array
        {
            return [this._country_1, this._country_2];
        }// end function

        protected function buttonOverHandler(_graphics:ButtonComponent) : void
        {
            _graphics.parent.addChild(_graphics);
            return;
        }// end function

        protected function initializeChooser(_graphics:MovieClip, _graphics:int) : void
        {
            var _loc_3:ButtonComponent = null;
            var _loc_4:IButton = null;
            var _loc_5:int = 0;
            var _loc_7:MovieClip = null;
            var _loc_8:MovieClip = null;
            var _loc_9:MovieClip = null;
            var _loc_10:String = null;
            var _loc_6:* = _graphics.numChildren;
            _loc_5 = 0;
            while (_loc_5 < _loc_6)
            {
                
                _loc_3 = _graphics.getChildAt(_loc_5) as ButtonComponent;
                if (!_loc_3)
                {
                }
                else
                {
                    this._module_interface.addTabElement(_graphics, _loc_3);
                    _loc_4 = _loc_3.getLogic() as IButton;
                    _loc_4.registerHandler(this.buttonHandler, _graphics, _loc_3);
                    _loc_4.registerOverInHandler(this.buttonOverHandler, _loc_3);
                    _loc_10 = _loc_3.name.toUpperCase();
                    _loc_7 = _loc_3.container;
                    _loc_8 = _loc_7.getChildByName("flag") as MovieClip;
                    _loc_8 = _loc_8.getChildAt(0) as MovieClip;
                    _loc_8.gotoAndStop(_loc_10);
                    _loc_9 = _loc_7.getChildByName("names") as MovieClip;
                    _loc_9.gotoAndStop(_loc_10);
                }
                _loc_5++;
            }
            return;
        }// end function

        protected function initialize() : void
        {
            this._tab_set_id = this._module_interface.createKeyboardSet();
            this._country_1 = this._graphics.getChildByName("country_1") as ButtonComponent;
            this._country_2 = this._graphics.getChildByName("country_2") as ButtonComponent;
            this._flag_1 = this._graphics.getChildByName("flag_1") as MovieClip;
            this._flag_2 = this._graphics.getChildByName("flag_2") as MovieClip;
            this._country_1_chooser = this._graphics.getChildByName("country_1_chooser") as MovieClip;
            this._country_2_chooser = this._graphics.getChildByName("country_2_chooser") as MovieClip;
            this._countries_1 = new MovieClipController(this._country_1_chooser);
            this._countries_2 = new MovieClipController(this._country_2_chooser);
            this._countries_1.stop(this._country_1_chooser.totalFrames);
            this._countries_2.stop(this._country_2_chooser.totalFrames);
            (this._country_1.getLogic() as IButton).registerUpHandler(this.openChooser, this._countries_1);
            (this._country_2.getLogic() as IButton).registerUpHandler(this.openChooser, this._countries_2);
            this._tab_set_1_id = this._module_interface.createKeyboardSet();
            this._tab_set_2_id = this._module_interface.createKeyboardSet();
            this.initializeChooser(this._country_1_chooser.getChildByName("buttons") as MovieClip, this._tab_set_1_id);
            this.initializeChooser(this._country_2_chooser.getChildByName("buttons") as MovieClip, this._tab_set_2_id);
            this._module_interface.enableKeyboardSet(this._tab_set_1_id, false);
            this._module_interface.enableKeyboardSet(this._tab_set_2_id, false);
            this.updateFlags();
            return;
        }// end function

        public function openChooser(_graphics:MovieClipController) : void
        {
            if (this._logic.state != GameState.NORMAL)
            {
                return;
            }
            if (_graphics.movie_clip.currentFrame == 1)
            {
                return this.closeChooser();
            }
            this.stage.addEventListener(MouseEvent.MOUSE_UP, this.checkCloseChooser, true);
            this._module_interface.enableKeyboardSet(_graphics == this._countries_1 ? (this._tab_set_1_id) : (this._tab_set_2_id), true);
            (_graphics.movie_clip.getChildByName("buttons") as MovieClip).mouseChildren = true;
            _graphics.playTo(1);
            return;
        }// end function

        protected function checkCloseChooser(event:Event) : void
        {
            if (this._country_1_chooser.contains(event.target as DisplayObject) || this._country_2_chooser.contains(event.target as DisplayObject))
            {
                return;
            }
            this.closeChooser();
            return;
        }// end function

        public function updateFlags() : void
        {
            var _loc_1:MovieClip = null;
            var _loc_2:IButton = null;
            var _loc_3:ButtonComponent = null;
            if (!this._logic.country_1 || !this._logic.country_2)
            {
                return;
            }
            (this._flag_1.getChildAt(0) as MovieClip).gotoAndStop(this._logic.country_1.type);
            (this._flag_2.getChildAt(0) as MovieClip).gotoAndStop(this._logic.country_2.type);
            this.enableChooser(this._country_1_chooser.getChildByName("buttons") as MovieClip, true);
            this.enableChooser(this._country_2_chooser.getChildByName("buttons") as MovieClip, true);
            _loc_1 = this._country_1_chooser.getChildByName("buttons") as MovieClip;
            _loc_3 = _loc_1.getChildByName(this._logic.country_1.type.toLowerCase()) as ButtonComponent;
            this.enableButton(_loc_3, false);
            _loc_3.gfx.gotoAndStop("disabled_s");
            _loc_3 = _loc_1.getChildByName(this._logic.country_2.type.toLowerCase()) as ButtonComponent;
            this.enableButton(_loc_3, false);
            _loc_1 = this._country_2_chooser.getChildByName("buttons") as MovieClip;
            _loc_3 = _loc_1.getChildByName(this._logic.country_1.type.toLowerCase()) as ButtonComponent;
            this.enableButton(_loc_3, false);
            _loc_3.gfx.gotoAndStop("disabled_s");
            _loc_3 = _loc_1.getChildByName(this._logic.country_2.type.toLowerCase()) as ButtonComponent;
            this.enableButton(_loc_3, false);
            return;
        }// end function

        public function closeChooser(event:Event = null) : void
        {
            this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.checkCloseChooser, true);
            this._module_interface.enableKeyboardSet(this._tab_set_1_id, false);
            this._module_interface.enableKeyboardSet(this._tab_set_2_id, false);
            this._countries_1.playTo(this._countries_1.movie_clip.totalFrames);
            this._countries_2.playTo(this._countries_2.movie_clip.totalFrames);
            return;
        }// end function

        protected function enableButton(_graphics:ButtonComponent, _graphics:Boolean) : void
        {
            var _loc_3:* = _graphics.getLogic() as IButton;
            _loc_3.disable(!_graphics);
            return;
        }// end function

        public function dispose() : void
        {
            if (this._module_interface)
            {
                this._module_interface.removeKeyboardSet(this._tab_set_id);
                this._module_interface.removeKeyboardSet(this._tab_set_1_id);
                this._module_interface.removeKeyboardSet(this._tab_set_2_id);
            }
            if (this.stage)
            {
                this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.closeChooser, true);
            }
            disposeObjects(this._countries_1, this._countries_2);
            this._graphics = null;
            this._logic = null;
            this._module_interface = null;
            this._country_1 = null;
            this._country_2 = null;
            this._countries_1 = null;
            this._countries_2 = null;
            this._country_1_chooser = null;
            this._country_2_chooser = null;
            this._flag_1 = null;
            this._flag_2 = null;
            this.stage = null;
            return;
        }// end function

        public function set disable(_graphics:Boolean) : void
        {
            this._module_interface.enableKeyboardSet(this._tab_set_id, _graphics);
            if (_graphics)
            {
                this._module_interface.enableKeyboardSet(this._tab_set_1_id, _graphics);
                this._module_interface.enableKeyboardSet(this._tab_set_2_id, _graphics);
            }
            return;
        }// end function

        public function openChooserFromIndex(_graphics:int) : void
        {
            this.openChooser(_graphics == 1 ? (this._countries_1) : (this._countries_2));
            return;
        }// end function

        protected function enableChooser(_graphics:MovieClip, _graphics:Boolean) : void
        {
            var _loc_3:ButtonComponent = null;
            var _loc_4:IButton = null;
            var _loc_5:int = 0;
            var _loc_6:* = _graphics.numChildren;
            _loc_5 = 0;
            while (_loc_5 < _loc_6)
            {
                
                _loc_3 = _graphics.getChildAt(_loc_5) as ButtonComponent;
                if (!_loc_3)
                {
                }
                else
                {
                    this.enableButton(_loc_3, _graphics);
                }
                _loc_5++;
            }
            return;
        }// end function

        public function hide(_graphics:Boolean) : void
        {
            this.disable = _graphics;
            this._graphics.visible = !_graphics;
            return;
        }// end function

        protected function buttonHandler(_graphics:MovieClip, _graphics:ButtonComponent) : void
        {
            _graphics.mouseChildren = false;
            if (_graphics.parent == this._country_1_chooser)
            {
                this._logic.country_1 = Country.fromType(_graphics.name.toUpperCase());
            }
            if (_graphics.parent == this._country_2_chooser)
            {
                this._logic.country_2 = Country.fromType(_graphics.name.toUpperCase());
            }
            this._logic._server.setTeams();
            this.updateFlags();
            dispatchEvent(new Event(TEAM_CHANGED));
            this.closeChooser();
            return;
        }// end function

    }
}
