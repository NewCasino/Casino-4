package com.ui.navigation {
	
	import de.popforge.events.*;
	import com.ui.navigation.*;
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.events.MouseEvent;

	public class VolumeSlider extends MovieClip {
		
		public var mcSliderStripe:MovieClip;
		public var mcSlider:MovieClip;
		public var mcBackground:MovieClip;
		public var bSoundChanging:Boolean = false;
		
		private const nSliderMaxY:Number = 50;
		private const nSliderMinY:Number = 4;
		private var nVolume:Number = 0.75;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		private var parentControl:VolumeControl;
		
		public function VolumeSlider() {
			super();
			
			SimpleMouseEventHandler.register(mcSliderStripe);
			mcSliderStripe.addEventListener(SimpleMouseEvent.PRESS, thisOnMouseDownHandler);
			this.addEventListener(SimpleMouseEvent.RELEASE, thisOnMouseUpHandler);
			this.addEventListener(SimpleMouseEvent.RELEASE_OUTSIDE, thisOnMouseUpHandler);
			mcSliderStripe.buttonMode = true;
			mcSlider.mouseEnabled = false;
			parentControl = parent as VolumeControl;
		}
		
		public function setDefaultVolume():void {
			dataHolder._stage.videoHandler.videoPlayer.volume = nVolume;
			this.update();
		}
		
		private function thisOnMouseDownHandler($event:SimpleMouseEvent):void {
			this.addEventListener(Event.ENTER_FRAME, moveSlider);
			bSoundChanging = true;
		}
		
		private function thisOnMouseUpHandler($event:SimpleMouseEvent):void {
			if (this.hasEventListener(Event.ENTER_FRAME)) {
				this.removeEventListener(Event.ENTER_FRAME, moveSlider);
				bSoundChanging = false;
			}
		}
		
		private function moveSlider($event:Event):void {
			var nYPos = this.mouseY;
			if (nYPos < nSliderMinY) nYPos = nSliderMinY;
			
			
			if (nYPos > nSliderMaxY) {
				nYPos = nSliderMaxY
				parentControl.setButtonOff();
			} else {
				parentControl.setButtonOn();
			}
			mcSlider.y = nYPos;
			var percent = Math.round(Math.abs((nYPos - nSliderMinY) / (nSliderMaxY - nSliderMinY) - 1) * 100);			
			nVolume = percent / 100;
			trace (nVolume);
			
			dataHolder.nVolume = nVolume;
			dataHolder._stage.videoHandler.videoPlayer.volume = nVolume;
			mcSlider.height = mcSliderStripe.height - mcSlider.y + 5;
		}
		
		public function update():void {
			var percent = dataHolder._stage.videoHandler.videoPlayer.volume;
			var nYPos = mcSliderStripe.height - (mcSliderStripe.height * percent);

			if (nYPos > nSliderMaxY) nYPos = nSliderMaxY;
			if (nYPos < nSliderMinY) nYPos = nSliderMinY;
			
			mcSlider.y = nYPos;
			mcSlider.height = mcSliderStripe.height - mcSlider.y + 5;
		}
		
		public function mute():void {			
			dataHolder.bSoundMuted = true;
			dataHolder.nVolume = 0;
			dataHolder._stage.videoHandler.videoPlayer.volume = 0;
			this.update();
		}
		
		public function unMute():void {
			dataHolder.bSoundMuted = false;
			dataHolder.nVolume = nVolume;
			dataHolder._stage.videoHandler.videoPlayer.volume = nVolume;
			this.update();
		}
	}
}