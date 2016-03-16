package com.shurba.miltonsite.view {
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.greensock.TweenNano;
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
		protected const OVER_MASK_ALPHA:Number = 0.25;
		
		public var label:TextField;
		
		public var upState:Sprite;
		public var hitState:Sprite;
		public var hoverMask:Sprite;
		
		
		private var _selected:Boolean = false;
		
		public function MenuButton() {
			super();
			this.init();
		}
		
		protected function init():void {
			//TweenPlugin.activate([TintPlugin]);
			
			label.mouseEnabled = false;
			this.buttonMode = true;
			upState.visible = true;
			hitState.visible = false;
			
			
			this.addListeners();
		}
		
		private function addListeners():void {
			this.addEventListener(MouseEvent.MOUSE_OVER, thisOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, thisOutHandler, false, 0, true);
			//this.addEventListener(MouseEvent.CLICK, thisClickHandler, false, 0, true);
		}
		
		private function thisOutHandler(e:MouseEvent):void {
			if (_selected) {
				return;
			}
			
			TweenLite.to(hoverMask, 0.25, { alpha:0 } );
		}
		
		private function thisClickHandler(e:MouseEvent):void {
			
		}
		
		private function thisOverHandler(e:MouseEvent):void {
			if (_selected) {
				return;
			}
			
			TweenLite.to(hoverMask, 0.25, { alpha:OVER_MASK_ALPHA } );
		}
		
		public function get selected():Boolean { 
			return _selected; 
		}
		
		public function set selected(value:Boolean):void {
			_selected = value;
		}
		
		
	}

}