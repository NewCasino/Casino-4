package com.shurba.shopsite.view.component.pages {
	import com.shurba.shopsite.ApplicationFacade;
	import com.shurba.shopsite.model.SiteDataProxy;
	import com.shurba.shopsite.view.component.PagesContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.TextEvent;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class Page3 extends Sprite {
		
		public var thisText0:TextField;
		public var thisText1:TextField;
		public var thisText2:TextField;
		public var thisText3:TextField;
		public var thisText4:TextField;
		public var thisText5:TextField;
		public var thisText6:TextField;
		
		private var facade:ApplicationFacade = ApplicationFacade.getInstance();
		
		public function Page3() {
			super();
			this.addListeners();
			this.updateTextFields();
		}
		
		private function addListeners():void {
			thisText0.addEventListener(TextEvent.LINK, asFuncShowDetails, false, 0, true);
			thisText1.addEventListener(TextEvent.LINK, asFuncShowDetails, false, 0, true);
			thisText2.addEventListener(TextEvent.LINK, asFuncShowDetails, false, 0, true);
			thisText3.addEventListener(TextEvent.LINK, asFuncShowDetails, false, 0, true);
			thisText4.addEventListener(TextEvent.LINK, asFuncShowDetails, false, 0, true);
			thisText5.addEventListener(TextEvent.LINK, asFuncShowDetails, false, 0, true);
			thisText6.addEventListener(TextEvent.LINK, asFuncShowDetails, false, 0, true);
		}
		
		private function asFuncShowDetails(e:TextEvent):void {
			(parent as PagesContainer).showMorePage(e.text);
		}
		
		public function updateTextFields():void {
			var siteProxy:SiteDataProxy = facade.retrieveProxy(SiteDataProxy.NAME) as SiteDataProxy;
			
			for (var i:int = 0; i < 7; i++) {
				var tField:TextField = this['thisText' + i.toString()] as TextField;
				tField.condenseWhite = true;
				tField.htmlText = siteProxy.getCurrentText(i);
			}
		}
		
	}

}