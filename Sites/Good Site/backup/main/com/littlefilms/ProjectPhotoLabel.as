package com.littlefilms
{
    import flash.display.*;
    import flash.text.*;
    import gs.*;
    import gs.easing.*;

    public class ProjectPhotoLabel extends MovieClip
    {
        public var buttonLabel:TextField;
        public var buttonBG:MovieClip;
        private var _orange:Number;
        private var _white:Number;
        private static const MAX_BUTTON_WIDTH:uint = 18;
        private static const BUTTON_TEXT_BUFFER:uint = 8;

        public function ProjectPhotoLabel(param1:String = null)
        {
            mouseChildren = false;
            buttonLabel.text = param1 != null ? (param1) : (buttonLabel.text);
            buttonLabel.autoSize = TextFieldAutoSize.RIGHT;
            buttonBG.width = buttonLabel.width < MAX_BUTTON_WIDTH ? (MAX_BUTTON_WIDTH) : (buttonLabel.width + BUTTON_TEXT_BUFFER);
            buttonLabel.x = -(buttonBG.width - buttonLabel.width) / 2 - buttonLabel.width;
            init();
            return;
        }// end function

        public function init() : void
        {
            _orange = TextFormatter.getColor("_orange");
            _white = TextFormatter.getColor("_white");
            return;
        }// end function

        public function highlightLabel() : void
        {
            TweenMax.to(buttonLabel, 0.2, {tint:_orange, ease:Expo.easeOut});
            TweenMax.to(buttonBG, 0.2, {tint:_white, ease:Expo.easeOut});
            return;
        }// end function

        public function unHighlightLabel() : void
        {
            TweenMax.to(buttonLabel, 0.2, {removeTint:true, ease:Expo.easeOut});
            TweenMax.to(buttonBG, 0.2, {removeTint:true, ease:Expo.easeOut});
            return;
        }// end function

        public function hideLabel() : void
        {
            unHighlightLabel();
            TweenMax.to(this, 0.2, {autoAlpha:0, ease:Expo.easeOut});
            return;
        }// end function

        public function revealLabel() : void
        {
            TweenMax.to(this, 0.2, {autoAlpha:1, ease:Expo.easeOut});
            return;
        }// end function

    }
}
