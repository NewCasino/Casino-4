package com.shurba.components.accordionNavigator {
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	[Event (name="resizeStart", type="com.shurba.components.accordionNavigator.AccordionItemResizeEvent")]
	[Event (name="resizeComplete", type="com.shurba.components.accordionNavigator.AccordionItemResizeEvent")]
	[Event (name="resizeProgress", type="com.shurba.components.accordionNavigator.AccordionItemResizeEvent")]
	
	public class AccordionContent extends Sprite {
		
		public function AccordionContent() {
			super();
			
		}
		
		protected function dispatchResizeStart():void {
			this.dispatchEvent(new AccordionItemResizeEvent(AccordionItemResizeEvent.RESIZE_START));
		}
		
		protected function dispatchResizePogress():void {
			this.dispatchEvent(new AccordionItemResizeEvent(AccordionItemResizeEvent.RESIZE_PROGRESS));
		}
		
		protected function dispatchResizeComplete():void {
			this.dispatchEvent(new AccordionItemResizeEvent(AccordionItemResizeEvent.RESIZE_COMPLETE));
		}
		
	}

}