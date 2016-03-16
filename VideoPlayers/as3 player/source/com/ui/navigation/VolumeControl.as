package com.ui.navigation {
	import com.data.DataHolder;
	import com.ui.navigation.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class VolumeControl extends MovieClip {
		
		public var mcVolumeSlider:VolumeSlider;
		public var mcSoundBtn:MovieClip;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function VolumeControl() {
			super();
			mcVolumeSlider.visible = false;
			mcSoundBtn.addEventListener(MouseEvent.CLICK, soundButtonClickHandler);
			mcSoundBtn.addEventListener(MouseEvent.MOUSE_OVER, soundButtonRollOverHandler);
			mcSoundBtn.buttonMode = true;
		}
		
		private function soundButtonClickHandler($event:MouseEvent):void {
			if (dataHolder.bSoundMuted) {
				setButtonOn();
				mcVolumeSlider.unMute();
			} else {
				setButtonOff();
				mcVolumeSlider.mute();
			}
		}
		
		public function setButtonOn():void {
			dataHolder.bSoundMuted = false;
			mcSoundBtn.gotoAndStop('on');
		}
		
		public function setButtonOff():void {
			dataHolder.bSoundMuted = true;
			mcSoundBtn.gotoAndStop('off');
		}
		
		private function soundButtonRollOverHandler($event:MouseEvent):void {
			mcVolumeSlider.visible = true;
			this.addEventListener(Event.ENTER_FRAME, checkMouseOver);
		}
		
		private function checkMouseOver($event:Event):void {			
			if (this.mouseX > 0 && this.mouseX < this.width && this.mouseY > 0 && this.mouseY < this.height + 50) {
				
			} else if (!mcVolumeSlider.bSoundChanging) {
				mcVolumeSlider.visible = false;
				this.removeEventListener(Event.ENTER_FRAME, checkMouseOver);
			}
		}
	}
}