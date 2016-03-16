package  {
	import com.greensock.plugins.*;
	import com.greensock.*;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class BtnSend extends Sprite	{
		
		public const TWEEN_TIME:Number = 0.15;
		public const OVER_TINT:uint = 0xa4a0dC;
		public const DOWN_TINT:uint = 0x2470AC;
		
		/*[Embed(source = '../lib/verdana.ttf', fontFamily = "VerdanaEmbeded", unicodeRange = 'U+0041-U+005A,U+0061-U+007A')]
		public var VerdanaFont:Class;		
		public var labelFont:Font;*/
		
		
		[Embed(source='../lib/btn.png')]
		private var BtnImage:Class;
		private var btnImage:Bitmap = new BtnImage ();
		
		public var label:TextField;
		
		public function BtnSend() {
			super();
			
			this.useHandCursor = true;
			this.buttonMode = true;
			
			this.addChild(btnImage);
			
			label = new TextField();
			this.addChild(label);
			
			label.mouseEnabled = false;
			var tf:TextFormat = new TextFormat();
			//labelFont = new VerdanaFont();
			label.embedFonts = false;
			tf.font = "Verdana";//labelFont.fontName;
			tf.size = 12;
			label.selectable = false;
			
			label.defaultTextFormat = tf;
			label.setTextFormat(tf);
			label.multiline = false;
			label.text = "Send";
			
			label.width = label.textWidth + 3;
			label.x = (this.width - label.textWidth) / 2 - 2;
			label.y = 5;
			
			this.addListeners();
		}
		
		private function addListeners():void {
			this.addEventListener(MouseEvent.ROLL_OVER, thisRollOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, thisRollOutHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, thisMouseDownHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, thisMouseUpHandler, false, 0, true);
			
		}
		
		private function thisMouseUpHandler(e:MouseEvent):void {
			this.x -= 1;
			this.y -= 1;
			
			//TweenMax.to(btnImage, TWEEN_TIME, {colorMatrixFilter:{colorize:OVER_TINT, amount:0.2}});
		}
		
		private function thisMouseDownHandler(e:MouseEvent):void {
			this.x += 1;
			this.y += 1;
			//TweenMax.to(btnImage, TWEEN_TIME, {colorMatrixFilter:{colorize:DOWN_TINT, amount:0.2}});
		}
		
		private function thisRollOutHandler(e:MouseEvent):void {
			TweenMax.to(btnImage, TWEEN_TIME, {colorMatrixFilter:{}});
		}
		
		private function thisRollOverHandler(e:MouseEvent):void {
			TweenMax.to(btnImage, TWEEN_TIME, {colorMatrixFilter:{colorize:OVER_TINT, amount:0.2}});
		}
		
		
		
	}

}