package com.shurba.miltonsite.view {
	import com.shurba.miltonsite.vo.SectionVO;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class NewsList extends Sprite {
		
		private var _dataProvider:SectionVO;
		public var items:Array;
		
		public var header:SectionHeaderLine;
		
		public function NewsList() {
			super();
			
		}
		
		protected function generateList():void {
			header = new SectionHeaderLine();
			this.addChild(header);
			header.txtTitle.text = _dataProvider.title;
			
			items = [];
			var tmpItem:NewsItem;
			for (var i:int = 0; i < _dataProvider.itemsData.length; i++) {
				tmpItem = new NewsItem();
				tmpItem.data = _dataProvider.itemsData[i];
				this.addChild(tmpItem);
				tmpItem.y = tmpItem.height * i + header.height;
				items.push(tmpItem);
			}
		}
		
		public function get dataProvider():SectionVO { 
			return _dataProvider; 
		}
		
		public function set dataProvider(value:SectionVO):void {
			_dataProvider = value;
			this.generateList();
		}
		
	}

}