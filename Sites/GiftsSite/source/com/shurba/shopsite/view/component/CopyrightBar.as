package com.shurba.shopsite.view.component {
	import com.shurba.shopsite.ApplicationFacade;
	import com.shurba.shopsite.model.SiteDataProxy;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class CopyrightBar extends Sprite {
		
		public var copyText:TextField;
		public var soundController:SoundController;
		
		private var _copyrightText:String;		
		private var facade:ApplicationFacade = ApplicationFacade.getInstance();
		
		public function CopyrightBar() {
			super();
			copyText.condenseWhite = true;
			this.getCopyrightText();
		}
		
		private function getCopyrightText():void {
			var siteProxy:SiteDataProxy = facade.retrieveProxy(SiteDataProxy.NAME) as SiteDataProxy;
			this.copyrightText = siteProxy.getCopyright();
		}
		
		public function get copyrightText():String { 
			return _copyrightText;
		}
		
		public function set copyrightText(value:String):void {
			_copyrightText = value;			
			copyText.htmlText = value;
			trace (copyText.textWidth);
			soundController.x = copyText.x + copyText.textWidth + 250;
		}
		
	}

}