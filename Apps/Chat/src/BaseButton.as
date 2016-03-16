package  {
	import com.greensock.*;
	import com.greensock.plugins.*;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class BaseButton extends Sprite {
		
		public const TWEEN_TIME:Number = 0.15;
		public const OVER_TINT:uint = 0xa4a0dC;
		public const DOWN_TINT:uint = 0x2470AC;
		public const TOGGLE_TINT:uint = 0x000000;
		public const TOGGLE_ALPHA:Number = 0.2;
		
		protected var _btnImage:Bitmap;
		
		protected var _toggle:Boolean = false;
		public var toggleMask:Sprite = new Sprite();
		
		
		public function BaseButton() {
			super();
			this.useHandCursor = true;
			this.buttonMode = true;
			
			this.addChild(toggleMask);
			
			this.addListeners();
		}
		
		protected function addListeners():void {
			this.addEventListener(MouseEvent.ROLL_OVER, thisRollOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, thisRollOutHandler, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, toggleThis, false, 0, true);
		}
		
		private function toggleThis(e:MouseEvent):void {
			toggle = !toggle;			
		}
		
		protected function thisRollOutHandler(e:MouseEvent):void {
			TweenMax.to(btnImage, TWEEN_TIME, {colorMatrixFilter:{}});
		}
		
		protected function thisRollOverHandler(e:MouseEvent):void {
			TweenMax.to(btnImage, TWEEN_TIME, {colorMatrixFilter:{colorize:OVER_TINT, amount:0.2}});
		}
		
		public function get btnImage():Bitmap { return _btnImage; }
		
		public function set btnImage(value:Bitmap):void {			
			_btnImage = value;
			toggleMask.graphics.beginFill(TOGGLE_TINT, TOGGLE_ALPHA);
			toggleMask.graphics.drawRoundRect(2, 2, this.width-4, this.height-4, 6, 6);
			toggleMask.graphics.endFill();
			this.setChildIndex(toggleMask, this.numChildren - 1);
			if (!_toggle) {
				toggleMask.alpha = 0;
			}
			//var maskBmp:Bitmap = _btnImage.bitmapData.clone();
			//toggleMask.mask = value;
		}
		
		public function get toggle():Boolean { return _toggle; }
		
		public function set toggle(value:Boolean):void {
			_toggle = value;
			if (_toggle) {
				TweenMax.to(toggleMask, TWEEN_TIME, {alpha:1});
			} else {
				TweenMax.to(toggleMask, TWEEN_TIME, {alpha:0});
			}
		}
	}

}