package com.stimuli.loading.loadingtypes
{
    import com.stimuli.loading.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class VideoItem extends LoadingItem
    {
        private var nc:NetConnection;
        var stream:NetStream;
        private var dummyEventTrigger:Sprite;
        private var _checkPolicyFile:Boolean;
        var pausedAtStart:Boolean = false;
        private var _metaData:Object;
        private var _canBeginStreaming:Boolean = false;

        public function VideoItem(param1:URLRequest, param2:String, param3:String)
        {
            specificAvailableProps = [BulkLoader.CHECK_POLICY_FILE, BulkLoader.PAUSED_AT_START];
            super(param1, param2, param3);
            return;
        }// end function

        override public function _parseOptions(param1:Object) : Array
        {
            pausedAtStart = param1[BulkLoader.PAUSED_AT_START] || false;
            _checkPolicyFile = param1[BulkLoader.CHECK_POLICY_FILE] || false;
            return super._parseOptions(param1);
        }// end function

        override public function load() : void
        {
            super.load();
            nc = new NetConnection();
            nc.connect(null);
            stream = new NetStream(nc);
            stream.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
            stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
            dummyEventTrigger = new Sprite();
            dummyEventTrigger.addEventListener(Event.ENTER_FRAME, createNetStreamEvent, false, 0, true);
            var customClient:* = new Object();
            customClient.onCuePoint = function (... args) : void
            {
                return;
            }// end function
            ;
            customClient.onMetaData = onVideoMetadata;
            customClient.onPlayStatus = function (... args) : void
            {
                return;
            }// end function
            ;
            stream.client = customClient;
            try
            {
                stream.play(url.url, _checkPolicyFile);
            }
            catch (e:SecurityError)
            {
                onSecurityErrorHandler(e);
            }
            stream.seek(0);
            return;
        }// end function

        public function createNetStreamEvent(event:Event) : void
        {
            var _loc_2:Event = null;
            var _loc_3:Event = null;
            var _loc_4:ProgressEvent = null;
            var _loc_5:int = 0;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            if (_bytesTotal == _bytesLoaded && _bytesTotal > 8)
            {
                if (dummyEventTrigger)
                {
                    dummyEventTrigger.removeEventListener(Event.ENTER_FRAME, createNetStreamEvent, false);
                }
                fireCanBeginStreamingEvent();
                _loc_2 = new Event(Event.COMPLETE);
                onCompleteHandler(_loc_2);
            }
            else if (_bytesTotal == 0 && stream.bytesTotal > 4)
            {
                _loc_3 = new Event(Event.OPEN);
                onStartedHandler(_loc_3);
                _bytesLoaded = stream.bytesLoaded;
                _bytesTotal = stream.bytesTotal;
            }
            else if (stream)
            {
                _loc_4 = new ProgressEvent(ProgressEvent.PROGRESS, false, false, stream.bytesLoaded, stream.bytesTotal);
                if (isVideo() && metaData && !_canBeginStreaming)
                {
                    _loc_5 = getTimer() - responseTime;
                    _loc_6 = bytesLoaded / (_loc_5 / 1000);
                    _bytesRemaining = _bytesTotal - bytesLoaded;
                    _loc_7 = _bytesRemaining / (_loc_6 * 0.8);
                    _loc_8 = metaData.duration - stream.bufferLength;
                    if (_loc_8 > _loc_7)
                    {
                        fireCanBeginStreamingEvent();
                    }
                }
                super.onProgressHandler(_loc_4);
            }
            return;
        }// end function

        override public function onCompleteHandler(event:Event) : void
        {
            _content = stream;
            super.onCompleteHandler(event);
            return;
        }// end function

        override public function onStartedHandler(event:Event) : void
        {
            _content = stream;
            if (pausedAtStart && stream)
            {
                stream.pause();
            }
            super.onStartedHandler(event);
            return;
        }// end function

        override public function stop() : void
        {
            try
            {
                if (stream)
                {
                    stream.close();
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
            if (stream)
            {
                stream.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false);
            }
            if (dummyEventTrigger)
            {
                dummyEventTrigger.removeEventListener(Event.ENTER_FRAME, createNetStreamEvent, false);
                dummyEventTrigger = null;
            }
            return;
        }// end function

        override public function isVideo() : Boolean
        {
            return true;
        }// end function

        override public function isStreamable() : Boolean
        {
            return true;
        }// end function

        override public function destroy() : void
        {
            if (stream)
            {
            }
            stop();
            cleanListeners();
            stream = null;
            super.destroy();
            return;
        }// end function

        function onNetStatus(event:NetStatusEvent) : void
        {
            var _loc_2:Event = null;
            if (!stream)
            {
                return;
            }
            stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false);
            if (event.info.code == "NetStream.Play.Start")
            {
                _content = stream;
                _loc_2 = new Event(Event.OPEN);
                onStartedHandler(_loc_2);
            }
            else if (event.info.code == "NetStream.Play.StreamNotFound")
            {
                onErrorHandler(event);
            }
            return;
        }// end function

        function onVideoMetadata(param1) : void
        {
            _metaData = param1;
            return;
        }// end function

        public function get metaData() : Object
        {
            return _metaData;
        }// end function

        public function get checkPolicyFile() : Object
        {
            return _checkPolicyFile;
        }// end function

        private function fireCanBeginStreamingEvent() : void
        {
            if (_canBeginStreaming)
            {
                return;
            }
            _canBeginStreaming = true;
            var _loc_1:* = new Event(BulkLoader.CAN_BEGIN_PLAYING);
            dispatchEvent(_loc_1);
            return;
        }// end function

    }
}
