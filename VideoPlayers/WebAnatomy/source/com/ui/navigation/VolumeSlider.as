package com.ui.navigation {
	
	import de.popforge.events.*;
	import com.ui.navigation.*;
	import com.data.DataHolder;
	import fl.motion.Color;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.MouseEvent;
	import gs.easing.Bounce;
	import gs.TweenLite;
	import com.events.VolumeSliderEvent;
	
	[Event("volumeChange", type = "com.events.VolumeSliderEvent")]
	
	public class VolumeSlider extends MovieClip {
		
		public var mcSliderStripe:MovieClip;
		public var mcSlider:MovieClip;
		public var mcMask:Sprite;
		public var mcSliderTopStripe:Sprite;
		public var mcSliderBottomStripe:Sprite;
		public var mcBorder:Sprite;
		
		public var mcBackground:MovieClip;
		public var bSoundChanging:Boolean = false;
		
		private const nSliderMaxY:Number = 114;
		private const nSliderMinY:Number = 6;
		private var nVolume:Number = 0.75;
		
		private var uiColorActive:uint;
		private var uiColorNormal:uint;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		private var parentControl:VolumeControl;
		
		public function VolumeSlider() {
			super();
			mcSliderStripe.alpha = 0.5;
			SimpleMouseEventHandler.register(mcSlider);
			mcSlider.addEventListener(SimpleMouseEvent.PRESS, thisOnMouseDownHandler);
			mcSlider.addEventListener(SimpleMouseEvent.RELEASE, thisOnMouseUpHandler);
			mcSlider.addEventListener(SimpleMouseEvent.RELEASE_OUTSIDE, thisOnMouseUpHandler);
			//this.stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
			mcSliderStripe.buttonMode = false;
			mcSlider.buttonMode = true;
			mcSlider.mouseEnabled = true;
			parentControl = parent as VolumeControl;
		}
		
		public function setDefaultVolume():void {
			//dataHolder._stage.videoHandler.videoPlayer.volume = nVolume;
			this.update();
		}
		
		private function thisOnMouseDownHandler($event:SimpleMouseEvent):void {
			this.addEventListener(Event.ENTER_FRAME, moveSlider);
			bSoundChanging = true;
		}
		
		private function thisOnMouseUpHandler($event:SimpleMouseEvent):void {
			if (this.hasEventListener(Event.ENTER_FRAME)) {
				this.removeEventListener(Event.ENTER_FRAME, moveSlider);
				
				//TweenLite.to(mc, 0.5, {x:46, y:43, ease:Bounce.easeOut});
				//TweenLite.to (mcMask.height = mcSliderStripe.height - mcSlider.y + 5;
				TweenLite.to(mcMask, 0.5, { height:mcSliderStripe.height * nVolume, ease:Bounce.easeOut } );
				bSoundChanging = false;
			}
		}
		
		private function moveSlider($event:Event):void {
			var nYPos = this.mouseY;
			if (nYPos < nSliderMinY) nYPos = nSliderMinY;
			
			
			if (nYPos > nSliderMaxY) {
				nYPos = nSliderMaxY
				//parentControl.setButtonOff();
			} else {
				//parentControl.setButtonOn();
			}
			
			mcSlider.y = nYPos;
			var percent = Math.round(Math.abs((nYPos - nSliderMinY) / (nSliderMaxY - nSliderMinY) - 1) * 100);			
			nVolume = percent / 100;
			//trace (nVolume);
			
			this.dispatchVolumeEvent();
		}
		
		private function dispatchVolumeEvent():void {
			var $event:VolumeSliderEvent = new VolumeSliderEvent(VolumeSliderEvent.VOLUME_CHANGE);
			$event.volume = nVolume
			this.dispatchEvent($event);
		}
		
		public function update():void {
			var percent //= dataHolder._stage.videoHandler.videoPlayer.volume;
			var nYPos = mcSliderStripe.height - (mcSliderStripe.height * percent);

			if (nYPos > nSliderMaxY) nYPos = nSliderMaxY;
			if (nYPos < nSliderMinY) nYPos = nSliderMinY;
			
			mcSlider.y = nYPos;
			//mcSlider.height = mcSliderStripe.height - mcSlider.y + 5;
		}
		
		public function mute():void {			
			//dataHolder.bSoundMuted = true;
			//dataHolder.nVolume = 0;
			//dataHolder._stage.videoHandler.videoPlayer.volume = 0;
			this.update();
		}
		
		public function unMute():void {
			//dataHolder.bSoundMuted = false;
			//dataHolder.nVolume = nVolume;
			//dataHolder._stage.videoHandler.videoPlayer.volume = nVolume;
			this.update();
		}
		
		public function show():void {
			this.visible = true;
			this.alpha = 0;
			TweenLite.to(this, 0.5, { alpha:1 } );
			
		}
		
		private function stageClickHandler($event:MouseEvent):void {
			trace (this.visible);
			if (this.visible) this.hide();
		}
		
		public function hide():void {
			this.visible = false;			
		}
		
		public function set normalColor($color:uint):void {
			uiColorNormal = $color;
			this.updateSkin();
		}
		
		public function set activeColor($color:uint):void {
			uiColorActive = $color;
		}
		
		public function updateSkin():void {
			var $skinColor:Color = new Color();
			$skinColor.setTint(uiColorActive, 1);
			mcSliderBottomStripe.transform.colorTransform = $skinColor;
		}
	}
}