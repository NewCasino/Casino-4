package com.shurba.miltonsite.vo {
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class NewsVO {
		
		private var _newsDate:Date;
		private var _dateText:String;
		public var newsTitle:String;
		public var previewText:String;
		public var text1:String;
		public var text2:String;
		public var imageUrl:String;
		public var readMoreText:String;
		
		public function NewsVO($newsDate:Date = null, 
								$newsTitle:String = null, 
								$previewText:String = null, 
								$text1:String = null, 
								$text2:String = null,
								$imageUrl:String = null, 
								$readMoreText:String = null) {
								
			_newsDate = $newsDate;			
			newsTitle = $newsTitle;
			previewText = $previewText;
			text1 = $text1;
			text2 = $text2;
			imageUrl = $imageUrl;
			readMoreText = $readMoreText;
		}
		
		public function get dateText():String { 
			return _newsDate.getDate() + '-' + _newsDate.getMonth() + '-' + _newsDate.getFullYear();
		}
		
	}

}