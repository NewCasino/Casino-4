package com.stimuli.loading.loadingtypes
{
    import com.stimuli.loading.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class ImageItem extends LoadingItem
    {
        public var loader:Loader;

        public function ImageItem(param1:URLRequest, param2:String, param3:String)
        {
            specificAvailableProps = [BulkLoader.CONTEXT];
            super(param1, param2, param3);
            return;
        }// end function

        override public function _parseOptions(param1:Object) : Array
        {
            _context = param1[BulkLoader.CONTEXT] || null;
            return super._parseOptions(param1);
        }// end function

        override public function load() : void
        {
            super.load();
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 100, true);
            loader.contentLoaderInfo.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
            try
            {
                loader.load(url, _context);
            }
            catch (e:SecurityError)
            {
                onSecurityErrorHandler(e);
            }
            return;
        }// end function

        public function _onHttpStatusHandler(event:HTTPStatusEvent) : void
        {
            _httpStatus = event.status;
            dispatchEvent(event);
            return;
        }// end function

        override public function onErrorHandler(event:Event) : void
        {
            super.onErrorHandler(event);
            return;
        }// end function

        override public function onCompleteHandler(event:Event) : void
        {
            var evt:* = event;
            try
            {
                _content = loader.content;
                super.onCompleteHandler(evt);
            }
            catch (e:SecurityError)
            {
                _content = loader;
                super.onCompleteHandler(evt);
            }
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
            var _loc_1:Object = null;
            if (loader)
            {
                _loc_1 = loader.contentLoaderInfo;
                _loc_1.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
                _loc_1.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
                _loc_1.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                _loc_1.removeEventListener(BulkLoader.OPEN, onStartedHandler, false);
                _loc_1.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
            }
            return;
        }// end function

        override public function isImage() : Boolean
        {
            return type == BulkLoader.TYPE_IMAGE;
        }// end function

        override public function isSWF() : Boolean
        {
            return type == BulkLoader.TYPE_MOVIECLIP;
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
