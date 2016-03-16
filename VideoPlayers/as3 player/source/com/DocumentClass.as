// ActionScript file
package com {
	
	import com.data.DataHolder;
	import com.data.XMLParser;
	import com.ui.components.AdvertisePanel;
	import com.ui.components.AdvImageLoader;
	import com.ui.components.Carousel;
	import com.ui.Logo;
	import com.ui.navigation.NavigationPanel;
	import com.ui.navigation.PlayButton;
	import com.ui.navigation.ReplayButton;
	import com.ui.share.ShareVideoWindow;
	import com.video.ClassVideo;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.setTimeout;
		
	public class DocumentClass extends MovieClip {
		
		public var videoHandler:ClassVideo;
		//public var videoClipHandler:ClassVideo;
		public var videoOutput:Sprite;
		public var advOutput:Sprite;
		public var mcBackground:MovieClip;
		
		public var mcShareWindowContainer:MovieClip;
		public var mcNavigation:NavigationPanel;		
		public var oParams:Object;
		private var dataHolder:DataHolder;
		public var mcStart:PlayButton;
		public var mcReplayButton:ReplayButton;
		public var carousel:Carousel;
		public var shareWindow:ShareVideoWindow;
		public var mcAdvImageContainer:AdvImageLoader;
		public var mcGoogleAdvPanel:AdvertisePanel;
		public var logo:Logo;
		

	
		public function DocumentClass() {
			super();
			this.loaderInfo.addEventListener(Event.COMPLETE, initApplication, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, _listenLoading, false, 0, true);// on enter frame to check if it’s loaded  
		}		
		
		private function _listenLoading($event:Event):void {  
			if (root.loaderInfo.bytesLoaded == root.loaderInfo.bytesTotal) {
				this.initApplication(new Event(""));  
			}  
		}
		
		private function initApplication($event:Event):void {
			this.loaderInfo.removeEventListener(Event.COMPLETE, initApplication);			
			this.removeEventListener(Event.ENTER_FRAME, _listenLoading);
			
			
			dataHolder = DataHolder.getInstance();
			this.initFlashVars();
			dataHolder._stage = this;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;			
			mcStart.visible = false;
			mcReplayButton.visible = false;
			
			root.stage.addEventListener(Event.RESIZE, onStageResizeHandler, false, 0, true);
			//oParams = LoaderInfo(this.root.loaderInfo).parameters;
			
			var $request:URLRequest;
			var $vars:URLVariables = new URLVariables();
			
			if (oParams.videoid != undefined && oParams.videoid != '') {
				$request = new URLRequest(dataHolder.sXmlUrl + "mm_player.php" + "?videoid=" + dataHolder.sVideoID + "&home=" + dataHolder.sHome);
				//$vars.videoid = dataHolder.sVideoID;
				//$vars.home = dataHolder.sHome;
				//$request.data = $vars;
				//$request.contentType = "text/xml";
			} else {
				$request = new URLRequest(dataHolder.sXmlUrl);
			}
		
			var xml = new XMLParser($request, xmlLoadCompleteHandler);
			
			changeContextMenu()
		}
		
		public function changeContextMenu():void {
			var myMenu:ContextMenu = new ContextMenu();
            myMenu.hideBuiltInItems();

            var menu_brand:ContextMenuItem = new ContextMenuItem(dataHolder.brand_name);
			menu_brand.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.menuClickHandler, false, 0, true) 
            myMenu.customItems.push(menu_brand);
			
            this.contextMenu = myMenu;        				
			//videoOutput.mouseEnabled = false
		}
		
		
		function menuClickHandler($event:ContextMenuEvent):void {
			var request:URLRequest = new URLRequest(dataHolder.brand_link);
			navigateToURL(request);
		}
		
		private function setAllVisible():void {
			mcStart.alpha = 1;
			mcAdvImageContainer.alpha = 1;
			mcGoogleAdvPanel.alpha = 1;
			mcShareWindowContainer.alpha = 1;
			mcReplayButton.alpha = 1;
			mcNavigation.alpha = 1;
		}		
		
		private function xmlLoadCompleteHandler():void {
			this.initVideo();
			onVideoInit()
		}
		
		private function onVideoInit():void {
			this.checkAutoplay();
			var sds:XML
			
			if (dataHolder.xMainXml.hasOwnProperty("logo")) {
				dataHolder.logo = true;
				this.loadLogo();
			}
			
			mcNavigation.mcProgressBar.trackLoadedVideo(1);
			this.updateTexts();			
			this.onStageResizeHandler(new Event(''));
			this.setAllVisible();
			setTimeout(onStageResizeHandler, 200, (new Event('')));
		}
		
		private function initFlashVars():void {
			oParams = LoaderInfo(this.root.loaderInfo).parameters;
			var sXmlUrl:String;
			if (oParams.http_base_url != undefined && oParams.http_base_url!='') {
				dataHolder.sXmlUrl = oParams.http_base_url;
			}
			
			if (oParams.advxml_path != undefined && oParams.advxml_path!='') {
				dataHolder.sXmlAdvUrl = oParams.advxml_path;
			}
			
			if (oParams.autoPlay != undefined && oParams.autoPlay!='') {
				if (oParams.autoPlay == 'true') {
					dataHolder.bAutoPlay = true;
				} else {
					dataHolder.bAutoPlay = false;
				}
			}
			
			//dataHolder.sXmlAdvUrl = oParams.
			if (oParams.home != undefined && oParams.home!='') {
				dataHolder.sHome = oParams.home;
			}
			
			if (oParams.videoid != undefined && oParams.videoid!='') {
				dataHolder.sVideoID = oParams.videoid;
			}
			
			
		}
		
		private function startPlay():void {			
			videoOutput.visible = true;
			videoHandler.playVideo();
		}
		
		public function updateTexts():void {
			mcStart.updateTexts();
			mcReplayButton.updateTexts();
		}
		/*
		private function checkRotator():void {
			if (!dataHolder.bRotatorOpen) {
				mcGoogleAdvPanel.showRotator();
			}
		}
		*/
		public function selectVideoTrack():void {
			if (dataHolder.bStartState) {
				dataHolder.bStartState = false;
				mcStart.hide();
			}
			
			if (dataHolder.bPrerollDone == false) {
				if (dataHolder.xMainXml.preroll.video.@active == 'true' || dataHolder.xMainXml.preroll.image.@active == 'true') {
					dataHolder.sCurrentVideo = DataHolder.CURRENT_PLAYING_PREROLL;
					this.switchToAdv();
					this.startPreroll();
					this.addVideoClickListener();
					mcGoogleAdvPanel.hideRotator();
					return;
				}				
			}
			
			
			if (dataHolder.bVideoDone == false) {
				dataHolder.sCurrentVideo = DataHolder.CURRENT_PLAYING_VIDEO;
				this.switchToClip();
				this.startVideo();
				this.removeVideoClickListener();
				mcGoogleAdvPanel.showRotator();
				return;
			}
			
			try {
				if (dataHolder.bPostrollDone == false) {
					if (dataHolder.xMainXml.postroll.video.@active == 'true' || dataHolder.xMainXml.postroll.image.@active == 'true') {
						dataHolder.sCurrentVideo = DataHolder.CURRENT_PLAYING_POSTROLL;
						this.switchToAdv();
						this.startPostroll();
						mcGoogleAdvPanel.hideRotator();
						this.addVideoClickListener();
						return;
					}		
				}
			} catch (error:ArgumentError) {
				trace("An ArgumentError has occurred.");
			} catch (error:SecurityError) {
				trace("A SecurityError has occurred.");
			}
			
			
			this.switchToClip();
			
			videoHandler.videoPlayer.seek(videoHandler.videoPlayer.duration/ 2);
			
			this.removeVideoClickListener();
			mcGoogleAdvPanel.hideRotator();
			this.showReplayWindow();			
		}
		
		private function initVideo():void {
			videoHandler = new ClassVideo();			
		}
		
		public function switchToClip():void {
			videoHandler.switchToClip();
			videoOutput.visible = true;
			advOutput.visible = false;
		}
		
		public function switchToAdv():void {
			videoHandler.switchToAdv();
			videoOutput.visible = false;
			advOutput.visible = true;
		}
		
		private function onStageResizeHandler($event:Event):void {
			dataHolder.nStageWidth = stage.stageWidth;
			dataHolder.nStageHeight = stage.stageHeight;
			//calculating max available space for video depending on screen state (normal or replay)
			if (dataHolder.bReplayState) {
				dataHolder.nMaxVideoWidth = stage.stageWidth / 1.78;
				dataHolder.nMaxVideoHeight = stage.stageHeight / 1.95;				
			} else {
				dataHolder.nMaxVideoWidth = stage.stageWidth;
				dataHolder.nMaxVideoHeight = stage.stageHeight - 41;
			}
			
			this.setBackgroundSize();
			this.setProgressBarSize();
			this.setNavigationPanelSize();
			mcStart.updateSize();
			mcAdvImageContainer.updateSize();
			this.resizeVideo();
			this.updateShareWindowSize();
			this.resizeReplayButton();
			this.resizeCarousel();
			if (dataHolder.logo) {
				logo.updateSize();
			}
			
			mcGoogleAdvPanel.updateSize();
		}
		
		private function setBackgroundSize():void {
			mcBackground.width = stage.stageWidth;
			mcBackground.height = stage.stageHeight;
		}
		
		private function resizeCarousel():void {
			if (dataHolder.bReplayState) {				
				//carousel.titleTF._width = sw;
				//carousel.set_sizes()
				//carousel.set_positions()
				carousel.mcBackground.width = stage.stageWidth;

				carousel.mcMask.x = 20;
				carousel.mcMask.width  = stage.stageWidth - 40;
				carousel.y = stage.stageHeight - 77 - 41;
				
				carousel.mcRightArrow.x = stage.stageWidth - 4;
				carousel.mcLeftArrow.x = 4;
				carousel.mcLeftArrow.y = carousel.mcRightArrow.y = 30;
			}			
		}
		
		public function resizeVideo():void {
			var $video:Video = videoHandler.videoPlayer.video;
			
			if (dataHolder.bReplayState) {				
				$video.x = 25;
				$video.y = 41;
			} 
			
			
			//calculating video size
			if (dataHolder.xMainXml.settings.@scale == 0) {
				
				if (!dataHolder.bReplayState) {
					$video.x = $video.y = 0;
				}
				
				$video.width = Math.round(dataHolder.nMaxVideoWidth);
				$video.height = Math.round(dataHolder.nMaxVideoHeight);
				
			} else {
				
				var coef:Number =  dataHolder.nOrigVideoWidth / dataHolder.nOrigVideoHeight;
				$video.width = dataHolder.nMaxVideoWidth;
				$video.height = dataHolder.nMaxVideoWidth / coef;
				
				if ($video.height > dataHolder.nMaxVideoHeight) {
					$video.height = dataHolder.nMaxVideoHeight;
					$video.width = dataHolder.nMaxVideoHeight * coef;
				}
				
				//checking whether state is not "replay", if not we set new video position
				if (!dataHolder.bReplayState) {
					$video.y = (dataHolder.nMaxVideoHeight - $video.height) / 2;
					$video.x = (dataHolder.nMaxVideoWidth - $video.width) / 2;
				} else {
					$video.y += (dataHolder.nMaxVideoHeight - $video.height) / 2;
					$video.x += (dataHolder.nMaxVideoWidth - $video.width) / 2;
				}
			}
		}
		
		private function resizeReplayButton():void {
			var $video:Video = videoHandler.videoPlayer.video;
			if (dataHolder.xMainXml.settings.@scale == 0) {
				mcReplayButton.mcScrimBtn.x = $video.x;
				mcReplayButton.mcScrimBtn.y = $video.y;
				mcReplayButton.mcScrimBtn.width = $video.width;
				mcReplayButton.mcScrimBtn.height = $video.height;
				mcReplayButton.mcEmbedButtons.x = $video.x + 17 + $video.width;
				mcReplayButton.mcEmbedButtons.y = $video.y;
				
				mcReplayButton.mcReplayBtn.x = ($video.width - mcReplayButton.mcReplayBtn.width) / 2;
				mcReplayButton.mcReplayBtn.y = ($video.height - mcReplayButton.mcReplayBtn.height) / 2;
			} else {
				mcReplayButton.mcScrimBtn.x = 25;
				mcReplayButton.mcScrimBtn.y = 41;
				mcReplayButton.mcScrimBtn.width = dataHolder.nMaxVideoWidth;
				mcReplayButton.mcScrimBtn.height = dataHolder.nMaxVideoHeight;
				
				mcReplayButton.mcEmbedButtons.x = 25 + 17 + dataHolder.nMaxVideoWidth;
				mcReplayButton.mcEmbedButtons.y = 41;
				
				mcReplayButton.mcReplayBtn.x = (mcReplayButton.mcScrimBtn.width - mcReplayButton.mcReplayBtn.width) / 2 +25;
				mcReplayButton.mcReplayBtn.y = (mcReplayButton.mcScrimBtn.height - mcReplayButton.mcReplayBtn.height) / 2 +41;
			}
			
		}
		
		private function setNavigationPanelSize():void {
			mcNavigation.y = stage.stageHeight - mcNavigation.mcNavBackground.height;
			mcNavigation.mcNavBackground.width = stage.stageWidth;
			mcNavigation.mcMiniPanel.x = stage.stageWidth - mcNavigation.mcMiniPanel.width - 4 //+ logo_x_off_set;
		}
		
		private function setProgressBarSize():void {			
			mcNavigation.mcProgressBar.x = 40;
			var nWidth:Number;
			if (dataHolder.logo && dataHolder.xMainXml.logo.@location == 'progress_bar') {
				nWidth = stage.stageWidth - mcNavigation.mcMiniPanel.width - mcNavigation.mcProgressBar.x - 5 - logo.width - logo.nHPadding;
			} else {
				nWidth = stage.stageWidth - mcNavigation.mcMiniPanel.width - mcNavigation.mcProgressBar.x - 5;
			}
			
			mcNavigation.mcProgressBar.setWidth(nWidth)
		}
		
		public function videoStoped():void {
			this.showReplayWindow();
		}
		
		private function showReplayWindow():void {
			//we just set view state "replay" and envoke resize handler			
			dataHolder.bReplayState = true;
			mcReplayButton.visible = true;
			videoOutput.visible = true;
			if (!carousel) {
				carousel = new Carousel();
			}
			var depth:Number = this.getChildIndex(mcNavigation);
			this.addChildAt(carousel, depth);
			this.onStageResizeHandler(new Event(''));
		}
		
		public function hideReplayWindowAndStart():void {
			//trace ('HIDE AND START');
			dataHolder.bReplayState = false;
			mcReplayButton.visible = false;
			this.removeChild(carousel);
			this.onStageResizeHandler(new Event(''));
			this.replay();
		}
		
		public function showShareWindow($panelID:Number):void {
			if (!shareWindow) {
				shareWindow = new ShareVideoWindow();
			}
			shareWindow.showPanel($panelID);
			mcShareWindowContainer.addChild(shareWindow);
			updateShareWindowSize();
		}
		
		public function hideShareWindow():void {			
			for (var i:int = 0; i < mcShareWindowContainer.numChildren; i++) {				
				mcShareWindowContainer.removeChildAt(i);
			}			
		}
		
		public function updateShareWindowSize():void {
			if (shareWindow) {
				shareWindow.y = (stage.stageHeight - mcShareWindowContainer.height) / 2;
				shareWindow.x = (stage.stageWidth - mcShareWindowContainer.width) / 2;
			}
		}
		
		private function startPreroll():void {			
			dataHolder.bPrerollDone = true;
			if (dataHolder.xMainXml.preroll.video.@active == 'true') {
				dataHolder.sVideoSource = dataHolder.xMainXml.preroll.video.@path;
				this.startPlay();
				return;
			}
			
			if (dataHolder.xMainXml.preroll.image.@active == 'true') {
				videoOutput.visible = false;
				mcAdvImageContainer.loadImage("preroll");
				return
			}
			
		}
		
		private function startPostroll():void {			
			dataHolder.bPostrollDone = true;
			if (dataHolder.xMainXml.postroll.video.@active == 'true') {				
				dataHolder.sVideoSource = dataHolder.xMainXml.postroll.video.@path;
				
				this.startPlay();
				return;
			}
			
			if (dataHolder.xMainXml.postroll.image.@active == 'true') {
				videoOutput.visible = false;
				mcAdvImageContainer.loadImage("postroll");
				return
			}
			
		}
		
		private function startVideo():void {
			dataHolder.bVideoDone = true;
			dataHolder.sVideoSource = dataHolder.xMainXml.file.@path;
			this.startPlay();
		}
		
		private function checkAutoplay():void {
			if (!dataHolder.bAutoPlay) {				
				mcStart.loadImage(dataHolder.xMainXml.file.@image);
				mcStart.visible = true;
			} else {
				selectVideoTrack();
			}			
		}
		
		public function replay():void {
			dataHolder.bVideoDone = false;
			dataHolder.bPrerollDone = false;
			dataHolder.bPostrollDone = false;
			this.selectVideoTrack();
		}
		
		private function checkAdvNodes():void {
			var check = dataHolder.xMainXml.insertChildBefore(<checknode/>, dataHolder.xMainXml.preroll);
			//trace (check);
			if (check == undefined) {
				dataHolder.bPrerollDone = true;
			} else {
				delete dataHolder.xMainXml.checknode;
			}
			
			check = dataHolder.xMainXml.insertChildBefore(<checknode/>, dataHolder.xMainXml.preroll);
			//trace (check);
			if (check == undefined) {
				dataHolder.bPostrollDone = true;
			} else {
				delete dataHolder.xMainXml.checknode;
			}
		}
		
		private function loadLogo():void {
			logo = new Logo(onLogoLoad);
			logo.loadLogo();
		}
		
		private function onLogoLoad():void {
			if (dataHolder.xMainXml.logo.@location == 'progress_bar') {
				mcNavigation.addChild(logo);
				logo.updateSize();
			} else {
				//trace ("ADDCHILD");
				this.addChild(logo);
				logo.updateSize();
			}
		}
		
		public function addVideoClickListener():void {			
			if (advOutput.hasEventListener(MouseEvent.CLICK)) return;
			advOutput.buttonMode = true;
			advOutput.addEventListener(MouseEvent.CLICK, clickVideoHandler, false, 0, true);
		}
		
		public function removeVideoClickListener():void {
			if (!advOutput.hasEventListener(MouseEvent.CLICK)) return;
			advOutput.buttonMode = false;
			advOutput.removeEventListener(MouseEvent.CLICK, clickVideoHandler);
		}
		
		private function clickVideoHandler($event:MouseEvent):void {
			var $url:String;
			var request:URLRequest;
			if (dataHolder.sCurrentVideo == DataHolder.CURRENT_PLAYING_PREROLL) {
				$url = dataHolder.xMainXml.preroll.video.@link;
				//trace(dataHolder.xMainXml.preroll.video.@link);
				request = new URLRequest($url);
			} else if (dataHolder.sCurrentVideo == DataHolder.CURRENT_PLAYING_POSTROLL) {
				$url = dataHolder.xMainXml.postroll.video.@link;
				//trace("postroll link: "+dataHolder.xMainXml.postroll.video.@link);
				request = new URLRequest($url);
			} else {
				return;
			}
			navigateToURL(request);
		}
	}
} 
