package com.shurba.shopsite.controller {
	import com.shurba.shopsite.view.*;
	import com.shurba.shopsite.view.component.*;
	import com.shurba.shopsite.view.SiteContentMediator;
	import flash.display.DisplayObject;	
	import flash.display.Stage;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ResizeCommand extends SimpleCommand implements ICommand {
		
		public function ResizeCommand() {
			super();			
		}
		
		override public function execute(notification:INotification):void {
			super.execute(notification);
			var stage:Stage = (facade.retrieveMediator(StageMediator.NAME) as StageMediator).getViewComponent() as Stage;
			if (facade.hasMediator(SiteContentMediator.NAME)) {
				var site:SiteContent = 
					(facade.retrieveMediator(SiteContentMediator.NAME) as SiteContentMediator).getViewComponent() as SiteContent;
				site.x = stage.stageWidth / 2;
				site.y = stage.stageHeight / 2;
			}
		}
		
	}

}