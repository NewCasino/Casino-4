package com.shurba.stickermaker {
	import com.greensock.TweenLite;
	import com.shurba.stickermaker.vo.ColorVO;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import com.shurba.stickermaker.ColorPaletteEvent;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ColorPalette extends Sprite {
		
		private var _dataProvider:Array;
		private var _width:Number;
		
		private var _selectedColorVO:ColorVO;
		private var _selectedColor:uint = 0x000000;
		private var _previewColorVO:ColorVO;
		
		public var paletteList:PaletteList = new PaletteList();
		public var openButton:ColorSample = new ColorSample();
		
		private var _wasOverPaletteList:Boolean = false;
		
		private var _preview:Boolean = true;
		
		[ColorPaletteEvent("previewColor", type = "com.shurba.stickermaker.ColorPaletteEvent")]
		[ColorPaletteEvent("selectColor", type = "com.shurba.stickermaker.ColorPaletteEvent")]
		
		public function ColorPalette() {
			super();
			
			this.addChild(paletteList);
			this.addChild(openButton);
			
			openButton.buttonMode = true;
			
			openButton.width = 30;
			openButton.height = 30;
			
			paletteList.alpha = 0;
			paletteList.visible = false;
			paletteList.x = openButton.width + 15;
			paletteList.y = 0;// openButton.height + 30;
			var filter:DropShadowFilter = new DropShadowFilter();
			filter.quality = 15;
			var filters:Array = [filter];
			paletteList.filters = filters;
			this.addListeners();
		}
		
		private function addListeners():void {
			openButton.addEventListener(MouseEvent.CLICK, openButtonClickHandler, false, 0, true);
			paletteList.addEventListener(Event.SELECT, paletteListSelectHandler, false, 0, true);			
			paletteList.addEventListener("previewColorChange", paletteListPreviewColorHandler, false, 0, true);
			//paletteList.addEventListener(MouseEvent.MOUSE_OVER, paletteListMouseOverHandler, false, 0, true);
		}
		
		private function paletteListPreviewColorHandler(e:Event):void {
			this._previewColorVO = paletteList.previewColor;
			if (_preview) {				
				this.dispatchEvent(new ColorPaletteEvent(ColorPaletteEvent.PREVIEW_COLOR));
			}
		}
			
		private function paletteListSelectHandler(e:Event):void {
			openButton.color = paletteList.selectedColor.hexColor;
			selectedColor = paletteList.selectedColor;
			paletteList.hide();
		}
		
		private function paletteListMouseOverHandler(e:MouseEvent):void {
			if (!_wasOverPaletteList)
				_wasOverPaletteList = true;
		}
		
		private function paletteListMouseOutHandler(e:MouseEvent):void {
			if (!_wasOverPaletteList) return;
			paletteList.hide();
			_wasOverPaletteList = false;
			//trace ("hide");
		}
		
		private function openButtonClickHandler(e:MouseEvent):void {
			if (paletteList.visible) {				
				paletteList.hide();
				this.dispatchEvent(new ColorPaletteEvent(ColorPaletteEvent.SELECT_COLOR));
			} else {
				paletteList.x = -paletteList.width + 15;
				paletteList.show();				
			}
			
		}
		
		private function removeListeners():void {
			openButton.removeEventListener(MouseEvent.CLICK, openButtonClickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, paletteListMouseOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER, paletteListMouseOverHandler);
		}
		
		public function get dataProvider():Array { 
			return paletteList.dataProvider; 
		}
		
		public function set dataProvider(value:Array):void {
			paletteList.dataProvider = value;
		}
		
		public function get selectedColor():ColorVO { 
			return _selectedColorVO;
		}
		
		public function set selectedColor(value:ColorVO):void {
			_selectedColorVO = value;
			this.dispatchEvent(new ColorPaletteEvent(ColorPaletteEvent.SELECT_COLOR));
		}
		
		override public function get width():Number { 
			return super.width; 
		}
		
		override public function set width(value:Number):void {
			paletteList.width = value;			
		}
		
		public function get previewColor():ColorVO { 
			return _previewColorVO; 
		}
		
		public function set previewColor(value:ColorVO):void {
			_previewColorVO = value;
		}
		
		
		
	}

}