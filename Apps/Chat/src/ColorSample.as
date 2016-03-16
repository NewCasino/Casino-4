package {
	import flash.display.*;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ColorSample extends Sprite {
		
		public var background:Shape = new Shape();
		public var colorShape:Shape = new Shape();
		
		private var _color:uint = 0x000000;
		
		public function ColorSample() {
			
			this.addChild(background);
			this.addChild(colorShape);
			
			background.graphics.beginFill(0xffffff);
			background.graphics.lineStyle(0, 0xaaaaaa);
			background.graphics.drawRect(0, 0, 22, 22);
			background.graphics.endFill();
			
			this.drawColor();
			
			colorShape.x = 3;
			colorShape.y = 3;
			
			var rect9:Rectangle = new Rectangle(4, 4, 4, 4);
			this.scale9Grid = rect9;
		}
		
		protected function drawColor():void {
			colorShape.graphics.beginFill(_color);
			colorShape.graphics.lineStyle(0, 0xaaaaaa);
			colorShape.graphics.drawRect(0, 0, 16, 16);
			colorShape.graphics.endFill();
		}
		
		public function get color():uint { 
			return _color; 
		}
		
		public function set color(value:uint):void {
			_color = value;
			this.drawColor();
		}
		
	}

}