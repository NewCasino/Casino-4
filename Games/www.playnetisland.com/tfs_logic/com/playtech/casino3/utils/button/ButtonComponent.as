package com.playtech.casino3.utils.button
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class ButtonComponent extends MovieClip
    {
        protected var _container:MovieClip;
        private var _param_label:String = "";
        private var _param_icon:String = "";
        private var _param_soundOver:String = "";
        private var _param_hint:String = "";
        private var _param_sound:String = "ui.click";
        private var _param_changeSize:Boolean = false;
        public var dummy:MovieClip;
        private var isLivePreview:Boolean;
        private var _param_fontResize:String = "none";
        protected var _gfx:MovieClip;
        private var _param_gfx:String = "";
        private var _param_type:String = "regular";
        protected var _icon:DisplayObject;
        private var logic:Object;

        public function ButtonComponent()
        {
            var controlClass:Class;
            this.isLivePreview = parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent";
            if (!this.isLivePreview)
            {
                try
                {
                    controlClass = getClassByAlias("ButtonLogicClass") as Class;
                    this.logic = new controlClass(this);
                }
                catch (err:Error)
                {
                    trace("Cannot create a Logic object for this button");
                }
                addEventListener(Event.ADDED_TO_STAGE, this.init);
                tabEnabled = false;
                tabChildren = false;
            }
            return;
        }// end function

        public function get gfx() : MovieClip
        {
            return this._gfx;
        }// end function

        public function get container() : MovieClip
        {
            return this._container;
        }// end function

        public function get icon() : DisplayObject
        {
            return this._icon;
        }// end function

        public function set param_label(value:String) : void
        {
            this._param_label = value;
            if (this.logic != null)
            {
                this.logic.updateText();
            }
            return;
        }// end function

        private function cleanGraphics(value:Boolean = false) : void
        {
            if (!value)
            {
                this.dummyBack();
            }
            this._icon = null;
            this._gfx = null;
            return;
        }// end function

        public function set param_changeSize(value:Boolean) : void
        {
            this._param_changeSize = value;
            return;
        }// end function

        public function set param_gfx(value:String) : void
        {
            this._param_gfx = value;
            if (!this.isLivePreview)
            {
                this.updateGraphics();
            }
            return;
        }// end function

        public function setIcon(value:DisplayObject) : void
        {
            if (value.parent == null)
            {
                if (this._icon != null)
                {
                    this._icon.parent.removeChild(this._icon);
                    this._icon = null;
                }
                if (this._gfx == this)
                {
                    return;
                }
                this._param_icon = "";
                this.getIconContainer().addChild(value);
            }
            this._icon = value;
            var _loc_2:* = this._icon.parent.name == "icon_dummy" ? (this._icon.parent.parent) : (this._icon.parent);
            this._icon.scaleX = this._icon.scaleX / _loc_2.scaleX / this.scaleX;
            this._icon.scaleY = this._icon.scaleY / _loc_2.scaleY / this.scaleY;
            if (this.logic != null)
            {
                this.logic.setIconRef(this._icon);
            }
            return;
        }// end function

        private function init(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            if (this._gfx == null)
            {
                this.updateGraphics();
            }
            if (this.logic != null)
            {
                this.logic.componentReady();
            }
            return;
        }// end function

        public function set param_soundOver(value:String) : void
        {
            this._param_soundOver = value;
            return;
        }// end function

        public function set param_fontResize(value:String) : void
        {
            this._param_fontResize = value;
            return;
        }// end function

        public function get param_type() : String
        {
            return this._param_type;
        }// end function

        public function getLogic() : Object
        {
            return this.logic;
        }// end function

        private function dummyBack() : void
        {
            var _loc_1:MovieClip = null;
            if (this._gfx != this)
            {
                hitArea = null;
                _loc_1 = new MovieClip();
                _loc_1.scaleX = this._gfx.parent.scaleX;
                _loc_1.scaleY = this._gfx.parent.scaleY;
                _loc_1.graphics.beginFill(16711680);
                _loc_1.graphics.drawRect(0, 0, this._gfx.width, this._gfx.height);
                _loc_1.graphics.endFill();
                _loc_1.name = "dummy";
                addChild(_loc_1);
                removeChild(this._gfx.parent as MovieClip);
            }
            return;
        }// end function

        public function set param_sound(value:String) : void
        {
            this._param_sound = value;
            return;
        }// end function

        public function get param_label() : String
        {
            return this._param_label;
        }// end function

        public function get param_changeSize() : Boolean
        {
            return this._param_changeSize;
        }// end function

        public function get param_gfx() : String
        {
            return this._param_gfx;
        }// end function

        public function clear() : void
        {
            this.cleanGraphics(true);
            this.logic = null;
            this.dummy = null;
            this._container = null;
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            return;
        }// end function

        public function get param_soundOver() : String
        {
            return this._param_soundOver;
        }// end function

        private function getIconContainer() : Sprite
        {
            var _loc_1:* = Sprite(this._container.getChildByName("icon_dummy"));
            var _loc_2:* = _loc_1 != null ? (_loc_1) : (this._container);
            return _loc_2;
        }// end function

        public function get param_fontResize() : String
        {
            return this._param_fontResize;
        }// end function

        public function set param_icon(value:String) : void
        {
            this._param_icon = value;
            if (!this.isLivePreview)
            {
                this.updateIcon();
            }
            return;
        }// end function

        public function get param_sound() : String
        {
            return this._param_sound;
        }// end function

        public function set param_type(value:String) : void
        {
            this._param_type = value;
            return;
        }// end function

        private function updateIcon() : void
        {
            var iconMc:MovieClip;
            var classRef:Class;
            if (this._icon != null)
            {
                this._icon.parent.removeChild(this._icon);
                this._icon = null;
                if (this.logic != null)
                {
                    this.logic.setIconRef(this._icon);
                }
            }
            if (this._gfx == this)
            {
                return;
            }
            if (this.param_icon != "")
            {
                try
                {
                    classRef = ApplicationDomain.currentDomain.getDefinition(this.param_icon) as Class;
                }
                catch (err:Error)
                {
                    if (logic != null)
                    {
                        logic.loadIcon(getIconContainer());
                    }
                    return;
                }
                iconMc = this.MovieClip(new classRef);
                this.getIconContainer().addChild(iconMc);
                this.setIcon(iconMc);
            }
            return;
        }// end function

        public function get param_icon() : String
        {
            return this._param_icon;
        }// end function

        public function set param_hint(value:String) : void
        {
            this._param_hint = value;
            return;
        }// end function

        public function get param_hint() : String
        {
            return this._param_hint;
        }// end function

        private function updateGraphics() : void
        {
            var dummyMC:MovieClip;
            var classRef:Class;
            var graphics:MovieClip;
            var hitMC:MovieClip;
            var origScaleX:Number;
            var origScaleY:Number;
            var multiplier1:Number;
            var multiplier2:Number;
            var item:DisplayObject;
            var i:int;
            if (this._gfx != null)
            {
                this.cleanGraphics();
            }
            dummyMC = getChildByName("dummy") as MovieClip;
            if (this.param_gfx != "")
            {
                try
                {
                    classRef = ApplicationDomain.currentDomain.getDefinition(this.param_gfx) as Class;
                    graphics = new classRef as MovieClip;
                    this._container = graphics;
                    this._gfx = this._container.getChildByName("gfx") as MovieClip;
                    this._gfx.gotoAndStop(1);
                    if (this.param_changeSize)
                    {
                        this.width = this._container.width;
                        this.height = this._container.height;
                        this.scaleX = 1;
                        this.scaleY = 1;
                    }
                    else
                    {
                        origScaleX = scaleX;
                        origScaleY = scaleY;
                        scaleX = 1;
                        scaleY = 1;
                        multiplier1 = width / this._gfx.width * origScaleX;
                        multiplier2 = height / this._gfx.height * origScaleY;
                        i;
                        while (i < this._container.numChildren)
                        {
                            
                            item = this._container.getChildAt(i);
                            if (item.width != 0)
                            {
                                item.width = item.width * multiplier1;
                                item.height = item.height * multiplier2;
                            }
                            item.x = item.x * multiplier1;
                            item.y = item.y * multiplier2;
                            i = (i + 1);
                        }
                    }
                    addChild(this._container);
                    hitMC = this._container.getChildByName("hitarea") as MovieClip;
                    if (hitMC != null)
                    {
                        hitArea = hitMC;
                        hitMC.visible = false;
                    }
                    removeChild(dummyMC);
                    dummyMC;
                }
                catch (err:Error)
                {
                    trace("Cannot find a movieclip with a linkage name \"" + param_gfx + "\" from library or \"gfx\" is missing inside that mc.");
                    dummyMC.alpha = 0;
                    _gfx = this;
                }
            }
            else
            {
                dummyMC.alpha = 0;
                this._gfx = this;
            }
            if (this.logic != null)
            {
                this.logic.setGfx(this._gfx);
            }
            return;
        }// end function

    }
}
