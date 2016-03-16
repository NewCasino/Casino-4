package com.shurba.miltonsite.vo {
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class SectionVO {
		
		public var title:String;		
		public var itemsData:Array;
		
		public function SectionVO($title:String = null, $itemsData:Array = null) {
			title = $title;
			itemsData = $itemsData;
		}
		
	}

}