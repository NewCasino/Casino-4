package com.shurba.shopsite.view.component {
	import com.shurba.shopsite.ApplicationFacade;
	import com.shurba.shopsite.model.SiteDataProxy;
	import com.shurba.shopsite.view.component.event.MenuEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class Menu extends MovieClip	{
		
		public var item1:MenuButton;
		public var item2:MenuButton;
		public var item3:MenuButton;
		public var item4:MenuButton;
		public var item5:MenuButton;
		
		private var prevButton:MenuButton;
		private var currentButton:MenuButton;
		
		public var items:Array;
		
		private var lastFrame:int = 0;		
		private var facade:ApplicationFacade = ApplicationFacade.getInstance();
		
		public function Menu() {
			super();
			this.addListeners();
			this.initButtons();			
		}
		
		private function addListeners():void {			
			
		}
		
		private function enterFramHandler(e:Event):void {
			if (lastFrame == this.currentFrame) {
				this.removeEventListener(Event.ENTER_FRAME, enterFramHandler);
			}
			lastFrame = this.currentFrame;			
		}
		
		private function itemClickHandler(e:MouseEvent):void {
			prevButton = currentButton;
			currentButton = e.currentTarget as MenuButton;
			if (facade.currentLink == currentButton.linkNumber && facade.animation) {
				return;
			}
			if (prevButton) {				
				prevButton.setNonactive();
			}
			
			this.dispatchEvent(new MenuEvent(MenuEvent.NAV_BUTTON_PRESSED, currentButton.linkNumber));
		}
		
		private function initButtons():void {
			var siteProxy:SiteDataProxy = facade.retrieveProxy(SiteDataProxy.NAME) as SiteDataProxy;
			items = [item1, item2, item3, item4, item5];
			for (var i:int = 0; i < items.length; i++) {
				(items[i] as MenuButton).itemNumber = i + 1;				
				(items[i] as MenuButton).linkNumber = siteProxy.getMenuSystemOrder(i);				
				(items[i] as MenuButton).itemLabel = siteProxy.getMenuLink(i);
				(items[i] as MenuButton).addEventListener(MouseEvent.CLICK, itemClickHandler, false, 0, true);	
			}
		}
		
	}

}