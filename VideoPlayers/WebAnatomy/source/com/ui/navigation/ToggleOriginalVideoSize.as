package com.ui.navigation {
	
	import fl.motion.Color;
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import gs.TweenLite;
	
	public class ToggleOriginalVideoSize extends MovieClip {
		
		public var bIsOriginal:Boolean = false;
		
		private var uiColorActive:uint;
		private var uiColorNormal:uint;
		
		public function ToggleOriginalVideoSize() {
			super();
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, thisRollOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, thisRollOutHandler);
			this.buttonMode = true;
			this.changeIcon();
		}
		
		private function clickHandler($event:MouseEvent):void {			
			if (bIsOriginal) {
				bIsOriginal = false;
			} else {
				bIsOriginal = true;
			}
			this.changeIcon();
		}
		
		private function changeIcon():void {
			if (bIsOriginal) {
				this.gotoAndStop("fullscreen");
			} else {
				this.gotoAndStop("windowed");
			}
		}
		
		private function keyDownHandler($event:KeyboardEvent):void {
			if ($event.charCode == Keyboard.ESCAPE) {
				this.gotoAndStop("windowed");
			}
		}
		
		public function set original($value:Boolean):void {
			bIsOriginal = $value;
			this.changeIcon();
		}
		
		public function get original():Boolean {
			return bIsOriginal;
			
		}
		
		private function thisRollOverHandler($event:MouseEvent):void {			
			TweenLite.to(this, 0.5, {tint:uiColorActive});
		}
		
		private function thisRollOutHandler($event:MouseEvent):void {
			TweenLite.to(this, 0.5, {tint:uiColorNormal});
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
			$skinColor.setTint(uiColorNormal, 1);
			this.transform.colorTransform = $skinColor;
		}
	}
	
}