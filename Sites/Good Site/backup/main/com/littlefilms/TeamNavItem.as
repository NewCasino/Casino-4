package com.littlefilms
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    import gs.easing.*;

    public class TeamNavItem extends Sprite
    {
        private var _itemXML:XML;
        private var _targetLabel:String;
        private var _enabled:Boolean = true;
        private var _active:Boolean = false;
        private var _memberNameFormat:TextFormat;
        private var _memberTitleFormat:TextFormat;
        private var _memberName:TextField;
        private var _memberTitle:TextField;
        private var _memberAvatar:Sprite;
        private var _memberAvatarHeight:uint = 104;
        private var _memberAvatarFloat:int = -10;
        private var _controller:Object;
        private var _mainMC:Object;
        protected var _bgManager:BGManager;

        public function TeamNavItem(param1:XML)
        {
            _itemXML = param1;
            name = param1.@id;
            _memberNameFormat = TextFormatter.getTextFmt("_teamThumbName");
            _memberTitleFormat = TextFormatter.getTextFmt("_teamThumbTitle");
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
            var _loc_1:* = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
            var _loc_2:* = _itemXML.thumbnail.@src.toString();
            var _loc_3:* = _itemXML.thumbnail.@width;
            var _loc_4:* = _itemXML.thumbnail.@height;
            _memberAvatar = _mainMC.contentManager.getImage(_loc_2, _loc_1, _loc_3, _loc_4);
            _memberAvatar.height = _memberAvatarHeight;
            _memberAvatar.scaleX = _memberAvatar.scaleY;
            TweenMax.to(_memberAvatar, 0, {dropShadowFilter:{color:0, alpha:0.7, blurX:5, blurY:5, strength:1, distance:2}});
            addChild(_memberAvatar);
            _memberName = new TextField();
            setLayout(_memberName, _memberNameFormat, _itemXML.thumbnail.@name);
            _memberName.y = _memberAvatar.height + 10;
            addChild(_memberName);
            _memberTitle = new TextField();
            _memberTitle.y = _memberName.y + _memberName.height;
            setLayout(_memberTitle, _memberTitleFormat, _itemXML.thumbnail.@title);
            addChild(_memberTitle);
            var _loc_5:* = buildSprite(width, height);
            buildSprite(width, height).alpha = 0;
            addChild(_loc_5);
            return;
        }// end function

        protected function highlightNavItem() : void
        {
            TweenMax.to(_memberAvatar, 1, {y:_memberAvatarFloat, ease:Expo.easeOut});
            return;
        }// end function

        protected function unHighlightNavItem() : void
        {
            TweenMax.to(_memberAvatar, 0.3, {y:0, ease:Bounce.easeOut});
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
            var _loc_5:Sprite = null;
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            _loc_5 = new Sprite();
            _loc_5.graphics.beginFill(0);
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
            trace("TeamNavItem::navClickHandler()");
            _mainMC.sequencer.changeSection(name, "member");
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
