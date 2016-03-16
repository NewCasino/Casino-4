package com.ui.navigation {
	
	import fl.motion.Color;
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import gs.TweenLite;
	
	public class ToggleFullscreenButton extends MovieClip {
		
		public var bIsFull:Boolean = false;
		
		private var uiColorActive:uint;
		private var uiColorNormal:uint;
		
		
		public function ToggleFullscreenButton() {
			super();
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, thisRollOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, thisRollOutHandler);
			this.buttonMode = true;
			this.gotoAndStop("fullscreen");
			bIsFull = false;
		}
		
		private function clickHandler($event:MouseEvent):void {
			if (root.stage.displayState == StageDisplayState.NORMAL) {
				root.stage.displayState = StageDisplayState.FULL_SCREEN;
				this.gotoAndStop("fullscreen");
				bIsFull = true;
			} else {
				root.stage.displayState = StageDisplayState.NORMAL;
				this.gotoAndStop("windowed");
				bIsFull = false;
			}			
		}
		
		private function keyDownHandler($event:KeyboardEvent):void {
			if ($event.charCode == Keyboard.ESCAPE) {
				this.gotoAndStop("windowed");
				bIsFull = false;
			}
		}
		
		public function checkDisplayState():void {			
			if (root.stage.displayState == StageDisplayState.NORMAL || root.stage.displayState == null) {
				this.gotoAndStop("windowed");
				bIsFull = false;
			} else if (root.stage.displayState == StageDisplayState.FULL_SCREEN) {
				this.gotoAndStop("fullscreen");
				bIsFull = true;
			}
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