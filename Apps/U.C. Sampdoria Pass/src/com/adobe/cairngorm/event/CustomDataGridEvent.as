package com.adobe.cairngorm.event {
	
	import flash.events.Event;
	
	
	public class CustomDataGridEvent extends Event {
		
		public static const EDIT_ACTION:String = "editAction";
		public static const DELETE_ACTION:String = "deleteAction";
		public static const SHOW_PASS_ACTION:String = "showPassAction";
		public static const PRINT_ACTION:String = "printAction";
		
		public var item:Object;
		
		public function CustomDataGridEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return Event(type);
		}
		
	}
}