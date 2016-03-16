package com.shurba.miltonsite.model {
	import com.shurba.miltonsite.vo.NewsVO;
	import com.shurba.miltonsite.vo.SectionVO;

	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DataManager {
		
		public static const SITE_WIDTH:int = 297;

		private static var instance:DataManager;
		private static var allowInstantiation:Boolean;
		
		[Bindable]
		public var sectionsData:Array;
		public var newsData:SectionVO;

		public static function getInstance():DataManager {
			if (instance == null) {
				allowInstantiation = true;
				instance = new DataManager();
				allowInstantiation = false;
			}
			return instance;
		}

		public function DataManager ():void {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use DataManager.getInstance() instead of new.");
			}
		}
		
		public function parseNewsXML($xml:XML):void {			
			var xList:XMLList = new XMLList();
			xList =  $xml.children();			
			var tmpArray:Array = [];
			for (var i:int = 0; i < xList.length(); i++) {
				var dateNumbers:Array = xList[i].date.split('-');
				var tmpObj:NewsVO = new NewsVO(new Date(dateNumbers[2], dateNumbers[1], dateNumbers[0]),
												xList[i].title, 
												xList[i].previewtext,
												xList[i].text1,
												xList[i].text2,
												xList[i].imageurl,
												$xml.@readMoreText);				
				tmpArray.push(tmpObj);
			}
			newsData = new SectionVO($xml.@title, tmpArray);
		}
		
		public function parseSectionsXML($xml:XML):void {
			var xList:XMLList = new XMLList();
			xList =  $xml.children();
			sectionsData = [];
			for (var i:int = 0; i < xList.length(); i++) {				
				var tmpObj:Object = { };
				tmpObj.name = xList[i].@name;
				tmpObj.url = xList[i].@url;
				sectionsData.push(tmpObj);
			}
		}

		
	}
}