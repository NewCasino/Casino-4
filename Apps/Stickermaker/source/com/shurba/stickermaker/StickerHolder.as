package com.shurba.stickermaker {
	import fl.controls.RadioButton;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.*;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class StickerHolder extends Sprite {
		
		
		[Event(name="sizeChanged", type="com.shurba.stickermaker.StickerHolderEvent")]
		
		public var aTf:TextFormat;
		public var stickerText:TextField;
		public var twinStickerText:TextField;
		public var backgroundMask:Shape;
		public var stringBounds:Shape;
		public var whiteBack:Sprite;
		
		public var containerLevel1:Sprite = new Sprite();;
		public var containerLevel2:Sprite = new Sprite();
		
		
		private var _textColor:int;
		private var _currentText:String = "";
		
		private var _textWidth:Number;
		private var _textHeight:Number;
		
		private var _mirrorText:Boolean = false;
		private var _transparentText:Boolean = false;
		private var _strictSize:Boolean = true;
		
		public function StickerHolder() {
			super();
			
			backgroundMask = new Shape();
			this.addChild(backgroundMask);
			this.mask = backgroundMask;
			backgroundMask.graphics.beginFill(0x000000);
			backgroundMask.graphics.drawRoundRect(0, 0, this.width, this.height, 7, 7);
			backgroundMask.graphics.endFill();
			backgroundMask.x = 0;
			backgroundMask.y = 0;
			
			stringBounds = new Shape();
			this.addChild(stringBounds);
			this.addChild(containerLevel1);
			containerLevel1.addChild(containerLevel2);
			
		}
		
		private function textChangedHandler(e:Event):void {
			//trace((e.currentTarget as TextField).x);
			//_currentText = (e.currentTarget as TextField).text;
			//stickerText.width = stickerText.textWidth;
			this.drawStringBorders();
		}
		
		private function drawStringBorders():void {
			
			twinStickerText.width = stickerText.width;
			twinStickerText.height = stickerText.height;
			twinStickerText.text = stickerText.text;
			twinStickerText.setTextFormat(stickerText.getTextFormat());
			
			if (_strictSize) {
				this.drawStrictBounds();
			} else {
				this.drawFontBounds();
			}
			
			this.dispatchEvent(new StickerHolderEvent(StickerHolderEvent.SIZE_CHANGED));
		}
		
		protected function drawFontBounds():void {
			stringBounds.graphics.clear();
			stringBounds.graphics.lineStyle(1, 0x000000);
			
			var metrics:TextLineMetrics = twinStickerText.getLineMetrics(0);
			
			/*var yPos:Number = stickerText.y;
			stringBounds.graphics.moveTo(whiteBack.x, yPos);
			stringBounds.graphics.lineTo(whiteBack.width + whiteBack.x, yPos);
			
			yPos = metrics.height + stickerText.y;
			stringBounds.graphics.moveTo(whiteBack.x, yPos);
			stringBounds.graphics.lineTo(whiteBack.width + whiteBack.x, yPos);
			
			var xPos:Number = stickerText.x;
			stringBounds.graphics.moveTo(xPos, whiteBack.y);
			stringBounds.graphics.lineTo(xPos, whiteBack.y + whiteBack.height);
			
			xPos = metrics.width + stickerText.x;
			stringBounds.graphics.moveTo(xPos, whiteBack.y);
			stringBounds.graphics.lineTo(xPos, whiteBack.y + whiteBack.height);
			*/
			_textWidth = metrics.width;
			_textHeight = metrics.height;
		}
		
		protected function drawStrictBounds():void {
			stringBounds.graphics.clear();
			stringBounds.graphics.lineStyle(1, 0x000000);
			
			var bounds:Rectangle = this.getVisibleBounds(containerLevel1);
			
			/*var yPos:Number = bounds.y + stickerText.y + 2;
			stringBounds.graphics.moveTo(whiteBack.x, yPos);
			stringBounds.graphics.lineTo(whiteBack.width + whiteBack.x, yPos);
			
			yPos = bounds.bottom + containerLevel1.y + 2;
			stringBounds.graphics.moveTo(whiteBack.x, yPos);
			stringBounds.graphics.lineTo(whiteBack.width + whiteBack.x, yPos);
			
			var xPos:Number = bounds.left + containerLevel1.x + 2;
			stringBounds.graphics.moveTo(xPos, whiteBack.y);
			stringBounds.graphics.lineTo(xPos, whiteBack.y + whiteBack.height);
			
			xPos = bounds.right + containerLevel1.x + 2;
			stringBounds.graphics.moveTo(xPos, whiteBack.y);
			stringBounds.graphics.lineTo(xPos, whiteBack.y + whiteBack.height);*/
			
			_textWidth = bounds.right - bounds.left;			
			_textHeight = bounds.bottom - bounds.top;
		}
		
		public function get textColor():int { 
			return _textColor; 
		}
		
		public function set textColor(value:int):void {
			_textColor = value;
			
			if (!stickerText || _transparentText) {
				return;
			}
			
			aTf = stickerText.getTextFormat();
			aTf.color = _textColor;
			stickerText.textColor = _textColor;
			stickerText.setTextFormat(aTf);
		}
		
		private function getVisibleBounds(source : DisplayObject) : Rectangle { 
			const bitmapData : BitmapData = new BitmapData(source.width, source.height, true, 0); 
			bitmapData.draw(source); 
			const bounds : Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0, false); 
			bitmapData.dispose(); 
			return bounds; 
		}
		
		public function setFontHolderClass($fontHolder:Class):void {			
			var fontInstance1:Object = new $fontHolder();			
			var fontInstance2:Object = new $fontHolder();			
			
			if (stickerText) {
				containerLevel2.removeChild(stickerText);
				stickerText.removeEventListener(Event.CHANGE, textChangedHandler);
			}
			
			stickerText = (fontInstance1).TXT as TextField;
			stickerText.addEventListener(Event.CHANGE, textChangedHandler, false, 0, true);
			
			aTf = new TextFormat();
			aTf.align = TextFormatAlign.LEFT;
			stickerText.type = TextFieldType.DYNAMIC;
			stickerText.selectable = false;
			stickerText.text = _currentText;
			stickerText.autoSize = TextFieldAutoSize.LEFT;
			stickerText.multiline = false;
			aTf.color = _textColor;
			//stickerText.x = 17;
			//stickerText.y = (whiteBack.height - stickerText.height) / 2;
			
			stickerText.setTextFormat(aTf);
			
			containerLevel2.addChild(stickerText);
			
			twinStickerText = (fontInstance2).TXT as TextField;			
			twinStickerText.text = _currentText;
			twinStickerText.multiline = false;
			twinStickerText.setTextFormat(aTf);
			this.textColor = _textColor;
			
			this.transparentText = _transparentText;
			this.mirrorText = _mirrorText;
			
			this.setContainerSize();
			this.drawStringBorders();
		}
		
		public function get textWidth():Number {
			return _textWidth;
		}
		
		public function get textHeight():Number {
			return _textHeight;
		}
		
		public function get mirrorText():Boolean { 
			return _mirrorText; 
		}
		
		public function set mirrorText(value:Boolean):void {
			_mirrorText = value;
			if (_mirrorText) {
				containerLevel1.scaleX = -1;
				containerLevel1.x = 17 + containerLevel1.width;				
			} else {
				containerLevel1.scaleX = 1;
				containerLevel1.x = 17;
			}
		}
		
		public function get transparentText():Boolean { 
			return _transparentText; 
		}
		
		public function set transparentText(value:Boolean):void {
			_transparentText = value;
			if (_transparentText) {
				stickerText.textColor = 0xFFFFFFFF;
				stickerText.background = true;
				stickerText.backgroundColor = 0x808040;
			} else {
				stickerText.textColor = _textColor;
				stickerText.background = false;				
			}
		}
		
		public function get strictSize():Boolean { 
			return _strictSize; 
		}
		
		public function set strictSize(value:Boolean):void {
			_strictSize = value;
			this.drawStringBorders();
		}
		
		public function get currentText():String { 
			return _currentText; 
		}
		
		public function set currentText(value:String):void {
			_currentText = value;
			if (!stickerText) {
				return;
			}
			stickerText.text = _currentText;
			this.setContainerSize();
			this.drawStringBorders();
		}
		
		private function setContainerSize():void {
			
			if (stickerText.width > whiteBack.width - 34) {
				var coef:Number = stickerText.width / stickerText.height;
				containerLevel2.width = whiteBack.width - 34;
				containerLevel2.height = containerLevel2.width / coef;
			} else {
				containerLevel2.scaleX = 1;
				containerLevel2.scaleY = 1;
			}
			
			this.centerText();
		}
		
		private function centerText():void {
			this.mirrorText = _mirrorText;
			containerLevel1.y = (whiteBack.height - containerLevel1.height) / 2;
		}
		
	}

}