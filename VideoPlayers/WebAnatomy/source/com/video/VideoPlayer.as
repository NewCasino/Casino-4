package com.video {
	
	import com.events.VideoMetadataEvent;
	import com.video.VideoState;
	import com.events.VideoPlayerEvent;
	import com.events.VideoPlayerTimeEvent;
	import flash.display.DisplayObject;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import com.control.ControlsHolder;
	
	
	[Event("play", type = "com.events.VideoPlayerEvent")]
	[Event("pause", type = "com.events.VideoPlayerEvent")]
	[Event("stop", type = "com.events.VideoPlayerEvent")]	
	[Event("seekNotify", type = "com.events.VideoPlayerEvent")]
	[Event("bufferFull", type = "com.events.VideoPlayerEvent")]
	[Event("bufferEmpty", type = "com.events.VideoPlayerEvent")]
	[Event("progress", type = "flash.events.ProgressEvent")]
	[Event("time", type = "com.events.VideoPlayerTimeEvent")]
	[Event("metadataEvent", type = "com.events.VideoMetadataEvent")]
	
	public class VideoPlayer extends Video {		
		
		private var controlsHolder:ControlsHolder = ControlsHolder.getInstance();
		
		
		public static const DEFAULT_UPDATE_TIME_INTERVAL:Number = 100;   // .25 seconds
		public static const DEFAULT_UPDATE_PROGRESS_INTERVAL:Number = 100;   // .25 seconds
		public var videoRenderrer:Sprite;		
		
		private var nsStream:NetStream;
		private var ncConnection:NetConnection;		
		
		private var videoPath:String;
		private var rtmpServerPath:String;
		private var sState:String;
		private var serverType:String = "";
		
		public var bIsRtmp:Boolean = false;
		private var bAutoPlay:Boolean = true;
		
		private var trDownloadProgress:Timer;
		private var trTimeProgress:Timer;
		
		private var nDuration:Number;
		
		public function VideoPlayer() {
			super();
			this.initVideo();			
		}
		
		public function initVideo():void {			
			ncConnection = new NetConnection();
			ncConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetConnectionStatus);
			ncConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			ncConnection.client = this;
			ncConnection.connect(null);
			this.initNetStream();
			this.smoothing = true;
			
			trTimeProgress = new Timer(DEFAULT_UPDATE_TIME_INTERVAL);			
			
			trDownloadProgress = new Timer(DEFAULT_UPDATE_PROGRESS_INTERVAL);			
			this.resetTimers();			
		}
		
		private function initNetStream():void {			
			if (nsStream && nsStream.hasEventListener(NetStatusEvent.NET_STATUS)) {
				trTimeProgress.stop();
				trDownloadProgress.stop();				
				nsStream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			}
			
			nsStream = new NetStream(ncConnection);			
			var oNSCallBack:Object = new Object();
			oNSCallBack.onMetaData = onMetaDataHandler;
			nsStream.client = oNSCallBack;
			nsStream.bufferTime = 0.5;
			nsStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			this.attachNetStream(nsStream);			
		}
		
		
		// META DATA INFO
		private function onMetaDataHandler($metaInfoObj:Object):void {
			var $event:VideoMetadataEvent = new VideoMetadataEvent(VideoMetadataEvent.METADATA_EVENT);
			$event.info = $metaInfoObj;
			this.nDuration = $metaInfoObj.duration;
			this.dispatchEvent($event);
		}
		
		// NetStatusEvent.NET_STATUS
		private function onNetConnectionStatus($event:NetStatusEvent):void {			
			if ($event.info.code == 'NetConnection.Connect.Success') {
				if (serverType == 'rtmp') {
					this.initNetStream();
					this.playStream();
				}
				
				this.startProgressTimer();
			}
		}
		
		public function onFCSubscribe(info:Object = null):void{
			trace("worked");
		}
		
		// META DATA INFO
		public function onMetaData($metaInfoObj:Object = null):void {
			
		}
		
		public function onBWDone(args:Object = null):void {
			 trace ( "onBWDone! : " + args );
		}
		
		public function close(args:Object = null):void {
			 trace ( "onBWDone! : " + args );
		}
		
		private function startProgressTimer():void {		
			if (!trTimeProgress) {
				trTimeProgress = new Timer(DEFAULT_UPDATE_TIME_INTERVAL);
				trTimeProgress.addEventListener(TimerEvent.TIMER, onTimeProgress);
			}
			
			if (!trDownloadProgress) {
				trDownloadProgress = new Timer(DEFAULT_UPDATE_PROGRESS_INTERVAL);
				trDownloadProgress.addEventListener(TimerEvent.TIMER, onDownloadProgress);
			}
			
			trDownloadProgress.start();
			trTimeProgress.start();
		}		
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }
		
		// NetStatusEvent.NET_STATUS
		private function netStatusHandler($event:NetStatusEvent):void {			
			switch ($event.info.code) {
				case "NetStream.Play.Start" : {
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY));
					this.state = VideoState.PLAYING;
					trace ("DOWNLOAD PROGRESS: "+nsStream.bytesTotal);
					break;
				}
				
				case "NetStream.Unpause.Notify" : {
					trace ("VIDEO PLAYER NOTIFY PAUSE");
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY));
					this.state = VideoState.PLAYING;
					break;
				}
				
				case "NetStream.Pause.Notify" : {
					trace ("VIDEO PLAYER NOTIFY PAUSE");
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PAUSE));
					this.state = VideoState.PAUSED;
					break;
				}
				
				case "NetStream.Seek.Notify" :
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SEEK_NOTIFY));
					switch (this.state) {
						case VideoState.PAUSED:
						case VideoState.STOPPED:
							this.pause();
							break;
						case VideoState.PLAYING:
							this.resume();
							break;
						default:
							break;
					}
					break;				
				
				case 'NetStream.Play.Stop' :
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.STOP));
					this.state = VideoState.STOPPED;
					break;
				
				
				case 'NetStream.Buffer.Full' :
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BUFFER_FULL));
					break;
				
				
				case 'NetStream.Buffer.Empty' :
					if (this.getBuffering() > 98) {
						this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.STOP));
						this.state = VideoState.STOPPED;
						break;
					}
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BUFFER_EMPTY));
					this.state = VideoState.BUFFERING;
					
					break;
					
				case 'NetStream.Seek.InvalidTime' : {
					
					break;
				}
			}
		}
		
		// PLAYER PLAY
		public function play($streamPath = "", duration = NaN):void {
			
			if ($streamPath != "") {				
				this.videoPath = $streamPath;				
			} else {
				
			}
			
			ncConnection.connect(null);
			
			if (videoPath.indexOf('rtmp') != -1) {
				this.bIsRtmp = true;
				serverType = 'rtmp';
				var nLastIndex:int = videoPath.lastIndexOf("/");				
				rtmpServerPath = videoPath.substring(0, nLastIndex + 1);
				videoPath = videoPath.substring(nLastIndex + 1, videoPath.length);				
				//trace("connecting to: rtmpServerPath  "+rtmpServerPath+",  videoPath: "+videoPath);
				ncConnection.connect(rtmpServerPath);				
			} else {
				this.bIsRtmp = false;
				serverType = 'http';				
				nsStream.play(videoPath);			
			}
		}
		
		private function resetTimers():void {
			trDownloadProgress.reset();
			trTimeProgress.reset();
		}
		
		private function onDownloadProgress($event:TimerEvent = null):void {			
			var $progressEvent:ProgressEvent;
			if ( nsStream.bytesLoaded / nsStream.bytesTotal > 0.99 ) {
				trDownloadProgress.stop();
			}			
			$progressEvent = new ProgressEvent(ProgressEvent.PROGRESS, false, false, nsStream.bytesLoaded, nsStream.bytesTotal);
			this.dispatchEvent($progressEvent);
		}
		
		private function onTimeProgress($event:TimerEvent = null):void {
			//trace ("Video player  "+nsStream.time);
			var $videoTimeEvent:VideoPlayerTimeEvent = new VideoPlayerTimeEvent(VideoPlayerTimeEvent.TIME, nsStream.time, false, false);
			this.dispatchEvent($videoTimeEvent);
		}
		
		private function playStream():void {
			nsStream.play(videoPath);
			//trace ("CURRENTLY PLAYING: "+videoPath);
		}
		
		public function pause():void {
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PAUSE));
			this.state = VideoState.PAUSED;
			nsStream.pause();
		}
		
		// SET VIDEO OUTPUT OBJECT
		public function set videoOutput(displayObject:Sprite):void {
			//displayObject.addChild(video);
		}
		
		// PLAYER RESUME PLAY
		public function resume():void {
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY));
			this.state = VideoState.PLAYING;
			nsStream.resume();			
		}		
			
		// SET VOLUME
		public function set volume(value):void {
			nsStream.soundTransform = new SoundTransform(value);			
		}
		
		// GET VOLUME
		public function get volume():Number {
			return nsStream.soundTransform.volume;
		}
		
		// GET SMOOTHING
		public function get smoothVideo():Boolean {
			return this.smoothing;
		}
		
		// SET AUTOPLAY
		public function set autoPlay(bValue:Boolean):void {
			this.bAutoPlay = bValue;
		}
		
		// GET AUTOPLAY
		public function get autoPlay():Boolean {
			return this.bAutoPlay;
		}
		
		//SEEK
		public function seek($nPercent:Number):void {
			//var newseek = $nPercent * dataHolder.nVideoDuration;
			//nsStream.pause();
			nsStream.seek($nPercent * nDuration);
		}
		
		// GET CURRENT TIME
		public function get time():Number {
			return nsStream.time;
		}
		
		// SET DEFAULT VALUES
		private function setDefaultValues():void {
			
		}
		
		// GET BUFFERING VALUE
		public function getBuffering():Number {
			var nValue:Number = Math.round(nsStream.bufferLength / nsStream.bufferTime * 100);			
			return nValue;
		}
		
		// GET VIDEO TOTAL  BYTES
		public function get getBytesTotal():Number {
			return nsStream.bytesTotal;
		}
		
		// GET VIDEO LOADED BYTES
		public function get getBytesLoaded():Number {
			return nsStream.bytesLoaded;
		}
		
		//GET CURRENT VIDEO PLAYER STATE
		public function set state($sState:String):void {
			sState = $sState;
		}
		
		//GET CURRENT VIDEO PLAYER STATE
		public function get state():String {
			return sState;
		}
	}
}