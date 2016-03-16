package com.littlefilms
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    import gs.easing.*;

    public class GalleryThumb extends Sprite
    {
        protected var _itemXML:XML;
        protected var _targetLabel:String;
        protected var _enabled:Boolean = true;
        protected var _active:Boolean = false;
        protected var _thumbLabelFormat:TextFormat;
        protected var _memberTitleFormat:TextFormat;
        protected var _memberTitle:TextField;
        protected var _memberAvatar:Sprite;
        protected var _thumbImageWidth:uint = 211;
        protected var _memberAvatarFloat:int = -10;
        protected var _controller:Object;
        protected var _mainMC:Object;
        protected var _thumbImage:Sprite;
        protected var _thumbText:String;
        protected var _thumbLabel:TextField;
        protected var _thumbBorder:uint = 7;
        protected var _thumbBG:Sprite;
        protected var _thumbBaseColor:Number;
        protected var _thumbHighlightColor:Number;
        protected var _bgManager:BGManager;

        public function GalleryThumb(param1:Sprite, param2:String, param3:String)
        {
            _thumbImage = param1;
            _thumbText = param2;
            name = param3;
            _thumbLabelFormat = TextFormatter.getTextFmt("_workGalleryThumb");
            _thumbHighlightColor = TextFormatter.getColor("_orange");
            _thumbBaseColor = 12498828;
            cacheAsBitmap = true;
            return;
        }// end function

        public function init() : void
        {
            layoutButton();
            mouseChildren = false;
            if (_active)
            {
                trace("NavItem: " + name + " is active by default.");
            }
            else
            {
                buttonMode = true;
                mouseEnabled = true;
                addEventListener(MouseEvent.MOUSE_OVER, navOverHandler, false, 0, true);
                addEventListener(MouseEvent.MOUSE_OUT, navOutHandler, false, 0, true);
                addEventListener(MouseEvent.CLICK, navClickHandler, false, 0, true);
            }
            return;
        }// end function

        public function toggleEnabled() : void
        {
            trace("LeftNavItem::toggleEnabled()");
            if (_active)
            {
                trace("Disable " + name);
                buttonMode = false;
                mouseEnabled = false;
                removeEventListener(MouseEvent.MOUSE_OVER, navOverHandler);
                removeEventListener(MouseEvent.MOUSE_OUT, navOutHandler);
                removeEventListener(MouseEvent.CLICK, navClickHandler);
                highlightNavItem();
            }
            else
            {
                trace("Enable " + name);
                buttonMode = true;
                mouseEnabled = true;
                addEventListener(MouseEvent.MOUSE_OVER, navOverHandler, false, 0, true);
                addEventListener(MouseEvent.MOUSE_OUT, navOutHandler, false, 0, true);
                addEventListener(MouseEvent.CLICK, navClickHandler, false, 0, true);
                unHighlightNavItem();
            }
            return;
        }// end function

        public function registerMain(param1:Sprite) : void
        {
            _mainMC = param1;
            return;
        }// end function

        public function registerController(param1:Sprite) : void
        {
            _controller = param1;
            return;
        }// end function

        protected function layoutButton() : void
        {
            trace("GalleryThumb::layoutButton()");
            _thumbImage.x = _thumbBorder;
            _thumbImage.y = _thumbBorder;
            _thumbImage.width = _thumbImageWidth;
            _thumbImage.scaleY = _thumbImage.scaleX;
            addChild(_thumbImage);
            _thumbLabel = new TextField();
            _thumbLabel.x = _thumbImage.x;
            _thumbLabel.y = _thumbImage.y + _thumbImage.height;
            _thumbLabel.width = _thumbImage.width;
            setLayout(_thumbLabel, _thumbLabelFormat, _thumbText);
            addChild(_thumbLabel);
            var _loc_1:* = width + _thumbBorder * 2;
            var _loc_2:* = height + _thumbBorder * 2 - 5;
            _thumbBG = buildSprite(_loc_1, _loc_2);
            addChildAt(_thumbBG, 0);
            return;
        }// end function

        protected function highlightNavItem() : void
        {
            TweenMax.to(_thumbBG, 0.5, {tint:_thumbHighlightColor, ease:Expo.easeOut});
            return;
        }// end function

        protected function unHighlightNavItem() : void
        {
            TweenMax.to(_thumbBG, 0.5, {removeTint:true, ease:Expo.easeOut});
            return;
        }// end function

        private function setLayout(param1:TextField, param2:TextFormat, param3:String) : void
        {
            param1.multiline = true;
            param1.wordWrap = true;
            param1.embedFonts = true;
            param1.selectable = false;
            param1.autoSize = TextFieldAutoSize.LEFT;
            param1.antiAliasType = AntiAliasType.ADVANCED;
            if (param2.size <= 12)
            {
                param1.thickness = 100;
            }
            param1.htmlText = param3;
            param1.setTextFormat(param2);
            return;
        }// end function

        private function buildSprite(param1:uint, param2:uint) : Sprite
        {
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            var _loc_5:* = new Sprite();
            new Sprite().graphics.beginFill(_thumbBaseColor);
            _loc_5.graphics.drawRect(0, 0, _loc_3, _loc_4);
            _loc_5.graphics.endFill();
            _loc_5.x = 0;
            _loc_5.y = 0;
            return _loc_5;
        }// end function

        protected function navOverHandler(event:MouseEvent) : void
        {
            if (_enabled)
            {
                highlightNavItem();
            }
            return;
        }// end function

        protected function navOutHandler(event:MouseEvent) : void
        {
            unHighlightNavItem();
            return;
        }// end function

        protected function navClickHandler(event:MouseEvent) : void
        {
            trace("GalleryThumb::navClickHandler()");
            _mainMC.sequencer.changeSection(name, "project");
            return;
        }// end function

        public function get targetLabel() : String
        {
            return _targetLabel;
        }// end function

        public function set targetLabel(param1:String) : void
        {
            if (param1 !== _targetLabel)
            {
                _targetLabel = param1;
            }
            return;
        }// end function

        public function get enabled() : Boolean
        {
            return _enabled;
        }// end function

        public function set enabled(param1:Boolean) : void
        {
            _enabled = param1;
            return;
        }// end function

        public function get active() : Boolean
        {
            return _active;
        }// end function

        public function set active(param1:Boolean) : void
        {
            _active = param1;
            toggleEnabled();
            return;
        }// end function

    }
}
