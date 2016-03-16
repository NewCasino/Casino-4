package com.control {	
	import flash.events.EventDispatcher;
	
	public class SizeManager extends EventDispatcher {
		
		public static var sizeManager:SizeManager;
		
		public function SizeManager() {
			if (sizeManager) {
				throw new Error( "Only one SizeManager instance should be instantiated" );
			} else {
				this.init();
			}
		}
		
		public static function getInstance():SizeManager {			
			if (sizeManager == null) {
				this.init();
			}
			return sizeManager;
		}
		
		private function init():void {
			sizeManager = new SizeManager();
		}
		
		private function addListeners():void {
			stage.addEventListener(Event.RESIZE, onStageResizeHandler);
		}
		
		private function removeListeners():void {			
			this.loaderInfo.removeEventListener(Event.INIT, loadInitHandler);
		}
		
		
		private function onLoadComplete():void {
			
		}		
		
	}
}