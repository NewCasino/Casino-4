package com.ui.navigation {	
	
	import com.data.DataHolder;
	import com.events.VideoStatusEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class NavigationPanel extends MovieClip {
		
		public var mcVolumeControl:VolumeControl;
		public var mcMiniPanel:MovieClip;
		public var mcPlayPause:MovieClip;
		public var mcLogoContainer:MovieClip;		
		public var mcProgressBar:ProgressBar;
		public var mcNavBackground:Sprite;
		private var dataHolder:DataHolder = DataHolder.getInstance();		
		
		public function NavigationPanel() {
			super();
			//trace (mcMiniPanel.mcPlayPause);
			mcPlayPause.addEventListener(MouseEvent.CLICK, onPlayPauseClickHandler);
			dataHolder.eventDispatcher.addEventListener(VideoStatusEvent.EVENT_VIDEO_STATUS, onVideoStatus);			
			//this.addEventListener(VideoStatusEvent.VIDEO_PAUSE, onVideoPauseHandler);
		}
		
		public function onPlayPauseClickHandler($event:MouseEvent):void {
			//trace (dataHolder.bPaused+"    "+dataHolder.bStoped);
			if (dataHolder.bReplayState) {
				dataHolder._stage.hideReplayWindowAndStart();
				return;
			}
			
			if (dataHolder.bPaused) {
				dataHolder._stage.videoHandler.resume();
			} else if (dataHolder.bStoped) {
				dataHolder._stage.selectVideoTrack();				
			} else {
				dataHolder._stage.videoHandler.pause();
			}
			
		}
		
		public function onVideoStatus($event:VideoStatusEvent):void {			
			switch ($event.status) {
				case VideoStatusEvent.VIDEO_PLAY : {
					dataHolder.bPaused = false;
					dataHolder.bStoped = false;
					mcPlayPause.gotoAndStop('pause');
					break;
				}
				case VideoStatusEvent.VIDEO_PAUSE : {
					dataHolder.bPaused = true;
					mcPlayPause.gotoAndStop('play');
					break;
				}
				case VideoStatusEvent.VIDEO_STOP : {
					dataHolder.bStoped = true;
					mcPlayPause.gotoAndStop('play');
					break;
				}
			}
		}
		
		public function onVideoPauseHandler():void {
			
		}
	}
}