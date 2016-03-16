package com.shurba.shopsite.view.component {
	import com.shurba.shopsite.ApplicationFacade;
	import com.shurba.shopsite.model.SiteDataProxy;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class CompanyNameClip extends Sprite	{
		
		public var nameText:TextField;		
		private var facade:ApplicationFacade = ApplicationFacade.getInstance();
		
		private var _companyName:String;
		
		public function CompanyNameClip() {
			super();			
			this.init();
		}
		
		private function init():void {
			var siteProxy:SiteDataProxy = facade.retrieveProxy(SiteDataProxy.NAME) as SiteDataProxy;			
			nameText.condenseWhite = true;
			this.companyName = siteProxy.getCompanyName();
		}
		
		public function get companyName():String { 
			return _companyName;
		}
		
		public function set companyName(value:String):void {
			_companyName = value;
			nameText.htmlText = _companyName;
		}
		
		
	}

}