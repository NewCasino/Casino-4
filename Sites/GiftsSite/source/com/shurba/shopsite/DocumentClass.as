package com.shurba.shopsite {
	
	import flash.display.*;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {
		
		private var facade:ApplicationFacade;
		
		public function DocumentClass() {
			super();	
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			facade = ApplicationFacade.getInstance();
			facade.startup(this.stage);
		}
		
	}

}