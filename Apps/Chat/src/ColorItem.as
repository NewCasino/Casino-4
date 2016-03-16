package {
	import vo.ColorVO;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ColorItem extends Sprite {
		
		private const OVER_BORDER_COLOR:uint = 0;
		private const OUT_BORDER_COLOR:uint = 0xffffff;
		
		public static var DEFAULT_WIDTH:int = 15;
		public static var DEFAULT_HEIGHT:int = 15;
		
		private var _color:uint;
		
		private var _dataProvider:ColorVO;
		
		public var colorSprite:Sprite;
		
		public function ColorItem() {
			colorSprite = new Sprite();
			this.addChild(colorSprite);
			this.buttonMode = true;
			this.addListeners();
		}
		
		private function addListeners():void {
			this.addEventListener(MouseEvent.MOUSE_OVER, thisMouseOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, thisMouseOutHandler, false, 0, true);
		}
		
		private function removeListeners():void {
			this.removeEventListener(MouseEvent.MOUSE_OVER, thisMouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, thisMouseOutHandler);
		}
		
		private function thisMouseOutHandler(e:MouseEvent):void {
			colorSprite.graphics.clear();
			colorSprite.graphics.lineStyle(1, OUT_BORDER_COLOR);
			colorSprite.graphics.beginFill(_dataProvider.hexColor);
			colorSprite.graphics.drawRect(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT);
			colorSprite.graphics.endFill();
		}
		
		private function thisMouseOverHandler(e:MouseEvent):void {
			colorSprite.graphics.clear();
			colorSprite.graphics.lineStyle(1, OVER_BORDER_COLOR);
			colorSprite.graphics.beginFill(_dataProvider.hexColor);
			colorSprite.graphics.drawRect(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT);
			colorSprite.graphics.endFill();
		}
		
		protected function drawColor():void {			
			colorSprite.graphics.clear();
			colorSprite.graphics.lineStyle(1, OUT_BORDER_COLOR);
			colorSprite.graphics.beginFill(_dataProvider.hexColor);
			colorSprite.graphics.drawRect(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT);
			colorSprite.graphics.endFill();
		}
		
		public function get color():uint { 
			return _color; 
		}
		
		public function set color(value:uint):void {
			_color = value;
		}
		
		public function get dataProvider():ColorVO { 
			return _dataProvider;
		}
		
		public function set dataProvider(value:ColorVO):void {
			_dataProvider = value;
			this.drawColor();
		}
		
	}

}