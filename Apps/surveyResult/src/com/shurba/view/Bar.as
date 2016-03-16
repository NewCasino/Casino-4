package com.shurba.view {
	import com.shurba.data.BarVO;
	import flash.display.Shape;
	import flash.display.Sprite;	
	import flash.text.*;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class Bar extends Sprite {
		
		private var _dataProvider:BarVO;
		
		public var description:TextField;
		public var stripe:Shape;
		
		public function Bar() {
			super();
			drawInerface();
		}
		
		protected function drawInerface():void {
			description = new TextField();
			addChild(description);
			var tf:TextFormat = description.getTextFormat();
			tf.align = TextFormatAlign.RIGHT;
			tf.size = 9;
			tf.color = 0xFFFFFF;
			//tf.font = 'Lucida Grande';
			description.defaultTextFormat = tf;			
			//description.embedFonts = true;
			description.width = 177;
			description.height = 17;
			description.multiline = false;
		}
		
		protected function updateInterface():void {
			description.text = _dataProvider.name;
			stripe = new Shape();
			stripe.graphics.beginFill(0xFFFFFF, 1);
			stripe.graphics.moveTo(0, 0);
			stripe.graphics.lineTo(5, 0);
			stripe.graphics.lineTo(5, 10);
			stripe.graphics.lineTo(0, 10);
			stripe.graphics.endFill();
			addChild(stripe);
			stripe.x = 198;
			stripe.y = 4;
		}
		
		public function get dataProvider():BarVO { return _dataProvider; }
		
		public function set dataProvider(value:BarVO):void {
			_dataProvider = value;
			updateInterface();
		}
		
	}

}