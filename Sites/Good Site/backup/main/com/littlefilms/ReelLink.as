package com.littlefilms
{
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    import gs.easing.*;

    public class ReelLink extends MovieClip
    {
        public var reelLinkTab:MovieClip;
        private var _mainMC:Object;
        private var _reelXML:XML;
        private var _activeVideoScreen:VideoScreen = null;
        private static const ACTIVE_X_LOC:int = -413;
        private static const INACTIVE_X_LOC:int = -21;

        public function ReelLink()
        {
            trace("ReelLink::()");
            mouseEnabled = true;
            mouseChildren = false;
            buttonMode = true;
            cacheAsBitmap = true;
            return;
        }// end function

        public function registerMain(param1) : void
        {
            _mainMC = param1;
            return;
        }// end function

        public function init(param1:XML) : void
        {
            trace("ReelLink::init()");
            _reelXML = param1;
            trace("reelXML = " + param1);
            var _loc_2:* = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
            var _loc_3:* = _reelXML.thumbnail.@src.toString();
            var _loc_4:* = _reelXML.thumbnail.@width;
            var _loc_5:* = _reelXML.thumbnail.@height;
            var _loc_6:* = _mainMC.contentManager.getImage(_loc_3, _loc_2, _loc_4, _loc_5);
            _mainMC.contentManager.getImage(_loc_3, _loc_2, _loc_4, _loc_5).x = Math.abs(INACTIVE_X_LOC);
            reelLinkTab.addChild(_loc_6);
            reelLinkTab.addChild(reelLinkTab.playIcon);
            reelLinkTab.reelLinkDescription.text = _reelXML.description.p;
            addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
            addEventListener(MouseEvent.CLICK, mouseClickHandler, false, 0, true);
            return;
        }// end function

        private function mouseOverHandler(event:MouseEvent) : void
        {
            trace("ReelLink::mouseOverHandler()");
            TweenMax.to(reelLinkTab, 0.5, {x:ACTIVE_X_LOC, ease:Expo.easeInOut});
            return;
        }// end function

        private function mouseOutHandler(event:MouseEvent) : void
        {
            trace("ReelLink::mouseOutHandler()");
            TweenMax.to(reelLinkTab, 0.5, {x:INACTIVE_X_LOC, ease:Expo.easeInOut});
            return;
        }// end function

        protected function mouseClickHandler(event:MouseEvent) : void
        {
            var _loc_2:* = _reelXML.video.@src.toString();
            var _loc_3:* = _reelXML.video.@width;
            var _loc_4:* = _reelXML.video.@height;
            _activeVideoScreen = _mainMC.contentManager.getVideoScreen(_loc_2, _loc_3, _loc_4);
            _activeVideoScreen.setSize(_mainMC.stageWidth, _mainMC.stageHeight);
            _activeVideoScreen.init();
            trace("_activeVideoScreen = " + _activeVideoScreen);
            var _loc_5:* = _mainMC.logo;
            _mainMC.addChildAt(_activeVideoScreen, _mainMC.getChildIndex(_loc_5));
            return;
        }// end function

    }
}
