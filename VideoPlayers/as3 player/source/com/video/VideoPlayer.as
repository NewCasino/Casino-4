package com.video {	
	import com.data.DataHolder;
	import com.events.VideoStatusEvent;
	import com.net.CustomNetConnection;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class VideoPlayer extends Sprite {		
		
		private var dataHolder:DataHolder;
		public var videoRenderrer:Sprite;
		public var video:Video;
		public var nsStream:NetStream;
		public var ncConnection:NetConnection;
		public var fOnStartLoading:Function;
		public var fOnStopLoading:Function;
		public var fOnVideoEnd:Function;
		private var sStreamPath:String;		
		private var nVideoWidth:Number;
		private var nVideoHeight:Number;
		public var duration:Number;
		
		private var serverType:String = "";
		
		private var nUsedVideoWidth:Number;
		private var nUsedVideoHeight:Number;
		
		private var bIsRtmp:Boolean = false;
		
		private const DEFAULT_VIDEO_WIDTH = 320;
		private const DEFAULT_VIDEO_HEIGHT = 240;
		
		public function VideoPlayer($settings:Object) {
			dataHolder = DataHolder.getInstance();
			this.setDefaultValues();
			videoRenderrer = new Sprite();
			this.fOnVideoEnd = $settings.fOnVideoEnd;
			this.fOnStartLoading = $settings.fOnStartLoading;
			this.fOnStopLoading = $settings.fOnStopLoading;
			$settings.target.addChild(videoRenderrer);
			initVideo();
			
		}
		
		public function initVideo():void {
			video = new Video();
			video.smoothing = true;
			var mc:MovieClip = new MovieClip()
			mc.addChild(video)
			videoRenderrer.addChild(mc);
			ncConnection = new CustomNetConnection();
			ncConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetConnectionStatus);
			
			
			if (String(dataHolder.xMainXml.rmpt.@path).length > 0) {
				//trace ("HAS NODE");
				bIsRtmp = true;
			} else {
				//trace (String(dataHolder.xMainXml.rmpt)+"  HASN'T NODE");
				//trace ("!!!!!!!!CONNECT")
				bIsRtmp = false;
			}
			ncConnection.connect(null);
			this.initNetStream();
		}
		
		private function initNetStream():void {
			//trace ("INIT NET STREAM");
			if (nsStream && nsStream.hasEventListener(NetStatusEvent.NET_STATUS)) {
				nsStream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			}
			
			nsStream = new NetStream(ncConnection);
			var oNSCallBack:Object = new Object();
			oNSCallBack.onMetaData = onMetaDataHandler;
			nsStream.client = oNSCallBack;
			nsStream.bufferTime = 0.5;
			nsStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			video.attachNetStream(nsStream);
		}
		
		
		// META DATA INFO
		private function onMetaDataHandler($metaInfoObj:Object):void {			
			if (Number($metaInfoObj.width) > 0) dataHolder.nOrigVideoWidth = $metaInfoObj.width;			
			if (Number($metaInfoObj.height) > 0) dataHolder.nOrigVideoHeight = $metaInfoObj.height;			
			if (int($metaInfoObj.duration) > 0) dataHolder.nVideoDuration = $metaInfoObj.duration;
			duration = $metaInfoObj.duration;
			dataHolder._stage.resizeVideo();
		}
		
		// NetStatusEvent.NET_STATUS
		private function onNetConnectionStatus($event:NetStatusEvent):void {
			//trace ('NetStatusEvent code is: '+$event.info.code)
			if ($event.info.code == 'NetConnection.Connect.Success' && serverType == 'rtmp') {
				//trace("rtmp connected");
				this.initNetStream();
				this.playStream();				
			}
		}
		
		// NetStatusEvent.NET_STATUS
		private function netStatusHandler($event:NetStatusEvent):void {
			//trace ($event.info.code);
			var $videoStatusEvent:VideoStatusEvent = new VideoStatusEvent(VideoStatusEvent.EVENT_VIDEO_STATUS, true);
			switch ($event.info.code) {
				case "NetStream.Play.Start" : {
					this.fOnStartLoading();
					this.volume = dataHolder.nVolume;
					break;
				}
				
				case "NetStream.Pause.Notify" : {
					
					break;
				}
				
				case "NetStream.Seek.Notify" : {
					if (dataHolder.bPaused || dataHolder.bStoped) {
						$videoStatusEvent.status = VideoStatusEvent.VIDEO_PAUSE;
						dataHolder.eventDispatcher.dispatchEvent($videoStatusEvent);
						this.pause();
					}
					break;
				}
				
				case 'NetStream.Play.Stop' : {
					
					$videoStatusEvent.status = VideoStatusEvent.VIDEO_STOP;
					dataHolder.eventDispatcher.dispatchEvent($videoStatusEvent);
					dataHolder._stage.selectVideoTrack();
					this.fOnStopLoading();
					break;
				}
				
				case ('NetStream.Buffer.Full') : {					
					
					break;
				}
				
				case ('NetStream.Buffer.Empty' || 'NetStream.Seek.InvalidTime') : {					
					
					break;
				}
			}
		}
		
		// PLAYER PLAY
		public function play($streamPath = "", duration = NaN):void {
			//trace("PLAY "+$streamPath);
			var $videoStatusEvent:VideoStatusEvent = new VideoStatusEvent(VideoStatusEvent.EVENT_VIDEO_STATUS, true);
			$videoStatusEvent.status = VideoStatusEvent.VIDEO_PLAY;
			dataHolder.eventDispatcher.dispatchEvent($videoStatusEvent);
			
			if ($streamPath != "") {
				//nsStream.play($streamPath)
				this.sStreamPath = $streamPath;				
			} else {
				//nsStream.play(this.sStreamPath)
			}
			
			
			//if (streamPath.indexOf('rtmp://') != -1) {
			if (sStreamPath.indexOf('http') != -1) {
				serverType = 'http';
				ncConnection.connect(null);
				this.initNetStream();
				//var liveStreamServer:String = streamPath;
                //liveStreamServer = liveStreamServer.substr(0,liveStreamServer.lastIndexOf('/')+1)
                //var liveStreamPath:String = liveStreamPath.substr(liveStreamServer.lastIndexOf('/') + 1, (liveStreamPath.length - liveStreamServer.lastIndexOf('/')));				
				nsStream.play($streamPath);
			} else {
				if (bIsRtmp) {
					serverType = 'rtmp';
					//this.sStreamPath = dataHolder.xMainXml.rmpt.@path + this.sStreamPath;
					//trace("connecting to... "+dataHolder.xMainXml.rmpt.@path);
					ncConnection.connect(dataHolder.xMainXml.rmpt.@path);
				} else {
					ncConnection.connect(null);
					this.initNetStream();
					nsStream.play($streamPath);
				}
				
			}
		}
		
		private function playStream():void {
			nsStream.play(sStreamPath);
			//trace ("CURRENTLY PLAYING: "+sStreamPath);
		}
		
		public function pause():void {
			//trace ("PAUSE");
			var $videoStatusEvent:VideoStatusEvent = new VideoStatusEvent(VideoStatusEvent.EVENT_VIDEO_STATUS, true);
			$videoStatusEvent.status = VideoStatusEvent.VIDEO_PAUSE;
			dataHolder.eventDispatcher.dispatchEvent($videoStatusEvent);
			nsStream.pause();
		}
		
		// PLAYER RESUME PLAY
		public function resume():void{
			nsStream.resume();
			var $videoStatusEvent:VideoStatusEvent = new VideoStatusEvent(VideoStatusEvent.EVENT_VIDEO_STATUS, true);
			$videoStatusEvent.status = VideoStatusEvent.VIDEO_PLAY;
			dataHolder.eventDispatcher.dispatchEvent($videoStatusEvent);
		}
		
		// SET VIDEO SIZE
		private function setVideoSize():void {
			var $sScaleMode:String = dataHolder.sScaleMode;
			manualVideoSize(dataHolder.nMaxVideoWidth, dataHolder.nMaxVideoHeight, $sScaleMode);
		}
		
		// SET VOLUME
		public function set volume(value):void{
			nsStream.soundTransform = new SoundTransform(value)
		}
		
		// GET VOLUEM
		public function get volume():Number{
			return nsStream.soundTransform.volume
		}
		
		//SEEK
		public function seek($nPercent):void{
			var newseek = $nPercent * dataHolder.nVideoDuration;
			nsStream.seek(newseek);
		}
		
		// GET CURRENT TIME
		public function get time():Number {
			return nsStream.time;
		}
		
		// SET MANUAL VIDEO SIZE
		public function manualVideoSize($nWidth, $nHeight, $vScale, $noevent:Boolean = false):void {
			//trace(video.height+" "+$nHeight+" "+$vScale);
			var nRatio:Number;
			if ($vScale == 'fitWidth') {
				video.width = $nWidth;
				nRatio = nUsedVideoHeight / nUsedVideoWidth;
				video.height = $nWidth * nRatio;				
			}
			if ($vScale == 'fitHeight') {
				video.height = $nHeight;
				nRatio = nUsedVideoWidth / nUsedVideoHeight;
				video.width = $nHeight * nRatio;
				
			}
			if ($vScale == 'manual') {
				video.width = $nWidth;
				video.height = $nHeight;
			}
			if ($vScale == 'default') {
				video.width = nUsedVideoWidth;
				video.height = nUsedVideoHeight;
			}			
		}
		
		// SET DEFAULT VALUES
		private function setDefaultValues():void{
			this.nUsedVideoWidth = this.DEFAULT_VIDEO_WIDTH;
			this.nUsedVideoHeight = this.DEFAULT_VIDEO_HEIGHT;
			dataHolder.sScaleMode = dataHolder.VIDEO_SCALE_FIT_HEIGHT;
			dataHolder.bVideoLoop = false;
		}
		
		// SET CUSTOM VIDEO SIZE
		public function setCustomVideoSize($nWidth, $nHeight):void {
			dataHolder.nMaxVideoWidth = $nWidth;
			dataHolder.nMaxVideoHeight = $nHeight;
		}
		
		// GET BUFFERING VALUE
		public function getBuffering():Number{
			var nValue:Number = Math.round(nsStream.bufferLength / nsStream.bufferTime * 100);			
			return nValue;
		}
		
		// GET VIDEO TOTAL  BYTES
		public function get getBytesTotal():Number{
			return nsStream.bytesTotal;
		}
		
		// GET VIDEO LOADED BYTES
		public function get getBytesLoaded():Number{
			return nsStream.bytesLoaded;
		}
	}
}