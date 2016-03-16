package com.shurba.miltonsite.view {
	import com.greensock.TweenLite;
	import com.shurba.miltonsite.model.DataManager;
	import com.shurba.miltonsite.vo.NewsVO;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	
	 
	public class NewsItem extends Sprite {
		
		public static const PREVIEW_BACK_COLOR:int = 0x575759;
		public static const FULL_VIEW_BACK_COLOR:int = 0x858789;
		public static const TWEEN_DELAY:Number = 0.5;
		
		public var preview:NewsItemPreview;
		public var fullView:NewsItemFull;
		public var background:Shape;
		
		private var _data:NewsVO;
		
		private var dataManager:DataManager = DataManager.getInstance();
		
		
		
		public function NewsItem() {
			super();
			this.init();			
		}
		
		protected function init():void {
			this.removeChild(fullView);
			fullView.visible = false;
			this.addListeners();
		}
		
		protected function addListeners():void {
			preview.addEventListener("showMoreClick", showMoreHandler, false, 0, true);
			fullView.addEventListener("closeClick", closeFullViewHandler, false, 0, true);
			fullView.addEventListener("loadComplete", fullViewLoadCompleteHandler, false, 0, true);
		}
		
		private function fullViewLoadCompleteHandler(e:Event):void {
			this.addChild(fullView);
			fullView.visible = true;
			fullView.alpha = 0;
			TweenLite.to(fullView, TWEEN_DELAY, { alpha:1} );
		}
		
		private function closeFullViewHandler(e:Event):void {			
			TweenLite.to(fullView, TWEEN_DELAY, { alpha:0, onComplete:function():void { removeChild(fullView); } } );
			preview.visible = true;
			TweenLite.to(preview, TWEEN_DELAY, { alpha:1 } );
		}
		
		private function showMoreHandler(e:Event):void {
			TweenLite.to(preview, TWEEN_DELAY, { alpha:0, onComplete:function():void { preview.visible = false } } );
			fullView.loadContent();
		}
		
		protected function addBack():void {
			background = new Shape();
			this.addChild(background);
			background.graphics.beginFill(0xD8D7D3);
            background.graphics.lineStyle();
            background.graphics.drawRect(0, 0, DataManager.SITE_WIDTH, preview.height);
            background.graphics.endFill();
		}
		
		public function get data():NewsVO { 
			return _data; 
		}
		
		public function set data(value:NewsVO):void {
			_data = value;
			preview.data = value;
			fullView.data = value;
		}
		
	}

}