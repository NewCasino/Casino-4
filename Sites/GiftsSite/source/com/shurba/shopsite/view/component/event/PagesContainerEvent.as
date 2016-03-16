package com.shurba.shopsite.view.component.event {
	import flash.events.Event;
	
	public class PagesContainerEvent extends Event {
		public static const SHOW_MORE_PAGE:String = "showMorePage";
		public var params:String;
		
		public function PagesContainerEvent(type:String, params:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.params = params;
		}
		
	}
}