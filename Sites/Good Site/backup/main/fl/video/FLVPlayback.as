package fl.video
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class FLVPlayback extends Sprite
    {
        private var _playheadUpdateInterval:Number;
        private var _align:String;
        var videoPlayerStateDict:Dictionary;
        var cuePointMgrs:Array;
        private var _volume:Number;
        private var _origHeight:Number;
        var videoPlayerStates:Array;
        private var _progressInterval:Number;
        private var _seekToPrevOffset:Number;
        private var _origWidth:Number;
        private var _scaleMode:String;
        var resizingNow:Boolean;
        var videoPlayers:Array;
        private var _bufferTime:Number;
        private var _aspectRatio:Boolean;
        private var _autoRewind:Boolean;
        var uiMgr:UIManager;
        private var previewImage_mc:Loader;
        private var _componentInspectorSetting:Boolean;
        var _firstStreamShown:Boolean;
        private var _visibleVP:uint;
        private var _idleTimeout:Number;
        private var _soundTransform:SoundTransform;
        public var boundingBox_mc:DisplayObject;
        var skinShowTimer:Timer;
        private var preview_mc:MovieClip;
        private var livePreviewHeight:Number;
        var _firstStreamReady:Boolean;
        private var _activeVP:uint;
        private var isLivePreview:Boolean;
        private var _topVP:uint;
        private var livePreviewWidth:Number;
        private var __forceNCMgr:NCManager;
        private var previewImageUrl:String;
        public static const SEEK_TO_PREV_OFFSET_DEFAULT:Number = 1;
        public static const SHORT_VERSION:String = "2.1";
        static const skinShowTimerInterval:Number = 2000;
        public static const VERSION:String = "2.1.0.14";
        static const DEFAULT_SKIN_SHOW_TIMER_INTERVAL:Number = 2000;

        public function FLVPlayback()
        {
            var _loc_1:VideoPlayer = null;
            mouseEnabled = false;
            isLivePreview = parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent";
            _componentInspectorSetting = false;
            _origWidth = super.width;
            _origHeight = super.height;
            super.scaleX = 1;
            super.scaleY = 1;
            _loc_1 = new VideoPlayer(0, 0);
            _loc_1.setSize(_origWidth, _origHeight);
            videoPlayers = new Array();
            videoPlayers[0] = _loc_1;
            _align = _loc_1.align;
            _autoRewind = _loc_1.autoRewind;
            _scaleMode = _loc_1.scaleMode;
            _bufferTime = _loc_1.bufferTime;
            _idleTimeout = _loc_1.idleTimeout;
            _playheadUpdateInterval = _loc_1.playheadUpdateInterval;
            _progressInterval = _loc_1.progressInterval;
            _soundTransform = _loc_1.soundTransform;
            _volume = _loc_1.volume;
            _seekToPrevOffset = SEEK_TO_PREV_OFFSET_DEFAULT;
            _firstStreamReady = false;
            _firstStreamShown = false;
            resizingNow = false;
            uiMgr = new UIManager(this);
            if (isLivePreview)
            {
                uiMgr.visible = true;
            }
            _activeVP = 0;
            _visibleVP = 0;
            _topVP = 0;
            videoPlayerStates = new Array();
            videoPlayerStateDict = new Dictionary(true);
            cuePointMgrs = new Array();
            createVideoPlayer(0);
            boundingBox_mc.visible = false;
            removeChild(boundingBox_mc);
            boundingBox_mc = null;
            if (isLivePreview)
            {
                previewImageUrl = "";
                createLivePreviewMovieClip();
                setSize(_origWidth, _origHeight);
            }
            return;
        }// end function

        public function set fullScreenTakeOver(param1:Boolean) : void
        {
            uiMgr.fullScreenTakeOver = param1;
            return;
        }// end function

        public function pause() : void
        {
            var _loc_1:VideoPlayerState = null;
            var _loc_2:VideoPlayer = null;
            if (!_firstStreamShown)
            {
                _loc_1 = videoPlayerStates[_activeVP];
                queueCmd(_loc_1, QueuedCommand.PAUSE);
            }
            else
            {
                _loc_2 = videoPlayers[_activeVP];
                _loc_2.pause();
            }
            return;
        }// end function

        public function setScale(param1:Number, param2:Number) : void
        {
            var _loc_3:Rectangle = null;
            var _loc_4:Rectangle = null;
            var _loc_5:int = 0;
            var _loc_6:VideoPlayer = null;
            _loc_3 = new Rectangle(x, y, width, height);
            _loc_4 = new Rectangle(registrationX, registrationY, registrationWidth, registrationHeight);
            resizingNow = true;
            _loc_5 = 0;
            while (_loc_5 < videoPlayers.length)
            {
                
                _loc_6 = videoPlayers[_loc_5];
                if (_loc_6 !== null)
                {
                    _loc_6.setSize(_origWidth * param1, _origWidth * param2);
                }
                _loc_5++;
            }
            resizingNow = false;
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT, false, false, _loc_3, _loc_4));
            return;
        }// end function

        public function stop() : void
        {
            var _loc_1:VideoPlayerState = null;
            var _loc_2:VideoPlayer = null;
            if (!_firstStreamShown)
            {
                _loc_1 = videoPlayerStates[_activeVP];
                queueCmd(_loc_1, QueuedCommand.STOP);
            }
            else
            {
                _loc_2 = videoPlayers[_activeVP];
                _loc_2.stop();
            }
            return;
        }// end function

        public function set align(param1:String) : void
        {
            var _loc_2:VideoPlayer = null;
            if (_activeVP == 0)
            {
                _align = param1;
            }
            _loc_2 = videoPlayers[_activeVP];
            _loc_2.align = param1;
            return;
        }// end function

        public function getVideoPlayer(param1:Number) : VideoPlayer
        {
            return videoPlayers[param1];
        }// end function

        public function get playheadTime() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.playheadTime;
        }// end function

        public function get progressInterval() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.progressInterval;
        }// end function

        public function set skinFadeTime(param1:int) : void
        {
            uiMgr.skinFadeTime = param1;
            return;
        }// end function

        public function get seekToPrevOffset() : Number
        {
            return _seekToPrevOffset;
        }// end function

        public function set playheadTime(param1:Number) : void
        {
            seek(param1);
            return;
        }// end function

        public function get source() : String
        {
            var _loc_1:VideoPlayerState = null;
            var _loc_2:VideoPlayer = null;
            _loc_1 = videoPlayerStates[_activeVP];
            if (_loc_1.isWaiting)
            {
                return _loc_1.url;
            }
            _loc_2 = videoPlayers[_activeVP];
            return _loc_2.source;
        }// end function

        public function get activeVideoPlayerIndex() : uint
        {
            return _activeVP;
        }// end function

        public function get skinFadeTime() : int
        {
            return uiMgr.skinFadeTime;
        }// end function

        public function set scaleMode(param1:String) : void
        {
            var _loc_2:VideoPlayer = null;
            if (_activeVP == 0)
            {
                _scaleMode = param1;
            }
            _loc_2 = videoPlayers[_activeVP];
            _loc_2.scaleMode = param1;
            return;
        }// end function

        public function set bufferingBar(param1:Sprite) : void
        {
            uiMgr.setControl(UIManager.BUFFERING_BAR, param1);
            return;
        }// end function

        public function get metadataLoaded() : Boolean
        {
            var _loc_1:CuePointManager = null;
            _loc_1 = cuePointMgrs[_activeVP];
            return _loc_1.metadataLoaded;
        }// end function

        public function closeVideoPlayer(param1:uint) : void
        {
            var _loc_2:VideoPlayer = null;
            if (param1 == 0)
            {
                throw new VideoError(VideoError.DELETE_DEFAULT_PLAYER);
            }
            if (videoPlayers[param1] == undefined)
            {
                return;
            }
            _loc_2 = videoPlayers[param1];
            if (_visibleVP == param1)
            {
                visibleVideoPlayerIndex = 0;
            }
            if (_activeVP == param1)
            {
                activeVideoPlayerIndex = 0;
            }
            removeChild(_loc_2);
            _loc_2.close();
            delete videoPlayers[param1];
            delete videoPlayerStates[param1];
            delete videoPlayerStateDict[_loc_2];
            return;
        }// end function

        public function get scaleMode() : String
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.scaleMode;
        }// end function

        public function set progressInterval(param1:Number) : void
        {
            var _loc_2:VideoPlayer = null;
            if (_activeVP == 0)
            {
                _progressInterval = param1;
            }
            _loc_2 = videoPlayers[_activeVP];
            _loc_2.progressInterval = param1;
            return;
        }// end function

        public function get playing() : Boolean
        {
            return state == VideoState.PLAYING;
        }// end function

        public function get totalTime() : Number
        {
            var _loc_1:VideoPlayerState = null;
            var _loc_2:VideoPlayer = null;
            if (isLivePreview)
            {
                return 1;
            }
            _loc_1 = videoPlayerStates[_activeVP];
            if (_loc_1.totalTimeSet)
            {
                return _loc_1.totalTime;
            }
            _loc_2 = videoPlayers[_activeVP];
            return _loc_2.totalTime;
        }// end function

        public function get ncMgr() : INCManager
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.ncMgr;
        }// end function

        public function set volume(param1:Number) : void
        {
            var _loc_2:VideoPlayer = null;
            if (_volume == param1)
            {
                return;
            }
            _volume = param1;
            if (!scrubbing)
            {
                _loc_2 = videoPlayers[_visibleVP];
                _loc_2.volume = _volume;
            }
            dispatchEvent(new SoundEvent(SoundEvent.SOUND_UPDATE, false, false, _loc_2.soundTransform));
            return;
        }// end function

        public function get skinAutoHide() : Boolean
        {
            return uiMgr.skinAutoHide;
        }// end function

        public function set source(param1:String) : void
        {
            var _loc_2:VideoPlayerState = null;
            var _loc_3:CuePointManager = null;
            if (isLivePreview)
            {
                return;
            }
            if (param1 == null)
            {
                param1 = "";
            }
            if (_componentInspectorSetting)
            {
                _loc_2 = videoPlayerStates[_activeVP];
                _loc_2.url = param1;
                if (param1.length > 0)
                {
                    _loc_2.isWaiting = true;
                    addEventListener(Event.ENTER_FRAME, doContentPathConnect);
                }
            }
            else
            {
                if (source == param1)
                {
                    return;
                }
                _loc_3 = cuePointMgrs[_activeVP];
                _loc_3.reset();
                _loc_2 = videoPlayerStates[_activeVP];
                _loc_2.url = param1;
                _loc_2.isWaiting = true;
                doContentPathConnect(_activeVP);
            }
            return;
        }// end function

        public function set activeVideoPlayerIndex(param1:uint) : void
        {
            if (_activeVP == param1)
            {
                return;
            }
            _activeVP = param1;
            if (videoPlayers[_activeVP] == undefined)
            {
                createVideoPlayer(_activeVP);
            }
            return;
        }// end function

        override public function set soundTransform(param1:SoundTransform) : void
        {
            var _loc_2:VideoPlayer = null;
            if (param1 == null)
            {
                return;
            }
            _volume = param1.volume;
            _soundTransform.volume = scrubbing ? (0) : (param1.volume);
            _soundTransform.leftToLeft = param1.leftToLeft;
            _soundTransform.leftToRight = param1.leftToRight;
            _soundTransform.rightToLeft = param1.rightToLeft;
            _soundTransform.rightToRight = param1.rightToRight;
            _loc_2 = videoPlayers[_activeVP];
            _loc_2.soundTransform = _soundTransform;
            dispatchEvent(new SoundEvent(SoundEvent.SOUND_UPDATE, false, false, _loc_2.soundTransform));
            return;
        }// end function

        public function set seekToPrevOffset(param1:Number) : void
        {
            _seekToPrevOffset = param1;
            return;
        }// end function

        public function set seekBarScrubTolerance(param1:Number) : void
        {
            uiMgr.seekBarScrubTolerance = param1;
            return;
        }// end function

        override public function get scaleX() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_visibleVP];
            return _loc_1.width / _origWidth;
        }// end function

        override public function get scaleY() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_visibleVP];
            return _loc_1.height / _origHeight;
        }// end function

        public function get bytesLoaded() : uint
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.bytesLoaded;
        }// end function

        override public function set height(param1:Number) : void
        {
            var _loc_2:Rectangle = null;
            var _loc_3:Rectangle = null;
            var _loc_4:int = 0;
            var _loc_5:VideoPlayer = null;
            if (isLivePreview)
            {
                setSize(this.width, param1);
                return;
            }
            _loc_2 = new Rectangle(x, y, width, height);
            _loc_3 = new Rectangle(registrationX, registrationY, registrationWidth, registrationHeight);
            resizingNow = true;
            _loc_4 = 0;
            while (_loc_4 < videoPlayers.length)
            {
                
                _loc_5 = videoPlayers[_loc_4];
                if (_loc_5 != null)
                {
                    _loc_5.height = param1;
                }
                _loc_4++;
            }
            resizingNow = false;
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT, false, false, _loc_2, _loc_3));
            return;
        }// end function

        public function get forwardButton() : Sprite
        {
            return uiMgr.getControl(UIManager.FORWARD_BUTTON);
        }// end function

        public function get seekBarInterval() : Number
        {
            return uiMgr.seekBarInterval;
        }// end function

        public function set totalTime(param1:Number) : void
        {
            var _loc_2:VideoPlayerState = null;
            _loc_2 = videoPlayerStates[_activeVP];
            _loc_2.totalTime = param1;
            _loc_2.totalTimeSet = true;
            return;
        }// end function

        public function set skinAutoHide(param1:Boolean) : void
        {
            if (isLivePreview)
            {
                return;
            }
            uiMgr.skinAutoHide = param1;
            return;
        }// end function

        public function set bufferTime(param1:Number) : void
        {
            var _loc_2:VideoPlayer = null;
            _loc_2 = videoPlayers[_activeVP];
            _loc_2.bufferTime = param1;
            return;
        }// end function

        public function get fullScreenSkinDelay() : int
        {
            return uiMgr.fullScreenSkinDelay;
        }// end function

        public function seekToNavCuePoint(param1) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Object = null;
            if (param1 is String)
            {
                _loc_2 = {name:String(param1)};
            }
            else if (param1 is Number)
            {
                _loc_2 = {time:Number(param1)};
            }
            else
            {
                _loc_2 = param1;
            }
            if (_loc_2.name == undefined)
            {
                seekToNextNavCuePoint(_loc_2.time);
                return;
            }
            if (isNaN(_loc_2.time))
            {
                _loc_2.time = 0;
            }
            _loc_3 = findNearestCuePoint(param1, CuePointType.NAVIGATION);
            while (_loc_3 != null && (_loc_3.time < _loc_2.time || !isFLVCuePointEnabled(_loc_3)))
            {
                
                _loc_3 = findNextCuePointWithName(_loc_3);
            }
            if (_loc_3 == null)
            {
                throw new VideoError(VideoError.INVALID_SEEK);
            }
            seek(_loc_3.time);
            return;
        }// end function

        private function onCompletePreview(event:Event) : void
        {
            var e:* = event;
            try
            {
                previewImage_mc.width = livePreviewWidth;
                previewImage_mc.height = livePreviewHeight;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function set isLive(param1:Boolean) : void
        {
            var _loc_2:VideoPlayerState = null;
            _loc_2 = videoPlayerStates[_activeVP];
            _loc_2.isLive = param1;
            _loc_2.isLiveSet = true;
            return;
        }// end function

        function showSkinNow(event:TimerEvent) : void
        {
            skinShowTimer = null;
            uiMgr.visible = true;
            return;
        }// end function

        override public function get x() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_visibleVP];
            return super.x + _loc_1.x;
        }// end function

        override public function get y() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_visibleVP];
            return super.y + _loc_1.y;
        }// end function

        public function get seekBar() : Sprite
        {
            return uiMgr.getControl(UIManager.SEEK_BAR);
        }// end function

        public function get volumeBarInterval() : Number
        {
            return uiMgr.volumeBarInterval;
        }// end function

        public function set registrationHeight(param1:Number) : void
        {
            height = param1;
            return;
        }// end function

        public function get bufferingBarHidesAndDisablesOthers() : Boolean
        {
            return uiMgr.bufferingBarHidesAndDisablesOthers;
        }// end function

        public function seek(param1:Number) : void
        {
            var _loc_2:VideoPlayerState = null;
            var _loc_3:VideoPlayer = null;
            _loc_2 = videoPlayerStates[_activeVP];
            if (!_firstStreamShown)
            {
                _loc_2.preSeekTime = 0;
                queueCmd(_loc_2, QueuedCommand.SEEK, param1);
            }
            else
            {
                _loc_2.preSeekTime = playheadTime;
                _loc_3 = videoPlayers[_activeVP];
                _loc_3.seek(param1);
            }
            return;
        }// end function

        public function get state() : String
        {
            var _loc_1:VideoPlayer = null;
            var _loc_2:String = null;
            var _loc_3:VideoPlayerState = null;
            if (isLivePreview)
            {
                return VideoState.STOPPED;
            }
            _loc_1 = videoPlayers[_activeVP];
            if (_activeVP == _visibleVP && scrubbing)
            {
                return VideoState.SEEKING;
            }
            _loc_2 = _loc_1.state;
            if (_loc_2 == VideoState.RESIZING)
            {
                return VideoState.LOADING;
            }
            _loc_3 = videoPlayerStates[_activeVP];
            if (_loc_3.prevState == VideoState.LOADING && _loc_3.autoPlay && _loc_2 == VideoState.STOPPED)
            {
                return VideoState.LOADING;
            }
            return _loc_2;
        }// end function

        public function set autoRewind(param1:Boolean) : void
        {
            var _loc_2:VideoPlayer = null;
            if (_activeVP == 0)
            {
                _autoRewind = param1;
            }
            _loc_2 = videoPlayers[_activeVP];
            _loc_2.autoRewind = param1;
            return;
        }// end function

        public function get volumeBar() : Sprite
        {
            return uiMgr.getControl(UIManager.VOLUME_BAR);
        }// end function

        function skinError(param1:String) : void
        {
            if (isLivePreview)
            {
                return;
            }
            if (_firstStreamReady && !_firstStreamShown)
            {
                showFirstStream();
            }
            dispatchEvent(new SkinErrorEvent(SkinErrorEvent.SKIN_ERROR, false, false, param1));
            return;
        }// end function

        override public function set scaleX(param1:Number) : void
        {
            var _loc_2:Rectangle = null;
            var _loc_3:Rectangle = null;
            var _loc_4:int = 0;
            var _loc_5:VideoPlayer = null;
            _loc_2 = new Rectangle(x, y, width, height);
            _loc_3 = new Rectangle(registrationX, registrationY, registrationWidth, registrationHeight);
            resizingNow = true;
            _loc_4 = 0;
            while (_loc_4 < videoPlayers.length)
            {
                
                _loc_5 = videoPlayers[_loc_4];
                if (_loc_5 !== null)
                {
                    _loc_5.width = _origWidth * param1;
                }
                _loc_4++;
            }
            resizingNow = false;
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT, false, false, _loc_2, _loc_3));
            return;
        }// end function

        override public function set scaleY(param1:Number) : void
        {
            var _loc_2:Rectangle = null;
            var _loc_3:Rectangle = null;
            var _loc_4:int = 0;
            var _loc_5:VideoPlayer = null;
            _loc_2 = new Rectangle(x, y, width, height);
            _loc_3 = new Rectangle(registrationX, registrationY, registrationWidth, registrationHeight);
            resizingNow = true;
            _loc_4 = 0;
            while (_loc_4 < videoPlayers.length)
            {
                
                _loc_5 = videoPlayers[_loc_4];
                if (_loc_5 !== null)
                {
                    _loc_5.height = _origHeight * param1;
                }
                _loc_4++;
            }
            resizingNow = false;
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT, false, false, _loc_2, _loc_3));
            return;
        }// end function

        function createVideoPlayer(param1:Number) : void
        {
            var vp:VideoPlayer;
            var added:Boolean;
            var vpState:VideoPlayerState;
            var cpMgr:CuePointManager;
            var skinDepth:int;
            var index:* = param1;
            if (isLivePreview)
            {
                return;
            }
            vp = videoPlayers[index];
            if (vp == null)
            {
                var _loc_3:* = new VideoPlayer(0, 0);
                vp = new VideoPlayer(0, 0);
                videoPlayers[index] = _loc_3;
                vp.setSize(registrationWidth, registrationHeight);
            }
            vp.visible = false;
            vp.volume = 0;
            vp.name = String(index);
            added;
            if (uiMgr.skin_mc != null)
            {
                try
                {
                    skinDepth = getChildIndex(uiMgr.skin_mc);
                    if (skinDepth > 0)
                    {
                        addChildAt(vp, skinDepth);
                        added;
                    }
                }
                catch (err:Error)
                {
                }
            }
            if (!added)
            {
                addChild(vp);
            }
            _topVP = index;
            vp.autoRewind = _autoRewind;
            vp.scaleMode = _scaleMode;
            vp.bufferTime = _bufferTime;
            vp.idleTimeout = _idleTimeout;
            vp.playheadUpdateInterval = _playheadUpdateInterval;
            vp.progressInterval = _progressInterval;
            vp.soundTransform = _soundTransform;
            vpState = new VideoPlayerState(vp, index);
            videoPlayerStates[index] = vpState;
            videoPlayerStateDict[vp] = vpState;
            vp.addEventListener(AutoLayoutEvent.AUTO_LAYOUT, handleAutoLayoutEvent);
            vp.addEventListener(MetadataEvent.CUE_POINT, handleMetadataEvent);
            vp.addEventListener(MetadataEvent.METADATA_RECEIVED, handleMetadataEvent);
            vp.addEventListener(VideoProgressEvent.PROGRESS, handleVideoProgressEvent);
            vp.addEventListener(VideoEvent.AUTO_REWOUND, handleVideoEvent);
            vp.addEventListener(VideoEvent.CLOSE, handleVideoEvent);
            vp.addEventListener(VideoEvent.COMPLETE, handleVideoEvent);
            vp.addEventListener(VideoEvent.PLAYHEAD_UPDATE, handleVideoEvent);
            vp.addEventListener(VideoEvent.STATE_CHANGE, handleVideoEvent);
            vp.addEventListener(VideoEvent.READY, handleVideoEvent);
            cpMgr = new CuePointManager(this, index);
            cuePointMgrs[index] = cpMgr;
            cpMgr.playheadUpdateInterval = _playheadUpdateInterval;
            return;
        }// end function

        public function findNearestCuePoint(param1, param2:String = "all") : Object
        {
            var _loc_3:CuePointManager = null;
            _loc_3 = cuePointMgrs[_activeVP];
            switch(param2)
            {
                case "event":
                {
                    return _loc_3.getCuePoint(_loc_3.eventCuePoints, true, param1);
                }
                case "navigation":
                {
                    return _loc_3.getCuePoint(_loc_3.navCuePoints, true, param1);
                }
                case "flv":
                {
                    return _loc_3.getCuePoint(_loc_3.flvCuePoints, true, param1);
                }
                case "actionscript":
                {
                    return _loc_3.getCuePoint(_loc_3.asCuePoints, true, param1);
                }
                case "all":
                {
                }
                default:
                {
                    return _loc_3.getCuePoint(_loc_3.allCuePoints, true, param1);
                    break;
                }
            }
        }// end function

        public function get muteButton() : Sprite
        {
            return uiMgr.getControl(UIManager.MUTE_BUTTON);
        }// end function

        public function seekPercent(param1:Number) : void
        {
            var _loc_2:VideoPlayer = null;
            _loc_2 = videoPlayers[_activeVP];
            if (isNaN(param1) || param1 < 0 || param1 > 100 || isNaN(_loc_2.totalTime) || _loc_2.totalTime <= 0)
            {
                throw new VideoError(VideoError.INVALID_SEEK);
            }
            seek(_loc_2.totalTime * param1 / 100);
            return;
        }// end function

        public function set forwardButton(param1:Sprite) : void
        {
            uiMgr.setControl(UIManager.FORWARD_BUTTON, param1);
            return;
        }// end function

        public function get registrationWidth() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_visibleVP];
            return _loc_1.registrationWidth;
        }// end function

        function queueCmd(param1:VideoPlayerState, param2:Number, param3:Number = NaN) : void
        {
            if (param1.cmdQueue == null)
            {
                param1.cmdQueue = new Array();
            }
            param1.cmdQueue.push(new QueuedCommand(param2, null, false, param3));
            return;
        }// end function

        private function doContentPathConnect(param1) : void
        {
            var _loc_2:int = 0;
            var _loc_3:VideoPlayer = null;
            var _loc_4:VideoPlayerState = null;
            if (isLivePreview)
            {
                return;
            }
            _loc_2 = 0;
            if (param1 is int)
            {
                _loc_2 = int(param1);
            }
            else
            {
                removeEventListener(Event.ENTER_FRAME, doContentPathConnect);
            }
            _loc_3 = videoPlayers[_loc_2];
            _loc_4 = videoPlayerStates[_loc_2];
            if (!_loc_4.isWaiting)
            {
                return;
            }
            if (_loc_4.autoPlay && _firstStreamShown)
            {
                _loc_3.play(_loc_4.url, _loc_4.totalTime, _loc_4.isLive);
            }
            else
            {
                _loc_3.load(_loc_4.url, _loc_4.totalTime, _loc_4.isLive);
            }
            _loc_4.isLiveSet = false;
            _loc_4.totalTimeSet = false;
            _loc_4.isWaiting = false;
            return;
        }// end function

        public function get registrationX() : Number
        {
            return super.x;
        }// end function

        public function bringVideoPlayerToFront(param1:uint) : void
        {
            var vp:VideoPlayer;
            var moved:Boolean;
            var skinDepth:int;
            var index:* = param1;
            if (index == _topVP)
            {
                return;
            }
            vp = videoPlayers[index];
            if (vp == null)
            {
                createVideoPlayer(index);
                vp = videoPlayers[index];
            }
            moved;
            if (uiMgr.skin_mc != null)
            {
                try
                {
                    skinDepth = getChildIndex(uiMgr.skin_mc);
                    if (skinDepth > 0)
                    {
                        setChildIndex(vp, (skinDepth - 1));
                        moved;
                    }
                }
                catch (err:Error)
                {
                }
            }
            if (!moved)
            {
                setChildIndex(vp, (numChildren - 1));
            }
            _topVP = index;
            return;
        }// end function

        public function get registrationY() : Number
        {
            return super.y;
        }// end function

        public function get pauseButton() : Sprite
        {
            return uiMgr.getControl(UIManager.PAUSE_BUTTON);
        }// end function

        public function set seekBarInterval(param1:Number) : void
        {
            uiMgr.seekBarInterval = param1;
            return;
        }// end function

        public function addASCuePoint(param1, param2:String = null, param3:Object = null) : Object
        {
            var _loc_4:CuePointManager = null;
            _loc_4 = cuePointMgrs[_activeVP];
            return _loc_4.addASCuePoint(param1, param2, param3);
        }// end function

        public function get playheadPercentage() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            if (isNaN(_loc_1.totalTime))
            {
                return NaN;
            }
            return _loc_1.playheadTime / _loc_1.totalTime * 100;
        }// end function

        public function setFLVCuePointEnabled(param1:Boolean, param2) : Number
        {
            var _loc_3:CuePointManager = null;
            _loc_3 = cuePointMgrs[_activeVP];
            return _loc_3.setFLVCuePointEnabled(param1, param2);
        }// end function

        public function set fullScreenSkinDelay(param1:int) : void
        {
            uiMgr.fullScreenSkinDelay = param1;
            return;
        }// end function

        public function seekToNextNavCuePoint(param1:Number = NaN) : void
        {
            var _loc_2:VideoPlayer = null;
            var _loc_3:Object = null;
            var _loc_4:Number = NaN;
            _loc_2 = videoPlayers[_activeVP];
            if (isNaN(param1) || param1 < 0)
            {
                param1 = _loc_2.playheadTime + 0.001;
            }
            _loc_3 = findNearestCuePoint(param1, CuePointType.NAVIGATION);
            if (_loc_3 == null)
            {
                seek(_loc_2.totalTime);
                return;
            }
            _loc_4 = _loc_3.index;
            if (_loc_3.time < param1)
            {
                _loc_4 = _loc_4 + 1;
            }
            while (_loc_4 < _loc_3.array.length && !isFLVCuePointEnabled(_loc_3.array[_loc_4]))
            {
                
                _loc_4 = _loc_4 + 1;
            }
            if (_loc_4 >= _loc_3.array.length)
            {
                param1 = _loc_2.totalTime;
                if (_loc_3.array[(_loc_3.array.length - 1)].time > param1)
                {
                    param1 = _loc_3.array[(_loc_3.array.length - 1)];
                }
                seek(param1);
            }
            else
            {
                seek(_loc_3.array[_loc_4].time);
            }
            return;
        }// end function

        public function load(param1:String, param2:Number = NaN, param3:Boolean = false) : void
        {
            if (param1 == null || param1.length == 0)
            {
                return;
            }
            if (param1 == this.source)
            {
                return;
            }
            this.autoPlay = false;
            this.totalTime = param2;
            this.isLive = param3;
            this.source = param1;
            return;
        }// end function

        public function seekSeconds(param1:Number) : void
        {
            seek(param1);
            return;
        }// end function

        public function get fullScreenButton() : Sprite
        {
            return uiMgr.getControl(UIManager.FULL_SCREEN_BUTTON);
        }// end function

        public function get scrubbing() : Boolean
        {
            var _loc_1:Sprite = null;
            var _loc_2:ControlData = null;
            _loc_1 = seekBar;
            if (_loc_1 != null)
            {
                _loc_2 = uiMgr.ctrlDataDict[_loc_1];
                return _loc_2.isDragging;
            }
            return false;
        }// end function

        override public function set y(param1:Number) : void
        {
            var _loc_2:VideoPlayer = null;
            _loc_2 = videoPlayers[_visibleVP];
            super.y = param1 - _loc_2.y;
            return;
        }// end function

        public function removeASCuePoint(param1) : Object
        {
            var _loc_2:CuePointManager = null;
            _loc_2 = cuePointMgrs[_activeVP];
            return _loc_2.removeASCuePoint(param1);
        }// end function

        public function get fullScreenTakeOver() : Boolean
        {
            return uiMgr.fullScreenTakeOver;
        }// end function

        override public function set x(param1:Number) : void
        {
            var _loc_2:VideoPlayer = null;
            _loc_2 = videoPlayers[_visibleVP];
            super.x = param1 - _loc_2.x;
            return;
        }// end function

        public function get backButton() : Sprite
        {
            return uiMgr.getControl(UIManager.BACK_BUTTON);
        }// end function

        public function set seekBar(param1:Sprite) : void
        {
            uiMgr.setControl(UIManager.SEEK_BAR, param1);
            return;
        }// end function

        public function set skin(param1:String) : void
        {
            uiMgr.skin = param1;
            return;
        }// end function

        public function set componentInspectorSetting(param1:Boolean) : void
        {
            _componentInspectorSetting = param1;
            return;
        }// end function

        public function get preferredHeight() : int
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.videoHeight;
        }// end function

        public function set volumeBarInterval(param1:Number) : void
        {
            uiMgr.volumeBarInterval = param1;
            return;
        }// end function

        public function set autoPlay(param1:Boolean) : void
        {
            var _loc_2:VideoPlayerState = null;
            _loc_2 = videoPlayerStates[_activeVP];
            _loc_2.autoPlay = param1;
            return;
        }// end function

        public function set visibleVideoPlayerIndex(param1:uint) : void
        {
            var _loc_2:VideoPlayer = null;
            var _loc_3:VideoPlayer = null;
            var _loc_4:uint = 0;
            var _loc_5:Rectangle = null;
            var _loc_6:Rectangle = null;
            if (_visibleVP == param1)
            {
                return;
            }
            if (videoPlayers[param1] == undefined)
            {
                createVideoPlayer(param1);
            }
            _loc_2 = videoPlayers[param1];
            _loc_3 = videoPlayers[_visibleVP];
            _loc_3.visible = false;
            _loc_3.volume = 0;
            _visibleVP = param1;
            if (_firstStreamShown)
            {
                uiMgr.setupSkinAutoHide(false);
                _loc_2.visible = true;
                _soundTransform.volume = !scrubbing ? (0) : (_volume);
                _loc_2.soundTransform = _soundTransform;
            }
            else if ((_loc_2.stateResponsive || _loc_2.state == VideoState.CONNECTION_ERROR || _loc_2.state == VideoState.DISCONNECTED) && uiMgr.skinReady)
            {
                uiMgr.visible = true;
                uiMgr.setupSkinAutoHide(false);
                _firstStreamReady = true;
                if (uiMgr.skin == "")
                {
                    uiMgr.hookUpCustomComponents();
                }
                showFirstStream();
            }
            if (_loc_2.height != _loc_3.height || _loc_2.width != _loc_3.width)
            {
                _loc_5 = new Rectangle(_loc_3.x + super.x, _loc_3.y + super.y, _loc_3.width, _loc_3.height);
                _loc_6 = new Rectangle(_loc_3.registrationX + super.x, _loc_3.registrationY + super.y, _loc_3.registrationWidth, _loc_3.registrationHeight);
                dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT, false, false, _loc_5, _loc_6));
            }
            _loc_4 = _activeVP;
            _activeVP = _visibleVP;
            uiMgr.handleIVPEvent(new VideoEvent(VideoEvent.STATE_CHANGE, false, false, state, playheadTime, _visibleVP));
            uiMgr.handleIVPEvent(new VideoEvent(VideoEvent.PLAYHEAD_UPDATE, false, false, state, playheadTime, _visibleVP));
            if (_loc_2.isRTMP)
            {
                uiMgr.handleIVPEvent(new VideoEvent(VideoEvent.READY, false, false, state, playheadTime, _visibleVP));
            }
            else
            {
                uiMgr.handleIVPEvent(new VideoProgressEvent(VideoProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal, _visibleVP));
            }
            _activeVP = _loc_4;
            return;
        }// end function

        public function get bufferingBar() : Sprite
        {
            return uiMgr.getControl(UIManager.BUFFERING_BAR);
        }// end function

        function _scrubStart() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:VideoPlayer = null;
            _loc_1 = playheadTime;
            _loc_2 = videoPlayers[_visibleVP];
            _volume = _loc_2.volume;
            _loc_2.volume = 0;
            dispatchEvent(new VideoEvent(VideoEvent.STATE_CHANGE, false, false, VideoState.SEEKING, _loc_1, _visibleVP));
            dispatchEvent(new VideoEvent(VideoEvent.SCRUB_START, false, false, VideoState.SEEKING, _loc_1, _visibleVP));
            return;
        }// end function

        public function get align() : String
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.align;
        }// end function

        function handleAutoLayoutEvent(event:AutoLayoutEvent) : void
        {
            var _loc_2:VideoPlayerState = null;
            var _loc_3:AutoLayoutEvent = null;
            var _loc_4:Rectangle = null;
            var _loc_5:Rectangle = null;
            _loc_2 = videoPlayerStateDict[event.currentTarget];
            _loc_3 = AutoLayoutEvent(event.clone());
            _loc_3.oldBounds.x = _loc_3.oldBounds.x + super.x;
            _loc_3.oldBounds.y = _loc_3.oldBounds.y + super.y;
            _loc_3.oldRegistrationBounds.x = _loc_3.oldRegistrationBounds.x + super.y;
            _loc_3.oldRegistrationBounds.y = _loc_3.oldRegistrationBounds.y + super.y;
            _loc_3.vp = _loc_2.index;
            dispatchEvent(_loc_3);
            if (!resizingNow && _loc_2.index == _visibleVP)
            {
                _loc_4 = Rectangle(event.oldBounds.clone());
                _loc_5 = Rectangle(event.oldRegistrationBounds.clone());
                _loc_4.x = _loc_4.x + super.x;
                _loc_4.y = _loc_4.y + super.y;
                _loc_5.x = _loc_5.x + super.y;
                _loc_5.y = _loc_5.y + super.y;
                dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT, false, false, _loc_4, _loc_5));
            }
            return;
        }// end function

        public function findNextCuePointWithName(param1:Object) : Object
        {
            var _loc_2:CuePointManager = null;
            _loc_2 = cuePointMgrs[_activeVP];
            return _loc_2.getNextCuePointWithName(param1);
        }// end function

        public function set playButton(param1:Sprite) : void
        {
            uiMgr.setControl(UIManager.PLAY_BUTTON, param1);
            return;
        }// end function

        public function set bitrate(param1:Number) : void
        {
            ncMgr.bitrate = param1;
            return;
        }// end function

        public function set bufferingBarHidesAndDisablesOthers(param1:Boolean) : void
        {
            uiMgr.bufferingBarHidesAndDisablesOthers = param1;
            return;
        }// end function

        override public function get soundTransform() : SoundTransform
        {
            var _loc_1:VideoPlayer = null;
            var _loc_2:SoundTransform = null;
            _loc_1 = videoPlayers[_visibleVP];
            _loc_2 = _loc_1.soundTransform;
            if (scrubbing)
            {
                _loc_2.volume = _volume;
            }
            return _loc_2;
        }// end function

        public function get stateResponsive() : Boolean
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.stateResponsive;
        }// end function

        public function get idleTimeout() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.idleTimeout;
        }// end function

        override public function get height() : Number
        {
            var _loc_1:VideoPlayer = null;
            if (isLivePreview)
            {
                return livePreviewHeight;
            }
            _loc_1 = videoPlayers[_visibleVP];
            return _loc_1.height;
        }// end function

        public function set registrationWidth(param1:Number) : void
        {
            width = param1;
            return;
        }// end function

        public function get metadata() : Object
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.metadata;
        }// end function

        public function set skinBackgroundColor(param1:uint) : void
        {
            uiMgr.skinBackgroundColor = param1;
            return;
        }// end function

        public function get volume() : Number
        {
            return _volume;
        }// end function

        public function play(param1:String = null, param2:Number = NaN, param3:Boolean = false) : void
        {
            var _loc_4:VideoPlayerState = null;
            var _loc_5:VideoPlayer = null;
            if (param1 == null)
            {
                if (!_firstStreamShown)
                {
                    _loc_4 = videoPlayerStates[_activeVP];
                    queueCmd(_loc_4, QueuedCommand.PLAY);
                }
                else
                {
                    _loc_5 = videoPlayers[_activeVP];
                    _loc_5.play();
                }
            }
            else
            {
                if (param1 == this.source)
                {
                    return;
                }
                this.autoPlay = true;
                this.totalTime = param2;
                this.isLive = param3;
                this.source = param1;
            }
            return;
        }// end function

        public function get paused() : Boolean
        {
            return state == VideoState.PAUSED;
        }// end function

        function handleVideoEvent(event:VideoEvent) : void
        {
            var _loc_2:VideoPlayerState = null;
            var _loc_3:CuePointManager = null;
            var _loc_4:VideoEvent = null;
            var _loc_5:String = null;
            var _loc_6:Number = NaN;
            _loc_2 = videoPlayerStateDict[event.currentTarget];
            _loc_3 = cuePointMgrs[_loc_2.index];
            _loc_4 = VideoEvent(event.clone());
            _loc_4.vp = _loc_2.index;
            _loc_5 = _loc_2.index == _visibleVP && scrubbing ? (VideoState.SEEKING) : (event.state);
            switch(event.type)
            {
                case VideoEvent.AUTO_REWOUND:
                {
                    dispatchEvent(_loc_4);
                    dispatchEvent(new VideoEvent(VideoEvent.REWIND, false, false, _loc_5, event.playheadTime, _loc_2.index));
                    _loc_3.resetASCuePointIndex(event.playheadTime);
                    break;
                }
                case VideoEvent.PLAYHEAD_UPDATE:
                {
                    _loc_4.state = _loc_5;
                    dispatchEvent(_loc_4);
                    if (!isNaN(_loc_2.preSeekTime) && event.state != VideoState.SEEKING)
                    {
                        _loc_6 = _loc_2.preSeekTime;
                        _loc_2.preSeekTime = NaN;
                        _loc_3.resetASCuePointIndex(event.playheadTime);
                        dispatchEvent(new VideoEvent(VideoEvent.SEEKED, false, false, event.state, event.playheadTime, _loc_2.index));
                        if (_loc_6 < event.playheadTime)
                        {
                            dispatchEvent(new VideoEvent(VideoEvent.FAST_FORWARD, false, false, event.state, event.playheadTime, _loc_2.index));
                        }
                        else if (_loc_6 > event.playheadTime)
                        {
                            dispatchEvent(new VideoEvent(VideoEvent.REWIND, false, false, event.state, event.playheadTime, _loc_2.index));
                        }
                    }
                    _loc_3.dispatchASCuePoints();
                    break;
                }
                case VideoEvent.STATE_CHANGE:
                {
                    if (_loc_2.index == _visibleVP && scrubbing)
                    {
                        break;
                    }
                    if (event.state == VideoState.RESIZING)
                    {
                        break;
                    }
                    if (_loc_2.prevState == VideoState.LOADING && _loc_2.autoPlay && event.state == VideoState.STOPPED)
                    {
                        return;
                    }
                    if (event.state == VideoState.CONNECTION_ERROR && event.vp == _visibleVP && !_firstStreamShown && uiMgr.skinReady)
                    {
                        showFirstStream();
                        uiMgr.visible = true;
                        if (uiMgr.skin == "")
                        {
                            uiMgr.hookUpCustomComponents();
                        }
                        if (skinShowTimer != null)
                        {
                            skinShowTimer.reset();
                            skinShowTimer = null;
                        }
                    }
                    _loc_2.prevState = event.state;
                    _loc_4.state = _loc_5;
                    dispatchEvent(_loc_4);
                    if (_loc_2.owner.state != event.state)
                    {
                        return;
                    }
                    switch(event.state)
                    {
                        case VideoState.BUFFERING:
                        {
                            dispatchEvent(new VideoEvent(VideoEvent.BUFFERING_STATE_ENTERED, false, false, _loc_5, event.playheadTime, _loc_2.index));
                            break;
                        }
                        case VideoState.PAUSED:
                        {
                            dispatchEvent(new VideoEvent(VideoEvent.PAUSED_STATE_ENTERED, false, false, _loc_5, event.playheadTime, _loc_2.index));
                            break;
                        }
                        case VideoState.PLAYING:
                        {
                            dispatchEvent(new VideoEvent(VideoEvent.PLAYING_STATE_ENTERED, false, false, _loc_5, event.playheadTime, _loc_2.index));
                            break;
                        }
                        case VideoState.STOPPED:
                        {
                            dispatchEvent(new VideoEvent(VideoEvent.STOPPED_STATE_ENTERED, false, false, _loc_5, event.playheadTime, _loc_2.index));
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    break;
                }
                case VideoEvent.READY:
                {
                    if (!_firstStreamReady)
                    {
                        if (_loc_2.index == _visibleVP)
                        {
                            _firstStreamReady = true;
                            if (uiMgr.skinReady && !_firstStreamShown)
                            {
                                uiMgr.visible = true;
                                if (uiMgr.skin == "")
                                {
                                    uiMgr.hookUpCustomComponents();
                                }
                                showFirstStream();
                            }
                        }
                    }
                    else if (_firstStreamShown && event.state == VideoState.STOPPED && _loc_2.autoPlay)
                    {
                        if (_loc_2.owner.isRTMP)
                        {
                            _loc_2.owner.play();
                        }
                        else
                        {
                            _loc_2.prevState = VideoState.STOPPED;
                            _loc_2.owner.playWhenEnoughDownloaded();
                        }
                    }
                    _loc_4.state = _loc_5;
                    dispatchEvent(_loc_4);
                    break;
                }
                case VideoEvent.CLOSE:
                case VideoEvent.COMPLETE:
                {
                    _loc_4.state = _loc_5;
                    dispatchEvent(_loc_4);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function set volumeBar(param1:Sprite) : void
        {
            uiMgr.setControl(UIManager.VOLUME_BAR, param1);
            return;
        }// end function

        public function set fullScreenBackgroundColor(param1:uint) : void
        {
            uiMgr.fullScreenBackgroundColor = param1;
            return;
        }// end function

        public function get isLive() : Boolean
        {
            var _loc_1:VideoPlayerState = null;
            var _loc_2:VideoPlayer = null;
            _loc_1 = videoPlayerStates[_activeVP];
            if (_loc_1.isLiveSet)
            {
                return _loc_1.isLive;
            }
            _loc_2 = videoPlayers[_activeVP];
            return _loc_2.isLive;
        }// end function

        public function get bufferTime() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.bufferTime;
        }// end function

        public function get registrationHeight() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_visibleVP];
            return _loc_1.registrationHeight;
        }// end function

        public function get playPauseButton() : Sprite
        {
            return uiMgr.getControl(UIManager.PLAY_PAUSE_BUTTON);
        }// end function

        function showFirstStream() : void
        {
            var _loc_1:VideoPlayer = null;
            var _loc_2:int = 0;
            var _loc_3:VideoPlayerState = null;
            var _loc_4:int = 0;
            _firstStreamShown = true;
            _loc_1 = videoPlayers[_visibleVP];
            _loc_1.visible = true;
            if (!scrubbing)
            {
                _soundTransform.volume = _volume;
                _loc_1.soundTransform = _soundTransform;
            }
            _loc_2 = 0;
            while (_loc_2 < videoPlayers.length)
            {
                
                _loc_1 = videoPlayers[_loc_2];
                if (_loc_1 != null)
                {
                    _loc_3 = videoPlayerStates[_loc_2];
                    if (_loc_1.state == VideoState.STOPPED && _loc_3.autoPlay)
                    {
                        if (_loc_1.isRTMP)
                        {
                            _loc_1.play();
                        }
                        else
                        {
                            _loc_3.prevState = VideoState.STOPPED;
                            _loc_1.playWhenEnoughDownloaded();
                        }
                    }
                    if (_loc_3.cmdQueue != null)
                    {
                        _loc_4 = 0;
                        while (_loc_4 < _loc_3.cmdQueue.length)
                        {
                            
                            switch(_loc_3.cmdQueue[_loc_4].type)
                            {
                                case QueuedCommand.PLAY:
                                {
                                    _loc_1.play();
                                    break;
                                }
                                case QueuedCommand.PAUSE:
                                {
                                    _loc_1.pause();
                                    break;
                                }
                                case QueuedCommand.STOP:
                                {
                                    _loc_1.stop();
                                    break;
                                }
                                case QueuedCommand.SEEK:
                                {
                                    _loc_1.seek(_loc_3.cmdQueue[_loc_4].time);
                                    break;
                                }
                                case QueuedCommand.PLAY_WHEN_ENOUGH:
                                {
                                    _loc_1.playWhenEnoughDownloaded();
                                    break;
                                }
                                default:
                                {
                                    break;
                                }
                            }
                            _loc_4++;
                        }
                        _loc_3.cmdQueue = null;
                    }
                }
                _loc_2++;
            }
            return;
        }// end function

        public function set volumeBarScrubTolerance(param1:Number) : void
        {
            uiMgr.volumeBarScrubTolerance = param1;
            return;
        }// end function

        public function set skinBackgroundAlpha(param1:Number) : void
        {
            uiMgr.skinBackgroundAlpha = param1;
            return;
        }// end function

        public function get playheadUpdateInterval() : Number
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.playheadUpdateInterval;
        }// end function

        public function set muteButton(param1:Sprite) : void
        {
            uiMgr.setControl(UIManager.MUTE_BUTTON, param1);
            return;
        }// end function

        public function set skinScaleMaximum(param1:Number)
        {
            uiMgr.skinScaleMaximum = param1;
            return;
        }// end function

        public function enterFullScreenDisplayState() : void
        {
            uiMgr.enterFullScreenDisplayState();
            return;
        }// end function

        function handleMetadataEvent(event:MetadataEvent) : void
        {
            var _loc_2:VideoPlayerState = null;
            var _loc_3:CuePointManager = null;
            var _loc_4:MetadataEvent = null;
            _loc_2 = videoPlayerStateDict[event.currentTarget];
            _loc_3 = cuePointMgrs[_loc_2.index];
            switch(event.type)
            {
                case MetadataEvent.METADATA_RECEIVED:
                {
                    _loc_3.processFLVCuePoints(event.info.cuePoints);
                    break;
                }
                case MetadataEvent.CUE_POINT:
                {
                    if (!_loc_3.isFLVCuePointEnabled(event.info))
                    {
                        return;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_4 = MetadataEvent(event.clone());
            _loc_4.vp = _loc_2.index;
            dispatchEvent(_loc_4);
            return;
        }// end function

        public function playWhenEnoughDownloaded() : void
        {
            var _loc_1:VideoPlayerState = null;
            var _loc_2:VideoPlayer = null;
            if (!_firstStreamShown)
            {
                _loc_1 = videoPlayerStates[_activeVP];
                queueCmd(_loc_1, QueuedCommand.PLAY_WHEN_ENOUGH);
            }
            else
            {
                _loc_2 = videoPlayers[_activeVP];
                _loc_2.playWhenEnoughDownloaded();
            }
            return;
        }// end function

        public function get bitrate() : Number
        {
            return ncMgr.bitrate;
        }// end function

        public function get autoRewind() : Boolean
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.autoRewind;
        }// end function

        public function get fullScreenBackgroundColor() : uint
        {
            return uiMgr.fullScreenBackgroundColor;
        }// end function

        public function get skin() : String
        {
            return uiMgr.skin;
        }// end function

        public function set registrationX(param1:Number) : void
        {
            super.x = param1;
            return;
        }// end function

        public function set registrationY(param1:Number) : void
        {
            super.y = param1;
            return;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            var _loc_3:Rectangle = null;
            var _loc_4:Rectangle = null;
            var _loc_5:int = 0;
            var _loc_6:VideoPlayer = null;
            _loc_3 = new Rectangle(x, y, this.width, this.height);
            _loc_4 = new Rectangle(registrationX, registrationY, registrationWidth, registrationHeight);
            if (isLivePreview)
            {
                livePreviewWidth = param1;
                livePreviewHeight = param2;
                if (previewImage_mc != null)
                {
                    previewImage_mc.width = param1;
                    previewImage_mc.height = param2;
                }
                preview_mc.box_mc.width = param1;
                preview_mc.box_mc.height = param2;
                if (preview_mc.box_mc.width < preview_mc.icon_mc.width || preview_mc.box_mc.height < preview_mc.icon_mc.height)
                {
                    preview_mc.icon_mc.visible = false;
                }
                else
                {
                    preview_mc.icon_mc.visible = true;
                    preview_mc.icon_mc.x = (preview_mc.box_mc.width - preview_mc.icon_mc.width) / 2;
                    preview_mc.icon_mc.y = (preview_mc.box_mc.height - preview_mc.icon_mc.height) / 2;
                }
                dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT, false, false, _loc_3, _loc_4));
                return;
            }
            resizingNow = true;
            _loc_5 = 0;
            while (_loc_5 < videoPlayers.length)
            {
                
                _loc_6 = videoPlayers[_loc_5];
                if (_loc_6 != null)
                {
                    _loc_6.setSize(param1, param2);
                }
                _loc_5++;
            }
            resizingNow = false;
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT, false, false, _loc_3, _loc_4));
            return;
        }// end function

        public function get isRTMP() : Boolean
        {
            var _loc_1:VideoPlayer = null;
            if (isLivePreview)
            {
                return true;
            }
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.isRTMP;
        }// end function

        public function set preview(param1:String) : void
        {
            var filename:* = param1;
            if (!isLivePreview)
            {
                return;
            }
            previewImageUrl = filename;
            if (previewImage_mc != null)
            {
                removeChild(previewImage_mc);
            }
            previewImage_mc = new Loader();
            previewImage_mc.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompletePreview);
            previewImage_mc.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (event:IOErrorEvent) : void
            {
                return;
            }// end function
            );
            previewImage_mc.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (event:SecurityErrorEvent) : void
            {
                return;
            }// end function
            );
            addChildAt(previewImage_mc, 1);
            previewImage_mc.load(new URLRequest(previewImageUrl));
            return;
        }// end function

        override public function set width(param1:Number) : void
        {
            var _loc_2:Rectangle = null;
            var _loc_3:Rectangle = null;
            var _loc_4:int = 0;
            var _loc_5:VideoPlayer = null;
            if (isLivePreview)
            {
                setSize(param1, this.height);
                return;
            }
            _loc_2 = new Rectangle(x, y, width, height);
            _loc_3 = new Rectangle(registrationX, registrationY, registrationWidth, registrationHeight);
            resizingNow = true;
            _loc_4 = 0;
            while (_loc_4 < videoPlayers.length)
            {
                
                _loc_5 = videoPlayers[_loc_4];
                if (_loc_5 != null)
                {
                    _loc_5.width = param1;
                }
                _loc_4++;
            }
            resizingNow = false;
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT, false, false, _loc_2, _loc_3));
            return;
        }// end function

        public function get playButton() : Sprite
        {
            return uiMgr.getControl(UIManager.PLAY_BUTTON);
        }// end function

        public function set pauseButton(param1:Sprite) : void
        {
            uiMgr.setControl(UIManager.PAUSE_BUTTON, param1);
            return;
        }// end function

        public function get bytesTotal() : uint
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.bytesTotal;
        }// end function

        public function seekToPrevNavCuePoint(param1:Number = NaN) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Number = NaN;
            var _loc_4:VideoPlayer = null;
            if (isNaN(param1) || param1 < 0)
            {
                _loc_4 = videoPlayers[_activeVP];
                param1 = _loc_4.playheadTime;
            }
            _loc_2 = findNearestCuePoint(param1, CuePointType.NAVIGATION);
            if (_loc_2 == null)
            {
                seek(0);
                return;
            }
            _loc_3 = _loc_2.index;
            while (_loc_3 >= 0 && (!isFLVCuePointEnabled(_loc_2.array[_loc_3]) || _loc_2.array[_loc_3].time >= param1 - _seekToPrevOffset))
            {
                
                _loc_3 = _loc_3 - 1;
            }
            if (_loc_3 < 0)
            {
                seek(0);
            }
            else
            {
                seek(_loc_2.array[_loc_3].time);
            }
            return;
        }// end function

        public function get autoPlay() : Boolean
        {
            var _loc_1:VideoPlayerState = null;
            _loc_1 = videoPlayerStates[_activeVP];
            return _loc_1.autoPlay;
        }// end function

        public function set playheadPercentage(param1:Number) : void
        {
            seekPercent(param1);
            return;
        }// end function

        public function isFLVCuePointEnabled(param1) : Boolean
        {
            var _loc_2:CuePointManager = null;
            _loc_2 = cuePointMgrs[_activeVP];
            return _loc_2.isFLVCuePointEnabled(param1);
        }// end function

        public function get buffering() : Boolean
        {
            return state == VideoState.BUFFERING;
        }// end function

        public function get volumeBarScrubTolerance() : Number
        {
            return uiMgr.volumeBarScrubTolerance;
        }// end function

        public function get skinBackgroundColor() : uint
        {
            return uiMgr.skinBackgroundColor;
        }// end function

        public function get visibleVideoPlayerIndex() : uint
        {
            return _visibleVP;
        }// end function

        public function set stopButton(param1:Sprite) : void
        {
            uiMgr.setControl(UIManager.STOP_BUTTON, param1);
            return;
        }// end function

        public function get skinBackgroundAlpha() : Number
        {
            return uiMgr.skinBackgroundAlpha;
        }// end function

        public function get skinScaleMaximum() : Number
        {
            return uiMgr.skinScaleMaximum;
        }// end function

        public function get preferredWidth() : int
        {
            var _loc_1:VideoPlayer = null;
            _loc_1 = videoPlayers[_activeVP];
            return _loc_1.videoWidth;
        }// end function

        override public function get width() : Number
        {
            var _loc_1:VideoPlayer = null;
            if (isLivePreview)
            {
                return livePreviewWidth;
            }
            _loc_1 = videoPlayers[_visibleVP];
            return _loc_1.width;
        }// end function

        public function get stopped() : Boolean
        {
            return state == VideoState.STOPPED;
        }// end function

        public function set fullScreenButton(param1:Sprite) : void
        {
            uiMgr.setControl(UIManager.FULL_SCREEN_BUTTON, param1);
            return;
        }// end function

        public function get stopButton() : Sprite
        {
            return uiMgr.getControl(UIManager.STOP_BUTTON);
        }// end function

        public function set playheadUpdateInterval(param1:Number) : void
        {
            var _loc_2:CuePointManager = null;
            var _loc_3:VideoPlayer = null;
            if (_activeVP == 0)
            {
                _playheadUpdateInterval = param1;
            }
            _loc_2 = cuePointMgrs[_activeVP];
            _loc_2.playheadUpdateInterval = param1;
            _loc_3 = videoPlayers[_activeVP];
            _loc_3.playheadUpdateInterval = param1;
            return;
        }// end function

        private function createLivePreviewMovieClip() : void
        {
            preview_mc = new MovieClip();
            preview_mc.name = "preview_mc";
            preview_mc.box_mc = new MovieClip();
            preview_mc.box_mc.name = "box_mc";
            preview_mc.box_mc.graphics.beginFill(0);
            preview_mc.box_mc.graphics.moveTo(0, 0);
            preview_mc.box_mc.graphics.lineTo(0, 100);
            preview_mc.box_mc.graphics.lineTo(100, 100);
            preview_mc.box_mc.graphics.lineTo(100, 0);
            preview_mc.box_mc.graphics.lineTo(0, 0);
            preview_mc.box_mc.graphics.endFill();
            preview_mc.addChild(preview_mc.box_mc);
            preview_mc.icon_mc = new Icon();
            preview_mc.icon_mc.name = "icon_mc";
            preview_mc.addChild(preview_mc.icon_mc);
            addChild(preview_mc);
            return;
        }// end function

        public function set idleTimeout(param1:Number) : void
        {
            var _loc_2:VideoPlayer = null;
            if (_activeVP == 0)
            {
                _idleTimeout = param1;
            }
            _loc_2 = videoPlayers[_activeVP];
            _loc_2.idleTimeout = param1;
            return;
        }// end function

        function skinLoaded() : void
        {
            var _loc_1:VideoPlayer = null;
            if (isLivePreview)
            {
                return;
            }
            _loc_1 = videoPlayers[_visibleVP];
            if (_firstStreamReady || _loc_1.state == VideoState.CONNECTION_ERROR || _loc_1.state == VideoState.DISCONNECTED)
            {
                uiMgr.visible = true;
                if (!_firstStreamShown)
                {
                    showFirstStream();
                }
            }
            else
            {
                if (skinShowTimer != null)
                {
                    skinShowTimer.reset();
                    skinShowTimer = null;
                }
                skinShowTimer = new Timer(DEFAULT_SKIN_SHOW_TIMER_INTERVAL, 1);
                skinShowTimer.addEventListener(TimerEvent.TIMER, showSkinNow);
                skinShowTimer.start();
            }
            dispatchEvent(new VideoEvent(VideoEvent.SKIN_LOADED, false, false, state, playheadTime, _visibleVP));
            return;
        }// end function

        function _scrubFinish() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:String = null;
            var _loc_3:VideoPlayer = null;
            _loc_1 = playheadTime;
            _loc_2 = state;
            _loc_3 = videoPlayers[_visibleVP];
            _soundTransform.volume = _volume;
            _loc_3.soundTransform = _soundTransform;
            if (_loc_2 != VideoState.SEEKING)
            {
                dispatchEvent(new VideoEvent(VideoEvent.STATE_CHANGE, false, false, _loc_2, _loc_1, _visibleVP));
            }
            dispatchEvent(new VideoEvent(VideoEvent.SCRUB_FINISH, false, false, _loc_2, _loc_1, _visibleVP));
            return;
        }// end function

        public function set playPauseButton(param1:Sprite) : void
        {
            uiMgr.setControl(UIManager.PLAY_PAUSE_BUTTON, param1);
            return;
        }// end function

        public function set backButton(param1:Sprite) : void
        {
            uiMgr.setControl(UIManager.BACK_BUTTON, param1);
            return;
        }// end function

        public function set cuePoints(param1:Array) : void
        {
            if (!_componentInspectorSetting)
            {
                return;
            }
            cuePointMgrs[0].processCuePointsProperty(param1);
            return;
        }// end function

        public function findCuePoint(param1, param2:String = "all") : Object
        {
            var _loc_3:CuePointManager = null;
            _loc_3 = cuePointMgrs[_activeVP];
            switch(param2)
            {
                case "event":
                {
                    return _loc_3.getCuePoint(_loc_3.eventCuePoints, false, param1);
                }
                case "navigation":
                {
                    return _loc_3.getCuePoint(_loc_3.navCuePoints, false, param1);
                }
                case "flv":
                {
                    return _loc_3.getCuePoint(_loc_3.flvCuePoints, false, param1);
                }
                case "actionscript":
                {
                    return _loc_3.getCuePoint(_loc_3.asCuePoints, false, param1);
                }
                case "all":
                {
                }
                default:
                {
                    return _loc_3.getCuePoint(_loc_3.allCuePoints, false, param1);
                    break;
                }
            }
        }// end function

        public function get seekBarScrubTolerance() : Number
        {
            return uiMgr.seekBarScrubTolerance;
        }// end function

        function handleVideoProgressEvent(event:VideoProgressEvent) : void
        {
            var _loc_2:VideoPlayerState = null;
            var _loc_3:VideoProgressEvent = null;
            _loc_2 = videoPlayerStateDict[event.currentTarget];
            _loc_3 = VideoProgressEvent(event.clone());
            _loc_3.vp = _loc_2.index;
            dispatchEvent(_loc_3);
            return;
        }// end function

    }
}
