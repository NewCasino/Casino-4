package com.shurba.shopsite.view.component {
	import flash.display.*;
	import flash.events.*
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	
	public class SiteContent extends MovieClip {
		
		public var menu:Menu;
		public var pages:PagesContainer;
		
		public function SiteContent() {
			super();
			//stop();
		}
		
		/*
		 * Called from flash IDE timeline
		 *  
		 */		
		private function menuAdded():void {
			this.dispatchEvent(new Event('menuAddedToStage'));
		}
		
		
		/*
		 * Called from flash IDE timeline
		 *  
		 */
		private function turnPage():void {
			this.dispatchEvent(new Event('turnPageEvent'));
		}
	}

}