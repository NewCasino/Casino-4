package com.littlefilms{
	import fl.video.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import gs.*;
	import gs.easing.*;

	public class VideoPlayer extends Sprite {
		public var flvPlayer:FLVPlayback;
		private const BUFFER_TIME:Number = 8;
		private const DEFAULT_VOLUME:Number = 0.6;
		private const DISPLAY_TIMER_UPDATE_DELAY:int = 10;
		private const SMOOTHING:Boolean = true;
		private const VIDEO_CONTROLS_Y_SPACING:Object = 10;
		private const VIDEO_CONTROLS_X_SPACING:Object = 10;
		private var _controller:Object;
		private var _mainMC:Object;
		public var videoControls:VideoControls;
		private var _videoWidth:uint;
		private var _videoHeight:uint;
		private var _isLoaded:Boolean = false;
		private var _isVolumeScrubbing:Boolean = false;
		private var _isProgressScrubbing:Boolean = false;
		private var _lastVolume:Number = 0.6;
		private var _netConnectionObject:NetConnection;
		private var _netStreamObject:NetStream;
		private var _metaInfoObject:Object;
		private var _streamSource:String = "assets/videos/hancock-tsr2_h480p.flv";
		private var _timerDisplay:Timer;

		public function VideoPlayer(src:String, vWidth:uint, vHeight:uint) {
			_streamSource = src;
			_videoWidth = vWidth;
			_videoHeight = vHeight;
			__setProp_flvPlayer_VideoPlayer_flvPlayer_0();
		}

		public function init():void {
			videoControls = new VideoControls();
			videoControls.x = flvPlayer.x;
			videoControls.y = flvPlayer.y + _videoHeight + VIDEO_CONTROLS_Y_SPACING;
			videoControls.seekBar.x = videoControls.playPauseButton.x + videoControls.playPauseButton.width + VIDEO_CONTROLS_X_SPACING;
			var seekBarWidth:int = _videoWidth - videoControls.playPauseButton.width - videoControls.closeVideo.width - 15;
			trace("videoControls.playPauseButton.width = " + videoControls.playPauseButton.width);
			trace("_videoWidth                         = " + _videoWidth);
			trace("targetSeekBarWidth                  = " + seekBarWidth);
			videoControls.seekBar.width = seekBarWidth;
			videoControls.alpha = 0;
			addChild(videoControls);
			videoControls.closeVideo.buttonMode = true;
			videoControls.closeVideo.mouseEnabled = true;
			videoControls.closeVideo.mouseChildren = false;
			videoControls.closeVideo.addEventListener(MouseEvent.MOUSE_OVER, closeOverHandler, false, 0, true);
			videoControls.closeVideo.addEventListener(MouseEvent.MOUSE_OUT, closeOutHandler, false, 0, true);
			videoControls.closeVideo.addEventListener(MouseEvent.CLICK, closeClickHandler, false, 0, true);
			videoControls.closeVideo.x = _videoWidth;
			videoControls.closeVideo.y = videoControls.playPauseButton.y + (videoControls.playPauseButton.height - videoControls.closeVideo.height) / 2;
			flvPlayer.playPauseButton = videoControls.playPauseButton;
			flvPlayer.seekBar = videoControls.seekBar;
			flvPlayer.x = 0;
			flvPlayer.y = 0;
			flvPlayer.width = _videoWidth;
			flvPlayer.height = _videoHeight;
			flvPlayer.source = _streamSource;
			flvPlayer.playWhenEnoughDownloaded();
			revealVideoControls();
		}

		public function registerMain(param1:Sprite):void {
			_mainMC = param1;
		}

		public function registerController(param1:Sprite):void {
			_controller = param1;
		}

		private function revealVideoControls():void {
			TweenMax.to(videoControls, 0.5, {alpha:1, ease:Expo.easeInOut});
		}

		protected function closeOverHandler(event:MouseEvent):void {
			var color:uint = TextFormatter.getColor("_orange");
			TweenMax.to(event.target.closeBG, 0.2, {tint:color, ease:Expo.easeInOut});
			TweenMax.to(event.target.buttonLabel, 0.2, {tint:16777215, ease:Expo.easeInOut});
		}

		protected function closeOutHandler(event:MouseEvent):void {
			TweenMax.to(event.target.closeBG, 0.2, {tint:7564637, ease:Expo.easeInOut});
			TweenMax.to(event.target.buttonLabel, 0.2, {removeTint:true, ease:Expo.easeInOut});
		}

		protected function closeClickHandler(event:MouseEvent):void {
			flvPlayer.pause();
			flvPlayer.seek(0);
			removeChild(videoControls);
			_controller.removeVideoPlayer();
		}

		function __setProp_flvPlayer_VideoPlayer_flvPlayer_0() {
			try {
				flvPlayer["componentInspectorSetting"] = true;
			} catch (e:Error) {
			}
			flvPlayer.align = "topLeft";
			flvPlayer.autoPlay = true;
			flvPlayer.scaleMode = "exactFit";
			flvPlayer.skin = "";
			flvPlayer.skinAutoHide = false;
			flvPlayer.skinBackgroundAlpha = 1;
			flvPlayer.skinBackgroundColor = 4697035;
			flvPlayer.source = "";
			flvPlayer.volume = 1;
			try {
				flvPlayer["componentInspectorSetting"] = false;
			} catch (e:Error) {
			}
		}

	}
}