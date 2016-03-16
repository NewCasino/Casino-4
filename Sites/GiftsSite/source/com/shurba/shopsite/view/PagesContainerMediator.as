package com.shurba.shopsite.view {
	import com.shurba.shopsite.ApplicationFacade;
	import com.shurba.shopsite.view.component.event.PagesContainerEvent;
	import com.shurba.shopsite.view.component.PagesContainer;
	import flash.events.Event;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class PagesContainerMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "PagesContainerMediator";
		
		public function PagesContainerMediator(viewComponent:Object = null) {
			super(NAME, viewComponent);
			pagesComp.addEventListener(PagesContainerEvent.SHOW_MORE_PAGE, showMorePageEventHandler, false, 0, true);
		}
		
		private function showMorePageEventHandler(e:PagesContainerEvent):void {
			sendNotification(ApplicationFacade.CHANGE_SECTION, e.params);
		}
		
		
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.SECTION_CHANGED];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch ( notification.getName() ) {
            	/**
            	 * If the notification sent has a name matching 
            	 * ApplicationFacade.INITIALIZE_SITE then this code block will execute
            	 */
                case ApplicationFacade.SECTION_CHANGED:
					pagesComp.showPage((facade as ApplicationFacade).currentLink);					
                  	break;
            }
		}
		
		public function get pagesComp():PagesContainer {
			return viewComponent as PagesContainer;
		} 
		
	}

}