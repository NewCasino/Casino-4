package com.video {
	import com.data.DataHolder;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import com.video.VideoPlayer;
	
	public class ClassVideo {
		
		public var videoPlayer:VideoPlayer;
		private var videoClipPlayer:VideoPlayer;
		private var videoAdvPlayer:VideoPlayer;
		private var dataHolder:DataHolder;
		private var trLoadedVideo:Timer = new Timer(50);
		private var trProgress : Timer = new Timer(50);
		
		
		public function ClassVideo() {
			dataHolder = DataHolder.getInstance();
			var $settings:Object = new Object();
			$settings.target = dataHolder._stage.videoOutput;			
			$settings.bVideoLoop = dataHolder.bVideoLoop;			
			$settings.fOnStartLoading = this.onStartLoading;
			$settings.fOnStopLoading = this.onStopLoading;
			videoClipPlayer = new VideoPlayer($settings);
			
			$settings.target = dataHolder._stage.advOutput;			
			$settings.bVideoLoop = dataHolder.bVideoLoop;			
			$settings.fOnStartLoading = this.onStartLoading;
			$settings.fOnStopLoading = this.onStopLoading;
			videoAdvPlayer = new VideoPlayer($settings);
			this.switchToClip();
			trProgress.addEventListener(TimerEvent.TIMER, trackProgress);			
		}
		
		private function trackLoadedVideo($event:TimerEvent):void {			
			
		}
		
		public function switchToClip():void {
			videoPlayer = videoClipPlayer;
		}
		
		public function switchToAdv():void {
			videoPlayer = videoAdvPlayer;
		}
		
		public function onStartLoading():void {
			trProgress.start();
			//trLoadedVideo.start();
		}
		
		public function onStopLoading():void {
			trProgress.stop();
			//trLoadedVideo.stop();
		}
		
		private function trackProgress($event:TimerEvent):void {
			if (!dataHolder.bSeek) {
				dataHolder._stage.mcNavigation.mcProgressBar.trackProgress(videoPlayer.time);
			}			
			var nPercent:Number = videoPlayer.getBytesLoaded / videoPlayer.getBytesTotal;
			if (nPercent == 1) {				
				dataHolder._stage.mcNavigation.mcProgressBar.trackLoadedVideo(1);				
			} else {
				dataHolder._stage.mcNavigation.mcProgressBar.trackLoadedVideo(nPercent);				
			}
		}
		
		public function playVideo($source:String = undefined):void {
			//unloadVideoCover()
			var $videoSource:String = ($source)?$source:dataHolder.sVideoSource;			
			videoPlayer.play($videoSource);
		}
		
		public function pause():void {
			videoPlayer.pause();
		}
		
		// PLAYER RESUME PLAY
		public function resume():void{
			videoPlayer.resume();			
		}
	}
	
}