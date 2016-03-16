package com.shurba.shopsite.controller {
	import com.shurba.shopsite.ApplicationFacade;
	import com.shurba.shopsite.view.PagesContainerMediator;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ChangeSectionCommand extends SimpleCommand implements ICommand	{
		
		public function ChangeSectionCommand() {
			super();
			
		}
		
		override public function execute(notification:INotification):void {
			super.execute(notification);			
			(facade as ApplicationFacade).animation = true;
			
			
			if (isNaN(Number(notification.getBody())) ) {
				//readMoreType = number;
				(facade as ApplicationFacade).readMoreParameters = notification.getBody().split(',');
				
			} else {
				var frame:int = int(notification.getBody());
			}
			(facade as ApplicationFacade).currentLink = frame;		
		}
		
	}

}