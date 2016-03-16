//
// Author: Sher Ali
// Website: http://www.kabulinteractive.com
// Creation Date: 02-04-2008

package com.kabulinteractive{
	
	import flash.events.Event;
	
	public class FlashCalendarEvent extends Event{
		
		public static const DATE_SELECTED:String = "date_selected";
		
		public var date:String;
		
		public function FlashCalendarEvent(dateStr:String, type:String, bubbles:Boolean = false, cancelable:Boolean = false){
			super(type, bubbles, cancelable);
			this.date = dateStr;
		}
		
	}
	
}