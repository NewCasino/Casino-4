package com.shurba.shopsite.view.component {
	import flash.display.Sprite;
	import flash.text.*;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ButtonLabel extends Sprite	{		
		
		public var labelText:TextField;
		private var _label:String;
		
		public function ButtonLabel() {
			super();
			labelText.autoSize = TextFieldAutoSize.LEFT;
			labelText.condenseWhite = true;
			var tf:TextFormat = new TextFormat();
			tf.letterSpacing = 0;
			labelText.defaultTextFormat = tf;
		}
		
		public function get label():String { 
			return _label; 
		}
		
		public function set label(value:String):void {
			_label = value;
			labelText.htmlText = _label;
		}
		
	}

}