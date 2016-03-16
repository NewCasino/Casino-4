package com.littlefilms
{
    import flash.text.*;
    import gs.*;

    public class WorkPane extends ContentPane
    {
        private var _navInfo:Array;
        private var _subNav:WorkNav;

        public function WorkPane(param1:String)
        {
            _navInfo = [];
            trace("WorkPane::()");
            super(param1);
            _maximizeButton.buttonLabel.text = "back to gallery";
            return;
        }// end function

        override public function init() : void
        {
            TweenMax.to(_paneBG, 0, {tint:16250352});
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
            trace("WorkPane::fetchContent()");
            trace("paneName = " + param1);
            var _loc_2:* = TextFormatter.getTextFmt("_contentBlockHeader");
            var _loc_3:* = new TextField();
            setLayout(_loc_3, _loc_2, "our work");
            content.addChild(_loc_3);
            var _loc_4:* = fetchWorkNavInfo(param1);
            _subNav = new WorkNav(_loc_4);
            _subNav.registerMain(_mainMC);
            _subNav.registerPane(this);
            _subNav.x = _loc_3.x + _loc_3.width + 40;
            _subNav.y = -3;
            _subNav.init();
            content.addChild(_subNav);
            return;
        }// end function

        private function fetchWorkNavInfo(param1:String) : Array
        {
            var _loc_3:XML = null;
            var _loc_4:Array = null;
            trace("WorkPane::fetchWorkNavInfo()");
            var _loc_2:* = _mainMC.contentManager.workXML.folio;
            trace("folioList = " + _loc_2);
            for each (_loc_3 in _loc_2)
            {
                
                trace("item.@id         = " + _loc_3.@id);
                trace("item.label       = " + _loc_3.label);
                trace("item.description = " + _loc_3.description);
                _loc_4 = [];
                _loc_4.push(_loc_3.@id);
                _loc_4.push(_loc_3.label);
                _loc_4.push(_loc_3.description);
                _navInfo.push(_loc_4);
            }
            trace("_navInfo = " + _navInfo);
            return _navInfo;
        }// end function

        private function setLayout(param1:TextField, param2:TextFormat, param3:String) : void
        {
            param1.multiline = false;
            param1.wordWrap = false;
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

    }
}
