package com.littlefilms
{
    import flash.events.*;
    import gs.*;
    import gs.easing.*;

    public class LeftNavItem extends NavItem
    {

        public function LeftNavItem(param1:String, param2:String)
        {
            _navItemFormat = TextFormatter.getTextFmt("_leftNavItem");
            super(param1, param2);
            return;
        }// end function

        override protected function navClickHandler(event:MouseEvent) : void
        {
            trace("override protected function navClickHandler()");
            _mainMC.sequencer.changeSubSection(this);
            return;
        }// end function

        override protected function highlightNavItem() : void
        {
            trace("override protected function highlightNavItem");
            var _loc_1:* = TextFormatter.getColor("_orange");
            TweenMax.to(this, 0.2, {tint:_loc_1, ease:Expo.easeOut});
            return;
        }// end function

    }
}
