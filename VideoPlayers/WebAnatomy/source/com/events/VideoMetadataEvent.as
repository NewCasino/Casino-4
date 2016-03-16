package com.events {
	import flash.events.Event;
	
	
	public class VideoMetadataEvent extends Event {
		
		public static var METADATA_EVENT:String = "metadataEvent";
		
		public var info:Object;
		
		public function VideoMetadataEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {			
			super(type);
		}
		
		override public function clone():Event {
			return new VideoMetadataEvent(type, bubbles, cancelable);
		}
	}
	
}