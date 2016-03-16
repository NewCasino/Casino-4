package com.shurba.miltonsite.view {
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class TextButton extends Sprite {
		
		public var txtLabel:TextField;		
		
		public function TextButton() {
			super();
			txtLabel.mouseEnabled = false;
			txtLabel.selectable = false;
			this.buttonMode = true;
		}
		
		public function get label():String { 
			return txtLabel.text; 
		}
		
		public function set label(value:String):void {
			txtLabel.text = value;
		}
		
	}

}