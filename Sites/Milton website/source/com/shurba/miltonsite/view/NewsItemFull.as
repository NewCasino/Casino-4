package com.shurba.miltonsite.view {
	import com.shurba.miltonsite.vo.NewsVO;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class NewsItemFull extends Sprite {
		
		[Event (name="loadComplete", type="flash.events.Event")]
		[Event (name="closeClick", type="flash.events.Event")]
		
		public var txtHeader:TextField;
		public var txtTopText:TextField;
		public var txtBottomText:TextField;
		public var topShadow:Sprite;		
		public var bottomShadow:Sprite;
		
		public var closeButton:SimpleButton;
		
		private var _data:NewsVO;
		
		public function NewsItemFull() {
			super();
			this.init();
		}
		
		protected function init():void {
			txtHeader.condenseWhite = true;
			txtTopText.condenseWhite = true;
			txtBottomText.condenseWhite = true;
			this.addListeners();
		}
		
		protected function addListeners():void {
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler, false, 0, true);
		}
		
		private function closeButtonClickHandler(e:MouseEvent):void {
			this.dispatchEvent(new Event("closeClick"));
		}
		
		protected function thisResizeHandler():void {
			
		}
		
		public function loadContent():void {
			txtHeader.htmlText = _data.dateText + ' | ' + _data.newsTitle;
			txtTopText.htmlText = _data.text1;
			txtBottomText.htmlText = _data.text2;
			
			
			btnReadMore.label = value.readMoreText;
			txtHeader.htmlText = value.dateText + ' | ' + value.newsTitle;
			txtText.htmlText = value.previewText;
			
			
			this.dispatchEvent(new Event("loadComplete"));
		}
		
		public function get data():NewsVO { 
			return _data; 
		}
		
		public function set data(value:NewsVO):void {
			_data = value;
		}
		
	}

}