package com.ui.components {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class EmbedButton extends Sprite {
		
		public var txtLabel:TextField;
		
		public function EmbedButton() {
			super();			
			txtLabel.mouseEnabled = false;
		}
		
		public function set label ($text:String):void  {
			txtLabel.text = $text;
		}
		
		public function get label ():String  {
			return txtLabel.text;
		}
	}
	
}