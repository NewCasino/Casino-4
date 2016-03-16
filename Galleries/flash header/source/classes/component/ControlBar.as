package classes.component {
	import classes.component.BarItem;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	[Event("itemClick", type = "flash.events.Event")]
	 
	public class ControlBar extends Sprite {
		
		private const GAP:int = 0;
		
		private var _numItems:int;
		
		private var items:Array = new Array();
		
		private var lastItemNumber:int = 0;
		private var _currentItemNumber:int = 0;
		
		private var hitSpace:Sprite;
		
		public function ControlBar() {
			super();
			this.buttonMode = true;
			hitSpace = new Sprite();
			this.addChildAt(hitSpace, 0);
		}
		
		public function get numItems():int { 
			return _numItems;
		}
		
		public function set numItems(value:int):void {
			_numItems = value;
			this.updateNumItems();
		}
		
		public function get currentItemNumber():int { 
			return _currentItemNumber; 
		}
		
		public function set currentItemNumber(value:int):void {
			lastItemNumber = _currentItemNumber;
			_currentItemNumber = value;
			
			if (lastItemNumber != _currentItemNumber) {
				(items[lastItemNumber] as BarItem).active = false;				
			}
			
			(items[_currentItemNumber] as BarItem).active = true;
		}
		
		private function updateNumItems():void {
			var difference:int
			difference = _numItems - items.length;
			if (difference > 0) {
				this.addItems(difference);
			} else {
				this.removeItems(Math.abs(difference));
			}
			this.addHitSpace();
		}
		
		private function removeItems($number:int):void {
			
		}
		
		private function addItems($number:int):void {
			var tmpItem:BarItem;
			for (var i:int = 0; i < $number; i++) {
				tmpItem = new BarItem();
				this.addChild(tmpItem);
				items.push(tmpItem);
				//tmpItem.addEventListener(MouseEvent.CLICK, itemClickHandler, false, 0, true);
			}
			this.updateItemsPosition();
		}
		
		private function itemClickHandler(e:MouseEvent):void {
			
			if (this.currentItemNumber != (e.currentTarget as BarItem).itemNumber) {
				this.currentItemNumber = (e.currentTarget as BarItem).itemNumber;
				this.dispatchEvent(new Event('itemClick'));
			}
			
		}
		
		public function updateItemsPosition():void {
			var item:BarItem;
			for (var i:int = 0; i < items.length; i++) {
				item = (items[i] as BarItem);
				item.x = (item.width + GAP) * i;
				item.itemNumber = i;
			}
		}
		
		private function addHitSpace():void {
			hitSpace.graphics.clear();
			hitSpace.graphics.beginFill(0xffffff);			
			hitSpace.graphics.moveTo(0, 0);
			hitSpace.graphics.lineTo(this.width, 0);
			hitSpace.graphics.lineTo(this.width, this.height);
			hitSpace.graphics.lineTo(0, this.height);
			hitSpace.graphics.lineTo(0, 0);
			hitSpace.graphics.endFill();			
			hitSpace.alpha = 0;
		}
		
	}

}