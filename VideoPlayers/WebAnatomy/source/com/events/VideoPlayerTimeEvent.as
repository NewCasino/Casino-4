package com.events {
	import flash.events.Event;
	
	
	public class VideoPlayerTimeEvent extends Event {
		
		public static var TIME:String = "time";
		
		public var time:Number;
		
		public function VideoPlayerTimeEvent(type:String, $time:Number, bubbles:Boolean = true, cancelable:Boolean = false) {
			time = $time;
			super(type);
		}
		
		override public function clone():Event {
			return new VideoPlayerEvent(type, bubbles, cancelable);
		}
	}
	
}