package com.shurba {
	import com.shurba.components.dynamicMenu.DynamicMenu;
	import com.shurba.components.dynamicMenu.SectionVO;	
	import com.shurba.utils.ApplyStandartOptions;
	import com.shurba.utils.xml.XMLLoader;
	import flash.display.Shape;
	import flash.display.Sprite;	
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {
		
		private const MENU_XML_PATH:String = "data/menu.xml";
		
		public var dynamicMenu:DynamicMenu;
		
		private var xmlLoader:XMLLoader;
		
		
		
		public function DocumentClass() {
			super();
			if (stage) init();
				else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);			
			new ApplyStandartOptions(this);
			
			this.loadMenuXML();
		}
		
		protected function drawDisplayList():void {
			dynamicMenu = new DynamicMenu();
			this.addChild(dynamicMenu);
		}
		
		private function loadMenuXML():void {
			xmlLoader = new XMLLoader(MENU_XML_PATH, parseXML);
		}
		
		protected function parseXML($xml:XML):void {			
			this.recursiveSectionParsing($xml.children());
		}
		
		protected function recursiveSectionParsing($xmlList:XMLList):SectionVO {
			var sectionObject:SectionVO = new SectionVO();
			trace ($xmlList.@label);
			for (var i:int = 0; i < $xmlList.length(); i++) {				
				if ($xmlList.hasComplexContent()) {
					this.recursiveSectionParsing($xmlList.children());
				}
			}
			
			
			
			return sectionObject;
		}
		
	}

}