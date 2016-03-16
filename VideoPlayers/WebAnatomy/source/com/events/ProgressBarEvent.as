package com.events {
	
	import flash.events.Event;
	
	public class ProgressBarEvent extends Event {
		
		public static var DRAG_SLIDER:String = "dragSlider";
		
		public var percent:Number;
		
		public function ProgressBarEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {			
			super(type);
		}
		
		override public function clone():Event {
			return new ProgressBarEvent(type, bubbles, cancelable);
		}
	}
	
}