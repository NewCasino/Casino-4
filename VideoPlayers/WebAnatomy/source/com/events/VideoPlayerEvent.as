package com.events {
	import flash.events.Event;
	
	
	public class VideoPlayerEvent extends Event {
		
		public static var EVENT_VIDEO_STATUS:String = "videoStatusEvent";
		public static var PLAY:String = "play";
		public static var PAUSE:String = "pause";
		public static var STOP:String = "stop";
		public static var SEEK_NOTIFY:String = "seekNotify";
		public static var BUFFER_FULL:String = "bufferFull";
		public static var BUFFER_EMPTY:String = "bufferEmpty";
		
		public function VideoPlayerEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type);
		}
		
		override public function clone():Event {
			return new VideoPlayerEvent(type, bubbles, cancelable);
		}
	}
	
}