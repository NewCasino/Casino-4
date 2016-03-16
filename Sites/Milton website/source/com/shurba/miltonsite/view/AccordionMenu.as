package com.shurba.miltonsite.view {
	import com.shurba.utils.xml.XMLLoader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class AccordionMenu extends Sprite {
		
		private const SECTIONS_XML_PATH:String = 'data/sections.xml';
		private const THIS_WIDTH:int = 299;		
		
		public var background:Sprite;
		public var billetHitSpace:Sprite;
		
		protected var _dataProvider:Object;		
		protected var buttons:Array;
		
		private var _visualWidth:Number;
		private var _visualHeight:Number;
		
		private var xmlLoader:XMLLoader;
		
		public function AccordionMenu() {
			super();
			
			this.init();
		}
		
		private function init():void {
			background.width = THIS_WIDTH;
			
			billetHitSpace.buttonMode = true;
			
			this.addListeners();
			
			this.loadSectionsXML();
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
		
		protected function loadSectionsXML():void {
			
			xmlLoader = new XMLLoader(SECTIONS_XML_PATH, sectionsLoaded);
		}
		
		protected function sectionsLoaded($xml:XML):void {			
			var xList:XMLList = new XMLList();
			xList =  $xml.children();
			var menuDataObjects:Array = [];
			trace($xml);
			for (var i:int = 0; i < xList.length(); i++) {				
				var tmpObj:Object = { };
				tmpObj.name = xList[i].@name;
				tmpObj.url = xList[i].@url;
				menuDataObjects.push(tmpObj);
			}
		}

		
	}

}