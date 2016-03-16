package com.littlefilms
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    import gs.easing.*;

    public class NavItem extends Sprite
    {
        protected var _targetLabel:String;
        protected var _enabled:Boolean = true;
        protected var _active:Boolean = false;
        protected var _navItemFormat:TextFormat;
        protected var _navItem:TextField;
        protected var _controller:Object;
        protected var _mainMC:Object;
        protected var _bgManager:BGManager;

        public function NavItem(param1:String, param2:String)
        {
            trace("NavItem::()");
            trace("section     = " + param1);
            trace("targetLabel = " + param2);
            name = param1;
            _targetLabel = param2;
            init();
            return;
        }// end function

        protected function init() : void
        {
            layoutCopy();
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
            if (_active)
            {
                buttonMode = false;
                mouseEnabled = false;
                removeEventListener(MouseEvent.MOUSE_OVER, navOverHandler);
                removeEventListener(MouseEvent.MOUSE_OUT, navOutHandler);
                removeEventListener(MouseEvent.CLICK, navClickHandler);
                highlightNavItem();
            }
            else
            {
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

        protected function layoutCopy() : void
        {
            _navItem = new TextField();
            _navItem.htmlText = "";
            _navItem.multiline = false;
            _navItem.wordWrap = false;
            _navItem.embedFonts = true;
            _navItem.selectable = false;
            _navItem.autoSize = TextFieldAutoSize.LEFT;
            _navItem.antiAliasType = AntiAliasType.ADVANCED;
            _navItem.htmlText = _targetLabel;
            _navItem.setTextFormat(_navItemFormat);
            addChild(_navItem);
            return;
        }// end function

        protected function highlightNavItem() : void
        {
            TweenMax.to(this, 0.2, {tint:16711680, ease:Expo.easeOut});
            return;
        }// end function

        protected function unHighlightNavItem() : void
        {
            TweenMax.to(this, 0.2, {removeTint:true, ease:Expo.easeOut});
            return;
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
            trace("NavItem::navClickHandler()");
            _controller.swapNav(this);
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
