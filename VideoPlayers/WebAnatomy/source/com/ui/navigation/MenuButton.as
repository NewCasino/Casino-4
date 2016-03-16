package com.ui.navigation {
	
	import flash.events.Event;
	import de.popforge.events.SimpleMouseEvent;
	import de.popforge.events.SimpleMouseEventHandler;
	import fl.motion.Color;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import gs.TweenLite;
	
	[Event("click", type = "flash.events.Event")]
	
	public class MenuButton extends MovieClip {
		
		public var txtLabel:TextField
		
		private var uiColorActive:uint;
		private var uiColorNormal:uint;
		
		public function MenuButton() {
			super();
			this.buttonMode = true;
			txtLabel.mouseEnabled = false;
			SimpleMouseEventHandler.register( this );			
			this.addEventListener(SimpleMouseEvent.ROLL_OVER, thisOnRollOver);
			this.addEventListener(SimpleMouseEvent.ROLL_OUT, thisOnRollOut);			
			this.addEventListener(SimpleMouseEvent.RELEASE_OUTSIDE, thisOnRollOut);
		}
		
		private function thisOnRollOver($event:SimpleMouseEvent):void {
			TweenLite.to(this, 0.5, {tint:uiColorActive});
		}
		
		private function thisOnRollOut($event:SimpleMouseEvent):void {
			TweenLite.to(this, 0.5, {tint:uiColorNormal});
		}
		
		public function set label ($text:String):void  {
			txtLabel.text = $text;
		}
		
		public function get label ():String  {
			return txtLabel.text;
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