package com.stimuli.loading.loadingtypes
{
    import com.stimuli.loading.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class SoundItem extends LoadingItem
    {
        public var loader:Sound;

        public function SoundItem(param1:URLRequest, param2:String, param3:String)
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
            loader = new Sound();
            loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
            loader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false, 0, true);
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

        override public function onStartedHandler(event:Event) : void
        {
            _content = loader;
            super.onStartedHandler(event);
            return;
        }// end function

        override public function onErrorHandler(event:Event) : void
        {
            super.onErrorHandler(event);
            return;
        }// end function

        override public function onCompleteHandler(event:Event) : void
        {
            _content = loader;
            super.onCompleteHandler(event);
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
                loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false);
            }
            return;
        }// end function

        override public function isStreamable() : Boolean
        {
            return true;
        }// end function

        override public function isSound() : Boolean
        {
            return true;
        }// end function

        override public function destroy() : void
        {
            cleanListeners();
            stop();
            _content = null;
            loader = null;
            return;
        }// end function

    }
}
