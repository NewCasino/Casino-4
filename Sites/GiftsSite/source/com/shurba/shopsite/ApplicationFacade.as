package com.shurba.shopsite {
	import com.shurba.shopsite.controller.*;
    import org.puremvc.as3.interfaces.IFacade;
    import org.puremvc.as3.patterns.facade.Facade;
    
    public class ApplicationFacade extends Facade implements IFacade {
        // Notification name constants
        public static const STARTUP:String  		= "startup";
        public static const SITE_RESIZE:String  	= "siteResize";
        public static const INITIALIZE_SITE:String  = "initializeSite";
        public static const SECTION_CHANGED:String  = "sectionChanged";
        public static const CHANGE_SECTION:String  = "changeSection";
		
		public var currentLink:int = 0;
		public var prevLink:int = 0;
		public var firstPage:int = 1;
		public var animation:Boolean = false;
		
		public var readMoreParameters:Array;
		

        public static function getInstance() : ApplicationFacade {
            if ( instance == null ) instance = new ApplicationFacade();
            return instance as ApplicationFacade;
        }

        /**
         * register StartupCommand with the Controller 
         */
        override protected function initializeController() : void {
            super.initializeController(); 
            /**
            * By registering StartupCommand with the STARTUP event, you're 
            * telling the framework that the StartupCommand is interested 
            * in listening for a STARTUP notification event. The Controller 
            * will add StartupCommand to its commandMap array and retrieve 
            * it when a Notification is dispatched.
            */
            registerCommand( STARTUP, StartupCommand );
            registerCommand( SITE_RESIZE, ResizeCommand );
            registerCommand( CHANGE_SECTION, ChangeSectionCommand );
        }
        
        public function startup( stage:Object ):void {
        	/**
        	 * Sending this notification will cause the execute() method in 
        	 * StartupCommand to be called as it's registered as a listener
        	 * of the STARTUP event.
        	 */
        	sendNotification( STARTUP, stage );
        }
        
    }
}