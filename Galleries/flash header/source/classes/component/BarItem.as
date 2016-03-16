package classes.component {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class BarItem extends Sprite	{
		
		private var barItemActive:ItemBitmapActive;
		private var barItem:ItemBitmap;
		private var itemActive:Bitmap;
		private var itemNormal:Bitmap;
		private var _active:Boolean = false;
		private var hitSpace:Sprite;
		
		public var itemNumber:int;
		
		public function BarItem() {
			super();
			this.addHitSpace();
			itemActive = new Bitmap(new ItemBitmapActive(0, 0));
			itemNormal = new Bitmap(new ItemBitmap(0, 0));
			this.addChild(itemActive);
			this.addChild(itemNormal);			
			this.active = false;
			
			itemActive.x = (this.width - itemActive.width) / 2;
			itemActive.y = (this.height - itemActive.height) / 2;
			
			itemNormal.x = (this.width - itemNormal.width) / 2;
			itemNormal.y = (this.height- itemNormal.height) / 2;
		}
		
		private function addListeners():void {
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
		}
		
		private function mouseOutHandler(e:MouseEvent):void {
			
		}
		
		private function mouseOverHandler(e:MouseEvent):void {
			
		}
		
		public function get active():Boolean { 
			return _active; 
		}
		
		public function set active(value:Boolean):void {
			_active = value;
			if (value) {
				itemNormal.visible = false;
				itemActive.visible = true;
			} else {
				itemNormal.visible = true;
				itemActive.visible = false;
			}
		}
		
		private function addHitSpace():void {
			hitSpace = new Sprite();
			hitSpace.graphics.clear();
			hitSpace.graphics.beginFill(0xffffff);			
			hitSpace.graphics.moveTo(0, 0);
			hitSpace.graphics.lineTo(10, 0);
			hitSpace.graphics.lineTo(10 , 10);
			hitSpace.graphics.lineTo(0, 10);
			hitSpace.graphics.lineTo(0, 0);
			hitSpace.graphics.endFill();
			this.addChildAt(hitSpace, 0);
			hitSpace.alpha = 0;
		}
		
		
	}

}