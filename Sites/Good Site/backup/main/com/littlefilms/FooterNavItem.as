package com.littlefilms
{
    import flash.events.*;
    import gs.*;
    import gs.easing.*;

    public class FooterNavItem extends NavItem
    {

        public function FooterNavItem(param1:String, param2:String)
        {
            _navItemFormat = TextFormatter.getTextFmt("_footerNavItem");
            super(param1, param2);
            return;
        }// end function

        override protected function navClickHandler(event:MouseEvent) : void
        {
            super.navClickHandler(event);
            _mainMC.sequencer.changeSection(name, "standard");
            return;
        }// end function

        override protected function highlightNavItem() : void
        {
            var _loc_1:* = TextFormatter.getColor("_brown");
            TweenMax.to(this, 0.2, {tint:_loc_1, ease:Expo.easeOut});
            return;
        }// end function

    }
}
