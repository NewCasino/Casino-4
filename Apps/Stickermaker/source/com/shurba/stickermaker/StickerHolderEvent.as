package com.shurba.stickermaker {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class StickerHolderEvent extends Event {
		
		public static const SIZE_CHANGED:String = "sizeChanged";
		
		public function StickerHolderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new StickerHolderEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("StickerHolderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}