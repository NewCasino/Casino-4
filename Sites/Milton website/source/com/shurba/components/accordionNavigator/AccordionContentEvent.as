package com.shurba.components.accordionNavigator {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class AccordionContentEvent extends Event {
		
		public static const 
		
		public function AccordionContentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new AccordionContentEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("AccordionContentEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}