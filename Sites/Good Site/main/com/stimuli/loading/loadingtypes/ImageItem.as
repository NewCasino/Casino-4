package com.stimuli.loading.loadingtypes {
	
	import com.stimuli.loading.BulkLoader;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
    /** @private */
	public class ImageItem extends LoadingItem {
        public var loader : Loader;
        
		public function ImageItem(url : URLRequest, type : String, uid : String){
			specificAvailableProps = [BulkLoader.CONTEXT];
			super(url, type, uid);
		}
		
		override public function _parseOptions(props : Object)  : Array{
            _context = props[BulkLoader.CONTEXT] || null;
            
            return super._parseOptions(props);
        }
        
		override public function load() : void{
		    super.load();
		    loader = new Loader();
		    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 100, true);
            loader.contentLoaderInfo.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
            //loader.content.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);  
            loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
            try{
            	// TODO: test for security error thown.
            	loader.load(url, _context);
            }catch( e : SecurityError){
            	onSecurityErrorHandler(e);
            }
            
		};
		
        public function _onHttpStatusHandler(evt : HTTPStatusEvent) : void{
            _httpStatus = evt.status;
            dispatchEvent(evt);
        }
        
        override public function onErrorHandler(evt : Event) : void{
            super.onErrorHandler(evt);
        }
        
        override public function onCompleteHandler(evt : Event) : void {
        	// TODO: test for the different behaviour when loading items with 
        	// the a specific crossdomain and without one
        	try{
        		// of no crossdomain has allowed this operation, this might
        		// raise a security error
	            _content = loader.content;
	            super.onCompleteHandler(evt);
	        }catch(e : SecurityError){
	        	// we can still use the Loader object (no dice for accessing it as data
	        	// though. Oh boy:
	        	_content = loader;
	        	super.onCompleteHandler(evt);
	        	// I am really unsure whether I should throw this event
	        	// it would be nice, but simply delegating the error handling to user's code 
	        	// seems cleaner (and it also mimics the Standar API behaviour on this respect)
	        	//onSecurityErrorHandler(e);
	        }
            
        };
        
        override public function stop() : void{
            try{
                if(loader){
                    loader.close();
                }
            }catch(e : Error){
                
            }
            super.stop();
        };
        
        override public function cleanListeners() : void {
            if (loader){
                var removalTarget : Object = loader.contentLoaderInfo;
                removalTarget.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
                removalTarget.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
                removalTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                removalTarget.removeEventListener(BulkLoader.OPEN, onStartedHandler, false);
                removalTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
            }
            
        }
        
        override public function isImage(): Boolean{
            return (type == BulkLoader.TYPE_IMAGE);
        }
        
        override public function isSWF(): Boolean{
            return (type == BulkLoader.TYPE_MOVIECLIP);
        }
        
        override public function destroy() : void{
            stop();
            cleanListeners();
            _content = null;
            loader = null;
        }
        
        
	}
	
}
