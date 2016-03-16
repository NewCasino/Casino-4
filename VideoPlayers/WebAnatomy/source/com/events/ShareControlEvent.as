package com.events {
	import flash.events.Event;
	
	
	public class ShareControlEvent extends Event {
		
		public static var SHARE_CONTROL_CLICK:String = "shareControlClick";
		
		public var panelID:int;
		
		public function ShareControlEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {			
			super(type);
		}
		
		override public function clone():Event {
			return new ShareControlEvent(type, bubbles, cancelable);
		}
	}
	
}