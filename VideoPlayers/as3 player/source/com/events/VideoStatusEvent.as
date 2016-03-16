package com.events {
	import flash.events.Event;
	
	
	public class VideoStatusEvent extends Event {
		
		public static var EVENT_VIDEO_STATUS:String = "videoStatusEvent";
		public static var VIDEO_PLAY:String = "play";
		public static var VIDEO_PAUSE:String = "paused";
		public static var VIDEO_STOP:String = "stop";
		public static var NET_CONNECTION_CONNECTED:String = "ncConnected";
		
		
		public var status:String;
		
		public function VideoStatusEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {
			this.status = type;
			super(type);
		}
		
		override public function clone():Event {
			return new VideoStatusEvent(type, bubbles, cancelable);
		}
	}
	
}