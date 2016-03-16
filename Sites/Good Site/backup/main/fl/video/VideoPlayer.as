package fl.video
{
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class VideoPlayer extends Video
    {
        protected var _align:String;
        protected var _registrationWidth:Number;
        var _updateProgressTimer:Timer;
        var _atEndCheckPlayhead:Number;
        var _hiddenForResize:Boolean;
        var startProgressTime:Number;
        protected var _volume:Number;
        var _invalidSeekTime:Boolean;
        var _readyDispatched:Boolean;
        var lastUpdateTimeStuckCount:Number;
        protected var _ns:NetStream;
        protected var _isLive:Boolean;
        var _bufferState:String;
        protected var _streamLength:Number;
        var _rtmpDoSeekTimer:Timer;
        protected var _contentPath:String;
        var lastUpdateTimeStuckCountMax:int = 10;
        protected var _metadata:Object;
        protected var __visible:Boolean;
        var autoResizeMetadataDelayMax:Number = 5;
        protected var _scaleMode:String;
        var _lastUpdateTime:Number;
        var _sawPlayStop:Boolean;
        var _atEnd:Boolean;
        var _sawSeekNotify:Boolean;
        var _idleTimeoutTimer:Timer;
        var _prevVideoWidth:int;
        protected var _registrationX:Number;
        protected var _registrationY:Number;
        protected var _bufferTime:Number;
        var _cachedState:String;
        var totalDownloadTime:Number;
        var _cachedPlayheadTime:Number;
        protected var _autoPlay:Boolean;
        protected var _autoRewind:Boolean;
        var _invalidSeekRecovery:Boolean;
        var _hiddenRewindPlayheadTime:Number;
        var _prevVideoHeight:int;
        protected var _ncMgr:INCManager;
        protected var _soundTransform:SoundTransform;
        var _httpDoSeekCount:Number;
        var oldRegistrationBounds:Rectangle;
        var _cmdQueue:Array;
        var _updateTimeTimer:Timer;
        var httpDoSeekMaxCount:Number = 4;
        var _startingPlay:Boolean;
        var baselineProgressTime:Number;
        var _autoResizeTimer:Timer;
        var _autoResizeDone:Boolean;
        var _httpDoSeekTimer:Timer;
        protected var _state:String;
        protected var _videoWidth:int;
        var _finishAutoResizeTimer:Timer;
        var _resizeImmediatelyOnMetadata:Boolean;
        var _currentPos:Number;
        var oldBounds:Rectangle;
        protected var _videoHeight:int;
        var waitingForEnough:Boolean;
        var _delayedBufferingTimer:Timer;
        protected var _registrationHeight:Number;
        var _hiddenForResizeMetadataDelay:Number;
        var autoResizePlayheadTimeout:Number = 0.5;
        var _rtmpDoStopAtEndTimer:Timer;
        var _lastSeekTime:Number;
        var totalProgressTime:Number;
        public static var netStreamClientClass:Object = VideoPlayerClient;
        public static var iNCManagerClass:Object = "fl.video.NCManager";
        static const FINISH_AUTO_RESIZE_INTERVAL:Number = 250;
        static const DEFAULT_AUTO_RESIZE_PLAYHEAD_TIMEOUT:Number = 0.5;
        static const DEFAULT_AUTO_RESIZE_METADATA_DELAY_MAX:Number = 5;
        public static const SHORT_VERSION:String = "2.1";
        static const HTTP_DO_SEEK_INTERVAL:Number = 250;
        static const DEFAULT_HTTP_DO_SEEK_MAX_COUNT:Number = 4;
        static const RTMP_DO_SEEK_INTERVAL:Number = 100;
        static const HTTP_DELAYED_BUFFERING_INTERVAL:Number = 100;
        public static const DEFAULT_UPDATE_TIME_INTERVAL:Number = 250;
        static var BUFFER_FLUSH:String = "bufferFlush";
        static var BUFFER_FULL:String = "bufferFull";
        static const AUTO_RESIZE_INTERVAL:Number = 100;
        public static const DEFAULT_IDLE_TIMEOUT_INTERVAL:Number = 300000;
        static const DEFAULT_LAST_UPDATE_TIME_STUCK_COUNT_MAX:int = 10;
        static const RTMP_DO_STOP_AT_END_INTERVAL:Number = 500;
        static var BUFFER_EMPTY:String = "bufferEmpty";
        public static const VERSION:String = "2.1.0.14";
        public static const DEFAULT_UPDATE_PROGRESS_INTERVAL:Number = 250;

        public function VideoPlayer(param1:int = 320, param2:int = 240)
        {
            autoResizePlayheadTimeout = DEFAULT_AUTO_RESIZE_PLAYHEAD_TIMEOUT;
            autoResizeMetadataDelayMax = DEFAULT_AUTO_RESIZE_METADATA_DELAY_MAX;
            httpDoSeekMaxCount = DEFAULT_HTTP_DO_SEEK_MAX_COUNT;
            lastUpdateTimeStuckCountMax = DEFAULT_LAST_UPDATE_TIME_STUCK_COUNT_MAX;
            super(param1, param2);
            _registrationX = x;
            _registrationY = y;
            _registrationWidth = param1;
            _registrationHeight = param2;
            _state = VideoState.DISCONNECTED;
            _cachedState = _state;
            _bufferState = BUFFER_EMPTY;
            _sawPlayStop = false;
            _cachedPlayheadTime = 0;
            _metadata = null;
            _startingPlay = false;
            _invalidSeekTime = false;
            _invalidSeekRecovery = false;
            _currentPos = 0;
            _atEnd = false;
            _streamLength = 0;
            _cmdQueue = new Array();
            _readyDispatched = false;
            _autoResizeDone = false;
            _lastUpdateTime = NaN;
            lastUpdateTimeStuckCount = 0;
            _sawSeekNotify = false;
            _hiddenForResize = false;
            _hiddenForResizeMetadataDelay = 0;
            _resizeImmediatelyOnMetadata = false;
            _videoWidth = -1;
            _videoHeight = -1;
            _prevVideoWidth = 0;
            _prevVideoHeight = 0;
            _updateTimeTimer = new Timer(DEFAULT_UPDATE_TIME_INTERVAL);
            _updateTimeTimer.addEventListener(TimerEvent.TIMER, doUpdateTime);
            _updateProgressTimer = new Timer(DEFAULT_UPDATE_PROGRESS_INTERVAL);
            _updateProgressTimer.addEventListener(TimerEvent.TIMER, doUpdateProgress);
            _idleTimeoutTimer = new Timer(DEFAULT_IDLE_TIMEOUT_INTERVAL, 1);
            _idleTimeoutTimer.addEventListener(TimerEvent.TIMER, doIdleTimeout);
            _autoResizeTimer = new Timer(AUTO_RESIZE_INTERVAL);
            _autoResizeTimer.addEventListener(TimerEvent.TIMER, doAutoResize);
            _rtmpDoStopAtEndTimer = new Timer(RTMP_DO_STOP_AT_END_INTERVAL);
            _rtmpDoStopAtEndTimer.addEventListener(TimerEvent.TIMER, rtmpDoStopAtEnd);
            _rtmpDoSeekTimer = new Timer(RTMP_DO_SEEK_INTERVAL);
            _rtmpDoSeekTimer.addEventListener(TimerEvent.TIMER, rtmpDoSeek);
            _httpDoSeekTimer = new Timer(HTTP_DO_SEEK_INTERVAL);
            _httpDoSeekTimer.addEventListener(TimerEvent.TIMER, httpDoSeek);
            _httpDoSeekCount = 0;
            _finishAutoResizeTimer = new Timer(FINISH_AUTO_RESIZE_INTERVAL, 1);
            _finishAutoResizeTimer.addEventListener(TimerEvent.TIMER, finishAutoResize);
            _delayedBufferingTimer = new Timer(HTTP_DELAYED_BUFFERING_INTERVAL);
            _delayedBufferingTimer.addEventListener(TimerEvent.TIMER, doDelayedBuffering);
            _isLive = false;
            _align = VideoAlign.CENTER;
            _scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
            _autoPlay = true;
            _autoRewind = false;
            _bufferTime = 0.1;
            _soundTransform = new SoundTransform();
            _volume = _soundTransform.volume;
            __visible = true;
            _contentPath = "";
            waitingForEnough = false;
            baselineProgressTime = NaN;
            startProgressTime = NaN;
            totalDownloadTime = NaN;
            totalProgressTime = NaN;
            return;
        }// end function

        public function get playheadTime() : Number
        {
            var _loc_1:Number = NaN;
            _loc_1 = _ns == null ? (_currentPos) : (_ns.time);
            if (_metadata != null && _metadata.audiodelay != undefined)
            {
                _loc_1 = _loc_1 - _metadata.audiodelay;
                if (_loc_1 < 0)
                {
                    _loc_1 = 0;
                }
            }
            return _loc_1;
        }// end function

        public function stop() : void
        {
            if (!isXnOK())
            {
                if (_state == VideoState.CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
                {
                    throw new VideoError(VideoError.NO_CONNECTION);
                }
                return;
            }
            else if (_state == VideoState.EXEC_QUEUED_CMD)
            {
                _state = _cachedState;
            }
            else
            {
                if (!stateResponsive)
                {
                    queueCmd(QueuedCommand.STOP);
                    return;
                }
                execQueuedCmds();
            }
            if (_state == VideoState.STOPPED || _ns == null)
            {
                return;
            }
            if (_ncMgr.isRTMP)
            {
                if (_autoRewind && !_isLive)
                {
                    _currentPos = 0;
                    _play(0, 0);
                    _state = VideoState.STOPPED;
                    setState(VideoState.REWINDING);
                }
                else
                {
                    closeNS(true);
                    setState(VideoState.STOPPED);
                }
            }
            else
            {
                _pause(true);
                if (_autoRewind)
                {
                    _seek(0);
                    _state = VideoState.STOPPED;
                    setState(VideoState.REWINDING);
                }
                else
                {
                    setState(VideoState.STOPPED);
                }
            }
            return;
        }// end function

        function execQueuedCmds() : void
        {
            var nextCmd:Object;
            while (_cmdQueue.length > 0 && (stateResponsive || _state == VideoState.DISCONNECTED || _state == VideoState.CONNECTION_ERROR) && (_cmdQueue[0].url != null || _state != VideoState.DISCONNECTED && _state != VideoState.CONNECTION_ERROR))
            {
                
                nextCmd = _cmdQueue.shift();
                _cachedState = _state;
                _state = VideoState.EXEC_QUEUED_CMD;
                switch(nextCmd.type)
                {
                    case QueuedCommand.PLAY:
                    {
                        play(nextCmd.url, nextCmd.time, nextCmd.isLive);
                        break;
                    }
                    case QueuedCommand.LOAD:
                    {
                        load(nextCmd.url, nextCmd.time, nextCmd.isLive);
                        break;
                    }
                    case QueuedCommand.PAUSE:
                    {
                        pause();
                        break;
                    }
                    case QueuedCommand.STOP:
                    {
                        stop();
                        break;
                    }
                    case QueuedCommand.SEEK:
                    {
                        seek(nextCmd.time);
                        break;
                    }
                    case QueuedCommand.PLAY_WHEN_ENOUGH:
                    {
                        playWhenEnoughDownloaded();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                finally
                {
                    var _loc_2:* = new catch0;
                    throw 0;
                }
                finally
                {
                    if (_state == VideoState.EXEC_QUEUED_CMD)
                    {
                        _state = _cachedState;
                    }
                }
            }
            return;
        }// end function

        public function setScale(param1:Number, param2:Number) : void
        {
            super.scaleX = param1;
            super.scaleY = param2;
            _registrationWidth = width;
            _registrationHeight = height;
            switch(_scaleMode)
            {
                case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
                case VideoScaleMode.NO_SCALE:
                {
                    startAutoResize();
                    break;
                }
                default:
                {
                    super.x = _registrationX;
                    super.y = _registrationY;
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function set playheadTime(param1:Number) : void
        {
            seek(param1);
            return;
        }// end function

        override public function get videoWidth() : int
        {
            if (_videoWidth > 0)
            {
                return _videoWidth;
            }
            if (_metadata != null && !isNaN(_metadata.width) && !isNaN(_metadata.height))
            {
                if (_metadata.width == _metadata.height && _readyDispatched)
                {
                    return super.videoWidth;
                }
                return int(_metadata.width);
            }
            if (_readyDispatched)
            {
                return super.videoWidth;
            }
            return -1;
        }// end function

        public function get scaleMode() : String
        {
            return _scaleMode;
        }// end function

        public function get progressInterval() : Number
        {
            return _updateProgressTimer.delay;
        }// end function

        public function set align(param1:String) : void
        {
            if (_align != param1)
            {
                switch(param1)
                {
                    case VideoAlign.CENTER:
                    case VideoAlign.TOP:
                    case VideoAlign.LEFT:
                    case VideoAlign.BOTTOM:
                    case VideoAlign.RIGHT:
                    case VideoAlign.TOP_LEFT:
                    case VideoAlign.TOP_RIGHT:
                    case VideoAlign.BOTTOM_LEFT:
                    case VideoAlign.BOTTOM_RIGHT:
                    {
                        break;
                    }
                    default:
                    {
                        return;
                        break;
                    }
                }
                _align = param1;
                switch(_scaleMode)
                {
                    case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
                    case VideoScaleMode.NO_SCALE:
                    {
                        startAutoResize();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        public function set scaleMode(param1:String) : void
        {
            if (_scaleMode != param1)
            {
                switch(param1)
                {
                    case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
                    case VideoScaleMode.NO_SCALE:
                    case VideoScaleMode.EXACT_FIT:
                    {
                        break;
                    }
                    default:
                    {
                        return;
                        break;
                    }
                }
                if (_scaleMode == VideoScaleMode.EXACT_FIT && _resizeImmediatelyOnMetadata && (_videoWidth < 0 || _videoHeight < 0))
                {
                    _resizeImmediatelyOnMetadata = false;
                }
                _scaleMode = param1;
                startAutoResize();
            }
            return;
        }// end function

        public function get source() : String
        {
            return _contentPath;
        }// end function

        function doUpdateTime(event:TimerEvent = null) : void
        {
            var _loc_2:Number = NaN;
            _loc_2 = playheadTime;
            if (_loc_2 != _atEndCheckPlayhead)
            {
                _atEndCheckPlayhead = NaN;
            }
            switch(_state)
            {
                case VideoState.STOPPED:
                case VideoState.PAUSED:
                case VideoState.DISCONNECTED:
                case VideoState.CONNECTION_ERROR:
                {
                    _updateTimeTimer.stop();
                    break;
                }
                case VideoState.PLAYING:
                case VideoState.BUFFERING:
                {
                    if (_ncMgr != null && !_ncMgr.isRTMP && _lastUpdateTime == _loc_2 && _ns != null && _ns.bytesLoaded == _ns.bytesTotal)
                    {
                        if (lastUpdateTimeStuckCount > lastUpdateTimeStuckCountMax)
                        {
                            lastUpdateTimeStuckCount = 0;
                            httpDoStopAtEnd();
                        }
                        else
                        {
                            var _loc_4:* = lastUpdateTimeStuckCount + 1;
                            lastUpdateTimeStuckCount = _loc_4;
                        }
                    }
                }
                default:
                {
                    break;
                }
            }
            if (_lastUpdateTime != _loc_2)
            {
                dispatchEvent(new VideoEvent(VideoEvent.PLAYHEAD_UPDATE, false, false, _state, _loc_2));
                _lastUpdateTime = _loc_2;
                lastUpdateTimeStuckCount = 0;
            }
            return;
        }// end function

        function rtmpNetStatus(event:NetStatusEvent) : void
        {
            if (_state == VideoState.CONNECTION_ERROR)
            {
                return;
            }
            switch(event.info.code)
            {
                case "NetStream.Play.Stop":
                {
                    if (_startingPlay)
                    {
                        return;
                    }
                    switch(_state)
                    {
                        case VideoState.RESIZING:
                        {
                            if (_hiddenForResize)
                            {
                                finishAutoResize();
                            }
                            break;
                        }
                        case VideoState.LOADING:
                        case VideoState.STOPPED:
                        case VideoState.PAUSED:
                        {
                            break;
                        }
                        default:
                        {
                            _sawPlayStop = true;
                            if (!_rtmpDoStopAtEndTimer.running && (_bufferState == BUFFER_FLUSH || _ns.bufferTime <= 0.1 && _ns.bufferLength <= 0.1))
                            {
                                _cachedPlayheadTime = playheadTime;
                                _rtmpDoStopAtEndTimer.reset();
                                _rtmpDoStopAtEndTimer.start();
                            }
                            break;
                            break;
                        }
                    }
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    switch(_bufferState)
                    {
                        case BUFFER_FULL:
                        {
                            if (_sawPlayStop)
                            {
                                rtmpDoStopAtEnd();
                            }
                            else if (_state == VideoState.PLAYING)
                            {
                                setState(VideoState.BUFFERING);
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _bufferState = BUFFER_EMPTY;
                    _sawPlayStop = false;
                    break;
                }
                case "NetStream.Buffer.Flush":
                {
                    if (_sawSeekNotify && _state == VideoState.SEEKING)
                    {
                        _bufferState = BUFFER_EMPTY;
                        _sawPlayStop = false;
                        setStateFromCachedState(false);
                        doUpdateTime();
                        execQueuedCmds();
                    }
                    if (!_rtmpDoStopAtEndTimer.running && _sawPlayStop && (_bufferState == BUFFER_EMPTY || _ns.bufferTime <= 0.1 && _ns.bufferLength <= 0.1))
                    {
                        _cachedPlayheadTime = playheadTime;
                        _rtmpDoStopAtEndTimer.reset();
                        _rtmpDoStopAtEndTimer.start();
                    }
                    switch(_bufferState)
                    {
                        case BUFFER_EMPTY:
                        {
                            if (!_hiddenForResize)
                            {
                                if (_state == VideoState.LOADING && _cachedState == VideoState.PLAYING || _state == VideoState.BUFFERING)
                                {
                                    setState(VideoState.PLAYING);
                                }
                                else if (_cachedState == VideoState.BUFFERING)
                                {
                                    _cachedState = VideoState.PLAYING;
                                }
                            }
                            _bufferState = BUFFER_FLUSH;
                            break;
                        }
                        default:
                        {
                            if (_state == VideoState.BUFFERING)
                            {
                                setStateFromCachedState();
                            }
                            break;
                            break;
                        }
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    if (_sawSeekNotify && _state == VideoState.SEEKING)
                    {
                        _bufferState = BUFFER_EMPTY;
                        _sawPlayStop = false;
                        setStateFromCachedState(false);
                        doUpdateTime();
                        execQueuedCmds();
                    }
                    switch(_bufferState)
                    {
                        case BUFFER_EMPTY:
                        {
                            _bufferState = BUFFER_FULL;
                            if (!_hiddenForResize)
                            {
                                if (_state == VideoState.LOADING && _cachedState == VideoState.PLAYING || _state == VideoState.BUFFERING)
                                {
                                    setState(VideoState.PLAYING);
                                }
                                else if (_cachedState == VideoState.BUFFERING)
                                {
                                    _cachedState = VideoState.PLAYING;
                                }
                                if (_rtmpDoStopAtEndTimer.running)
                                {
                                    _sawPlayStop = true;
                                    _rtmpDoStopAtEndTimer.reset();
                                }
                            }
                            break;
                        }
                        case BUFFER_FLUSH:
                        {
                            _bufferState = BUFFER_FULL;
                            if (_rtmpDoStopAtEndTimer.running)
                            {
                                _sawPlayStop = true;
                                _rtmpDoStopAtEndTimer.reset();
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    if (_state == VideoState.BUFFERING)
                    {
                        setStateFromCachedState();
                    }
                    break;
                }
                case "NetStream.Pause.Notify":
                {
                    if (_state == VideoState.RESIZING && _hiddenForResize)
                    {
                        finishAutoResize();
                    }
                    break;
                }
                case "NetStream.Unpause.Notify":
                {
                    if (_state == VideoState.PAUSED)
                    {
                        _state = VideoState.PLAYING;
                        setState(VideoState.BUFFERING);
                    }
                    else
                    {
                        _cachedState = VideoState.PLAYING;
                    }
                    break;
                }
                case "NetStream.Play.Start":
                {
                    _rtmpDoStopAtEndTimer.reset();
                    _bufferState = BUFFER_EMPTY;
                    _sawPlayStop = false;
                    if (_startingPlay)
                    {
                        _startingPlay = false;
                        _cachedPlayheadTime = playheadTime;
                    }
                    else if (_state == VideoState.PLAYING)
                    {
                        setState(VideoState.BUFFERING);
                    }
                    break;
                }
                case "NetStream.Play.Reset":
                {
                    _rtmpDoStopAtEndTimer.reset();
                    if (_state == VideoState.REWINDING)
                    {
                        _rtmpDoSeekTimer.reset();
                        if (playheadTime == 0 || playheadTime < _cachedPlayheadTime)
                        {
                            setStateFromCachedState();
                        }
                        else
                        {
                            _cachedPlayheadTime = playheadTime;
                            _rtmpDoSeekTimer.start();
                        }
                    }
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    if (playheadTime != _cachedPlayheadTime)
                    {
                        setStateFromCachedState(false);
                        doUpdateTime();
                        execQueuedCmds();
                    }
                    else
                    {
                        _sawSeekNotify = true;
                        _rtmpDoSeekTimer.start();
                    }
                    break;
                }
                case "Netstream.Play.UnpublishNotify":
                {
                    break;
                }
                case "Netstream.Play.PublishNotify":
                {
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    if (!_ncMgr.connectAgain())
                    {
                        setState(VideoState.CONNECTION_ERROR);
                    }
                    break;
                }
                case "NetStream.Play.Failed":
                case "NetStream.Failed":
                case "NetStream.Play.FileStructureInvalid":
                case "NetStream.Play.NoSupportedTrackFound":
                {
                    setState(VideoState.CONNECTION_ERROR);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function set progressInterval(param1:Number) : void
        {
            _updateProgressTimer.delay = param1;
            return;
        }// end function

        function onCuePoint(param1:Object) : void
        {
            if (!_hiddenForResize || !isNaN(_hiddenRewindPlayheadTime) && playheadTime < _hiddenRewindPlayheadTime)
            {
                dispatchEvent(new MetadataEvent(MetadataEvent.CUE_POINT, false, false, param1));
            }
            return;
        }// end function

        function createINCManager() : void
        {
            var theClass:Class;
            theClass;
            try
            {
                if (iNCManagerClass is String)
                {
                    theClass = Class(getDefinitionByName(String(iNCManagerClass)));
                }
                else if (iNCManagerClass is Class)
                {
                    theClass = Class(iNCManagerClass);
                }
            }
            catch (e:Error)
            {
                theClass;
            }
            if (theClass == null)
            {
                throw new VideoError(VideoError.INCMANAGER_CLASS_UNSET, iNCManagerClass == null ? ("null") : (iNCManagerClass.toString()));
            }
            _ncMgr = new theClass;
            _ncMgr.videoPlayer = this;
            return;
        }// end function

        function doAutoResize(event:TimerEvent = null) : void
        {
            var _loc_2:Boolean = false;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            if (_autoResizeTimer.running)
            {
                switch(_state)
                {
                    case VideoState.RESIZING:
                    case VideoState.LOADING:
                    {
                        break;
                    }
                    case VideoState.DISCONNECTED:
                    case VideoState.CONNECTION_ERROR:
                    {
                        _autoResizeTimer.reset();
                        return;
                    }
                    default:
                    {
                        if (!stateResponsive)
                        {
                            return;
                        }
                        break;
                    }
                }
                if (super.videoWidth != _prevVideoWidth || super.videoHeight != _prevVideoHeight || _bufferState == BUFFER_FULL || _bufferState == BUFFER_FLUSH || _ns.time > autoResizePlayheadTimeout)
                {
                    if (_hiddenForResize && !_ns.client.ready && _hiddenForResizeMetadataDelay < autoResizeMetadataDelayMax)
                    {
                        var _loc_8:* = _hiddenForResizeMetadataDelay + 1;
                        _hiddenForResizeMetadataDelay = _loc_8;
                        return;
                    }
                    _autoResizeTimer.reset();
                }
                else
                {
                    return;
                }
            }
            if (_autoResizeDone)
            {
                setState(_cachedState);
                return;
            }
            oldBounds = new Rectangle(x, y, width, height);
            oldRegistrationBounds = new Rectangle(registrationX, registrationY, registrationWidth, registrationHeight);
            _autoResizeDone = true;
            _loc_2 = _readyDispatched;
            _readyDispatched = true;
            _loc_3 = videoWidth;
            _loc_4 = videoHeight;
            _readyDispatched = _loc_2;
            switch(_scaleMode)
            {
                case VideoScaleMode.NO_SCALE:
                {
                    super.width = _loc_3;
                    super.height = _loc_4;
                    break;
                }
                case VideoScaleMode.EXACT_FIT:
                {
                    super.width = registrationWidth;
                    super.height = registrationHeight;
                    break;
                }
                case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
                {
                }
                default:
                {
                    _loc_5 = _loc_3 * _registrationHeight / _loc_4;
                    _loc_6 = _loc_4 * _registrationWidth / _loc_3;
                    if (_loc_6 < _registrationHeight)
                    {
                        super.width = _registrationWidth;
                        super.height = _loc_6;
                    }
                    else if (_loc_5 < _registrationWidth)
                    {
                        super.width = _loc_5;
                        super.height = _registrationHeight;
                    }
                    else
                    {
                        super.width = _registrationWidth;
                        super.height = _registrationHeight;
                    }
                    break;
                }
            }
            switch(_align)
            {
                case VideoAlign.CENTER:
                case VideoAlign.TOP:
                case VideoAlign.BOTTOM:
                {
                }
                default:
                {
                    super.x = _registrationX + (_registrationWidth - width) / 2;
                    break;
                }
                case VideoAlign.TOP_LEFT:
                case VideoAlign.BOTTOM_LEFT:
                case VideoAlign.RIGHT:
                {
                    super.x = _registrationX;
                    break;
                }
                case VideoAlign.TOP_RIGHT:
                case VideoAlign.BOTTOM_RIGHT:
                case :
                {
                    super.x = _registrationX + (_registrationWidth - width);
                    break;
                    break;
                }
            }
            switch(_align)
            {
                case VideoAlign.CENTER:
                case VideoAlign.LEFT:
                case VideoAlign.RIGHT:
                {
                }
                default:
                {
                    super.y = _registrationY + (_registrationHeight - height) / 2;
                    break;
                }
                case VideoAlign.TOP_LEFT:
                case VideoAlign.TOP_RIGHT:
                case VideoAlign.BOTTOM:
                {
                    super.y = _registrationY;
                    break;
                }
                case VideoAlign.BOTTOM_LEFT:
                case VideoAlign.BOTTOM_RIGHT:
                case :
                {
                    super.y = _registrationY + (_registrationHeight - height);
                    break;
                    break;
                }
            }
            if (_hiddenForResize)
            {
                _hiddenRewindPlayheadTime = playheadTime;
                if (_state == VideoState.LOADING)
                {
                    _cachedState = VideoState.PLAYING;
                }
                if (!_ncMgr.isRTMP)
                {
                    _pause(true);
                    _seek(0);
                    _finishAutoResizeTimer.reset();
                    _finishAutoResizeTimer.start();
                }
                else if (!_isLive)
                {
                    _currentPos = 0;
                    _play(0, 0);
                    setState(VideoState.RESIZING);
                }
                else if (_autoPlay)
                {
                    _finishAutoResizeTimer.reset();
                    _finishAutoResizeTimer.start();
                }
                else
                {
                    finishAutoResize();
                }
            }
            else
            {
                dispatchEvent(new AutoLayoutEvent(AutoLayoutEvent.AUTO_LAYOUT, false, false, oldBounds, oldRegistrationBounds));
            }
            return;
        }// end function

        public function get totalTime() : Number
        {
            return _streamLength;
        }// end function

        public function get ncMgr() : INCManager
        {
            if (_ncMgr == null)
            {
                createINCManager();
            }
            return _ncMgr;
        }// end function

        public function set volume(param1:Number) : void
        {
            var _loc_2:SoundTransform = null;
            _loc_2 = soundTransform;
            _loc_2.volume = param1;
            soundTransform = _loc_2;
            return;
        }// end function

        function _play(param1:int = 0, param2:int = -1) : void
        {
            waitingForEnough = false;
            _rtmpDoStopAtEndTimer.reset();
            _startingPlay = true;
            _ns.play(_ncMgr.streamName, _isLive ? (-1) : (param1), param2);
            return;
        }// end function

        function finishAutoResize(event:TimerEvent = null) : void
        {
            if (stateResponsive)
            {
                return;
            }
            _hiddenForResize = false;
            super.visible = __visible;
            volume = _volume;
            dispatchEvent(new AutoLayoutEvent(AutoLayoutEvent.AUTO_LAYOUT, false, false, oldBounds, oldRegistrationBounds));
            if (_autoPlay)
            {
                if (_ncMgr.isRTMP)
                {
                    if (!_isLive)
                    {
                        _currentPos = 0;
                        _play(0);
                    }
                    if (_state == VideoState.RESIZING)
                    {
                        setState(VideoState.LOADING);
                        _cachedState = VideoState.PLAYING;
                    }
                }
                else
                {
                    waitingForEnough = true;
                    _cachedState = _state;
                    _state = VideoState.PAUSED;
                    checkReadyForPlay(bytesLoaded, bytesTotal);
                    if (waitingForEnough)
                    {
                        _state = _cachedState;
                        setState(VideoState.PAUSED);
                    }
                    else
                    {
                        _cachedState = VideoState.PLAYING;
                    }
                }
            }
            else
            {
                setState(VideoState.STOPPED);
            }
            return;
        }// end function

        public function set soundTransform(param1:SoundTransform) : void
        {
            if (param1 == null)
            {
                return;
            }
            if (_hiddenForResize)
            {
                _volume = param1.volume;
            }
            _soundTransform = new SoundTransform();
            _soundTransform.volume = _hiddenForResize ? (0) : (param1.volume);
            _soundTransform.leftToLeft = param1.leftToLeft;
            _soundTransform.leftToRight = param1.leftToRight;
            _soundTransform.rightToLeft = param1.rightToLeft;
            _soundTransform.rightToRight = param1.rightToRight;
            if (_ns != null)
            {
                _ns.soundTransform = _soundTransform;
            }
            return;
        }// end function

        function httpDoSeek(event:TimerEvent) : void
        {
            var _loc_2:Boolean = false;
            _loc_2 = _state == VideoState.REWINDING || _state == VideoState.SEEKING;
            if (_loc_2 && _httpDoSeekCount < httpDoSeekMaxCount && (_cachedPlayheadTime == playheadTime || _invalidSeekTime))
            {
                var _loc_4:* = _httpDoSeekCount + 1;
                _httpDoSeekCount = _loc_4;
                return;
            }
            _httpDoSeekCount = 0;
            _httpDoSeekTimer.reset();
            if (!_loc_2)
            {
                return;
            }
            setStateFromCachedState(false);
            if (_invalidSeekTime)
            {
                _invalidSeekTime = false;
                _invalidSeekRecovery = true;
                seek(playheadTime);
            }
            else
            {
                doUpdateTime();
                _lastSeekTime = playheadTime;
                execQueuedCmds();
            }
            return;
        }// end function

        public function get bytesLoaded() : uint
        {
            if (_ns == null || _ncMgr.isRTMP)
            {
                return uint.MIN_VALUE;
            }
            return _ns.bytesLoaded;
        }// end function

        override public function set height(param1:Number) : void
        {
            var _loc_2:* = param1;
            _registrationHeight = param1;
            super.height = _loc_2;
            switch(_scaleMode)
            {
                case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
                case VideoScaleMode.NO_SCALE:
                {
                    startAutoResize();
                    break;
                }
                default:
                {
                    super.height = param1;
                    break;
                    break;
                }
            }
            return;
        }// end function

        function httpNetStatus(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetStream.Play.Stop":
                {
                    _delayedBufferingTimer.reset();
                    if (_invalidSeekTime)
                    {
                        _invalidSeekTime = false;
                        _invalidSeekRecovery = true;
                        setState(_cachedState);
                        seek(playheadTime);
                    }
                    else
                    {
                        switch(_state)
                        {
                            case VideoState.SEEKING:
                            {
                                httpDoSeek(null);
                            }
                            case VideoState.PLAYING:
                            case VideoState.BUFFERING:
                            {
                                httpDoStopAtEnd();
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                    }
                    break;
                }
                case "NetStream.Seek.InvalidTime":
                {
                    if (_invalidSeekRecovery)
                    {
                        _invalidSeekTime = false;
                        _invalidSeekRecovery = false;
                        setState(_cachedState);
                        seek(0);
                    }
                    else
                    {
                        _invalidSeekTime = true;
                        _httpDoSeekCount = 0;
                        _httpDoSeekTimer.start();
                    }
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    _bufferState = BUFFER_EMPTY;
                    if (_state == VideoState.PLAYING)
                    {
                        _delayedBufferingTimer.reset();
                        _delayedBufferingTimer.start();
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                case "NetStream.Buffer.Flush":
                {
                    _delayedBufferingTimer.reset();
                    _bufferState = BUFFER_FULL;
                    if (!_hiddenForResize)
                    {
                        if (_state == VideoState.LOADING && _cachedState == VideoState.PLAYING || _state == VideoState.BUFFERING)
                        {
                            setState(VideoState.PLAYING);
                        }
                        else if (_cachedState == VideoState.BUFFERING)
                        {
                            _cachedState = VideoState.PLAYING;
                        }
                    }
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    _invalidSeekRecovery = false;
                    switch(_state)
                    {
                        case VideoState.SEEKING:
                        case VideoState.REWINDING:
                        {
                            _httpDoSeekCount = 0;
                            _httpDoSeekTimer.start();
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                case "NetStream.Play.FileStructureInvalid":
                case "NetStream.Play.NoSupportedTrackFound":
                {
                    setState(VideoState.CONNECTION_ERROR);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get netConnection() : NetConnection
        {
            if (_ncMgr != null)
            {
                return _ncMgr.netConnection;
            }
            return null;
        }// end function

        public function set bufferTime(param1:Number) : void
        {
            _bufferTime = param1;
            if (_ns != null)
            {
                _ns.bufferTime = _bufferTime;
            }
            return;
        }// end function

        function onMetaData(param1:Object) : void
        {
            if (_metadata != null)
            {
                return;
            }
            _metadata = param1;
            if (isNaN(_streamLength))
            {
                _streamLength = param1.duration;
            }
            if (_resizeImmediatelyOnMetadata && _ns.client.ready)
            {
                _resizeImmediatelyOnMetadata = false;
                _autoResizeTimer.reset();
                _autoResizeDone = false;
                doAutoResize();
            }
            dispatchEvent(new MetadataEvent(MetadataEvent.METADATA_RECEIVED, false, false, param1));
            return;
        }// end function

        function queueCmd(param1:Number, param2:String = null, param3:Boolean = false, param4:Number = NaN) : void
        {
            _cmdQueue.push(new QueuedCommand(param1, param2, param3, param4));
            return;
        }// end function

        public function set registrationHeight(param1:Number) : void
        {
            height = param1;
            return;
        }// end function

        override public function get visible() : Boolean
        {
            if (!_hiddenForResize)
            {
                __visible = super.visible;
            }
            return __visible;
        }// end function

        public function seek(param1:Number) : void
        {
            if (_invalidSeekTime)
            {
                return;
            }
            if (isNaN(param1) || param1 < 0)
            {
                throw new VideoError(VideoError.INVALID_SEEK);
            }
            if (!isXnOK())
            {
                if (_state == VideoState.CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
                {
                    throw new VideoError(VideoError.NO_CONNECTION);
                }
                flushQueuedCmds();
                queueCmd(QueuedCommand.SEEK, null, false, param1);
                setState(VideoState.LOADING);
                _cachedState = VideoState.LOADING;
                _ncMgr.reconnect();
                return;
            }
            else if (_state == VideoState.EXEC_QUEUED_CMD)
            {
                _state = _cachedState;
            }
            else
            {
                if (!stateResponsive)
                {
                    queueCmd(QueuedCommand.SEEK, null, false, param1);
                    return;
                }
                execQueuedCmds();
            }
            if (_ns == null)
            {
                _createStream();
            }
            if (_atEnd && param1 < playheadTime)
            {
                _atEnd = false;
            }
            switch(_state)
            {
                case VideoState.PLAYING:
                {
                    _state = VideoState.BUFFERING;
                }
                case VideoState.BUFFERING:
                case VideoState.PAUSED:
                {
                    _seek(param1);
                    setState(VideoState.SEEKING);
                    break;
                }
                case VideoState.STOPPED:
                {
                    if (_ncMgr.isRTMP)
                    {
                        _play(0);
                        _pause(true);
                    }
                    _seek(param1);
                    _state = VideoState.PAUSED;
                    setState(VideoState.SEEKING);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get state() : String
        {
            return _state;
        }// end function

        public function set autoRewind(param1:Boolean) : void
        {
            _autoRewind = param1;
            return;
        }// end function

        override public function set scaleX(param1:Number) : void
        {
            super.scaleX = param1;
            _registrationWidth = width;
            switch(_scaleMode)
            {
                case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
                case VideoScaleMode.NO_SCALE:
                {
                    startAutoResize();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override public function set scaleY(param1:Number) : void
        {
            super.scaleY = param1;
            _registrationHeight = height;
            switch(_scaleMode)
            {
                case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
                case VideoScaleMode.NO_SCALE:
                {
                    startAutoResize();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get registrationWidth() : Number
        {
            return _registrationWidth;
        }// end function

        function flushQueuedCmds() : void
        {
            while (_cmdQueue.length > 0)
            {
                
                _cmdQueue.pop();
            }
            return;
        }// end function

        public function get registrationX() : Number
        {
            return _registrationX;
        }// end function

        function _setUpStream() : void
        {
            if (!isNaN(_ncMgr.streamLength) && _ncMgr.streamLength >= 0)
            {
                _streamLength = _ncMgr.streamLength;
            }
            _videoWidth = _ncMgr.streamWidth >= 0 ? (_ncMgr.streamWidth) : (-1);
            _videoHeight = _ncMgr.streamHeight >= 0 ? (_ncMgr.streamHeight) : (-1);
            _resizeImmediatelyOnMetadata = _videoWidth >= 0 && _videoHeight >= 0 || _scaleMode == VideoScaleMode.EXACT_FIT;
            if (!_hiddenForResize)
            {
                __visible = super.visible;
                super.visible = false;
                _volume = volume;
                volume = 0;
                _hiddenForResize = true;
            }
            _hiddenForResizeMetadataDelay = 0;
            _play(0);
            if (_currentPos > 0)
            {
                _seek(_currentPos);
                _currentPos = 0;
            }
            _autoResizeTimer.reset();
            _autoResizeTimer.start();
            return;
        }// end function

        public function get registrationY() : Number
        {
            return _registrationY;
        }// end function

        function httpDoStopAtEnd() : void
        {
            if (_atEndCheckPlayhead == playheadTime && _atEndCheckPlayhead != _lastUpdateTime && playheadTime != 0)
            {
                _atEnd = false;
                _seek(0);
                return;
            }
            _atEndCheckPlayhead = NaN;
            _atEnd = true;
            if (isNaN(_streamLength))
            {
                _streamLength = _ns.time;
            }
            _pause(true);
            setState(VideoState.STOPPED);
            if (_state != VideoState.STOPPED)
            {
                return;
            }
            doUpdateTime();
            if (_state != VideoState.STOPPED)
            {
                return;
            }
            dispatchEvent(new VideoEvent(VideoEvent.COMPLETE, false, false, _state, playheadTime));
            if (_state != VideoState.STOPPED)
            {
                return;
            }
            if (_autoRewind)
            {
                _atEnd = false;
                _pause(true);
                _seek(0);
                setState(VideoState.REWINDING);
            }
            return;
        }// end function

        public function ncConnected() : void
        {
            if (_ncMgr == null || _ncMgr.netConnection == null)
            {
                setState(VideoState.CONNECTION_ERROR);
            }
            else if (_ns == null)
            {
                _createStream();
                _setUpStream();
            }
            return;
        }// end function

        override public function set visible(param1:Boolean) : void
        {
            __visible = param1;
            if (!_hiddenForResize)
            {
                super.visible = __visible;
            }
            return;
        }// end function

        public function load(param1:String, param2:Number = NaN, param3:Boolean = false) : void
        {
            if (param1 == null)
            {
                throw new VideoError(VideoError.NULL_URL_LOAD);
            }
            if (_state == VideoState.EXEC_QUEUED_CMD)
            {
                _state = _cachedState;
            }
            else
            {
                if (!stateResponsive && _state != VideoState.DISCONNECTED && _state != VideoState.CONNECTION_ERROR)
                {
                    queueCmd(QueuedCommand.LOAD, param1, param3, param2);
                    return;
                }
                execQueuedCmds();
            }
            _autoPlay = false;
            _load(param1, param2, param3);
            return;
        }// end function

        override public function set x(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            if (this.x != param1)
            {
                _loc_2 = param1 - this.x;
                super.x = param1;
                _registrationX = _registrationX + _loc_2;
            }
            return;
        }// end function

        override public function set y(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            if (this.y != param1)
            {
                _loc_2 = param1 - this.y;
                super.y = param1;
                _registrationY = _registrationY + _loc_2;
            }
            return;
        }// end function

        function _pause(param1:Boolean) : void
        {
            _atEndCheckPlayhead = playheadTime;
            _rtmpDoStopAtEndTimer.reset();
            if (param1)
            {
                _ns.pause();
            }
            else
            {
                _ns.resume();
            }
            return;
        }// end function

        public function get playheadUpdateInterval() : Number
        {
            return _updateTimeTimer.delay;
        }// end function

        function doDelayedBuffering(event:TimerEvent) : void
        {
            switch(_state)
            {
                case VideoState.LOADING:
                case VideoState.RESIZING:
                {
                    break;
                }
                case VideoState.PLAYING:
                {
                    _delayedBufferingTimer.reset();
                    if (!isNaN(totalTime) && totalTime > 0 && bytesLoaded > 0 && bytesLoaded < uint.MAX_VALUE && bytesLoaded < bytesTotal)
                    {
                        pause();
                        if (_state == VideoState.PAUSED)
                        {
                            waitingForEnough = true;
                            playWhenEnoughDownloaded();
                        }
                    }
                    else
                    {
                        setState(VideoState.BUFFERING);
                    }
                    break;
                }
                default:
                {
                    _delayedBufferingTimer.reset();
                    break;
                    break;
                }
            }
            return;
        }// end function

        function createNetStreamClient() : Object
        {
            var theClass:Class;
            var theInst:Object;
            theClass;
            theInst;
            try
            {
                if (netStreamClientClass is String)
                {
                    theClass = Class(getDefinitionByName(String(netStreamClientClass)));
                }
                else if (netStreamClientClass is Class)
                {
                    theClass = Class(netStreamClientClass);
                }
                if (theClass != null)
                {
                    theInst = new theClass(this);
                }
            }
            catch (e:Error)
            {
                theClass;
                theInst;
            }
            if (theInst == null)
            {
                throw new VideoError(VideoError.NETSTREAM_CLIENT_CLASS_UNSET, netStreamClientClass == null ? ("null") : (netStreamClientClass.toString()));
            }
            return theInst;
        }// end function

        public function get align() : String
        {
            return _align;
        }// end function

        public function set registrationWidth(param1:Number) : void
        {
            width = param1;
            return;
        }// end function

        public function get stateResponsive() : Boolean
        {
            switch(_state)
            {
                case VideoState.STOPPED:
                case VideoState.PLAYING:
                case VideoState.PAUSED:
                case VideoState.BUFFERING:
                {
                    return true;
                }
                default:
                {
                    return false;
                    break;
                }
            }
        }// end function

        public function get volume() : Number
        {
            return soundTransform.volume;
        }// end function

        public function get soundTransform() : SoundTransform
        {
            var _loc_1:SoundTransform = null;
            if (_ns != null)
            {
                _soundTransform = _ns.soundTransform;
            }
            _loc_1 = new SoundTransform();
            _loc_1.volume = _hiddenForResize ? (_volume) : (_soundTransform.volume);
            _loc_1.leftToLeft = _soundTransform.leftToLeft;
            _loc_1.leftToRight = _soundTransform.leftToRight;
            _loc_1.rightToLeft = _soundTransform.rightToLeft;
            _loc_1.rightToRight = _soundTransform.rightToRight;
            return _loc_1;
        }// end function

        public function get bufferTime() : Number
        {
            if (_ns != null)
            {
                _bufferTime = _ns.bufferTime;
            }
            return _bufferTime;
        }// end function

        public function get metadata() : Object
        {
            return _metadata;
        }// end function

        public function play(param1:String = null, param2:Number = NaN, param3:Boolean = false) : void
        {
            if (param1 != null)
            {
                if (_state == VideoState.EXEC_QUEUED_CMD)
                {
                    _state = _cachedState;
                }
                else
                {
                    if (!stateResponsive && _state != VideoState.DISCONNECTED && _state != VideoState.CONNECTION_ERROR)
                    {
                        queueCmd(QueuedCommand.PLAY, param1, param3, param2);
                        return;
                    }
                    execQueuedCmds();
                }
                _autoPlay = true;
                _load(param1, param2, param3);
                return;
            }
            if (!isXnOK())
            {
                if (_state == VideoState.CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
                {
                    throw new VideoError(VideoError.NO_CONNECTION);
                }
                flushQueuedCmds();
                queueCmd(QueuedCommand.PLAY);
                setState(VideoState.LOADING);
                _cachedState = VideoState.LOADING;
                _ncMgr.reconnect();
                return;
            }
            else if (_state == VideoState.EXEC_QUEUED_CMD)
            {
                _state = _cachedState;
            }
            else
            {
                if (!stateResponsive)
                {
                    queueCmd(QueuedCommand.PLAY);
                    return;
                }
                execQueuedCmds();
            }
            if (_ns == null)
            {
                _createStream();
            }
            switch(_state)
            {
                case VideoState.BUFFERING:
                {
                    if (_ncMgr.isRTMP)
                    {
                        _play(0);
                        if (_atEnd)
                        {
                            _atEnd = false;
                            _currentPos = 0;
                            setState(VideoState.REWINDING);
                        }
                        else if (_currentPos > 0)
                        {
                            _seek(_currentPos);
                            _currentPos = 0;
                        }
                    }
                }
                case VideoState.PLAYING:
                {
                    return;
                }
                case VideoState.STOPPED:
                {
                    if (_ncMgr.isRTMP)
                    {
                        if (_isLive)
                        {
                            _play(-1);
                            setState(VideoState.BUFFERING);
                        }
                        else
                        {
                            _play(0);
                            if (_atEnd)
                            {
                                _atEnd = false;
                                _currentPos = 0;
                                _state = VideoState.BUFFERING;
                                setState(VideoState.REWINDING);
                            }
                            else if (_currentPos > 0)
                            {
                                _seek(_currentPos);
                                _currentPos = 0;
                                setState(VideoState.BUFFERING);
                            }
                            else
                            {
                                setState(VideoState.BUFFERING);
                            }
                        }
                    }
                    else
                    {
                        _pause(false);
                        if (_atEnd)
                        {
                            _atEnd = false;
                            _seek(0);
                            _state = VideoState.BUFFERING;
                            setState(VideoState.REWINDING);
                        }
                        else if (_bufferState == BUFFER_EMPTY)
                        {
                            setState(VideoState.BUFFERING);
                        }
                        else
                        {
                            setState(VideoState.PLAYING);
                        }
                    }
                    break;
                }
                case VideoState.PAUSED:
                {
                    _pause(false);
                    if (!_ncMgr.isRTMP)
                    {
                        if (_bufferState == BUFFER_EMPTY)
                        {
                            setState(VideoState.BUFFERING);
                        }
                        else
                        {
                            setState(VideoState.PLAYING);
                        }
                    }
                    else
                    {
                        setState(VideoState.BUFFERING);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get isLive() : Boolean
        {
            return _isLive;
        }// end function

        function setStateFromCachedState(param1:Boolean = true) : void
        {
            switch(_cachedState)
            {
                case VideoState.PLAYING:
                case VideoState.PAUSED:
                case VideoState.BUFFERING:
                {
                    setState(_cachedState, param1);
                    break;
                }
                default:
                {
                    setState(VideoState.STOPPED, param1);
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function get idleTimeout() : Number
        {
            return _idleTimeoutTimer.delay;
        }// end function

        public function get registrationHeight() : Number
        {
            return _registrationHeight;
        }// end function

        public function ncReconnected() : void
        {
            if (_ncMgr == null || _ncMgr.netConnection == null)
            {
                setState(VideoState.CONNECTION_ERROR);
            }
            else
            {
                _ns = null;
                _state = VideoState.STOPPED;
                execQueuedCmds();
            }
            return;
        }// end function

        function startAutoResize() : void
        {
            switch(_state)
            {
                case VideoState.DISCONNECTED:
                case VideoState.CONNECTION_ERROR:
                {
                    return;
                }
                default:
                {
                    if (_ns == null)
                    {
                        return;
                    }
                    _autoResizeDone = false;
                    if (stateResponsive && (super.videoWidth != 0 || super.videoHeight != 0 || _bufferState == BUFFER_FULL || _bufferState == BUFFER_FLUSH || _ns.time > autoResizePlayheadTimeout))
                    {
                        doAutoResize();
                    }
                    else
                    {
                        _autoResizeTimer.reset();
                        _autoResizeTimer.start();
                    }
                    break;
                    break;
                }
            }
            return;
        }// end function

        function setState(param1:String, param2:Boolean = true) : void
        {
            var _loc_3:String = null;
            if (param1 == _state)
            {
                return;
            }
            _hiddenRewindPlayheadTime = NaN;
            _cachedState = _state;
            _cachedPlayheadTime = playheadTime;
            _state = param1;
            _loc_3 = _state;
            dispatchEvent(new VideoEvent(VideoEvent.STATE_CHANGE, false, false, _loc_3, playheadTime));
            if (!_readyDispatched)
            {
                switch(_loc_3)
                {
                    case VideoState.STOPPED:
                    case VideoState.PLAYING:
                    case VideoState.PAUSED:
                    case VideoState.BUFFERING:
                    {
                        _readyDispatched = true;
                        dispatchEvent(new VideoEvent(VideoEvent.READY, false, false, _loc_3, playheadTime));
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            switch(_cachedState)
            {
                case VideoState.REWINDING:
                {
                    dispatchEvent(new VideoEvent(VideoEvent.AUTO_REWOUND, false, false, _loc_3, playheadTime));
                    if (_ncMgr.isRTMP && _loc_3 == VideoState.STOPPED)
                    {
                        closeNS();
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            switch(_loc_3)
            {
                case VideoState.STOPPED:
                case VideoState.PAUSED:
                {
                    if (_ncMgr.isRTMP)
                    {
                        _idleTimeoutTimer.reset();
                        _idleTimeoutTimer.start();
                    }
                    break;
                }
                case VideoState.SEEKING:
                case VideoState.REWINDING:
                {
                    _bufferState = BUFFER_EMPTY;
                    _sawPlayStop = false;
                    _idleTimeoutTimer.reset();
                    break;
                }
                case VideoState.PLAYING:
                case VideoState.BUFFERING:
                {
                    _updateTimeTimer.start();
                    _idleTimeoutTimer.reset();
                    break;
                }
                case VideoState.LOADING:
                case VideoState.RESIZING:
                {
                    _idleTimeoutTimer.reset();
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (param2)
            {
                execQueuedCmds();
            }
            return;
        }// end function

        function _seek(param1:Number) : void
        {
            _rtmpDoStopAtEndTimer.reset();
            if (_metadata != null && _metadata.audiodelay != undefined && (isNaN(_streamLength) || param1 + _metadata.audiodelay < _streamLength))
            {
                param1 = param1 + _metadata.audiodelay;
            }
            _ns.seek(param1);
            _lastSeekTime = param1;
            _invalidSeekTime = false;
            _bufferState = BUFFER_EMPTY;
            _sawPlayStop = false;
            _sawSeekNotify = false;
            return;
        }// end function

        public function get autoRewind() : Boolean
        {
            return _autoRewind;
        }// end function

        function doIdleTimeout(event:TimerEvent) : void
        {
            close();
            return;
        }// end function

        public function playWhenEnoughDownloaded() : void
        {
            if (_ncMgr != null && _ncMgr.isRTMP)
            {
                play();
                return;
            }
            if (!isXnOK())
            {
                throw new VideoError(VideoError.NO_CONNECTION);
            }
            if (_state == VideoState.EXEC_QUEUED_CMD)
            {
                _state = _cachedState;
            }
            else
            {
                if (!stateResponsive)
                {
                    queueCmd(QueuedCommand.PLAY_WHEN_ENOUGH);
                    return;
                }
                execQueuedCmds();
            }
            waitingForEnough = true;
            checkReadyForPlay(bytesLoaded, bytesTotal);
            return;
        }// end function

        function rtmpDoSeek(event:TimerEvent) : void
        {
            if (_state != VideoState.REWINDING && _state != VideoState.SEEKING)
            {
                _rtmpDoSeekTimer.reset();
                _sawSeekNotify = false;
            }
            else if (playheadTime != _cachedPlayheadTime)
            {
                _rtmpDoSeekTimer.reset();
                _sawSeekNotify = false;
                setStateFromCachedState(false);
                doUpdateTime();
                _lastSeekTime = playheadTime;
                execQueuedCmds();
            }
            return;
        }// end function

        public function get netStream() : NetStream
        {
            return _ns;
        }// end function

        override public function get videoHeight() : int
        {
            if (_videoHeight > 0)
            {
                return _videoHeight;
            }
            if (_metadata != null && !isNaN(_metadata.width) && !isNaN(_metadata.height))
            {
                if (_metadata.width == _metadata.height && _readyDispatched)
                {
                    return super.videoHeight;
                }
                return int(_metadata.height);
            }
            if (_readyDispatched)
            {
                return super.videoHeight;
            }
            return -1;
        }// end function

        public function set registrationX(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            if (_registrationX != param1)
            {
                _loc_2 = param1 - _registrationX;
                _registrationX = param1;
                this.x = this.x + _loc_2;
            }
            return;
        }// end function

        public function set registrationY(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            if (_registrationY != param1)
            {
                _loc_2 = param1 - _registrationY;
                _registrationY = param1;
                this.y = this.y + _loc_2;
            }
            return;
        }// end function

        function doUpdateProgress(event:TimerEvent) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            if (_ns == null)
            {
                return;
            }
            _loc_2 = _ns.bytesLoaded;
            _loc_3 = _ns.bytesTotal;
            if (_loc_3 < uint.MAX_VALUE)
            {
                dispatchEvent(new VideoProgressEvent(VideoProgressEvent.PROGRESS, false, false, _loc_2, _loc_3));
            }
            if (_state == VideoState.DISCONNECTED || _state == VideoState.CONNECTION_ERROR || _loc_2 >= _loc_3)
            {
                _updateProgressTimer.stop();
            }
            checkEnoughDownloaded(_loc_2, _loc_3);
            return;
        }// end function

        override public function set width(param1:Number) : void
        {
            var _loc_2:* = param1;
            _registrationWidth = param1;
            super.width = _loc_2;
            switch(_scaleMode)
            {
                case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
                case VideoScaleMode.NO_SCALE:
                {
                    startAutoResize();
                    break;
                }
                default:
                {
                    super.width = param1;
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function get isRTMP() : Boolean
        {
            if (_ncMgr == null)
            {
                return false;
            }
            return _ncMgr.isRTMP;
        }// end function

        public function get bytesTotal() : uint
        {
            if (_ns == null || _ncMgr.isRTMP)
            {
                return uint.MAX_VALUE;
            }
            return _ns.bytesTotal;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            var _loc_3:* = param1;
            _registrationWidth = param1;
            super.width = _loc_3;
            var _loc_3:* = param2;
            _registrationHeight = param2;
            super.height = _loc_3;
            switch(_scaleMode)
            {
                case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
                case VideoScaleMode.NO_SCALE:
                {
                    startAutoResize();
                    break;
                }
                default:
                {
                    super.x = _registrationX;
                    super.y = _registrationY;
                    break;
                    break;
                }
            }
            return;
        }// end function

        function isXnOK() : Boolean
        {
            if (_state == VideoState.LOADING)
            {
                return true;
            }
            if (_state == VideoState.CONNECTION_ERROR)
            {
                return false;
            }
            if (_state != VideoState.DISCONNECTED)
            {
                if (_ncMgr == null || _ncMgr.netConnection == null || _ncMgr.isRTMP && !_ncMgr.netConnection.connected)
                {
                    setState(VideoState.DISCONNECTED);
                    return false;
                }
                return true;
            }
            return false;
        }// end function

        function _createStream() : void
        {
            var _loc_1:NetStream = null;
            _ns = null;
            _loc_1 = new NetStream(_ncMgr.netConnection);
            if (_ncMgr.isRTMP)
            {
                _loc_1.addEventListener(NetStatusEvent.NET_STATUS, rtmpNetStatus);
            }
            else
            {
                _loc_1.addEventListener(NetStatusEvent.NET_STATUS, httpNetStatus);
            }
            _loc_1.client = createNetStreamClient();
            _loc_1.bufferTime = _bufferTime;
            _loc_1.soundTransform = soundTransform;
            _ns = _loc_1;
            attachNetStream(_ns);
            return;
        }// end function

        function checkReadyForPlay(param1:uint, param2:uint) : void
        {
            var _loc_3:Number = NaN;
            if (param1 >= param2)
            {
                waitingForEnough = false;
                _cachedState = _state;
                _state = VideoState.EXEC_QUEUED_CMD;
                play();
                execQueuedCmds();
                return;
            }
            if (isNaN(baselineProgressTime))
            {
                return;
            }
            if (isNaN(totalTime) || totalTime < 0)
            {
                waitingForEnough = false;
                _cachedState = _state;
                _state = VideoState.EXEC_QUEUED_CMD;
                play();
                execQueuedCmds();
            }
            else if (totalDownloadTime > 1.5)
            {
                _loc_3 = (totalProgressTime - baselineProgressTime) / totalDownloadTime;
                if (totalTime - playheadTime > (totalTime - totalProgressTime) / _loc_3)
                {
                    waitingForEnough = false;
                    _cachedState = _state;
                    _state = VideoState.EXEC_QUEUED_CMD;
                    play();
                    execQueuedCmds();
                }
            }
            return;
        }// end function

        function closeNS(param1:Boolean = false) : void
        {
            if (_ns != null)
            {
                if (param1)
                {
                    doUpdateTime();
                    _currentPos = _ns.time;
                }
                _updateTimeTimer.reset();
                _updateProgressTimer.reset();
                _idleTimeoutTimer.reset();
                _autoResizeTimer.reset();
                _rtmpDoStopAtEndTimer.reset();
                _rtmpDoSeekTimer.reset();
                _httpDoSeekTimer.reset();
                _finishAutoResizeTimer.reset();
                _delayedBufferingTimer.reset();
                _ns.removeEventListener(NetStatusEvent.NET_STATUS, rtmpNetStatus);
                _ns.removeEventListener(NetStatusEvent.NET_STATUS, httpNetStatus);
                _ns.close();
                _ns = null;
            }
            return;
        }// end function

        function _load(param1:String, param2:Number, param3:Boolean) : void
        {
            var _loc_4:Boolean = false;
            _prevVideoWidth = super.videoWidth;
            _prevVideoHeight = super.videoHeight;
            _autoResizeDone = false;
            _cachedPlayheadTime = 0;
            _bufferState = BUFFER_EMPTY;
            _sawPlayStop = false;
            _metadata = null;
            _startingPlay = false;
            _invalidSeekTime = false;
            _invalidSeekRecovery = false;
            _isLive = param3;
            _contentPath = param1;
            _currentPos = 0;
            _streamLength = isNaN(param2) || param2 <= 0 ? (NaN) : (param2);
            _atEnd = false;
            _readyDispatched = false;
            _lastUpdateTime = NaN;
            lastUpdateTimeStuckCount = 0;
            _sawSeekNotify = false;
            waitingForEnough = false;
            baselineProgressTime = NaN;
            startProgressTime = NaN;
            totalDownloadTime = NaN;
            totalProgressTime = NaN;
            _httpDoSeekCount = 0;
            _updateTimeTimer.reset();
            _updateProgressTimer.reset();
            _idleTimeoutTimer.reset();
            _autoResizeTimer.reset();
            _rtmpDoStopAtEndTimer.reset();
            _rtmpDoSeekTimer.reset();
            _httpDoSeekTimer.reset();
            _finishAutoResizeTimer.reset();
            _delayedBufferingTimer.reset();
            closeNS(false);
            if (_ncMgr == null)
            {
                createINCManager();
            }
            _loc_4 = _ncMgr.connectToURL(_contentPath);
            setState(VideoState.LOADING);
            _cachedState = VideoState.LOADING;
            if (_loc_4)
            {
                _createStream();
                _setUpStream();
            }
            if (!_ncMgr.isRTMP)
            {
                _updateProgressTimer.start();
            }
            return;
        }// end function

        function rtmpDoStopAtEnd(event:TimerEvent = null) : void
        {
            if (_rtmpDoStopAtEndTimer.running)
            {
                switch(_state)
                {
                    case VideoState.DISCONNECTED:
                    case VideoState.CONNECTION_ERROR:
                    {
                        _rtmpDoStopAtEndTimer.reset();
                        return;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (event == null || _cachedPlayheadTime == playheadTime)
                {
                    _rtmpDoStopAtEndTimer.reset();
                }
                else
                {
                    _cachedPlayheadTime = playheadTime;
                    return;
                }
            }
            if (_atEndCheckPlayhead == playheadTime && _atEndCheckPlayhead != _lastSeekTime && !_isLive && playheadTime != 0)
            {
                _atEnd = false;
                _currentPos = 0;
                _play(0);
                return;
            }
            _atEndCheckPlayhead = NaN;
            _bufferState = BUFFER_EMPTY;
            _sawPlayStop = false;
            _atEnd = true;
            setState(VideoState.STOPPED);
            if (_state != VideoState.STOPPED)
            {
                return;
            }
            doUpdateTime();
            if (_state != VideoState.STOPPED)
            {
                return;
            }
            dispatchEvent(new VideoEvent(VideoEvent.COMPLETE, false, false, _state, playheadTime));
            if (_state != VideoState.STOPPED)
            {
                return;
            }
            if (_autoRewind && !_isLive && playheadTime != 0)
            {
                _atEnd = false;
                _currentPos = 0;
                _play(0, 0);
                setState(VideoState.REWINDING);
            }
            else
            {
                closeNS();
            }
            return;
        }// end function

        public function set idleTimeout(param1:Number) : void
        {
            _idleTimeoutTimer.delay = param1;
            return;
        }// end function

        public function set playheadUpdateInterval(param1:Number) : void
        {
            _updateTimeTimer.delay = param1;
            return;
        }// end function

        function checkEnoughDownloaded(param1:uint, param2:uint) : void
        {
            if (param1 == 0 || param2 == uint.MAX_VALUE)
            {
                return;
            }
            if (isNaN(totalTime) || totalTime <= 0)
            {
                if (waitingForEnough && stateResponsive)
                {
                    waitingForEnough = false;
                    _cachedState = _state;
                    _state = VideoState.EXEC_QUEUED_CMD;
                    play();
                    execQueuedCmds();
                }
                return;
            }
            if (param1 >= param2)
            {
                if (waitingForEnough)
                {
                    waitingForEnough = false;
                    _cachedState = _state;
                    _state = VideoState.EXEC_QUEUED_CMD;
                    play();
                    execQueuedCmds();
                }
                return;
            }
            if (isNaN(baselineProgressTime))
            {
                baselineProgressTime = param1 / param2 * totalTime;
            }
            if (isNaN(startProgressTime))
            {
                startProgressTime = getTimer();
            }
            else
            {
                totalDownloadTime = (getTimer() - startProgressTime) / 1000;
                totalProgressTime = param1 / param2 * totalTime;
                if (waitingForEnough)
                {
                    checkReadyForPlay(param1, param2);
                }
            }
            return;
        }// end function

        public function close() : void
        {
            closeNS(true);
            if (_ncMgr != null && _ncMgr.isRTMP)
            {
                _ncMgr.close();
            }
            setState(VideoState.DISCONNECTED);
            dispatchEvent(new VideoEvent(VideoEvent.CLOSE, false, false, _state, playheadTime));
            return;
        }// end function

        public function pause() : void
        {
            if (!isXnOK())
            {
                if (_state == VideoState.CONNECTION_ERROR || _ncMgr == null || _ncMgr.netConnection == null)
                {
                    throw new VideoError(VideoError.NO_CONNECTION);
                }
                return;
            }
            else if (_state == VideoState.EXEC_QUEUED_CMD)
            {
                _state = _cachedState;
            }
            else
            {
                if (!stateResponsive)
                {
                    queueCmd(QueuedCommand.PAUSE);
                    return;
                }
                execQueuedCmds();
            }
            if (_state == VideoState.PAUSED || _state == VideoState.STOPPED || _ns == null)
            {
                return;
            }
            _pause(true);
            setState(VideoState.PAUSED);
            return;
        }// end function

    }
}
