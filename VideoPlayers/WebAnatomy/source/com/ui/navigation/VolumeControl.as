package com.ui.navigation {
	import com.control.ControlsHolder;
	import com.data.DataHolder;
	import com.ui.navigation.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import gs.TweenLite;
	
	
	[Event("buttonRollOver", type = "flash.events.Event")]
	[Event("buttonRollOut", type = "flash.events.Event")]
	
	public class VolumeControl extends MovieClip {
		
		public var mcVolumeSlider:VolumeSlider;
		public var mcSoundBtn:MovieClip;
		
		private var bSLiderOpen:Boolean = false;
		
		private var uiColorActive:uint;
		private var uiColorNormal:uint;
		
		private var controlsHolder:ControlsHolder = ControlsHolder.getInstance();
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function VolumeControl() {
			super();
			mcVolumeSlider.visible = false;
			mcSoundBtn.addEventListener(MouseEvent.CLICK, soundButtonClickHandler);
			mcSoundBtn.addEventListener(MouseEvent.MOUSE_OVER, soundButtonRollOverHandler);
			mcSoundBtn.addEventListener(MouseEvent.MOUSE_OUT, soundButtonRollOutHandler);
			mcSoundBtn.buttonMode = true;
			controlsHolder.volumeSlider = mcVolumeSlider;
		}
		
		private function soundButtonClickHandler($event:MouseEvent):void {
			if (bSLiderOpen) {
				mcVolumeSlider.hide();
				bSLiderOpen = false;
			} else {
				mcVolumeSlider.show();
				bSLiderOpen = true;
			}			
		}
		
		public function setButtonOn():void {
			dataHolder.bSoundMuted = false;			
		}
		
		public function setButtonOff():void {
			dataHolder.bSoundMuted = true;			
		}
		
		public function set normalColor($color:uint):void {
			uiColorNormal = $color;
			mcVolumeSlider.normalColor = $color;
			this.updateSkin();
		}
		
		public function set activeColor($color:uint):void {
			uiColorActive = $color;
			mcVolumeSlider.activeColor = $color;
		}
		
		private function soundButtonRollOverHandler($event:MouseEvent):void {
			this.dispatchEvent(new Event("buttonRollOver"));
			TweenLite.to(mcSoundBtn, 0.5, {tint:uiColorActive});
			
			//this.addEventListener(Event.ENTER_FRAME, checkMouseOver);
		}
		
		private function soundButtonRollOutHandler($event:MouseEvent):void {
			this.dispatchEvent(new Event("buttonRollOut"));
			TweenLite.to(mcSoundBtn, 0.5, {tint:uiColorNormal});
		}
		
		private function updateSkin():void {
			var $colorTransform:ColorTransform = new ColorTransform();
			$colorTransform.color = uiColorNormal;
			mcSoundBtn.transform.colorTransform = $colorTransform;
		}		
	}
}