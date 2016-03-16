package com.shurba.stickermaker {
	import com.shurba.stickermaker.vo.ColorVO;
	import com.shurba.stickermaker.vo.PaletteItemVO;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	
	public class PaletteItem extends Sprite	{
		
		public static var DEFAULT_WIDTH:int = 50;
		public static var DEFAULT_GAP:int = 3;
		
		private var _dataProvider:PaletteItemVO;
		private var _width:Number = 0;
		
		public var colorItems:Array = [];
		
		public var title:TextField = new TextField();
		
		private var _owner:PaletteList;
		
		//private var myFont:Font = new VerdanaFont();
		
		public function PaletteItem() {
			_width = DEFAULT_WIDTH;
			this.addChild(title);			
			title.mouseEnabled = false;
			var tf:TextFormat = title.getTextFormat();			
			tf.font = "Verdana";
			tf.size = 10;
			title.defaultTextFormat = tf;
			title.selectable = false;
			title.multiline = false;
		}
		
		private function addListeners():void {
			
		}
		
		private function removeListeners():void {
			
		}
		
		protected function drawPalette():void {			
			title.text = _dataProvider.name;
			title.height = title.textHeight + 5;			
			
			var tmpColor:ColorItem;
			var xPos:Number = 0;
			var yPos:Number = title.height + 5;
			for (var i:int = 0; i < _dataProvider.colors.length; i++) {
				tmpColor = new ColorItem();
				tmpColor.dataProvider = _dataProvider.colors[i];				
				tmpColor.x = xPos;
				tmpColor.y = yPos;
				xPos += tmpColor.width + DEFAULT_GAP;
				if (xPos + tmpColor.width > this._width) {
					xPos = 0;
					yPos += DEFAULT_GAP + tmpColor.height;
				}
				
				tmpColor.addEventListener(MouseEvent.CLICK, colorSampleClickHandler, false, 0, true);
				tmpColor.addEventListener(MouseEvent.MOUSE_OVER, colorSampleOverHandler, false, 0, true);
				this.addChild(tmpColor);
				colorItems.push(tmpColor);
			}
		}
		
		private function colorSampleOverHandler(e:MouseEvent):void {		
			var color:ColorVO = (e.currentTarget as ColorItem).dataProvider;
			_owner.previewColor = color;
		}
		
		private function colorSampleClickHandler(e:MouseEvent):void {
			var color:ColorVO = (e.currentTarget as ColorItem).dataProvider;
			_owner.selectColor(color);
		}
		
		protected function updateDisplayList():void {			
			var xPos:Number = 0;
			var yPos:Number = title.height + 5;
			for (var i:int = 0; i < colorItems.length; i++) {				
				colorItems[i].x = xPos;
				colorItems[i].y = yPos;
				xPos += colorItems[i].width + DEFAULT_GAP;
				if (xPos + colorItems[i].width > this._width) {
					xPos = 0;
					yPos += DEFAULT_GAP + colorItems[i].height;
				}
			}
		}
		
		public function get dataProvider():PaletteItemVO { 
			return _dataProvider; 
		}
		
		public function set dataProvider(value:PaletteItemVO):void {
			_dataProvider = value;
			this.drawPalette();
		}
		
		override public function get width():Number { 
			return _width; 
		}
		
		override public function set width(value:Number):void {
			_width = value;
			this.updateDisplayList();
		}
		
		public function get owner():PaletteList { 
			return _owner; 
		}
		
		public function set owner(value:PaletteList):void {			
			_owner = value;
		}
		
	}

}