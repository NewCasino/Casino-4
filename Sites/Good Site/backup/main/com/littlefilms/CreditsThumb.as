package com.littlefilms
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import gs.*;
    import gs.easing.*;

    public class CreditsThumb extends GalleryThumb
    {
        private var _thumbLink:String;
        var _labelRestColor:Number;
        var _labelHighlightColor:Number;
        var _bgHighlightColor:Number;
        var _white:Number;
        var _orange:Number;
        var _lightBrown:Number;

        public function CreditsThumb(param1:Sprite, param2:String, param3:String, param4:String)
        {
            super(param1, param2, param3);
            _thumbLink = param4;
            _white = TextFormatter.getColor("_white");
            _orange = TextFormatter.getColor("_orange");
            _lightBrown = TextFormatter.getColor("_lightBrown");
            return;
        }// end function

        override public function init() : void
        {
            super.init();
            TweenMax.to(_thumbBG, 0, {tint:_white});
            TweenMax.to(_thumbLabel, 0.5, {tint:_lightBrown, ease:Expo.easeOut});
            return;
        }// end function

        override protected function highlightNavItem() : void
        {
            TweenMax.to(_thumbBG, 0.5, {tint:_orange, ease:Expo.easeOut});
            TweenMax.to(_thumbLabel, 0.5, {tint:_white, ease:Expo.easeOut});
            return;
        }// end function

        override protected function unHighlightNavItem() : void
        {
            TweenMax.to(_thumbBG, 0.5, {tint:_white, ease:Expo.easeOut});
            TweenMax.to(_thumbLabel, 0.5, {tint:_lightBrown, ease:Expo.easeOut});
            return;
        }// end function

        override protected function navClickHandler(event:MouseEvent) : void
        {
            trace("CreditsThumb::navClickHandler()");
            navigateToURL(new URLRequest(_thumbLink), "_blank");
            return;
        }// end function

    }
}
