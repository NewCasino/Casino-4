package com.stimuli.loading.loadingtypes
{
    import com.stimuli.loading.*;
    import flash.events.*;
    import flash.net.*;

    public class XMLItem extends LoadingItem
    {
        public var loader:URLLoader;

        public function XMLItem(param1:URLRequest, param2:String, param3:String)
        {
            super(param1, param2, param3);
            return;
        }// end function

        override public function _parseOptions(param1:Object) : Array
        {
            return super._parseOptions(param1);
        }// end function

        override public function load() : void
        {
            super.load();
            loader = new URLLoader();
            loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false, 0, true);
            loader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
            try
            {
                loader.load(url);
            }
            catch (e:SecurityError)
            {
                onSecurityErrorHandler(e);
            }
            return;
        }// end function

        override public function onErrorHandler(event:Event) : void
        {
            super.onErrorHandler(event);
            return;
        }// end function

        override public function onStartedHandler(event:Event) : void
        {
            super.onStartedHandler(event);
            return;
        }// end function

        override public function onCompleteHandler(event:Event) : void
        {
            var bulkErrorEvent:BulkErrorEvent;
            var evt:* = event;
            try
            {
                _content = new XML(loader.data);
            }
            catch (e:Error)
            {
                _content = null;
                status = STATUS_ERROR;
                bulkErrorEvent = new BulkErrorEvent(BulkErrorEvent.ERROR);
                bulkErrorEvent.errors = [this];
                dispatchEvent(bulkErrorEvent);
            }
            super.onCompleteHandler(evt);
            return;
        }// end function

        override public function stop() : void
        {
            try
            {
                if (loader)
                {
                    loader.close();
                }
            }
            catch (e:Error)
            {
            }
            super.stop();
            return;
        }// end function

        override public function cleanListeners() : void
        {
            if (loader)
            {
                loader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
                loader.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
                loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                loader.removeEventListener(BulkLoader.OPEN, onStartedHandler, false);
                loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
                loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false);
            }
            return;
        }// end function

        override public function isText() : Boolean
        {
            return true;
        }// end function

        override public function destroy() : void
        {
            stop();
            cleanListeners();
            _content = null;
            loader = null;
            return;
        }// end function

    }
}
