package com.ui.navigation {
	
	import flash.events.Event;
	import de.popforge.events.SimpleMouseEvent;
	import de.popforge.events.SimpleMouseEventHandler;
	import fl.motion.Color;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import gs.TweenLite;
	
	[Event("hdsd", type = "flash.events.Event")]
	
	public class HdSdButton extends MovieClip {
		
		public var mcSd:MovieClip;
		public var mcHd:MovieClip;
		public var isHd:Boolean = false;
		
		private var uiColorActive:uint;
		private var uiColorNormal:uint;
		
		public function HdSdButton() {
			super();
			this.showSdBtn();	
			mcHd.mouseEnabled = true;
			SimpleMouseEventHandler.register( this );			
			this.addEventListener(SimpleMouseEvent.ROLL_OVER, thisOnRollOver);
			this.addEventListener(SimpleMouseEvent.ROLL_OUT, thisOnRollOut);
			this.addEventListener(MouseEvent.CLICK, thisClickHandler);
			this.addEventListener(SimpleMouseEvent.RELEASE_OUTSIDE, thisOnRollOut);
		}
		
		private function thisClickHandler($event:MouseEvent):void {			
			if (isHd) {
				this.showSdBtn();
			} else {
				this.showHdBtn();
			}
			this.dispatchEvent(new Event("hdsd"));
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
		
		private function updateSkin():void {
			var $colorTransform:ColorTransform = new ColorTransform();
			$colorTransform.color = uiColorNormal;
			this.transform.colorTransform = $colorTransform;
		}
		
		public function showSdBtn():void {
			isHd = false;
			mcHd.visible = false;
			mcSd.visible = true;
		}
		
		public function showHdBtn():void {
			isHd = true;
			mcSd.visible = false;
			mcHd.visible = true;
			
		}
		
	}
}