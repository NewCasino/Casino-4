package com.shurba.shopsite.controller {
	import com.shurba.shopsite.model.SiteDataProxy;
	import com.shurba.shopsite.view.StageMediator;
	import flash.display.Stage;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class StartupCommand extends SimpleCommand implements ICommand {
		
		public function StartupCommand() {
			super();
			
		}
		
		override public function execute(notification:INotification):void {
			super.execute(notification);
			
			/**
			 * Get the View Components for the Mediators from the app,
         	 * which passed a reference to itself on the notification.
         	 */
	    	var stage:Stage = notification.getBody() as Stage;
            facade.registerMediator( new StageMediator( stage ) );
			
			/**
			 * Initializes a SiteDataProxy instance for loading site
			 * data via xml.
			 */
			facade.registerProxy( new SiteDataProxy() );
		}
		
	}

}