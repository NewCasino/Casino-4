package com.ui.navigation {
	
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	public class ToggleFullscreenButton extends MovieClip {
		
		public function ToggleFullscreenButton() {
			super();
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			this.buttonMode = true;
		}
		
		private function clickHandler($event:MouseEvent):void {
			if (root.stage.displayState == StageDisplayState.NORMAL) {
				root.stage.displayState = StageDisplayState.FULL_SCREEN;
				this.gotoAndStop("fullscreen");
			} else {
				root.stage.displayState = StageDisplayState.NORMAL;
				this.gotoAndStop("windowed");
			}			
		}
		
		private function keyDownHandler($event:KeyboardEvent):void {
			if ($event.charCode == Keyboard.ESCAPE) {
				this.gotoAndStop("windowed");
			}
		}
	}
	
}