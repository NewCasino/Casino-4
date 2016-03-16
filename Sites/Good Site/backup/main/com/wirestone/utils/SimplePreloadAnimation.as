package com.wirestone.utils
{
    import fl.motion.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;

    public class SimplePreloadAnimation extends Sprite
    {
        private var _loaderMC:Sprite;
        private var _loaderBox:Sprite;
        private var _loadbg:Sprite;
        private var _loadbar:Sprite;
        private var _progtxt:TextField;
        private var _tf:TextFormat;
        private var _pbWidth:Number = 100;
        private var _pbHeight:Number = 3;
        private var _progMsgYOffset:Number = 10;
        private var _progMsg:String = "Loading ";
        private var _progMsgWidth:Number = 100;
        private var _bytesLoaded:Number;
        private var _bytesTotal:Number;

        public function SimplePreloadAnimation(param1:Number)
        {
            _loaderMC = new Sprite();
            _loaderBox = new Sprite();
            _loadbg = new Sprite();
            _loadbar = new Sprite();
            _progtxt = new TextField();
            _tf = new TextFormat();
            _pbWidth = param1;
            setupLoader();
            return;
        }// end function

        public function setupLoader() : void
        {
            addChild(_loaderMC);
            _loaderBox.graphics.beginFill(16777215, 1);
            _loaderBox.graphics.drawRect(0, 0, _pbWidth, _pbHeight);
            _loaderBox.graphics.endFill();
            _loaderBox.x = 0;
            _loaderBox.y = 0;
            _loaderBox.alpha = 0;
            _loadbar.graphics.beginFill(8483677);
            _loadbar.graphics.drawRect(0, 0, _pbWidth, _pbHeight);
            _loadbar.graphics.endFill();
            _loaderMC.addChild(_loaderBox);
            _loaderMC.addChild(_loadbg);
            _loaderMC.addChild(_loadbar);
            _loaderMC.alpha = 0;
            _loadbar.width = 1;
            TweenMax.to(_loaderMC, 0.5, {autoAlpha:1, overwrite:1});
            return;
        }// end function

        public function handleOpen() : void
        {
            _loadbar.width = 1;
            TweenMax.to(_loaderMC, 0.5, {delay:0.5, autoAlpha:1, overwrite:1});
            return;
        }// end function

        public function handleProgress(event:ProgressEvent) : void
        {
            _bytesLoaded = event.bytesLoaded;
            _bytesTotal = event.bytesTotal;
            var _loc_2:* = Math.round(_bytesLoaded / _bytesTotal * 100);
            TweenMax.to(_loadbar, 0.5, {width:_loc_2 * _pbWidth / 100, ease:Circular.easeOut, overwrite:1});
            dispatchEvent(new Event("loadProgress"));
            return;
        }// end function

        public function handleComplete() : void
        {
            trace("SimplePreloadAnimation::handleComplete()");
            TweenMax.to(_loadbar, 0.2, {width:_pbWidth, ease:Circular.easeOut, onComplete:dispatchProgressBarComplete, overwrite:1});
            dispatchEvent(new Event("loadComplete"));
            return;
        }// end function

        private function dispatchProgressBarComplete() : void
        {
            TweenMax.to(_loaderMC, 0.5, {autoAlpha:0, onComplete:dispatchFinishEvent, overwrite:1});
            dispatchEvent(new Event("progressBarComplete"));
            return;
        }// end function

        private function dispatchFinishEvent() : void
        {
            trace("SimplePreloadAnimation::dispatchFinishEvent()");
            dispatchEvent(new Event("loadFinished"));
            return;
        }// end function

    }
}
