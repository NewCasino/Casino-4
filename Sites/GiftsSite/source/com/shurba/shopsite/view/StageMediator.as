package com.shurba.shopsite.view {
	import com.shurba.shopsite.ApplicationFacade;
	import com.shurba.shopsite.view.component.*;
	import flash.display.Stage;
	import flash.events.Event;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class StageMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "StageMediator";
		
		public function StageMediator( viewComponent:Object ) {
            /**
             * pass the viewComponent to the superclass where 
             * it will be stored in the inherited viewComponent property
             */
            super( NAME, viewComponent );
        }
		
		/**
		 * StageMediator lists the INITIALIZE_SITE notification as an 
		 * event of interest. You may list as many notification 
		 * interests as needed.
		 */
        override public function listNotificationInterests():Array {
            return [ 
            		ApplicationFacade.INITIALIZE_SITE
                   ];
        }

        /**
         * Called by the framework when a notification is sent that
         * this mediator expressed an interest in.
         */
        override public function handleNotification( note:INotification ):void {
            switch ( note.getName() ) {
            	/**
            	 * If the notification sent has a name matching 
            	 * ApplicationFacade.INITIALIZE_SITE then this code block will execute
            	 */
                case ApplicationFacade.INITIALIZE_SITE:     	
					initializeSite();
                  	break;
            }
        }
        
        /**
        * Called to handle the INITIALIZE_SITE notification.        
        * PureMVC functionality to the varies view components of the application.
        */
        private function initializeSite():void {
			stage.addEventListener(Event.RESIZE, resizeStageHandler);
			var site:SiteContent = new SiteContent();			
        	facade.registerMediator( new SiteContentMediator( site ) );        	
        	facade.registerMediator( new PagesContainerMediator( site.pages ) );        	
        	stage.addChild( site );
			sendNotification(ApplicationFacade.SITE_RESIZE);
        }
		
		private function resizeStageHandler(e:Event):void {
			sendNotification(ApplicationFacade.SITE_RESIZE);
		}

		/**
		 * Retrieves the viewComponent and casting it to type Stage
		 */
        protected function get stage():Stage {
            return viewComponent as Stage;
        }
		
	}

}