package com.shurba.components.accordionNavigator {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class AccordionItemResizeEvent extends Event {
		
		public static const RESIZE_COMPLETE:String = 'resizeComplete';
		public static const RESIZE_START:String = 'resizeStart';
		public static const RESIZE_PROGRESS:String = 'resizeProgress';
		
		public static const RESIZE_TYPE_COLAPSE:String = 'resizeTypeColapse';
		public static const RESIZE_TYPE_EXPAND:String = 'resizeTypeExpand';
		
		public var resizeType:String;
		
		public function AccordionItemResizeEvent(type:String, resizeType:String = null, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			this.resizeType = resizeType;
		} 
		
		public override function clone():Event { 
			return new AccordionComponentEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("AccordionComponentEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}