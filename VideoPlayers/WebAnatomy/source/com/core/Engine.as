package com.core {	
	import com.data.DataHolder;
	import com.control.ControlsHolder;
	import com.events.ProgressBarEvent;
	import com.events.ShareControlEvent;
	import com.events.VideoListEvent;
	import com.events.VideoMetadataEvent;
	import com.events.VideoPlayerEvent;
	import com.events.VideoPlayerTimeEvent;
	import com.events.VolumeSliderEvent;
	import com.video.VideoState;
	import com.vo.VideoListItemVO;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	public class Engine extends EventDispatcher {
		
		public static var engine:Engine;
		private var dataHolder:DataHolder = DataHolder.getInstance();
		private var controlsHolder:ControlsHolder = ControlsHolder.getInstance();
		
		public function Engine() {
			if (engine) {
				throw new Error( "Only one Engine instance should be instantiated" );
			}
		}
		
		public static function getInstance():Engine {			
			if (engine == null) {
				engine = new Engine();
			}
			return engine;
		}
		
		public function startUp():void {			
			//controlsHolder._stage.mcMain.initUI();
			setTimeout(checkAutoplay, 100);
		}
		
		
		
		private function onMainXMLLoadComplete():void {
			trace ("Engine: xml loaded");
		}
		
		private function checkAutoplay():void {
			this.addListeners();
			this.loadVideoData();
			this.parsePlayListData();
			
			if (!dataHolder.bAutoPlay) {				
				controlsHolder.playButton.loadImage(dataHolder.xMainXml.videoData.thumb);				
			} else {
				this.selectVideoTrack();
			}
			this.initResizeHandler();
			controlsHolder.mainClass.alpha = 1;
		}
		
		private function loadVideoData(data:VideoListItemVO = null):void {
			if (!data) {
				dataHolder.sSDVideoPath = dataHolder.xMainXml.videoData.sdPath;
				dataHolder.sHDVideoPath = dataHolder.xMainXml.videoData.hdPath;
				dataHolder.sTitle = dataHolder.xMainXml.videoData.title;
				dataHolder.sDescription = dataHolder.xMainXml.videoData.desc;
			} else {
				dataHolder.sSDVideoPath = data.sdLink;
				dataHolder.sHDVideoPath = data.hdLink;
				dataHolder.sTitle = data.title;
				dataHolder.sDescription = data.description;
				this.replay();
			}
		}
		
		private function addListeners():void {
			controlsHolder.playButton.addEventListener(MouseEvent.CLICK, onUserClickPlay);
			controlsHolder.playPauseButton.addEventListener("play", onUserClickPlay);
			controlsHolder.playPauseButton.addEventListener("pause", onUserClickPause);
			controlsHolder.videoPlayer.addEventListener("play", onPlayerPlay);
			controlsHolder.videoPlayer.addEventListener("pause", onPlayerPause);
			controlsHolder.videoPlayer.addEventListener("stop", onPlayerStop);
			controlsHolder.videoPlayer.addEventListener("bufferFull", onPlayerBufferFull);
			controlsHolder.videoPlayer.addEventListener("bufferEmpty", onPlayerBufferEmpty);
			controlsHolder.videoPlayer.addEventListener(ProgressEvent.PROGRESS, onVideoLoadProgress);
			controlsHolder.videoPlayer.addEventListener("time", onVideoPlayerProgress);
			controlsHolder.progressBar.addEventListener("dragSlider", onDragProgressBar);
			controlsHolder.volumeSlider.addEventListener("volumeChange", onVolumeChange);
			controlsHolder.btnOriginalVideoSize.addEventListener(MouseEvent.CLICK, onClickOriginalBtn);
			controlsHolder.fullScreenButton.addEventListener(MouseEvent.CLICK, onClickFullscreenBtn);
			controlsHolder.shareControl.addEventListener("shareControlClick", onShareControlClick);
			controlsHolder.shareWindow.addEventListener("close", onShareWindowClose);
			controlsHolder.videoPlayList.addEventListener("itemClick", videoListClickHandler);
			controlsHolder.hdSd.addEventListener("hdsd", onUserClickHdSd);
			controlsHolder.menuButton.addEventListener("click", onUserClickMenuBtn);
			controlsHolder.replayScreen.addEventListener("replay", replayClickHandler);
			controlsHolder.advImageContainer.addEventListener("close", advContainerCloseHandler);
			controlsHolder.logo.addEventListener("loadComplete", logoLoadCompleteHandler);
		}
		
		private function removeListeners():void {
			controlsHolder.playPauseButton.removeEventListener("play", onUserClickPlay);
			controlsHolder.playPauseButton.removeEventListener("pause", onUserClickPause);
		}
		
		private function onUserClickPlay($event:Event):void {
			if (dataHolder.bReplayState) {
				this.hideReplayWindowAndStart();
				return;
			}
			
			//trace ("ENGINE videoplayer state: "+ controlsHolder.videoPlayer.state);
			if (controlsHolder.videoPlayer.state == "paused") {
				controlsHolder.videoPlayer.resume();
			} else {//if (dataHolder.bStoped) {
				this.selectVideoTrack();				
			}
			
			//trace ("ENGINE: user clicked play button");
		}
		
		private function onUserClickPause($event:Event):void {
			//trace ("ENGINE: user clicked pause button");
			controlsHolder.videoPlayer.pause();
		}
		
		private function onPlayerPlay($event:VideoPlayerEvent):void {
			controlsHolder.playPauseButton.showPauseBtn();
		}
		
		private function onPlayerStop($event:VideoPlayerEvent):void {
			controlsHolder.playPauseButton.showPlayBtn();
			trace ("ENGINE: player stoped");
			this.selectVideoTrack();
		}
		
		private function onPlayerPause($event:VideoPlayerEvent):void {
			controlsHolder.playPauseButton.showPlayBtn();
		}
		
		private function onPlayerBufferFull($event:VideoPlayerEvent):void {
			
		}
		
		private function onPlayerBufferEmpty($event:VideoPlayerEvent):void {
			
		}
		
		private function onVideoLoadProgress($event:ProgressEvent):void {
			//trace ("DOWNLOAD PROGRESS");
			var $nPerc:Number = $event.bytesLoaded / $event.bytesTotal;
			controlsHolder.progressBar.trackLoadedVideo($nPerc);
		}
		
		private function onVideoPlayerProgress($event:VideoPlayerTimeEvent):void {
			var $percent:Number = $event.time / dataHolder.nVideoDuration;
			//trace ("TRACK PROGRESS  "+$percent);
			controlsHolder.progressBar.trackProgress($percent);
		}
		
		private function onDragProgressBar($event:ProgressBarEvent):void {
			controlsHolder.videoPlayer.seek($event.percent);
		}
		
		private function onVolumeChange($event:VolumeSliderEvent):void {
			controlsHolder.videoPlayer.volume = $event.volume;
		}
		
		private function onClickOriginalBtn($event:MouseEvent):void {			
			controlsHolder.mainClass.resizeVideo(controlsHolder.btnOriginalVideoSize.original);
		}
		
		private function onClickFullscreenBtn($event:MouseEvent):void {
			controlsHolder.btnOriginalVideoSize.original = false;
			controlsHolder.mainClass.resizeVideo(false);
		}
		
		private function onShareControlClick($event:ShareControlEvent):void {
			if (dataHolder.iCurrentShareWindow == $event.panelID) {				
				controlsHolder.shareWindow.close();
			} else if (dataHolder.iCurrentShareWindow == -1) {				
				dataHolder.iCurrentShareWindow = $event.panelID;
				controlsHolder.shareWindow.showPanel($event.panelID);
			}			
		}
		
		private function onShareWindowClose($event:Event):void {
			//trace ("WINDOW CLOSED");
			dataHolder.iCurrentShareWindow = -1;
		}
		
		private function videoListClickHandler($event:VideoListEvent):void {
			controlsHolder.replayScreen.visible = false;
			if ($event.data.play) {
				this.loadVideoData($event.data);
			} else {
				var $request:URLRequest = new URLRequest($event.data.link);
				navigateToURL($request, $event.data.type);
			}
			
		}
		
		private function onUserClickHdSd($event:Event):void {
			trace ("CLICK HDSD");
			dataHolder.bIsHD = controlsHolder.hdSd.isHd;
			if (dataHolder.sCurrentVideo == DataHolder.CURRENT_PLAYING_VIDEO) {
				controlsHolder.videoPlayer.pause();
				this.playVideo();
			}
		}
		
		private function showReplayScreen() {
			controlsHolder.replayScreen.visible = true;
		}
		
		private function onUserClickMenuBtn($event:Event):void {			
			if (dataHolder.sCurrentVideo != "") {
				if (!controlsHolder.replayScreen.visible) {
					controlsHolder.replayScreen.visible = true;
				} else {
					controlsHolder.replayScreen.visible = false;
				}				
			}
		}
		
		private function replayClickHandler($event:Event):void {
			this.replay();
		}
		
		private function advContainerCloseHandler($event:Event):void {
			
			this.selectVideoTrack();
		}
		
		private function replay():void {
			dataHolder.bVideoDone = false;
			dataHolder.bPrerollDone = false;
			dataHolder.bPostrollDone = false;
			this.selectVideoTrack();
		}
		
		private function selectVideoTrack():void {
			if (dataHolder.bStartState) {
				dataHolder.bStartState = false;
				controlsHolder.playButton.hide();
			}
			
			if (dataHolder.bPrerollDone == false) {
				if (dataHolder.xMainXml.preroll.video.@active == 'true' || dataHolder.xMainXml.preroll.image.@active == 'true') {
					dataHolder.sCurrentVideo = DataHolder.CURRENT_PLAYING_PREROLL;
					this.startPreroll();					
					this.addVideoClickListener();
					controlsHolder.advPanel.hideRotator();
					return;
				}				
			}
			
			
			if (dataHolder.bVideoDone == false) {
				dataHolder.sCurrentVideo = DataHolder.CURRENT_PLAYING_VIDEO;
				dataHolder.bVideoDone = true;
				this.playVideo();
				controlsHolder.statusPanel.show();				
				this.removeVideoClickListener();
				controlsHolder.advPanel.showRotator();
				return;
			}
			
			try {
				if (dataHolder.bPostrollDone == false) {
					if (dataHolder.xMainXml.postroll.video.@active == 'true' || dataHolder.xMainXml.postroll.image.@active == 'true') {
						dataHolder.sCurrentVideo = DataHolder.CURRENT_PLAYING_POSTROLL;
						this.startPostroll();
						controlsHolder.advPanel.hideRotator();
						this.addVideoClickListener();
						return;
					}		
				}
			} catch (error:ArgumentError) {
				trace("An ArgumentError has occurred.");
			} catch (error:SecurityError) {
				trace("A SecurityError has occurred.");
			}
			this.removeVideoClickListener();
			controlsHolder.advPanel.hideRotator();
			controlsHolder.videoPlayer.visible = true;
			controlsHolder.progressBar.sliderEnabled = true;
			this.showReplayScreen();
		}
		
		private function addVideoClickListener():void {
			if (controlsHolder.mainClass.videoOutput.hasEventListener(MouseEvent.CLICK)) return;
			controlsHolder.mainClass.videoOutput.buttonMode = true;
			controlsHolder.mainClass.videoOutput.addEventListener(MouseEvent.CLICK, clickVideoHandler);
		}
		
		public function removeVideoClickListener():void {
			if (!controlsHolder.mainClass.videoOutput.hasEventListener(MouseEvent.CLICK)) return;
			controlsHolder.mainClass.videoOutput.buttonMode = false;
			controlsHolder.mainClass.videoOutput.removeEventListener(MouseEvent.CLICK, clickVideoHandler);
		}
		
		private function clickVideoHandler($event:MouseEvent):void {
			var $url:String;
			var request:URLRequest;
			if (dataHolder.sCurrentVideo == DataHolder.CURRENT_PLAYING_PREROLL) {
				$url = dataHolder.xMainXml.preroll.video.@link;				
				request = new URLRequest($url);
			} else if (dataHolder.sCurrentVideo == DataHolder.CURRENT_PLAYING_POSTROLL) {
				$url = dataHolder.xMainXml.postroll.video.@link;				
				request = new URLRequest($url);
			} else {
				return;
			}
			navigateToURL(request);
		}
		
		private function startPreroll():void {			
			dataHolder.bPrerollDone = true;
			controlsHolder.progressBar.sliderEnabled = false;
			if (dataHolder.xMainXml.preroll.video.@active == 'true') {				
				controlsHolder.videoPlayer.play(dataHolder.xMainXml.preroll.video.@path);
				return;
			}
			
			if (dataHolder.xMainXml.preroll.image.@active == 'true') {
				controlsHolder.videoPlayer.visible = false;
				controlsHolder.progressBar.trackProgress(0);
				controlsHolder.advImageContainer.loadImage("preroll");
				return
			}
			
		}
		
		private function startPostroll():void {			
			dataHolder.bPostrollDone = true;
			controlsHolder.progressBar.sliderEnabled = false;
			if (dataHolder.xMainXml.postroll.video.@active == 'true') {
				controlsHolder.videoPlayer.play(dataHolder.xMainXml.postroll.video.@path);
				return;
			}
			
			if (dataHolder.xMainXml.postroll.image.@active == 'true') {
				controlsHolder.videoPlayer.visible = false;
				controlsHolder.progressBar.trackProgress(0);
				controlsHolder.advImageContainer.loadImage("postroll");
				return
			}
			
		}
		
		private function playVideo():void {
			controlsHolder.videoPlayer.visible = true;
			controlsHolder.progressBar.sliderEnabled = true;
			if (dataHolder.bIsHD) {
				trace ("CURRENT LINK HD");
				controlsHolder.videoPlayer.play(dataHolder.sHDVideoPath);
			} else {
				trace ("CURRENT LINK SD");
				controlsHolder.videoPlayer.play(dataHolder.sSDVideoPath);
			}
			
		}
		
		public function hideReplayWindowAndStart():void {
			trace ('HIDE AND START');
			dataHolder.bReplayState = false;
			//mcReplayButton.visible = false;
			//this.removeChild(carousel);
			//this.onStageResizeHandler(new Event(''));
			//this.replay();
		}
		
		public function videoMetadataRecieved():void {
			//controlsHolder.progressBar
		}
		
		private function parsePlayListData():void {
			var $data:Array = new Array();
			var $xList:XMLList = new XMLList();
			$xList = dataHolder.xMainXml.playlist.children();
			
			for (var i:int = 0; i < $xList.length(); i++) {
				var $videoItemVO:VideoListItemVO = new VideoListItemVO();
				$videoItemVO.description = $xList[i].@info;
				$videoItemVO.hdLink = $xList[i].@hdPath;
				$videoItemVO.sdLink = $xList[i].@sdPath;
				$videoItemVO.link = $xList[i].@link;				
				$videoItemVO.title = $xList[i].@tilte;
				$videoItemVO.thumb = $xList[i].@thumb;
				$videoItemVO.type = $xList[i].@type;
				
				if ($xList[i].@play.toLowerCase() == "true") {
					$videoItemVO.play = true;
				} else {
					$videoItemVO.play = false;
				}
				$data.push($videoItemVO);
			}
			controlsHolder.videoPlayList.dataProvider = $data;			
		}
		
		private function logoLoadCompleteHandler($event:Event):void {
			this.initResizeHandler();
		}
		
		private function initResizeHandler():void {
			controlsHolder.mainClass.onStageResizeHandler(new Event(''));
		}
		
		private function setBlurEffect():void {
			
		}
		
		private function removeBlurEffect():void {
			
		}
		
		
	}
}