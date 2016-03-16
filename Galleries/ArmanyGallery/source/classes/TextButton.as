package classes {
	import classes.GalleryButton;
	import flash.text.*;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class TextButton extends GalleryButton {
		
		private var _label:String;
		
		private var textLabel:TextField;
		private var myFont:Font = new Font1();
		
		public function TextButton() {
			super();
			var tf:TextFormat = new TextFormat();
			tf.font = myFont.fontName;
			tf.size = 20;
			tf.align = TextFormatAlign.CENTER;			
			textLabel = new TextField();			
			textLabel.autoSize = TextFieldAutoSize.CENTER
			textLabel.textColor = 0xffffff;
			textLabel.embedFonts = true;			
			textLabel.defaultTextFormat = tf;
			textLabel.multiline = true;
			textLabel.wordWrap = true;
			textLabel.selectable = false;
			this.addChild(textLabel);
			textLabel.mouseEnabled = false;
		}
		
		public function get label():String { 
			return _label; 
		}
		
		public function set label(value:String):void {
			_label = value;
			textLabel.text = value;
		}
		
	}

}