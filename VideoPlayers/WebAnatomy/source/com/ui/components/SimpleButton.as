package com.ui.components {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;	
	import gs.TweenLite;
	
	public class  SimpleButton extends Sprite {
		
		public function SimpleButton() {
			this.buttonMode = true;
			this.alpha = 0.5;
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
		}
		
		function onRollOverHandler($event:MouseEvent):void {			
			TweenLite.to(this, 0.5, { alpha:1 } );
		}
		
		function onRollOutHandler($event:MouseEvent):void {			
			TweenLite.to(this, 0.5, { alpha:0.5 } );
		}		
	}
	
}