package com.ui.navigation {
	
	import com.data.DataHolder;
	import de.popforge.events.SimpleMouseEvent;
	import de.popforge.events.SimpleMouseEventHandler;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ProgressBar extends MovieClip {
		
		public var mcBorder:MovieClip;
		public var mcBlackBar:MovieClip;
		public var mcLoadProgress:MovieClip;
		public var mcProgressBack:MovieClip;
		public var mcProgressShadow:MovieClip;
		public var mcMask:MovieClip;
		public var mcSlider:MovieClip;
		public var txtCurrent:TextField;
		public var txtTotal:TextField;
		
		private var nMinXPos:Number = 0;
		private var nMaxXPos:Number = 0;		
		public var currentWidth:Number;
		private var nSliderWidth:Number;
		public var mcHitSpace:MovieClip;
		public var thisWidth;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function ProgressBar() {
			super();
			SimpleMouseEventHandler.register(mcHitSpace);			
			mcHitSpace.addEventListener(SimpleMouseEvent.PRESS, thisMouseDownHandler);
			mcHitSpace.addEventListener(SimpleMouseEvent.RELEASE, thisMouseUpHandler);			
			mcHitSpace.addEventListener(SimpleMouseEvent.RELEASE_OUTSIDE, thisMouseUpHandler);			
			nSliderWidth = mcSlider.width;
			this.buttonMode = true;
			mcSlider.mouseEnabled = false;
			this.trackProgress(0);
		}
		
		public function setWidth($width:Number):void {
			thisWidth = $width;
			$width -= nSliderWidth;
			//mask
			mcMask.center.x = 5;
			mcMask.center.width = $width - 15;
			mcMask.right.x = $width - 5;
			
			//border
			mcBorder.center.x = 5;
			mcBorder.center.width = $width - 15;
			mcBorder.right.x = $width - 5;
			
			mcProgressShadow.width = $width;
			mcBlackBar.width = $width;
			currentWidth = $width;
			
			nMaxXPos = $width;
			txtTotal.x = this.currentWidth - txtTotal.width - 20;
			mcHitSpace .width = $width;
			
			if (dataHolder.bReplayState) {
				this.trackProgress(dataHolder.nVideoDuration);
			}
		}
		
		private function thisMouseDownHandler($event:SimpleMouseEvent):void {
			if (!checkEnabled()) {
				return;
			}
			mcSlider.addEventListener(Event.ENTER_FRAME, dragSlider);
			dataHolder.bSeek = true;
		}
		
		private function thisMouseUpHandler($event:SimpleMouseEvent):void {
			if (mcSlider.hasEventListener(Event.ENTER_FRAME)) {
				mcSlider.removeEventListener(Event.ENTER_FRAME, dragSlider);
			}
			
			if (!checkEnabled()) {
				return;
			}
			var nPercent:Number = this.mouseX / this.currentWidth;
			if (nPercent < 0) nPercent = 0;
			if (nPercent > 1) nPercent = 1;
			dataHolder._stage.videoHandler.videoPlayer.seek(nPercent);			
			dataHolder.bSeek = false;			
		}
		
		private function checkEnabled():Boolean {
			var bPreroll:Boolean = dataHolder.sCurrentVideo == DataHolder.CURRENT_PLAYING_PREROLL;
			var bPostroll:Boolean = dataHolder.sCurrentVideo == DataHolder.CURRENT_PLAYING_POSTROLL;
			var bHasListener:Boolean = mcSlider.hasEventListener(Event.ENTER_FRAME);
			if ( bPreroll || bPostroll || bHasListener) {
				return false;
			}
			return true;
		}
		
		private function dragSlider($event:Event):void {		
			var nXPos:Number = this.mouseX - nSliderWidth / 2;
			if (nXPos < 0) nXPos = 0;			
			if (nXPos > (this.currentWidth - nSliderWidth)) nXPos = this.currentWidth - nSliderWidth;			
			mcSlider.x = Math.round(nXPos);
			mcProgressBack.width = mcSlider.x + nSliderWidth / 2;
			txtCurrent.text = dataHolder.xMainXml.buttonsname.seeking.@value;			
		}
		
		public function trackLoadedVideo($nPercent:Number):void {
			mcLoadProgress.width = (nMaxXPos - nSliderWidth / 2) * $nPercent + nSliderWidth + nSliderWidth / 2;
		}
		
		public function trackProgress($time:Number):void {
			if ($time > dataHolder.nVideoDuration) $time = dataHolder.nVideoDuration;
			var nPlayTimePerc:Number = $time / dataHolder.nVideoDuration;
			//trace ($time+"   "+dataHolder.nVideoDuration);
			mcSlider.x = (this.currentWidth - nSliderWidth) * nPlayTimePerc; //* (nMaxXPos - nSliderWidth);
			mcProgressBack.width = mcSlider.x + nSliderWidth / 2;
			txtCurrent.text = dataHolder.secondsToTime($time);
			txtTotal.text = dataHolder.secondsToTime(dataHolder.nVideoDuration);
		}
	}
	
}