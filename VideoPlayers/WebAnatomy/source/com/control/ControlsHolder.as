package com.control {
	
	import com.ui.components.AdvImageLoader;
	import com.ui.components.Logo;
	import com.ui.components.TooltipBaloon;
	import com.ui.components.VideoList;
	import com.ui.components.AdvertisePanel;
	import com.ui.components.StatusPanel;
	import com.ui.Main;
	import com.ui.navigation.HdSdButton;
	import com.ui.navigation.MenuButton;
	import com.ui.navigation.NavigationPanel;
	import com.ui.navigation.PlayButton;
	import com.ui.navigation.PlayPauseButton;
	import com.ui.navigation.ProgressBar;
	import com.ui.navigation.ReplayScreen;
	import com.ui.navigation.ToggleFullscreenButton;
	import com.ui.navigation.ToggleOriginalVideoSize;
	import com.ui.navigation.VolumeControl;
	import com.ui.navigation.VolumeSlider;
	import com.ui.navigation.ShareVideoControl;
	import com.ui.share.ShareVideoWindow;
	import com.video.VideoPlayer;
	import com.DocumentClass;
	
	public class ControlsHolder {
		
		public static var controlsHolder:ControlsHolder;
		
		public var _stage:DocumentClass;
		public var videoPlayer:VideoPlayer;
		public var mainClass:Main;
		public var playButton:PlayButton;
		public var playPauseButton:PlayPauseButton;
		public var progressBar:ProgressBar;
		public var volumeSlider:VolumeSlider;
		public var fullScreenButton:ToggleFullscreenButton;
		public var btnOriginalVideoSize:ToggleOriginalVideoSize;
		public var shareControl:ShareVideoControl;
		public var shareWindow:ShareVideoWindow;
		public var advPanel:AdvertisePanel;
		public var statusPanel:StatusPanel;
		public var replayScreen:ReplayScreen;
		public var videoPlayList:VideoList;
		public var hdSd:HdSdButton;
		public var menuButton:MenuButton;
		public var advImageContainer:AdvImageLoader;
		public var logo:Logo;
		public var toolTip:TooltipBaloon;
		public var navigation:NavigationPanel;
		
		public function ControlsHolder() {
			if (controlsHolder) {
				throw new Error( "Only one ControlsHolder instance should be instantiated" );
			}
		}
		
		public static function getInstance():ControlsHolder {			
			if (controlsHolder == null) {
				controlsHolder = new ControlsHolder();
			}
			return controlsHolder;
		}
		
		public function clear($object:Object):void {
			while ($object.numChildren) {				
				$object.removeChildAt(0);
			}
		}
	}
}