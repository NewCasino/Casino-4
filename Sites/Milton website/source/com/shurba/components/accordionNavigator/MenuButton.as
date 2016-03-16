package com.shurba.components.accordionNavigator {
	import com.greensock.plugins.*;
	import com.greensock.*;
	import com.shurba.miltonsite.assets.MenuButtonHitState;
	import com.shurba.miltonsite.assets.MenuButtonNormalState;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class MenuButton extends Sprite	{
		
		public const TWEEN_DELAY:Number = 0.5;
		public const SELECTED_TEXT_COLOR:int = 0x000000;
		public const UNSELECTED_TEXT_COLOR:int = 0xFFFFFF;		
		
		public var label:TextField;
		
		public var upState:Sprite;
		public var hitState:Sprite;
		public var overState:Sprite;
		
		
		private var _selected:Boolean = false;
		
		public function MenuButton() {
			super();
			this.init();
		}
		
		protected function init():void {
			//TweenPlugin.activate([TintPlugin]);
			
			label.mouseEnabled = false;
			this.buttonMode = true;
			upState.alpha = 1;
			hitState.alpha = 0;
			overState.alpha = 0;
			
			
			this.addListeners();
		}
		
		private function addListeners():void {
			this.addEventListener(MouseEvent.MOUSE_OVER, thisOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, thisOutHandler, false, 0, true);
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
		
		public function get selected():Boolean { 
			return _selected; 
		}
		
		public function set selected(value:Boolean):void {
			_selected = value;
			if (_selected) {
				label.textColor = SELECTED_TEXT_COLOR;
				TweenLite.to(overState, TWEEN_DELAY, { alpha:0 } );
				TweenLite.to(upState, TWEEN_DELAY, { alpha:0 } );
				TweenLite.to(hitState, TWEEN_DELAY, { alpha:1 } );
			} else {
				label.textColor = UNSELECTED_TEXT_COLOR;
				TweenLite.to(upState, TWEEN_DELAY, { alpha:1 } );
				TweenLite.to(hitState, TWEEN_DELAY, { alpha:0 } );
			}
		}
		
		
	}

}