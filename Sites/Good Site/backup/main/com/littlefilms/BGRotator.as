package com.littlefilms
{
    import com.wirestone.utils.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    import gs.easing.*;

    public class BGRotator extends Sprite
    {
        private var _activeImage:Sprite = null;
        private var _deadImage:Sprite = null;
        private var _activeImageAspectRatio:Number = 0;
        private var _deadImageAspectRatio:Number = 0;
        private var _stageHeight:Number;
        private var _stageWidth:Number;
        private var _mainMC:Object;
        private var _parentMC:BGManager;

        public function BGRotator()
        {
            trace("BGRotator::()");
            return;
        }// end function

        public function registerMain(param1) : void
        {
            _mainMC = param1;
            return;
        }// end function

        public function registerController(param1:BGManager) : void
        {
            _parentMC = param1;
            return;
        }// end function

        public function loadNewImage(param1:Sprite, param2:uint, param3:uint) : void
        {
            var _loc_4:Sprite = null;
            var _loc_5:String = null;
            var _loc_6:ObjectLoader = null;
            trace("imageSprite.name = " + param1.name);
            if (_activeImage != null)
            {
                trace("_activeImage.name = " + _activeImage.name);
            }
            if (_activeImage != null && param1.name == _activeImage.name)
            {
                _mainMC.sequencer.nextStep();
            }
            else
            {
                swapImages();
                _loc_4 = param1;
                _loc_5 = param1.name + "Revealed";
                _activeImage = _loc_4;
                _activeImageAspectRatio = param2 / param3;
                _activeImage.addEventListener(_loc_5, imageLoaded);
                addChild(_activeImage);
                setSize(_mainMC.stageWidth, _mainMC.stageHeight);
                if (_activeImage is ObjectLoader)
                {
                    _loc_6 = _activeImage as ObjectLoader;
                    _loc_6.imageLoader.contentLoaderInfo.addEventListener(Event.OPEN, handleOpen);
                    _loc_6.imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, updatePreloaderProgress);
                    _loc_6.imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, preloadProgressComplete);
                }
                else
                {
                    _activeImage.alpha = 0;
                    TweenMax.to(_activeImage, 1, {alpha:1, ease:Sine.easeOut, onComplete:imageLoadCleanup});
                }
            }
            return;
        }// end function

        private function handleOpen(event:Event) : void
        {
            _mainMC.footer.preloadAni.handleOpen();
            return;
        }// end function

        private function updatePreloaderProgress(param1) : void
        {
            _mainMC.footer.preloadAni.handleProgress(param1);
            return;
        }// end function

        private function preloadProgressComplete(param1) : void
        {
            _mainMC.footer.preloadAni.handleComplete();
            return;
        }// end function

        private function imageLoaded(event:Event) : void
        {
            ListChildren.listAllChildren(this);
            imageLoadCleanup();
            return;
        }// end function

        private function swapImages() : void
        {
            _deadImage = _activeImage;
            _deadImageAspectRatio = _activeImageAspectRatio;
            return;
        }// end function

        public function imageLoadCleanup() : void
        {
            var _loc_2:DisplayObject = null;
            var _loc_1:uint = 0;
            while (_loc_1 < numChildren)
            {
                
                _loc_2 = getChildAt(_loc_1);
                if (_loc_2 != _activeImage)
                {
                    clearDisplayListItem(_loc_2);
                }
                _loc_1 = _loc_1 + 1;
            }
            if (name != "mainBG")
            {
                _mainMC.sequencer.nextStep();
            }
            return;
        }// end function

        public function removeAllImages() : void
        {
            var _loc_2:DisplayObject = null;
            var _loc_1:uint = 0;
            while (_loc_1 < numChildren)
            {
                
                _loc_2 = getChildAt(_loc_1);
                TweenMax.to(_loc_2, 1, {delay:0.5, autoAlpha:0, ease:Expo.easeOut, onComplete:clearDisplayListItem, onCompleteParams:_loc_2});
                _loc_1 = _loc_1 + 1;
            }
            _activeImage = null;
            _deadImage = null;
            return;
        }// end function

        private function clearDisplayListItem(param1:DisplayObject) : void
        {
            removeChild(param1);
            return;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            _stageHeight = param2;
            _stageWidth = param1;
            if (_activeImage != null)
            {
                resizeImage(_activeImage, param1, param2);
            }
            if (_deadImage != null)
            {
                resizeImage(_deadImage, param1, param2);
            }
            return;
        }// end function

        public function resizeImage(param1:Sprite, param2:Number, param3:Number) : void
        {
            var _loc_4:* = param1 == _activeImage ? (_activeImageAspectRatio) : (_deadImageAspectRatio);
            var _loc_5:* = param2;
            var _loc_6:* = param2 / _loc_4;
            if (_loc_5 < param2)
            {
                _loc_5 = param2;
                _loc_6 = _loc_5 * _loc_4;
            }
            else if (_loc_6 < param3)
            {
                _loc_6 = param3;
                _loc_5 = _loc_6 * _loc_4;
            }
            param1.width = _loc_5;
            param1.height = _loc_6;
            param1.x = Math.floor((param2 - _loc_5) / 2);
            param1.y = Math.floor((param3 - _loc_6) / 2);
            return;
        }// end function

        public function get activeImage() : Sprite
        {
            return _activeImage;
        }// end function

        public function set activeImage(param1:Sprite) : void
        {
            if (param1 !== _activeImage)
            {
                _activeImage = param1;
            }
            return;
        }// end function

    }
}
