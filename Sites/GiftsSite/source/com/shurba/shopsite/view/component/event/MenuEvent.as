package com.shurba.shopsite.view.component.event {
	import flash.events.Event;
	
	public class MenuEvent extends Event {
		public static const NAV_BUTTON_PRESSED:String = "navButtonPressed";
		public var linkId:int;
		
		public function MenuEvent(type:String, linkId:int, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.linkId = linkId;
		}
		
	}
}