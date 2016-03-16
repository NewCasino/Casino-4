package com.shurba.shopsite.view {
	import com.shurba.shopsite.ApplicationFacade;
	import com.shurba.shopsite.view.MenuMediator;
	import com.shurba.shopsite.view.component.SiteContent;
	import flash.events.Event;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class SiteContentMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "SiteContentMediator";
		
		public function SiteContentMediator( viewComponent:Object ) {
			super(NAME, viewComponent);
			siteContent.addEventListener('menuAddedToStage', menuAddedToStageHandler);
			siteContent.addEventListener('turnPageEvent', turnPageHandler);
		}
		
		private function turnPageHandler(e:Event):void {
			sendNotification(ApplicationFacade.SECTION_CHANGED);
		}
		
		private function menuAddedToStageHandler(e:Event):void {
			facade.registerMediator(new MenuMediator(siteContent.menu));
		}
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.CHANGE_SECTION];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch ( notification.getName() ) {
            	/**
            	 * If the notification sent has a name matching 
            	 * ApplicationFacade.INITIALIZE_SITE then this code block will execute
            	 */
                case ApplicationFacade.CHANGE_SECTION:     	
					siteContent.play();
                  	break;
            }
		}
		
		protected function get siteContent():SiteContent {
            return viewComponent as SiteContent;
        }
		
	}

}