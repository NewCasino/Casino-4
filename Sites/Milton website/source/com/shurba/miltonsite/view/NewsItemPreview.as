package com.shurba.miltonsite.view {
	import com.shurba.miltonsite.vo.NewsVO;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class NewsItemPreview extends Sprite {
		
		public var txtHeader:TextField;
		public var txtText:TextField;		
		public var btnReadMore:TextButton;
		
		private var _data:NewsVO;
		
		[Event (name="showMoreClick", type="flash.events.Event")]		
		
		public function NewsItemPreview() {
			super();
			this.init();
			//txtHeader.addEventListener(Event.RENDER
		}
		
		protected function init():void {
			this.addListeners();
		}
		
		protected function addListeners():void {
			btnReadMore.addEventListener(MouseEvent.CLICK, showMoreClickHandler, false, 0, true);
		}
		
		private function showMoreClickHandler(e:MouseEvent):void {
			this.dispatchEvent(new Event('showMoreClick'));
		}
		
		protected function drawInterface():void {
			txtHeader = new TextField();
			txtHeader.condenseWhite = true;
			this.addChild(txtHeader);			
			
			txtText = new TextField();
			txtText.condenseWhite = true;
			this.addChild(txtText);
		}
		
		public function get data():NewsVO { 
			return _data; 
		}
		
		public function set data(value:NewsVO):void {
			_data = value;
			btnReadMore.label = value.readMoreText;
			txtHeader.htmlText = value.dateText + ' | ' + value.newsTitle;
			txtText.htmlText = value.previewText;
		}
		
		
		
	}

}