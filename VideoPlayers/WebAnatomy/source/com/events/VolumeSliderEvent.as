package com.events {
	import flash.events.Event;
	
	
	public class VolumeSliderEvent extends Event {
		
		public static var VOLUME_CHANGE:String = "volumeChange";
		
		public var volume:Number;
		
		public function VolumeSliderEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {			
			super(type);
		}
		
		override public function clone():Event {
			return new VolumeSliderEvent(type, bubbles, cancelable);
		}
	}
	
}