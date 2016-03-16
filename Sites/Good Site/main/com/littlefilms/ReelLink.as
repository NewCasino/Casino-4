package com.littlefilms {
	import flash.display.*;
	import flash.events.*;
	import gs.*;
	import gs.easing.*;

	public class ReelLink extends MovieClip {
		public var reelLinkTab:MovieClip;
		private var _mainMC:Object;
		private var _reelXML:XML;
		private var _activeVideoScreen:VideoScreen = null;
		private static const ACTIVE_X_LOC:int = -413;
		private static const INACTIVE_X_LOC:int = -21;

		public function ReelLink() {
			trace("ReelLink::()");
			mouseEnabled = true;
			mouseChildren = false;
			buttonMode = true;
			cacheAsBitmap = true;
		}

		public function registerMain(param1):void {
			_mainMC = param1;
		}

		public function init(param1:XML):void {
			trace("ReelLink::init()");
			_reelXML = param1;
			trace("reelXML = " + param1);
			var path:String = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
			var fileName:String = _reelXML.thumbnail.@src.toString();
			var imgWidth:int = _reelXML.thumbnail.@width;
			var imgHeight:int = _reelXML.thumbnail.@height;
			var imageSprite:Sprite = _mainMC.contentManager.getImage(fileName,path,imgWidth,imgHeight);
			imageSprite.x = Math.abs(INACTIVE_X_LOC);
			reelLinkTab.addChild(imageSprite);
			reelLinkTab.addChild(reelLinkTab.playIcon);
			reelLinkTab.reelLinkDescription.text = _reelXML.description.p;
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
			addEventListener(MouseEvent.CLICK, mouseClickHandler, false, 0, true);
		}

		private function mouseOverHandler(event:MouseEvent):void {
			trace("ReelLink::mouseOverHandler()");
			TweenMax.to(reelLinkTab, 0.5, {x:ACTIVE_X_LOC, ease:Expo.easeInOut});
		}

		private function mouseOutHandler(event:MouseEvent):void {
			trace("ReelLink::mouseOutHandler()");
			TweenMax.to(reelLinkTab, 0.5, {x:INACTIVE_X_LOC, ease:Expo.easeInOut});
		}

		protected function mouseClickHandler(event:MouseEvent):void {
			var _loc_2:String = _reelXML.video.@src.toString();
			var _loc_3:int = _reelXML.video.@width;
			var _loc_4:int = _reelXML.video.@height;
			_activeVideoScreen = _mainMC.contentManager.getVideoScreen(_loc_2,_loc_3,_loc_4);
			_activeVideoScreen.setSize(_mainMC.stageWidth, _mainMC.stageHeight);
			_activeVideoScreen.init();
			trace("_activeVideoScreen = " + _activeVideoScreen);
			var _loc_5:* = _mainMC.logo;
			_mainMC.addChildAt(_activeVideoScreen, _mainMC.getChildIndex(_loc_5));
		}

	}
}