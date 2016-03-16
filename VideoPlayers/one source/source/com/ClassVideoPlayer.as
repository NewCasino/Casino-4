package com{
	import flash.display.*;
	import flash.events.*;
	import flash.media.Video;	
	import flash.net.*
	import flash.net.NetStream
	import flash.utils.Timer
	import flash.media.SoundTransform
	
	public class ClassVideoPlayer{
		//VARS
		private var targetRoot:            Object
		public  var videoSprite:           Sprite
		public  var video_width:           Number
		public  var video_height:          Number
		private var recommendWidth:        Number
		private var recommendHeight:       Number		
		private var video_duration:        Number
		public  var vscale:                String
		private var streamPath:            String
		private var myVideo:               Video 
		private var nc:                    NetConnection
		private var ns:                    NetStream
		private var onvideoload:           Function
		private var videopreload:          Function
		private var onvideoend:            Function
		private var videoPreloadTimer:     Timer
		public  var vstatus:               String
		public  var vloop:                 Boolean
		private var onbufferFull:          Function
		private var onbufferEmpty:         Function		
		// CONSTANTS
		private const CONST_video_width  = 320
		private const CONST_video_height = 240
		
		public const VIDEO_PLAYING       = 'playing'
		public const VIDEO_STOP          = 'stop'
		public const VIDEO_PAUSE         = 'pause'

		function ClassVideoPlayer(settings){
			var nsCallBack:Object    = new Object()
			setDefaultValues()			
			targetRoot       = settings.target
			vscale           = settings.vscale
			recommendWidth   = settings.recommendWidth
			recommendHeight  = settings.recommendHeight	
			onvideoload      = settings.onvideoload
			videopreload     = settings.videopreload
			onvideoend       = settings.onvideoend
			vloop            = settings.vloop
			
			if(typeof(settings.onbufferFull)== 'function'){
				onbufferFull = settings.onbufferFull
			}
			if(typeof(settings.onbufferEmpty)== 'function'){
				onbufferEmpty = settings.onbufferEmpty
			}
			videoPreloadTimer = new Timer(50)
			videoPreloadTimer.addEventListener(TimerEvent.TIMER,getvideoload)
		
			videoSprite      = new Sprite()
			videoSprite.name = settings.targetName
			targetRoot.addChild(videoSprite)
			myVideo = new Video()
			myVideo.smoothing = true
			videoSprite.addChild(myVideo)
			nc = new NetConnection()
			nc.connect(null)
			nsCallBack.onMetaData   = onMetaDataHandler
			ns = new NetStream(nc)
			ns.client     = nsCallBack
			ns.bufferTime = 0.5
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler)
			myVideo.attachNetStream(ns);
			
			volume = 1;
		}
		
		// SET DEFAULT VALUES
		private function setDefaultValues():void{
			video_width  = CONST_video_width
			video_height = CONST_video_height
			vscale       = 'original'
			vloop        = false
		}
		// META DATA INFO
		private function onMetaDataHandler(metaInfoObj:Object):void{
			if(Number(metaInfoObj.width)>0)    video_width    = metaInfoObj.width
			if(Number(metaInfoObj.height)>0)   video_height   = metaInfoObj.height
			if(Number(metaInfoObj.duration)>0) video_duration = metaInfoObj.duration
			setVideoSize()
		}
		// NetStatusEvent.NET_STATUS
		private function netStatusHandler(e:NetStatusEvent):void{
			if(e.info.code == 'NetStream.Play.Start'){
				setVideoSize()
			}

			if(e.info.code == 'NetStream.Buffer.Full'){
				if(this.onbufferFull!=null){
					this.onbufferFull()
				}
			}
			if(e.info.code == 'NetStream.Buffer.Empty' || e.info.code == 'NetStream.Seek.InvalidTime' || e.info.code == 'NetStream.Play.Start'){
				if(this.onbufferEmpty!=null){
					this.onbufferEmpty()
				}
			}
			if(e.info.code == 'NetStream.Play.Stop'){
				vstatus = VIDEO_STOP
				if(this.vloop){
					this.play()
				}else{
					if(this.onvideoend!=null){
						this.onvideoend()
					}
				}
			}
		}
		// SET VIDEO SIZE
		private function setVideoSize():void{
			manualVideoSize(recommendWidth,recommendHeight,vscale)
		}
		// SET MANUAL VIDEO SIZE
		public function manualVideoSize(vwidth,vheight,vscale,noevent:Boolean=false):void{
			var coef:Number
			if(vscale == 'fitw'){
				myVideo.width    = vwidth
				coef             = video_height/video_width
				myVideo.height   = vwidth * coef
			}
			if(vscale == 'fith'){
				myVideo.height   = vheight
				coef             = video_width/video_height
				myVideo.width    = vheight * coef
			}
			if(vscale=='scale'){
				myVideo.width  = vwidth
				myVideo.height = vheight
			}
			if(vscale=='original'){
				myVideo.width  = video_width
				myVideo.height = video_height
			}
			if(onvideoload!=null && !noevent){
				onvideoload()
			}
		}
		// PLAYER PLAY
		public function play(streamPath=undefined, duration=undefined):void{
			if(duration!=undefined){
				video_duration = duration
			}
			if(streamPath!=undefined){
				ns.play(streamPath)
				this.streamPath = streamPath
			}else{
				ns.play(this.streamPath)
			}
			videoPreloadTimer.start()
			vstatus = VIDEO_PLAYING

		}
		// PLAYER STOP
		public function stop():void{
			ns.close()
			vstatus = VIDEO_STOP
		}
		// PLAYER PAUSE
		public function pause():void{
			ns.pause()
			vstatus = VIDEO_PAUSE
		}
		// PLAYER RESUME PLAY
		public function resume():void{
			ns.resume()
			vstatus = VIDEO_PLAYING			
		}
		// PLAYER togglePause
		public function togglePause():void{
			ns.togglePause()
		}
		// GET CURRENT TIME
		public function get time():Number{
			return ns.time
		}
		// GET VIDEO DURATION
		public function get duration():Number{
			return video_duration
		}
		// SEEK VIDEO
		public function seek(percent):void{
			var newseek = percent/100*video_duration
			ns.seek(newseek)
		}
		// PRELOAD VIDEO
		private function getvideoload(e:TimerEvent):void{
			if(this.getBytesTotal == this.getBytesLoaded){
				videoPreloadTimer.stop()
				if(videopreload!=null){
					videopreload(true)
				}
			}else{
				if(videopreload!=null){
					videopreload(false)
				}
			}
		}
		// GET VIDEO TOTAL  BYTES
		public function get getBytesTotal():Number{
			return ns.bytesTotal
		}
		// GET VIDEO LOADED BYTES
		public function get getBytesLoaded():Number{
			return ns.bytesLoaded
		}
		// SET VOLUME
		public function set volume(value):void{
			ns.soundTransform = new SoundTransform(value)
		}
		// GET VOLUEM
		public function get volume():Number{
			return ns.soundTransform.volume
		}
		// SET VIDEO FILE
		public function set file(value):void{
			streamPath = value
		}
		// SET CUSTOM VIDEO SIZE
		public function setCustomVideoSize(vwidth,vheight):void{
			recommendWidth  = vwidth
			recommendHeight = vheight
		}
		// SET BUFFER TIME
		public function set bufferTime(value):void{
			ns.bufferTime = value
		}
		// GET BUFFERING VALUE
		public function getBuffering():Number{
			var value = 0
			value = Math.round(ns.bufferLength / ns.bufferTime*100)
			return value
		}
		// SET VIDEO SMOOTHING
		public function set smoothing(value:Boolean):void{
			myVideo.smoothing = value
		}

	}
}