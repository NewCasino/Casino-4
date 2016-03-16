package com.shurba.components.accordionNavigator {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class AccordionComponentEvent extends Event {
		
		public static const BUTTON_CLICK:String = 'buttonClick';
		
		public function AccordionComponentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new AccordionComponentEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("AccordionComponentEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}