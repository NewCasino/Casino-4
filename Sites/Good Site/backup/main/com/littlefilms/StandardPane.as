package com.littlefilms
{
    import gs.*;

    public class StandardPane extends ContentPane
    {
        private var _navInfo:Array;
        private var _childCount:uint;
        private var _subNav:LeftNav;

        public function StandardPane(param1:String)
        {
            _navInfo = [];
            super(param1);
            _maximizeButton.buttonLabel.text = "back to team";
            return;
        }// end function

        override public function init() : void
        {
            switch(name)
            {
                case "whoWeAre":
                {
                    TweenMax.to(_paneBG, 0, {tint:16777198});
                    break;
                }
                case "whatWeDo":
                {
                    TweenMax.to(_paneBG, 0, {tint:16775650});
                    break;
                }
                case "contactUs":
                {
                    TweenMax.to(_paneBG, 0, {tint:16775650});
                    break;
                }
                default:
                {
                    break;
                }
            }
            fetchContent(name);
            super.init();
            return;
        }// end function

        override public function setUpPane() : void
        {
            _subNav.activateFirstItem();
            return;
        }// end function

        override public function removeCurrentContent(param1:NavItem) : void
        {
            _subNav.swapNav(param1);
            _subNav.hideBlock();
            return;
        }// end function

        override public function revealNewContent(param1:String) : void
        {
            _subNav.addBlock();
            return;
        }// end function

        private function fetchContent(param1:String) : void
        {
            var _loc_2:* = fetchLeftNavInfo(param1);
            _subNav = new LeftNav(_loc_2);
            _subNav.registerMain(_mainMC);
            _subNav.registerPane(this);
            trace("_childCount = " + _childCount);
            if (_childCount > 1)
            {
                content.addChild(_subNav);
            }
            _subNav.init();
            return;
        }// end function

        private function fetchLeftNavInfo(param1:String) : Array
        {
            var sectionNode:XMLList;
            var item:XML;
            var navItem:Array;
            var paneName:* = param1;
            var _loc_4:int = 0;
            var _loc_5:* = _mainMC.contentManager.contentXML.section;
            var _loc_3:* = new XMLList("");
            for each (_loc_6 in _loc_5)
            {
                
                var _loc_7:* = _loc_5[_loc_4];
                with (_loc_5[_loc_4])
                {
                    if (@id == paneName)
                    {
                        _loc_3[_loc_4] = _loc_6;
                    }
                }
            }
            sectionNode = _loc_3;
            _childCount = sectionNode.children().length();
            var _loc_3:int = 0;
            var _loc_4:* = sectionNode.children();
            while (_loc_4 in _loc_3)
            {
                
                item = _loc_4[_loc_3];
                navItem;
                navItem.push(item.@id);
                navItem.push(item.@name);
                _navInfo.push(navItem);
            }
            return _navInfo;
        }// end function

        public function get subNav() : LeftNav
        {
            return _subNav;
        }// end function

        public function set subNav(param1:LeftNav) : void
        {
            if (param1 !== _subNav)
            {
                _subNav = param1;
            }
            return;
        }// end function

    }
}
