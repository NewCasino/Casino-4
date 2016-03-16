package com.ui.navigation {
	
	import flash.events.Event;
	import de.popforge.events.SimpleMouseEvent;
	import de.popforge.events.SimpleMouseEventHandler;
	import fl.motion.Color;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import gs.TweenLite;
	
	[Event("play", type = "flash.events.Event")]
	[Event("pause", type = "flash.events.Event")]
	
	public class PlayPauseButton extends MovieClip {
		
		public var mcPlay:MovieClip;
		public var mcPause:MovieClip;
		private var isPause:Boolean = false;
		private var uiColorActive:uint;
		private var uiColorNormal:uint;
		
		public function PlayPauseButton() {
			super();
			mcPause.alpha = 0;
			mcPause.label.mouseEnabled = false;
			mcPause.mouseEnabled = true;
			SimpleMouseEventHandler.register( this );			
			this.addEventListener(SimpleMouseEvent.ROLL_OVER, thisOnRollOver);
			this.addEventListener(SimpleMouseEvent.ROLL_OUT, thisOnRollOut);
			this.addEventListener(MouseEvent.CLICK, thisClickHandler);
			this.addEventListener(SimpleMouseEvent.RELEASE_OUTSIDE, thisOnRollOut);
		}
		
		private function thisClickHandler($event:MouseEvent):void {
			if (!isPause) {
				//trace ("PlayPauseButton: click play");
				this.dispatchEvent(new Event("play"));
			} else {
				//trace ("PlayPauseButton: click pause");
				this.dispatchEvent(new Event("pause"));
			}			
		}
		
		private function thisOnRollOver($event:SimpleMouseEvent):void {
			TweenLite.to(this, 0.5, {tint:uiColorActive});
		}
		
		private function thisOnRollOut($event:SimpleMouseEvent):void {
			TweenLite.to(this, 0.5, {tint:uiColorNormal});
		}
		
		public function set normalColor($color:uint):void {
			uiColorNormal = $color;
			this.updateSkin();
		}
		
		public function set activeColor($color:uint):void {
			uiColorActive = $color;
		}
		
		public function showPlayBtn():void {
			isPause = false;
			TweenLite.to(mcPlay, 0.5, { alpha:1 } );
			TweenLite.to(mcPause, 0.5, { alpha:0 } );
		}
		
		public function showPauseBtn():void {
			isPause = true;
			TweenLite.to(mcPlay, 0.5, { alpha:0 } );
			TweenLite.to(mcPause, 0.5, { alpha:1 } );
		}
		
		private function updateSkin():void {
			var $colorTransform:ColorTransform = new ColorTransform();
			$colorTransform.color = uiColorNormal;
			this.transform.colorTransform = $colorTransform;
		}
		
	}
}