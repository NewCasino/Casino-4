package com.ui.components {
	
	import fl.motion.Color;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import gs.TweenLite;
	
	public class DialogButton extends Sprite {
		
		public static var OK_MODE:int = 0;
		public static var CANCEL_MODE:int = 1;
		
		public var txtLabel:TextField;
		public var mcOkShape:Sprite;
		public var mcCancelShape:Sprite;
		public var mcButtonBack:Sprite;
		public var mcTintBack:Sprite;
		public var normalColor:int = 0x535252;
		public var rollOverColor:int = 0x66CC00;
		
		private var _curMode:int = -1;
		private var _glowFilter:GlowFilter;
		
		
		public function DialogButton() {
			super();
			
			txtLabel.mouseEnabled = false;
			mcOkShape.visible = false;
			mcCancelShape.visible = false;
			this.mouseEnabled = true;
			this.buttonMode = true;
			this.mode = DialogButton.OK_MODE;
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			
			_glowFilter = new GlowFilter(0x999999, 1, 5, 5, 100, 3);
			this.filters.push(_glowFilter);
			this.label = "COPY";
			//trace ("BUTTON  " + this.getChildAt(5));
			
		}
		
		function onRollOverHandler($event:MouseEvent):void {
			var $skinColor:Color = new Color();
			$skinColor.setTint(normalColor, 1);
			mcTintBack.transform.colorTransform = $skinColor;
			mcTintBack.alpha = 1;
			TweenLite.to(mcTintBack, 0.5, { tint:rollOverColor } );
		}
		
		function onRollOutHandler($event:MouseEvent):void {			
			TweenLite.to(mcTintBack, 0.5, { alpha:0 } );
		}
		
		public function set label($text:String):void  {
			txtLabel.text = $text;
		}
		
		public function get label():String  {
			return txtLabel.text;
		}
		
		public function set mode($mode:int):void  {
			_curMode = $mode;
			switch ($mode) {
				case DialogButton.OK_MODE:
					mcOkShape.visible = true;
					mcCancelShape.visible = false;
					break;
					
				case DialogButton.CANCEL_MODE:
					mcOkShape.visible = false;
					mcCancelShape.visible = true;
					break;
					
				default:
					mcOkShape.visible = false;
					mcCancelShape.visible = false;
					break;
			}
		}
		
		public function get mode():int  {
			return _curMode;
		}
		
		public function set glowColor($color:int):void  {
			_glowFilter.color = $color;
		}
		
		public function get glowColor():int  {
			return _glowFilter.color;
		}
	}
	
}