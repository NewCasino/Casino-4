package com.ui.navigation {	
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import com.data.DataHolder;
	import com.control.ControlsHolder;
	import com.ui.navigation.ShareVideoControl;
	import de.popforge.events.SimpleMouseEvent;
	import de.popforge.events.SimpleMouseEventHandler;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.ui.components.TooltipBaloon;
	

	public class NavigationPanel extends MovieClip {
		
		public var mcVolumeControl:VolumeControl;
		public var mcShareControl:ShareVideoControl;
		public var mcPlayPause:PlayPauseButton;
		public var mcLogoContainer:MovieClip;		
		public var mcProgressBar:ProgressBar;
		public var mcToggleFullscreen:ToggleFullscreenButton;
		public var mcOriginalVideoSize:ToggleOriginalVideoSize;
		public var mcNavBackground:Sprite;
		public var mcHdSd:HdSdButton;
		public var mcMenu:MenuButton;
		public var mcToolTip:TooltipBaloon;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();		
		private var controlsHolder:ControlsHolder = ControlsHolder.getInstance();
		
		private const HEIGHT:int = 47;
		private const WIDTH:int = 500;
		
		public function NavigationPanel() {
			super();
			controlsHolder.playPauseButton = mcPlayPause;
			controlsHolder.progressBar = mcProgressBar;
			controlsHolder.fullScreenButton = mcToggleFullscreen;
			controlsHolder.btnOriginalVideoSize = mcOriginalVideoSize;
			controlsHolder.shareControl = mcShareControl;
			controlsHolder.hdSd = mcHdSd;
			controlsHolder.menuButton = mcMenu;
			controlsHolder.navigation = this;
			mcToolTip.alpha = 0;
			this.updateSkin();
			this.addListeners();
		}
		
		public function onPlayPauseClickHandler($event:MouseEvent):void {
			/*
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
			*/
		}
		
		private function addListeners():void {
			mcVolumeControl.addEventListener("buttonRollOver", onSoundRollOver);
			mcPlayPause.addEventListener(MouseEvent.MOUSE_OVER, rollOverHandler);
			mcToggleFullscreen.addEventListener(MouseEvent.MOUSE_OVER, rollOverHandler);
			mcOriginalVideoSize.addEventListener(MouseEvent.MOUSE_OVER, rollOverHandler);
			mcHdSd.addEventListener(MouseEvent.MOUSE_OVER, rollOverHandler);
			mcMenu.addEventListener(MouseEvent.MOUSE_OVER, rollOverHandler);
			
			mcVolumeControl.addEventListener("buttonRollOut", onSoundRollOut);
			mcPlayPause.addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
			mcToggleFullscreen.addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
			mcOriginalVideoSize.addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
			mcHdSd.addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
			mcMenu.addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
		}
		
		public function updateSize():void {
			mcNavBackground.width = dataHolder.nStageWidth;
			this.y = dataHolder.nStageHeight - this.mcNavBackground.height;
			mcVolumeControl.x = dataHolder.nStageWidth - 82;
			mcToggleFullscreen.x = dataHolder.nStageWidth - 111;
			mcOriginalVideoSize.x = dataHolder.nStageWidth - 130;
			mcShareControl.x = (dataHolder.nStageWidth - mcShareControl.width) / 2;
			mcMenu.x = dataHolder.nStageWidth - 52;
			mcToggleFullscreen.checkDisplayState();
		}
		
		public function rollOutHandler($event:MouseEvent):void {
			this.hideToolTip();
		}
		
		private function onSoundRollOver($event:Event):void {
			var data:Object = new Object();
			data.stageWidth = dataHolder.nStageWidth;
			data.x = $event.currentTarget.x;
			data.y = $event.currentTarget.y;
			data.message = dataHolder.xMainXml.tooltips.sound;
			this.showToolTip(data);
		}
		
		private function onSoundRollOut($event:Event):void {
			this.hideToolTip();
		}
		
		private function rollOverHandler($event:MouseEvent):void {			
			var data:Object = new Object();			
			data.stageWidth = dataHolder.nStageWidth;
			switch ($event.currentTarget) {
				case mcPlayPause : {
					data.x = $event.currentTarget.x;
					data.y = $event.currentTarget.y;
					data.message = dataHolder.xMainXml.tooltips.playPause;
					this.showToolTip(data);
					break;
				}
				
				case mcToggleFullscreen : {
					data.x = $event.currentTarget.x;
					data.y = $event.currentTarget.y;
					if (!mcToggleFullscreen.bIsFull) {
						data.message = dataHolder.xMainXml.tooltips.fullscreen;
					} else {
						data.message = dataHolder.xMainXml.tooltips.windowed;
					}
					
					this.showToolTip(data);
					break;
				}
				
				case mcOriginalVideoSize : {
					data.x = $event.currentTarget.x;
					data.y = $event.currentTarget.y;
					if (!mcOriginalVideoSize.bIsOriginal) {
						data.message = dataHolder.xMainXml.tooltips.origSize;
					} else {
						data.message = dataHolder.xMainXml.tooltips.maxSize;
					}
					this.showToolTip(data);
					break;
				}
				
				case mcHdSd : {
					data.x = $event.currentTarget.x;
					data.y = $event.currentTarget.y;
					if (!mcHdSd.isHd) {
						data.message = dataHolder.xMainXml.tooltips.hdMode;
					} else {
						data.message = dataHolder.xMainXml.tooltips.sdMode;
					}
					this.showToolTip(data);
					break;
				}
				
				case mcMenu : {
					data.x = $event.currentTarget.x;
					data.y = $event.currentTarget.y;
					data.message = dataHolder.xMainXml.tooltips.menu;					
					/*
					if (!mcHdSd.isHd) {
						
					} else {
						data.message = dataHolder.xMainXml.tooltips.sdMode;
					}
					*/
					this.showToolTip(data);
					break;
				}
			}
		}
		
		public function showToolTip($data:Object):void {
			//trace ($data.message);
			mcToolTip.show($data);
		}	
		
		public function hideToolTip():void {
			mcToolTip.hide();
		}
		
		public function updateSkin():void {
			controlsHolder.clear(mcNavBackground);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(stage.stageWidth, this.HEIGHT, (Math.PI / 180) * 90, 0, 00);
			var shapeGradient:Sprite = new Sprite();
			shapeGradient.graphics.beginGradientFill(GradientType.LINEAR, dataHolder.aColors, dataHolder.aAlphas, dataHolder.aRatios, matrix);
			shapeGradient.graphics.drawRect( 0, 0, stage.stageWidth, this.HEIGHT);
			shapeGradient.graphics.endFill();
			mcNavBackground.addChild(shapeGradient);
			
			mcPlayPause.activeColor = dataHolder.fontColorActive;
			mcPlayPause.normalColor = dataHolder.fontColorNormal;
			
			mcHdSd.activeColor = dataHolder.fontColorActive;
			mcHdSd.normalColor = dataHolder.fontColorNormal;
			
			mcVolumeControl.activeColor = dataHolder.fontColorActive;
			mcVolumeControl.normalColor = dataHolder.fontColorNormal;
			
			mcMenu.activeColor = dataHolder.fontColorActive;
			mcMenu.normalColor = dataHolder.fontColorNormal;
			
			mcToggleFullscreen.activeColor = dataHolder.fontColorActive;
			mcToggleFullscreen.normalColor = dataHolder.fontColorNormal;
			
			mcOriginalVideoSize.activeColor = dataHolder.fontColorActive;
			mcOriginalVideoSize.normalColor = dataHolder.fontColorNormal;
			
			mcShareControl.activeColor = dataHolder.fontColorActive;
			mcShareControl.normalColor = dataHolder.fontColorNormal;
		}
	}
}