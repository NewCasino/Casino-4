package com.wirestone.utils
{
    import com.stimuli.loading.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import gs.*;
    import gs.easing.*;

    public class ObjectLoader extends Sprite
    {
        private var _imageName:String;
        private var _imagePath:String;
        private var _imageWidth:Number;
        private var _imageHeight:Number;
        private var _targetMC:Sprite;
        private var _assetLoader:BulkLoader;
        private var _preloadAni:SimplePreloadAnimation;
        private var _imageHolder:Sprite;
        private var _imageLoader:Loader;
        public var imageBitmap:Bitmap;

        public function ObjectLoader(param1:String, param2:String, param3:Number, param4:Number)
        {
            _imageHolder = new Sprite();
            loadObject(param1, param2, param3, param4);
            return;
        }// end function

        private function loadObject(param1:String, param2:String, param3:Number, param4:Number) : void
        {
            name = param1.slice(0, param1.indexOf("."));
            _imageName = param1;
            _imagePath = param2;
            _imageWidth = param3;
            _imageHeight = param4;
            var _loc_5:* = buildSprite(_imageWidth, _imageHeight);
            buildSprite(_imageWidth, _imageHeight).alpha = 0;
            _imageHolder.addChild(_loc_5);
            _imageHolder.alpha = 0;
            addChild(_imageHolder);
            _preloadAni = new SimplePreloadAnimation(_imageWidth);
            _preloadAni.y = _imageHeight - _preloadAni.height;
            addChild(_preloadAni);
            TweenMax.to(_preloadAni, 0.5, {alpha:1, ease:Expo.easeOut});
            _imageLoader = new Loader();
            _imageLoader.contentLoaderInfo.addEventListener(Event.OPEN, handleOpen);
            _imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, updateProgress);
            _imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, placeImage);
            _imageLoader.load(new URLRequest(param2 + param1));
            return;
        }// end function

        private function handleOpen(event:Event) : void
        {
            _preloadAni.handleOpen();
            return;
        }// end function

        private function updateProgress(event:ProgressEvent) : void
        {
            _preloadAni.handleProgress(event);
            return;
        }// end function

        private function placeImage(event:Event) : void
        {
            event.target.content.smoothing = true;
            event.target.content.cacheAsBitmap = true;
            imageBitmap = event.target.content;
            imageBitmap.x = (_imageHolder.width - imageBitmap.width) / 2;
            imageBitmap.y = (_imageHolder.height - imageBitmap.height) / 2;
            _imageHolder.addChild(imageBitmap);
            TweenMax.to(_imageHolder, 1, {alpha:1, ease:Sine.easeOut, onComplete:dispatchRevealedEvent});
            _preloadAni.handleComplete();
            return;
        }// end function

        private function dispatchRevealedEvent() : void
        {
            var _loc_1:* = name + "Revealed";
            trace("imageRevealedEvent = " + _loc_1);
            dispatchEvent(new Event(_loc_1));
            return;
        }// end function

        private function buildSprite(param1:uint, param2:uint) : Sprite
        {
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            var _loc_5:* = new Sprite();
            new Sprite().graphics.beginFill(0);
            _loc_5.graphics.drawRect(0, 0, _loc_3, _loc_4);
            _loc_5.graphics.endFill();
            _loc_5.x = 0;
            _loc_5.y = 0;
            return _loc_5;
        }// end function

        public function get imageLoader() : Loader
        {
            return _imageLoader;
        }// end function

        public function set imageLoader(param1:Loader) : void
        {
            if (param1 !== _imageLoader)
            {
                _imageLoader = param1;
            }
            return;
        }// end function

    }
}
