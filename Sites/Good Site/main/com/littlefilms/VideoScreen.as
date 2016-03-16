package com.littlefilms{
	import flash.display.*;
	import gs.*;
	import gs.easing.*;

	public class VideoScreen extends Sprite {
		private var _videoBG:Sprite;
		private var _videoPlayer:VideoPlayer = null;
		private var _closeButton:Sprite;
		private var _mainMC:Object;
		private var _videoName:String;
		private var _videoSource:String;
		private var _videoWidth:int;
		private var _videoHeight:int;
		private var _stageHeight:int;
		private var _stageWidth:int;

		public function VideoScreen(param1:String, param2:int, param3:int) {
			name = param1;
			_videoName = param1;
			_videoWidth = param2;
			_videoHeight = param3;
			_videoBG = buildSprite(1, 1);
			_videoBG.alpha = 0;
			_videoBG.visible = false;
			addChildAt(_videoBG, 0);
			return;
		}

		public function init():void {
			showVideoBackground();
			colorizeLogo();
			return;
		}

		public function registerMain(param1:Sprite):void {
			_mainMC = param1;
			setUpVideoPlayer();
			return;
		}

		private function setUpVideoPlayer():void {
			var path:String = _mainMC.contentManager.contentXML.meta.work_videos.@location.toString();
			var fullPath:String = path + _videoName;
			_videoPlayer = new VideoPlayer(fullPath, _videoWidth, _videoHeight);
			_videoPlayer.registerMain(_mainMC);
			_videoPlayer.registerController(this);
			_videoPlayer.alpha = 0;
			_videoPlayer.visible = false;
			addChild(_videoPlayer);
			_mainMC.bgManager.pauseBGRotation(true);
			return;
		}

		private function showVideoBackground():void {
			TweenMax.to(_videoBG, 0.5, {autoAlpha:1, ease:Cubic.easeOut, onComplete:showVideoPlayer});
			return;
		}

		private function showVideoPlayer():void {
			_videoPlayer.init();
			TweenMax.to(_videoPlayer, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
			positionContent();
			return;
		}

		private function colorizeLogo():void {
			TweenMax.to(_mainMC.logo, 0.5, {tint:7564637, ease:Cubic.easeOut});
			return;
		}

		public function removeVideoPlayer():void {
			TweenMax.to(_videoPlayer, 0.5, {autoAlpha:0, ease:Cubic.easeOut});
			TweenMax.to(_videoBG, 0.5, {delay:0.5, autoAlpha:0, ease:Cubic.easeOut, onComplete:_mainMC.removeChild, onCompleteParams:[this]});
			TweenMax.delayedCall(0.5, removeLogoTint);
			_mainMC.bgManager.pauseBGRotation(false);
			return;
		}

		private function removeLogoTint():void {
			TweenMax.to(_mainMC.logo, 0.2, {removeTint:true, ease:Cubic.easeOut});
			return;
		}

		public function setSize(param1:Number, param2:Number):void {
			_stageHeight = param2;
			_stageWidth = param1;
			positionContent();
			return;
		}

		private function positionContent():void {
			_videoBG.x = 0;
			_videoBG.y = 0;
			_videoBG.width = _stageWidth;
			_videoBG.height = _stageHeight;
			_videoPlayer.x = (_stageWidth - _videoWidth) / 2;
			_videoPlayer.y = (_stageHeight - _videoHeight) / 2;
			return;
		}

		private function buildSprite(spriteWidth:int, spriteHeight:int):Sprite {
			var newSprite:Sprite = new Sprite();
			newSprite.graphics.beginFill(1905934);
			newSprite.graphics.drawRect(0, 0, spriteWidth, spriteHeight);
			newSprite.graphics.endFill();
			newSprite.x = 0;
			newSprite.y = 0;
			return newSprite;
		}
	}
}