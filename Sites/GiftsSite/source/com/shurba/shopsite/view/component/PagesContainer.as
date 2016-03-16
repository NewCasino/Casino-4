package com.shurba.shopsite.view.component {
	import com.shurba.shopsite.view.component.event.PagesContainerEvent;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class PagesContainer extends MovieClip {
		
		public function PagesContainer() {
			super();			
		}
		
		public function showPage($pageNum:int):void {
			var frame:String = 'page' + $pageNum.toString();
			this.gotoAndStop(frame);
		}
		
		public function showMorePage(param:String):void {
			this.dispatchEvent(new PagesContainerEvent(PagesContainerEvent.SHOW_MORE_PAGE, param));
		}
		
	}

}