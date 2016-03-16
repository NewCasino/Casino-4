package com.shurba.shopsite.view.component {
	import com.shurba.shopsite.ApplicationFacade;
	import com.shurba.shopsite.model.SiteDataProxy;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class CompanySloganClip extends Sprite {
		
		public var sloganText:TextField;
		private var _slogan:String;
		
		private var facade:ApplicationFacade = ApplicationFacade.getInstance();
		
		public function CompanySloganClip() {
			super();
			this.init();
		}		
		
		private function init():void {
			var siteProxy:SiteDataProxy = facade.retrieveProxy(SiteDataProxy.NAME) as SiteDataProxy;			
			sloganText.condenseWhite = true;
			this.slogan = siteProxy.getSlogan();
		}
		
		public function get slogan():String { 
			return _slogan;
		}
		
		public function set slogan(value:String):void {
			_slogan = value;
			sloganText.htmlText = _slogan;
		}
		
		
	}

}