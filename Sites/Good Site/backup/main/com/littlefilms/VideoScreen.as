package com.littlefilms
{
    import flash.display.*;
    import gs.*;
    import gs.easing.*;

    public class VideoScreen extends Sprite
    {
        private var _videoBG:Sprite;
        private var _videoPlayer:VideoPlayer = null;
        private var _closeButton:Sprite;
        private var _mainMC:Object;
        private var _videoName:String;
        private var _videoSource:String;
        private var _videoWidth:uint;
        private var _videoHeight:uint;
        private var _stageHeight:uint;
        private var _stageWidth:uint;

        public function VideoScreen(param1:String, param2:uint, param3:uint)
        {
            name = param1;
            _videoName = param1;
            _videoWidth = param2;
            _videoHeight = param3;
            _videoBG = buildSprite(1, 1);
            _videoBG.alpha = 0;
            _videoBG.visible = false;
            addChildAt(_videoBG, 0);
            return;
        }// end function

        public function init() : void
        {
            showVideoBackground();
            colorizeLogo();
            return;
        }// end function

        public function registerMain(param1:Sprite) : void
        {
            _mainMC = param1;
            setUpVideoPlayer();
            return;
        }// end function

        private function setUpVideoPlayer() : void
        {
            var _loc_1:* = _mainMC.contentManager.contentXML.meta.work_videos.@location.toString();
            var _loc_2:* = _loc_1 + _videoName;
            _videoPlayer = new VideoPlayer(_loc_2, _videoWidth, _videoHeight);
            _videoPlayer.registerMain(_mainMC);
            _videoPlayer.registerController(this);
            _videoPlayer.alpha = 0;
            _videoPlayer.visible = false;
            addChild(_videoPlayer);
            _mainMC.bgManager.pauseBGRotation(true);
            return;
        }// end function

        private function showVideoBackground() : void
        {
            TweenMax.to(_videoBG, 0.5, {autoAlpha:1, ease:Cubic.easeOut, onComplete:showVideoPlayer});
            return;
        }// end function

        private function showVideoPlayer() : void
        {
            _videoPlayer.init();
            TweenMax.to(_videoPlayer, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
            positionContent();
            return;
        }// end function

        private function colorizeLogo() : void
        {
            TweenMax.to(_mainMC.logo, 0.5, {tint:7564637, ease:Cubic.easeOut});
            return;
        }// end function

        public function removeVideoPlayer() : void
        {
            TweenMax.to(_videoPlayer, 0.5, {autoAlpha:0, ease:Cubic.easeOut});
            TweenMax.to(_videoBG, 0.5, {delay:0.5, autoAlpha:0, ease:Cubic.easeOut, onComplete:_mainMC.removeChild, onCompleteParams:[this]});
            TweenMax.delayedCall(0.5, removeLogoTint);
            _mainMC.bgManager.pauseBGRotation(false);
            return;
        }// end function

        private function removeLogoTint() : void
        {
            TweenMax.to(_mainMC.logo, 0.2, {removeTint:true, ease:Cubic.easeOut});
            return;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            _stageHeight = param2;
            _stageWidth = param1;
            positionContent();
            return;
        }// end function

        private function positionContent() : void
        {
            _videoBG.x = 0;
            _videoBG.y = 0;
            _videoBG.width = _stageWidth;
            _videoBG.height = _stageHeight;
            _videoPlayer.x = (_stageWidth - _videoWidth) / 2;
            _videoPlayer.y = (_stageHeight - _videoHeight) / 2;
            return;
        }// end function

        private function buildSprite(param1:uint, param2:uint) : Sprite
        {
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            var _loc_5:* = new Sprite();
            new Sprite().graphics.beginFill(1905934);
            _loc_5.graphics.drawRect(0, 0, _loc_3, _loc_4);
            _loc_5.graphics.endFill();
            _loc_5.x = 0;
            _loc_5.y = 0;
            return _loc_5;
        }// end function

    }
}
