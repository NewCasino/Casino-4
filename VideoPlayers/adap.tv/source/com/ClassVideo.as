package com{
	class ClassVideo{
		import flash.display.*
		import flash.events.*		
		import flash.net.*
		import flash.utils.*
		import com.ClassVideoPlayer
		import com.ClassUtils
		import com.ClassVideoUtils
		import com.TweenLite
		
		var myPlayer        : ClassVideoPlayer
		var root			: MovieClip
		var src             : String
		var videoFileLoaded : Boolean = false
		var coverSprite     : Sprite
		var bufferTimer     : Timer = new Timer(50)
		var ProgressTimer   : Timer = new Timer(50)
		
		function ClassVideo(){
			root = ClassUtils.root
			var settings:Object = new Object()
			settings.target          = root.video_layer.video_mc
			settings.targetName      = 'myVideo'
			settings.recommendWidth  = root.stage.stageWidth
			settings.recommendHeight = root.stage.stageHeight-root.navigation_mc.bottom_navigation.height
			settings.vloop           = false
			settings.onvideoend      = myVideo_whenvideoend
			settings.onvideoload     = myVideo_whenvideoload
			//settings.videopreload    = myVideo_videopreload
			//settings.onbufferFull    = myVideo_onbufferFull
			//settings.onbufferEmpty   = myVideo_onbufferEmpty
			
			// fitw :: fith :: scale :: original
			settings.vscale          = 'fitw'
			myPlayer            = new ClassVideoPlayer(settings)
			myPlayer.bufferTime = root.settings.buffer
			
			ProgressTimer.addEventListener(TimerEvent.TIMER, onProgress)
			ProgressTimer.start()
			
			bufferTimer.addEventListener(TimerEvent.TIMER, showBufferProgress)
			
		}
		function showBufferProgress(e:TimerEvent){
			var buffer = myPlayer.getBuffering()			
			if(buffer>=99){
				root.video_cover.buffer_mc.visible = false
				bufferTimer.stop()				
			}else{
				root.video_cover.buffer_mc.txt.text = buffer
			}
			
		}
		function myVideo_onbufferFull(){
			root.video_cover.buffer_mc.visible = false
			bufferTimer.stop()	
		}
		function myVideo_onbufferEmpty(){
			if(root.myVideo.myPlayer.vstatus != root.myVideo.myPlayer.VIDEO_STOP){
				root.video_cover.buffer_mc.visible = true
				bufferTimer.start()	
			}
		}	
		function myVideo_whenvideoend(){
			root.playNextVideo()
		}
		public function myVideo_whenvideoload(){
			root.checkVideoSize(true)
			root.video_layer.video_mc.x = root.stage.stageWidth/2  - root.video_layer.video_mc.width/2
			root.video_layer.video_mc.y = root.stage.stageHeight/2 - root.video_layer.video_mc.height/2 -root.navigation_mc.bottom_navigation.height/2
		}
		function myVideo_videopreload(finished){
			root.navigation_mc.progress_mc.progress_loading.visible = true
			var percent:Number = myPlayer.getBytesLoaded/myPlayer.getBytesTotal
			root.navigation_mc.progress_mc.progress_loading.width = percent*root.navigation_mc.progress_mc.progress_bar.width
			if(finished){
				videoFileLoaded = true
			}
		}
		public function playVideo(src=undefined){
			unloadVideoCover()
			if(src!=undefined)this.src = src
			myPlayer.play(this.src)
		}

		public function pause():void{
			myPlayer.pause()
		}
		public function stop():void{
			myPlayer.stop()
		}
		function onProgress(e:TimerEvent){
			var nowtime:String = ClassVideoUtils.maketime(root.myVideo.myPlayer.time)
			var alltime:String = ClassVideoUtils.maketime(root.myVideo.myPlayer.duration)
			root.navigation_mc.bottom_navigation.timeTF.text            = nowtime + ' / ' + alltime

			root.navigation_mc.progress_mc.video_progress.progress_play.width = root.myVideo.myPlayer.time/root.myVideo.myPlayer.duration*root.navigation_mc.progress_mc.video_progress.progress_bar.width
			root.navigation_mc.progress_mc.video_progress.progress_load.width = root.myVideo.myPlayer.getBytesLoaded/root.myVideo.myPlayer.getBytesTotal*root.navigation_mc.progress_mc.video_progress.progress_bar.width
		}
		
		public function loadVideoCover(src){
			var coverLoader:Loader = new Loader()
			coverLoader.load(new URLRequest(src))
			coverLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,on_coverLoader)
			coverSprite       = new Sprite()
			coverSprite.alpha = 0
			coverSprite.addChild(coverLoader)
			root.video_cover.image_mc.addChild(coverSprite)
		}
		public function unloadVideoCover(){
			if(coverSprite!=null){
				root.video_cover.image_mc.removeChild(coverSprite)
				coverSprite = null
			}
		}
		function on_coverLoader(e:Event){
			root.on_stage_resize(new Event(''))
			TweenLite.to(e.target.content.parent.parent,0.5,{alpha:1})
		}
	}
}