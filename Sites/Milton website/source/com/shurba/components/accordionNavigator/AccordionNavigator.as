package com.shurba.components.accordionNavigator {
	import com.greensock.plugins.*;
	import com.greensock.*;
	import com.shurba.components.accordionNavigator.*;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class AccordionNavigator extends Sprite {
		
		public var background:Shape;
		
		protected const ITEMS_NUMBER:int = 5;
		protected const ITEMS_GAP:int = 0;
		
		public var currentItemNum:int = 0;
		
		public var items:Array;
		
		private var currentFirstAnimatedItem:int = -1;
		private var resizeCompleteCounter:int = 0;
		
		public function AccordionNavigator() {
			super();
			
		}
		
		public function init():void {			
			TweenPlugin.activate([TintPlugin]);
			this.generateItems();
			this.addBackground();
		}
		
		private function addBackground():void {
			background = new Shape();
			this.addChildAt(background, 0);
			background.graphics.beginFill(0xD8D7D3);
            background.graphics.lineStyle();
            background.graphics.drawRect(0, 0, 297, this.height);
            background.graphics.endFill();
		}
		
		protected function generateItems():void {
			items = [];
			var tmpItem:AccordionItem;
			
			for (var i:int = 0; i < ITEMS_NUMBER; i++) {
				tmpItem = new AccordionItem();
				tmpItem.number = i;
				tmpItem.x = 0;
				tmpItem.y = (tmpItem.height + ITEMS_GAP) * i + ITEMS_GAP;
				tmpItem.addEventListener(AccordionComponentEvent.BUTTON_CLICK, accordionItemClickHandler, false, 0, true);
				tmpItem.addEventListener(AccordionItemResizeEvent.RESIZE_COMPLETE, resizeComplete, false, 0, true);
				tmpItem.addEventListener(AccordionItemResizeEvent.RESIZE_START, resizeStart, false, 0, true);
				this.addChild(tmpItem);
				items.push(tmpItem);
			}
			
			(items[currentItemNum] as AccordionItem).expand();
			resizeCompleteCounter = 1;
			this.addEventListener(Event.ENTER_FRAME, moveItems, false, 0, true);
			
		}
		
		private function resizeStart(e:AccordionItemResizeEvent):void {
			resizeCompleteCounter = 1;
			this.addEventListener(Event.ENTER_FRAME, moveItems, false, 0, true);
		}
		
		private function accordionItemClickHandler(e:AccordionComponentEvent):void {
			var tmpItem:AccordionItem = e.currentTarget as AccordionItem;
			
			if (tmpItem.number == currentItemNum) {
				return;
			}
			
			(items[currentItemNum] as AccordionItem).colapse();
			tmpItem.expand();
			
			currentItemNum = tmpItem.number;
			
			this.addEventListener(Event.ENTER_FRAME, moveItems, false, 0, true);
		}
		
		protected function moveItems(e:Event):void {			
			var tmpItem:AccordionItem;
			var heightCounter:Number = 0;
			for (var i:int = 0; i < ITEMS_NUMBER; i++) {				
				(items[i] as AccordionItem).y = heightCounter;
				heightCounter += (items[i] as AccordionItem).height + ITEMS_GAP;
			}
			background.height = this.height;		
			
		}
		
		protected function resizeComplete(e:AccordionItemResizeEvent):void {
			resizeCompleteCounter++;
			
			if (resizeCompleteCounter < 2) {
				return
			}
			this.removeEventListener(Event.ENTER_FRAME, moveItems);
			resizeCompleteCounter = 0;
		}
		
	}

}