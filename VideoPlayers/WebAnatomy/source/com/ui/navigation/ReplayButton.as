package com.ui.navigation {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gs.TweenLite;
	
	public class  ReplayButton extends Sprite {
		
		public var txtLabel:TextField;
		
		
		public function ReplayButton() {
			this.buttonMode = true;
			this.alpha = 0.5;
			txtLabel.mouseEnabled = false;
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
		}
		
		function onRollOverHandler($event:MouseEvent):void {			
			TweenLite.to(this, 0.5, { alpha:1 } );
		}
		
		function onRollOutHandler($event:MouseEvent):void {			
			TweenLite.to(this, 0.5, { alpha:0.5 } );
		}
		
		public function set label($text:String):void  {
			txtLabel.text = $text;
		}
		
		public function get label():String  {
			return txtLabel.text;
		}
	}
	
}