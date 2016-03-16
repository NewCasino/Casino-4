package {
	import com.greensock.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import vo.ColorVO;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	[Event("select", type = "flash.events.Event")]
	[Event("previewStateChange", type = "flash.events.Event")]
	[Event("previewColorChange", type = "flash.events.Event")]
	 
	public class PaletteList extends Sprite {
		
		public static var DEFAULT_GAP:int = 15;
		public static var DEFAULT_OFFSET:int = 5;
		public static var DEFAULT_HEADER:int = 25;
		
		public var background:Shape = new Shape();
		public var palletesBack:Shape = new Shape();
		public var palletes:Sprite = new Sprite();
		
		
		
		private var _dataProvider:Array;
		
		
		private var _width:Number = 100;
		
		public var items:Array = [];
		
		public var selectedColor:ColorVO;
		private var _previewColor:ColorVO;
		
		private var enabled:Boolean = false;
		
		public var colorName:TextField = new TextField();
		
		public function PaletteList() {
			super();
			
			this.addChild(background);
			this.addChild(palletes);
			this.addChild(colorName);
			
			colorName.x = 5;
			colorName.y = 5;
			
			colorName.defaultTextFormat = new TextFormat("Verdana", 10);
			
			palletes.addChild(palletesBack);
			palletes.x = 5;
			palletes.y = DEFAULT_HEADER;
			
					
			this.addListeners();
		}
		
		private function addListeners():void {
			
		}
		
		private function removeListeners():void {
			
		}
		
		
		protected function drawBackground():void {
			background.graphics.clear();
			background.graphics.beginFill(0xeeeeee);
			background.graphics.lineStyle(1, 0xaaaaaa);
			background.graphics.drawRect(0, 0, palletes.width + (palletes.x * 2) + (DEFAULT_OFFSET * 2), palletes.height + palletes.y + (DEFAULT_OFFSET * 3));
			background.graphics.endFill();
			
		}
		
		protected function drawPalletesBack():void {
			palletesBack.graphics.clear();
			palletesBack.graphics.beginFill(0xffffff);
			//palletesBack.graphics.lineStyle(0);
			palletesBack.graphics.drawRect(0, 0, palletes.width + (DEFAULT_OFFSET * 2), palletes.height + (DEFAULT_OFFSET * 2));
			palletesBack.graphics.endFill();
			
		}
		
		public function show():void {
			
			this.visible = true;
			//var clickPoint:Point = new Point(this.width, 0);
			TweenLite.to(this, 0.5, { alpha:1 } );
		}
		
		public function hide():void {
			enabled = false;
			TweenLite.to(this, 0.5, { alpha:0, onComplete:makeThisInvisible } );
		}
		
		private function makeThisInvisible():void {
			this.visible = false;
		}
		
		protected function createPalettes():void {
			var tmpPalette:PaletteItem;
			for (var i:int = 0; i < _dataProvider.length; i++) {
				tmpPalette = new PaletteItem();
				tmpPalette.dataProvider = _dataProvider[i];
				tmpPalette.y = (tmpPalette.height + DEFAULT_GAP) * i;
				palletes.addChild(tmpPalette);
				items.push(tmpPalette);
				tmpPalette.owner = this;
			}
			
			
		}		
		
		private function updateDisplayList():void {
			var xPos:Number = 0;
			var yPos:Number = 0;
			for (var i:int = 0; i < items.length; i++) {				
				(items[i] as PaletteItem).width = _width;
				(items[i] as PaletteItem).x = DEFAULT_OFFSET;
				(items[i] as PaletteItem).y = yPos;
				yPos += (items[i] as PaletteItem).height + DEFAULT_GAP;				
			}
			
			this.drawBackground();
			this.drawPalletesBack();
			
			
			colorName.height = 25;
			colorName.width = this.width;
			
			this.selectColor((items[0] as PaletteItem).colorItems[0].dataProvider);
		}
		
		public function get dataProvider():Array { 
			return _dataProvider; 
		}
		
		public function set dataProvider(value:Array):void {
			_dataProvider = value;
			this.createPalettes();
		}
		
		override public function get width():Number { 
			return super.width; 
		}
		
		override public function set width(value:Number):void {
			_width = value;
			this.updateDisplayList();
		}
		
		public function get previewColor():ColorVO { 
			return _previewColor; 
		}
		
		public function set previewColor(value:ColorVO):void {
			_previewColor = value;
			colorName.text = _previewColor.name;
			if (enabled) {
				this.dispatchEvent(new Event("previewColorChange"));
			}
		}
		
		public function selectColor($color:ColorVO):void {
			selectedColor = $color;
			this.dispatchEvent(new Event(Event.SELECT));
		}
		
	}

}