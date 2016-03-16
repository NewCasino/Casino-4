package com.littlefilms{
	import com.wirestone.utils.*;
	import flash.display.*;
	import flash.events.*;
	import gs.*;
	import gs.easing.*;

	public class BGRotator extends Sprite {
		private var _activeImage:Sprite = null;
		private var _deadImage:Sprite = null;
		private var _activeImageAspectRatio:Number = 0;
		private var _deadImageAspectRatio:Number = 0;
		private var _stageHeight:Number;
		private var _stageWidth:Number;
		private var _mainMC:Object;
		private var _parentMC:BGManager;

		public function BGRotator() {
			trace("BGRotator::()");
		}

		public function registerMain(param1):void {
			_mainMC = param1;
		}

		public function registerController(param1:BGManager):void {
			_parentMC = param1;
		}

		public function loadNewImage(imageToLoad:Sprite, imgWidth:int, imgHeight:int):void {
			var eventName:String = null;
			var loader:ObjectLoader = null;
			trace("imageSprite.name = " + imageToLoad.name);
			if (_activeImage != null) {
				trace("_activeImage.name = " + _activeImage.name);
			}
			if (_activeImage != null && imageToLoad.name == _activeImage.name) {
				_mainMC.sequencer.nextStep();
			} else {
				swapImages();
				eventName = imageToLoad.name + "Revealed";
				_activeImage = imageToLoad;
				_activeImageAspectRatio = imgWidth / imgHeight;
				_activeImage.addEventListener(eventName, imageLoaded);
				addChild(_activeImage);
				setSize(_mainMC.stageWidth, _mainMC.stageHeight);
				if (_activeImage is ObjectLoader) {
					loader = _activeImage as ObjectLoader;
					loader.imageLoader.contentLoaderInfo.addEventListener(Event.OPEN, handleOpen);
					loader.imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, updatePreloaderProgress);
					loader.imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, preloadProgressComplete);
				} else {
					_activeImage.alpha = 0;
					TweenMax.to(_activeImage, 1, {alpha:1, ease:Sine.easeOut, onComplete:imageLoadCleanup});
				}
			}
		}

		private function handleOpen(event:Event):void {
			_mainMC.footer.preloadAni.handleOpen();
		}

		private function updatePreloaderProgress(param1):void {
			_mainMC.footer.preloadAni.handleProgress(param1);
		}

		private function preloadProgressComplete(param1):void {
			_mainMC.footer.preloadAni.handleComplete();
		}

		private function imageLoaded(event:Event):void {
			ListChildren.listAllChildren(this);
			imageLoadCleanup();
		}

		private function swapImages():void {
			_deadImage = _activeImage;
			_deadImageAspectRatio = _activeImageAspectRatio;
		}

		public function imageLoadCleanup():void {
			var tmpChild:DisplayObject = null;
			var i:int = 0;
			while (i < numChildren) {
				tmpChild = getChildAt(i);
				if (tmpChild != _activeImage) {
					clearDisplayListItem(tmpChild);
				}
				i++;
			}
			if (name != "mainBG") {
				_mainMC.sequencer.nextStep();
			}
		}

		public function removeAllImages():void {
			var child:DisplayObject = null;
			var i:int = 0;
			while (i < numChildren) {
				child = getChildAt(i);
				TweenMax.to(child, 1, {delay:0.5, autoAlpha:0, ease:Expo.easeOut, onComplete:clearDisplayListItem, onCompleteParams:[child]});
				i++;
			}
			_activeImage = null;
			_deadImage = null;
		}

		private function clearDisplayListItem(childObj:DisplayObject):void {
			removeChild(childObj);
		}

		public function setSize(param1:Number, param2:Number):void {
			_stageHeight = param2;
			_stageWidth = param1;
			if (_activeImage != null) {
				resizeImage(_activeImage, param1, param2);
			}
			if (_deadImage != null) {
				resizeImage(_deadImage, param1, param2);
			}
		}

		public function resizeImage(image:Sprite, imgWidth:int, imgHeight:int):void {
			var ratio:Number = (image == _activeImage) ? _activeImageAspectRatio : _deadImageAspectRatio;
			var toWidth:int = imgWidth;
			var toHeight:int = imgWidth / ratio;
			if (toWidth < imgWidth) {
				toWidth = imgWidth;
				toHeight = toWidth * ratio;
			} else if (toHeight < imgHeight) {
				toHeight = imgHeight;
				toWidth = toHeight * ratio;
			}
			image.width = toWidth;
			image.height = toHeight;
			image.x = Math.floor((imgWidth - toWidth) / 2);
			image.y = Math.floor((imgHeight - toHeight) / 2);
		}

		public function get activeImage():Sprite {
			return _activeImage;
		}

		public function set activeImage(value:Sprite):void {
			if (value !== _activeImage) {
				_activeImage = value;
			}
		}

	}
}