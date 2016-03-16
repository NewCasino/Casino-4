package com.littlefilms
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    import gs.easing.*;

    public class WorkNavItem extends NavItem
    {
        private var _highlightText:TextField;
        private var _highlightTextFmt:TextFormat;

        public function WorkNavItem(param1:String, param2:String, param3:String)
        {
            trace("WorkNavItem::()");
            trace("section       = " + param1);
            trace("targetLabel   = " + param2);
            trace("highlightCopy = " + param3);
            trace("WorkNavItem::()");
            _navItemFormat = TextFormatter.getTextFmt("_leftNavItem");
            _highlightTextFmt = TextFormatter.getTextFmt("_workToggleHighlight");
            var _loc_4:* = buildSprite(width, height);
            buildSprite(width, height).alpha = 0;
            addChild(_loc_4);
            super(param1, param2);
            _highlightText = new TextField();
            _highlightText.x = 55;
            _highlightText.y = 2;
            _highlightText.alpha = 0;
            setLayout(_highlightText, _highlightTextFmt, param3);
            addChild(_highlightText);
            trace("WorkNavItem name = " + name);
            return;
        }// end function

        override protected function highlightNavItem() : void
        {
            var _loc_1:* = TextFormatter.getColor("_orange");
            TweenMax.to(this, 0.2, {tint:_loc_1, ease:Expo.easeOut});
            TweenMax.to(_highlightText, 0.2, {alpha:1, ease:Expo.easeOut});
            return;
        }// end function

        override protected function unHighlightNavItem() : void
        {
            super.unHighlightNavItem();
            TweenMax.to(_highlightText, 0.2, {alpha:0, ease:Expo.easeOut});
            return;
        }// end function

        override protected function navClickHandler(event:MouseEvent) : void
        {
            trace("WorkNavItem::navClickHandler()");
            _mainMC.sequencer.changeSubSection(this);
            return;
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

        private function buildSprite(param1:uint, param2:uint) : Sprite
        {
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            var _loc_5:* = new Sprite();
            new Sprite().graphics.beginFill(12498828);
            _loc_5.graphics.drawRect(0, 0, _loc_3, _loc_4);
            _loc_5.graphics.endFill();
            _loc_5.x = 0;
            _loc_5.y = 0;
            return _loc_5;
        }// end function

    }
}
