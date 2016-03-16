package com.shurba.miltonsite.view {
	import com.shurba.utils.xml.XMLLoader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class SiteHeader extends Sprite {
		
		
		private const THIS_WIDTH:int = 299;		
		
		public var background:Sprite;
		public var billetHitSpace:Sprite;
		
		protected var _dataProvider:Object;		
		
		private var _visualWidth:Number;
		private var _visualHeight:Number;
		
		
		
		public function SiteHeader() {
			super();
			
			this.init();
		}
		
		private function init():void {
			background.width = THIS_WIDTH;
			
			billetHitSpace.buttonMode = true;
			
			this.addListeners();
		}
		
		private function addListeners():void {
			billetHitSpace.addEventListener(MouseEvent.CLICK, billetClickHandler, false, 0, true);
		}
		
		private function billetClickHandler(e:MouseEvent):void {
			
		}
		
		public function get dataProvider():Object { 
			return _dataProvider; 
		}
		
		public function set dataProvider(value:Object):void {
			_dataProvider = value;
			this.initContent();
		}
		
		public function get visualWidth():Number { 
			return background.width; 
		}
		
		public function get visualHeight():Number { 
			return background.height; 
		}
		
		protected function initContent():void {
			
		}
		
		

		
	}

}