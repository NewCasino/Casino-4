package com.shurba.miltonsite.view {
	import com.greensock.plugins.*;
	import com.greensock.*;
	import com.shurba.miltonsite.assets.MenuButtonHitState;
	import com.shurba.miltonsite.assets.MenuButtonNormalState;
	import flash.display.Sprite;
	import flash.events.MouseEvent;	
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class HorisontalCloseButton extends Sprite {
		
		public const TWEEN_DELAY:Number = 0.5;
		
		public var upState:Sprite;
		public var hitState:Sprite;
		public var overState:Sprite;
		
		public function HorisontalCloseButton() {
			super();		
			this.init();
		}
		
		protected function init():void {		
			this.buttonMode = true;
			upState.alpha = 1;
			hitState.alpha = 0;
			overState.alpha = 0;
			
			this.addListeners();
		}
		
		private function addListeners():void {
			this.addEventListener(MouseEvent.MOUSE_OVER, thisOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, thisOutHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, thisMouseDownHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, thisMouseUpHandler, false, 0, true);
		}
		
		private function thisMouseUpHandler(e:MouseEvent):void {
			
		}
		
		private function thisMouseDownHandler(e:MouseEvent):void {
			
		}
		
		private function thisOutHandler(e:MouseEvent):void {
			if (_selected) {
				return;
			}
			
			TweenLite.to(overState, TWEEN_DELAY, { alpha:0 } );
			TweenLite.to(upState, TWEEN_DELAY, { alpha:1 } );
		}
		
		private function thisClickHandler(e:MouseEvent):void {
			
		}
		
		private function thisOverHandler(e:MouseEvent):void {
			if (_selected) {
				return;
			}
			
			TweenLite.to(overState, TWEEN_DELAY, { alpha:1 } );
			TweenLite.to(upState, TWEEN_DELAY, { alpha:0 } );
		}
	}

}