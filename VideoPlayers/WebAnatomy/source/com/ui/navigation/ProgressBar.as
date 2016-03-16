package com.ui.navigation {
	
	import com.data.DataHolder;
	import de.popforge.events.SimpleMouseEvent;
	import de.popforge.events.SimpleMouseEventHandler;
	import fl.motion.Color;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import com.events.ProgressBarEvent;
	
	[Event("dragSlider", type = "com.events.ProgressBarEvent")]
	
	public class ProgressBar extends MovieClip {
		
		public var mcBorder:MovieClip;
		public var mcBlackBar:MovieClip;
		public var mcLoadProgress:MovieClip;
		public var mcProgressBack:MovieClip;
		public var mcProgressLine:MovieClip;
		public var mcMask:MovieClip;
		public var mcSlider:MovieClip;
		public var mcHitSpace:MovieClip;
		public var txtCurrent:TextField;
		public var txtTotal:TextField;
		
		public var sliderEnabled:Boolean = true;
		private var bDraging:Boolean = false;
		
		private var nGapForText:Number = 56;
		private var nMinXPos:Number = 56;
		private var nMaxXPos:Number = 0;		
		private var nTrackWidth:Number = 0;
		private var nSliderWidth:Number = 0;		
		private var thisWidth:Number = 0;
		private var nCurTime:Number = 0;
		
		
		
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function ProgressBar() {
			super();
			SimpleMouseEventHandler.register(mcHitSpace);
			SimpleMouseEventHandler.register(mcSlider);
			mcSlider.addEventListener(SimpleMouseEvent.PRESS, thisMouseDownHandler);
			mcSlider.addEventListener(SimpleMouseEvent.RELEASE, thisMouseUpHandler);
			mcSlider.addEventListener(SimpleMouseEvent.RELEASE_OUTSIDE, thisMouseUpHandler);
			mcHitSpace.addEventListener(SimpleMouseEvent.PRESS, thisMouseDownHandler);
			mcHitSpace.addEventListener(SimpleMouseEvent.RELEASE, thisMouseUpHandler);
			mcHitSpace.addEventListener(SimpleMouseEvent.RELEASE_OUTSIDE, thisMouseUpHandler);
			nSliderWidth = mcSlider.width;
			this.buttonMode = true;
			mcSlider.mouseEnabled = false;
			txtCurrent.mouseEnabled = false;
			txtTotal.mouseEnabled = false;
			mcLoadProgress.width = 0;
			mcSlider.x = nMinXPos;
			this.trackProgress(0);
			this.updateSkin();
			//this.setWidth(stage.stageWidth)
		}
		
		public function setWidth($width:Number):void {
			thisWidth = $width;
			$width -= nGapForText;
			txtTotal.x = $width + 10;
			nMaxXPos = $width;
			$width -= nGapForText;
			//txtCurrent.x = nGapForText;
			//trace (" @#$#@$@$@#$@#   "+(thisWidth - $width) / 2);
			mcProgressBack.x = nGapForText;
			mcLoadProgress.x = nGapForText;
			mcMask.x = nGapForText;
			mcHitSpace.x = nGapForText;
			
			mcProgressBack.width = $width;			
			nTrackWidth = $width;
			mcMask.width = $width;			
			mcHitSpace.width = $width;
			this.trackProgress(nCurTime);
		}
		
		private function thisMouseDownHandler($event:SimpleMouseEvent):void {
			if (!sliderEnabled) {
				return;
			}
			
			bDraging = true;
			mcSlider.alpha = 0.5;
			mcSlider.addEventListener(Event.ENTER_FRAME, dragSlider);
			//dataHolder.bSeek = true;
		}
		
		private function thisMouseUpHandler($event:SimpleMouseEvent):void {
			if (mcSlider.hasEventListener(Event.ENTER_FRAME)) {
				mcSlider.removeEventListener(Event.ENTER_FRAME, dragSlider);
			}
			
			bDraging = false;
			mcSlider.alpha = 1;
			this.trackProgressLine();
			if (!sliderEnabled) {
				return;
			}				
		}
		
		private function dragSlider($event:Event):void {		
			var nXPos:Number = this.mouseX;
			if (nXPos < nMinXPos) nXPos = nMinXPos;			
			if (nXPos > nMaxXPos) nXPos = nMaxXPos;			
			mcSlider.x = Math.round(nXPos);
			//mcProgressLine.width =  mcSlider.x + nSliderWidth / 2 - nMinXPos;
			this.dispatchDragSliderEvent();			
		}
		
		private function dispatchDragSliderEvent():void {
			var $event:ProgressBarEvent = new ProgressBarEvent(ProgressBarEvent.DRAG_SLIDER);
			var nPercent:Number = (this.mouseX - nMinXPos) / this.nTrackWidth;			
			if (nPercent < 0) nPercent = 0;
			if (nPercent > 1) nPercent = 1;
			$event.percent = nPercent;
			this.dispatchEvent($event);
		}
		
		public function trackLoadedVideo($nPercent:Number):void {
			mcLoadProgress.width = (nMaxXPos - nSliderWidth / 2) * $nPercent + nSliderWidth + nSliderWidth / 2;
		}
		
		public function trackProgress($time:Number):void {
			if (bDraging) return;
			if (isNaN($time)) {
				$time = 0;
			}
			nCurTime = $time;
			this.trackSlider();
			this.trackProgressLine();			
			txtCurrent.text = DataHolder.secondsToTime(Math.round($time * dataHolder.nVideoDuration));
			txtTotal.text = DataHolder.secondsToTime(dataHolder.nVideoDuration);
		}
		
		
		private function trackSlider():void {
			var nPlayTimePerc:Number = nCurTime;
			mcSlider.x = nPlayTimePerc * nTrackWidth + nMinXPos;
		}
		
		private function trackProgressLine():void {			
			mcProgressLine.width = mcSlider.x + nSliderWidth / 2 - nMinXPos;
		}
		
		public function updateSkin():void {
			var $skinColor:Color = new Color();			
			$skinColor.setTint(dataHolder.fontColorActive, 1);			
			mcSlider.mcSliderGradient.transform.colorTransform = $skinColor;
			mcProgressLine.transform.colorTransform = $skinColor;
			txtTotal.textColor = dataHolder.fontColorNormal;
			txtCurrent.textColor = dataHolder.fontColorNormal;
		}
		
	}
	
}