package com.events {
	import com.vo.VideoListItemVO;
	import flash.events.Event;
	
	
	public class VideoListEvent extends Event {
		
		public static var ITEM_CLICK:String = "itemClick";
		
		public var data:VideoListItemVO;
		
		public function VideoListEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {			
			super(type);
		}
		
		override public function clone():Event {
			return new ShareControlEvent(type, bubbles, cancelable);
		}
	}
	
}