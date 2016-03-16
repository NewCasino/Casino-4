package com.ui {	
	import com.control.ControlsHolder;
	import com.core.Engine;
	import com.data.DataHolder;
	import com.events.VideoMetadataEvent;
	import com.ui.components.AdvertisePanel;
	import com.ui.components.AdvImageLoader;
	import com.ui.components.Logo;
	import com.ui.components.StatusPanel;
	import com.ui.components.TooltipBaloon;
	import com.ui.navigation.NavigationPanel;
	import com.ui.navigation.PlayButton;
	import com.ui.navigation.ReplayScreen;
	import com.ui.share.ShareVideoWindow;
	import com.video.VideoPlayer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import gs.TweenLite;
	
	public class Main extends Sprite {		
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		private var controlsHolder:ControlsHolder = ControlsHolder.getInstance();
		private var engine:Engine = Engine.getInstance();
		public var videoOutput:Sprite;
		public var mcBackground:Sprite;
		public var mcNavigation:NavigationPanel;
		public var mcStart:PlayButton;		
		public var videoPlayer:VideoPlayer;
		public var shareWindow:ShareVideoWindow;
		public var mcGoogleAdvPanel:AdvertisePanel;
		public var mcStatusPanel:StatusPanel;
		public var mcReplayScreen:ReplayScreen;
		public var mcAdvImageContainer:AdvImageLoader;
		public var logo:Logo;
		
		private var bIsOriginal:Boolean = false;		
		
		public function Main() {
			this.alpha = 0;
			videoOutput = new Sprite();
			videoOutput.mouseEnabled = true;
			this.addChild(videoOutput);
			this.setChildIndex(videoOutput, 1);
			//trace ("Main constructor  "+videoOutput.parent);
			this.initUI();			
		}
		
		public function initUI():void {			
			controlsHolder.mainClass = this;
			controlsHolder.playButton = mcStart;
			videoPlayer = new VideoPlayer();
			
			/*
			if (String(dataHolder.xMainXml.rmpt.@path).length > 0) {				
				videoPlayer.bIsRtmp = true;
			} else {
				videoPlayer.bIsRtmp = false;
			}
			*/
			videoOutput.addChild(videoPlayer);			
			controlsHolder.videoPlayer = this.videoPlayer;
			videoPlayer.addEventListener("metadataEvent", onPlayerMetadata);
			shareWindow = new ShareVideoWindow();
			this.addChild(shareWindow);
			controlsHolder.shareWindow = shareWindow;
			controlsHolder.advPanel = mcGoogleAdvPanel;
			controlsHolder.statusPanel = mcStatusPanel;
			controlsHolder.replayScreen = mcReplayScreen;
			controlsHolder.advImageContainer = mcAdvImageContainer;
			this.loadLogo();
			
			mcReplayScreen.visible = false;
			root.stage.addEventListener(Event.RESIZE, onStageResizeHandler);			
		}
		
		private function onPlayerMetadata($event:VideoMetadataEvent):void {
			dataHolder.nVideoDuration = $event.info.duration;
			dataHolder.nOrigVideoWidth = $event.info.width;
			dataHolder.nOrigVideoHeight = $event.info.height;
			engine.videoMetadataRecieved();
			this.resizeVideo(bIsOriginal);
			//trace("metadata: duration=" + $event.info.duration + " width=" + $event.info.width + " height=" + $event.info.height + " framerate=" + $event.info.framerate);
		}
		
		public function onStageResizeHandler($event:Event):void {
			this.x = 0;
			this.y = 0;
			dataHolder.nStageWidth = stage.stageWidth;
			dataHolder.nStageHeight = stage.stageHeight;
			
			this.setBackgroundSize();
			
			controlsHolder.playButton.updateSize();
			mcNavigation.updateSize();
			dataHolder.nMaxVideoWidth = stage.stageWidth;
			dataHolder.nMaxVideoHeight = stage.stageHeight - mcNavigation.mcNavBackground.height;
			controlsHolder.progressBar.setWidth(stage.stageWidth);
			controlsHolder.shareWindow.updatePosition();
			this.resizeVideo(bIsOriginal);
			mcGoogleAdvPanel.updateSize();
			mcStatusPanel.updateSize();
			mcReplayScreen.updateSize();
			mcAdvImageContainer.updateSize();
			logo.updateSize();
			//trace(this.x + "  " + this.y);
		}
		
		private function loadLogo():void {
			logo = new Logo();
			controlsHolder.logo = this.logo;
			this.addChild(logo);
		}
		
		public function resizeVideo($originalSize:Boolean):void {
			bIsOriginal = $originalSize;			
			if (bIsOriginal) {				
				if (dataHolder.nMaxVideoWidth > dataHolder.nOrigVideoWidth || dataHolder.nMaxVideoHeight > dataHolder.nOrigVideoHeight) {
					this.resizeVideoToOriginal();
				} else {
					this.resizeVideoToMax();
				}
			} else {
				this.resizeVideoToMax();
			}
		}
		
		private function resizeVideoToOriginal():void {
			if (dataHolder.nOrigVideoWidth > dataHolder.nMaxVideoWidth) {
				return;
			}
			var xPos:Number = Math.round((dataHolder.nMaxVideoWidth - dataHolder.nOrigVideoWidth) / 2);
			var yPos:Number = Math.round((dataHolder.nMaxVideoHeight - dataHolder.nOrigVideoHeight) / 2);			
			if (videoPlayer.width != dataHolder.nOrigVideoWidth) {
				TweenLite.to(videoPlayer, 0.5, { x:xPos, y:yPos, width:dataHolder.nOrigVideoWidth, height:dataHolder.nOrigVideoHeight } );
			} else {
				videoPlayer.x = xPos;
				videoPlayer.y = yPos;
			}
			
			
		}
		
		private function resizeVideoToMax():void {			
			if (dataHolder.xMainXml.settings.@scale == 0) {
				videoPlayer.x = videoPlayer.y = 0;
				videoPlayer.width = Math.round(dataHolder.nMaxVideoWidth);
				videoPlayer.height = Math.round(dataHolder.nMaxVideoHeight);
			} else {				
				var coef:Number =  dataHolder.nOrigVideoWidth / dataHolder.nOrigVideoHeight;
				videoPlayer.width = dataHolder.nMaxVideoWidth;
				videoPlayer.height = dataHolder.nMaxVideoWidth / coef;
				
				if (videoPlayer.height > dataHolder.nMaxVideoHeight) {
					videoPlayer.height = dataHolder.nMaxVideoHeight;
					videoPlayer.width = dataHolder.nMaxVideoHeight * coef;
				}				
				
				videoPlayer.y = (dataHolder.nMaxVideoHeight - videoPlayer.height) / 2;
				videoPlayer.x = (dataHolder.nMaxVideoWidth - videoPlayer.width) / 2;				
			}
		}
		
		private function setBackgroundSize():void {
			mcBackground.width = stage.stageWidth;
			mcBackground.height = stage.stageHeight;
		}
	}
}