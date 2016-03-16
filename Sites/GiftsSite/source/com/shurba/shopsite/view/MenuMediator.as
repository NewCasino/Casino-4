package com.shurba.shopsite.view {
	import com.shurba.shopsite.ApplicationFacade;
	import com.shurba.shopsite.view.component.event.MenuEvent;
	import com.shurba.shopsite.view.component.Menu;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class MenuMediator extends Mediator implements IMediator	{
		
		public static const NAME:String = "MenuMediator";
		
		public function MenuMediator(viewComponent:Object = null) {
			super(NAME, viewComponent);
			menuComp.addEventListener(MenuEvent.NAV_BUTTON_PRESSED, navButtonPressedHandler, false, 0, true);
		}
		
		private function navButtonPressedHandler(e:MenuEvent):void {
			sendNotification(ApplicationFacade.CHANGE_SECTION, e.linkId);
		}
		
		override public function listNotificationInterests():Array {
			return super.listNotificationInterests();
		}
		
		override public function handleNotification(notification:INotification):void {
			super.handleNotification(notification);
		}
		
		public function get menuComp():Menu {
			return viewComponent as Menu;
		}
	}

}