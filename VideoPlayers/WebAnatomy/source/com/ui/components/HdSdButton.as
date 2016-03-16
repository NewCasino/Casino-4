package com.ui.components {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;	
	import gs.TweenLite;
	
	public class  HdSdButton extends Sprite {
		
		public function HdSdButton() {
			this.buttonMode = true;
			this.alpha = 0.5;
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
		}
		
		function onRollOverHandler($event:MouseEvent):void {			
			TweenLite.to(this, 0.5, { tint:1 } );
		}
		
		function onRollOutHandler($event:MouseEvent):void {			
			TweenLite.to(this, 0.5, { tint:0.5 } );
		}		
	}
	
}