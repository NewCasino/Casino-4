package com.ui.components {
	
	import com.events.VideoListEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.ui.components.VideoListItem;	
	
	[Event("itemClick", type = "com.events.VideoListEvent")]
	
	public class VideoList extends Sprite {
		
		public var maxHeght:Number = 250;
		public var gap:Number = 8;
		
		private var data:Array;
		private var iCurrentPage:int = 0;
		private var iPages:int = 0;
		
		
		public function VideoList() {
			
		}
		
		private function renderItems():void {
			this.clear();
			var $itemsPerPage:int = Math.floor(maxHeght / VideoListItem.HEIGHT);
			iPages = Math.ceil(data.length / $itemsPerPage) - 1;
			//trace ()
			
			for (var i:int = 0; i < $itemsPerPage; i++) {
				
				var iNum:int = iCurrentPage * $itemsPerPage + i;
				if (!data[iNum]) {
					return;					
				}
				var $listItem:VideoListItem = new VideoListItem();
				
				$listItem.dataProvider = data[iNum];
				this.addChild($listItem);
				$listItem.addEventListener(MouseEvent.CLICK, itemClickHandler);
				$listItem.y = ($listItem.height + gap) * i;
			}			
		}
		
		private function clear():void {
			var $item:VideoListItem;
			while (this.numChildren) {
				$item = this.getChildAt(0) as VideoListItem;
				$item.clear();				
				$item.removeEventListener(MouseEvent.CLICK, itemClickHandler);
				
				this.removeChildAt(0);
			}
		}
		
		private function itemClickHandler($event:MouseEvent):void {
			var $listItem:VideoListItem =  $event.currentTarget as VideoListItem;			
			var $videoListEvent:VideoListEvent = new VideoListEvent(VideoListEvent.ITEM_CLICK);
			$videoListEvent.data = $listItem.data;			
			this.dispatchEvent($videoListEvent);
		}
		
		public function set dataProvider($data:Array):void {
			data = $data;
			iCurrentPage = 0;			
			this.renderItems();
		}
		
		public function turnUp():void {
			if (iCurrentPage < iPages) {
				iCurrentPage++;
				this.renderItems();
			}
		}
		
		public function turnDown():void {
			if (iCurrentPage > 0) {
				iCurrentPage--;
				this.renderItems();
			}
		}
		
	}
}