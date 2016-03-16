package fl.video
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    public class UIManager extends Object
    {
        var cacheStageBGColor:uint;
        var _bufferingDelayTimer:Timer;
        public var ctrlDataDict:Dictionary;
        var _skinAutoHide:Boolean;
        var placeholderLeft:Number;
        var _playAfterScrub:Boolean;
        public var customClips:Array;
        var _skinFadeStartTime:int;
        var delayedControls:Array;
        var _lastScrubPos:Number;
        var _skinAutoHideLastMotionTime:int;
        var _volumeBarTimer:Timer;
        var cacheFLVPlaybackScaleMode:Array;
        var borderScale9Rects:Array;
        var _volumeBarScrubTolerance:Number;
        var fullScreenSourceRectMinAspectRatio:Number;
        var _skin:String;
        var fullScreenSourceRectMinHeight:uint;
        var videoRight:Number;
        var _bufferingBarHides:Boolean;
        var placeholderRight:Number;
        var cachedSoundLevel:Number;
        var videoBottom:Number;
        var border_mc:DisplayObject;
        var borderAlpha:Number;
        var borderColorTransform:ColorTransform;
        var _skinFadingTimer:Timer;
        var __visible:Boolean;
        var borderColor:uint;
        var cacheFLVPlaybackIndex:int;
        var cacheFLVPlaybackLocation:Rectangle;
        var _skinReady:Boolean;
        var controls:Array;
        var cacheFLVPlaybackAlign:Array;
        var _skinAutoHideMouseX:Number;
        var _skinAutoHideMouseY:Number;
        var layout_mc:Sprite;
        var cacheSkinAutoHide:Boolean;
        var cacheStageScaleMode:String;
        var videoTop:Number;
        var _skinFadingMaxTime:int;
        var placeholderTop:Number;
        var _lastVolumePos:Number;
        var mouseCaptureCtrl:int;
        var _seekBarScrubTolerance:Number;
        var borderPrevRect:Rectangle;
        var skinTemplate:Sprite;
        var _progressPercent:Number;
        var videoLeft:Number;
        var _fullScreenVideoWidth:Number;
        var _isMuted:Boolean;
        var _skinAutoHideTimer:Timer;
        var _fullScreenBgColor:uint;
        var _vc:FLVPlayback;
        var _bufferingOn:Boolean;
        var _seekBarTimer:Timer;
        var _controlsEnabled:Boolean;
        var _fullScreen:Boolean;
        var placeholderBottom:Number;
        var fullScreenSourceRectMinWidth:uint;
        var _fullScreenTakeOver:Boolean;
        var skin_mc:Sprite;
        var _fullScreenAccel:Boolean;
        var _fullScreenVideoHeight:Number;
        var skinLoadDelayCount:uint;
        var _skinFadingIn:Boolean;
        var _skinAutoHideMotionTimeout:int;
        var borderCopy:Sprite;
        var cacheStageAlign:String;
        var cacheFLVPlaybackParent:DisplayObjectContainer;
        var skinLoader:Loader;
        var _skinScaleMaximum:Number;
        public static const VOLUME_BAR_HIT:int = 12;
        static var layoutNameToIndexMappings:Object = null;
        public static const MUTE_OFF_BUTTON:int = 10;
        static var buttonSkinLinkageIDs:Array = ["upLinkageID", "overLinkageID", "downLinkageID"];
        public static const BACK_BUTTON:int = 5;
        static var layoutNameArray:Array = ["pause_mc", "play_mc", "stop_mc", null, null, "back_mc", "forward_mc", null, null, null, null, null, null, "playpause_mc", "fullScreenToggle_mc", "volumeMute_mc", "bufferingBar_mc", "seekBar_mc", "volumeBar_mc", "seekBarHandle_mc", "seekBarHit_mc", "seekBarProgress_mc", "seekBarFullness_mc", "volumeBarHandle_mc", "volumeBarHit_mc", "volumeBarProgress_mc", "volumeBarFullness_mc", "progressFill_mc"];
        public static const FORWARD_BUTTON:int = 6;
        public static const STOP_BUTTON:int = 2;
        public static const NUM_BUTTONS:int = 13;
        public static const NORMAL_STATE:uint = 0;
        public static const SEEK_BAR_HANDLE:int = 3;
        public static const PLAY_BUTTON:int = 1;
        public static const MUTE_BUTTON:int = 15;
        public static const DOWN_STATE:uint = 2;
        public static const SEEK_BAR_SCRUB_TOLERANCE_DEFAULT:Number = 5;
        public static const FULL_SCREEN_OFF_BUTTON:int = 8;
        static const SKIN_AUTO_HIDE_MOTION_TIMEOUT_DEFAULT:Number = 3000;
        public static const SEEK_BAR:int = 17;
        public static const VOLUME_BAR_SCRUB_TOLERANCE_DEFAULT:Number = 0;
        public static const FULL_SCREEN_ON_BUTTON:int = 7;
        public static const FULL_SCREEN_BUTTON:int = 14;
        public static const BUFFERING_BAR:int = 16;
        public static const VERSION:String = "2.1.0.14";
        public static const VOLUME_BAR_HANDLE:int = 11;
        public static const PAUSE_BUTTON:int = 0;
        static const SKIN_AUTO_HIDE_INTERVAL:Number = 200;
        public static const OVER_STATE:uint = 1;
        static const SKIN_FADING_INTERVAL:Number = 100;
        public static const VOLUME_BAR:int = 18;
        public static const SHORT_VERSION:String = "2.1";
        public static const SEEK_BAR_INTERVAL_DEFAULT:Number = 250;
        static var skinClassPrefixes:Array = ["pauseButton", "playButton", "stopButton", null, null, "backButton", "forwardButton", "fullScreenButtonOn", "fullScreenButtonOff", "muteButtonOn", "muteButtonOff", null, null, null, null, null, "bufferingBar", "seekBar", "volumeBar"];
        static const SKIN_FADING_MAX_TIME_DEFAULT:Number = 500;
        public static const SEEK_BAR_HIT:int = 4;
        public static const PLAY_PAUSE_BUTTON:int = 13;
        public static const BUFFERING_DELAY_INTERVAL_DEFAULT:Number = 1000;
        static var customComponentClassNames:Array = ["PauseButton", "PlayButton", "StopButton", null, null, "BackButton", "ForwardButton", null, null, null, null, null, null, "PlayPauseButton", "FullScreenButton", "MuteButton", "BufferingBar", "SeekBar", "VolumeBar"];
        public static const MUTE_ON_BUTTON:int = 9;
        public static const FULL_SCREEN_SOURCE_RECT_MIN_HEIGHT:uint = 240;
        public static const NUM_CONTROLS:int = 19;
        public static const VOLUME_BAR_INTERVAL_DEFAULT:Number = 250;
        public static const FULL_SCREEN_SOURCE_RECT_MIN_WIDTH:uint = 320;

        public function UIManager(param1:FLVPlayback)
        {
            var vc:* = param1;
            _vc = vc;
            _skin = null;
            _skinAutoHide = false;
            cacheSkinAutoHide = _skinAutoHide;
            _skinFadingMaxTime = SKIN_FADING_MAX_TIME_DEFAULT;
            _skinAutoHideMotionTimeout = SKIN_AUTO_HIDE_MOTION_TIMEOUT_DEFAULT;
            _skinReady = true;
            __visible = false;
            _bufferingBarHides = false;
            _controlsEnabled = true;
            _lastScrubPos = 0;
            _lastVolumePos = 0;
            cachedSoundLevel = _vc.volume;
            _isMuted = false;
            controls = new Array();
            customClips = null;
            ctrlDataDict = new Dictionary(true);
            skin_mc = null;
            skinLoader = null;
            skinTemplate = null;
            layout_mc = null;
            border_mc = null;
            borderCopy = null;
            borderPrevRect = null;
            borderScale9Rects = null;
            borderAlpha = 0.85;
            borderColor = 4697035;
            borderColorTransform = new ColorTransform(0, 0, 0, 0, 71, 171, 203, 255 * borderAlpha);
            _seekBarScrubTolerance = SEEK_BAR_SCRUB_TOLERANCE_DEFAULT;
            _volumeBarScrubTolerance = VOLUME_BAR_SCRUB_TOLERANCE_DEFAULT;
            _bufferingOn = false;
            mouseCaptureCtrl = -1;
            _seekBarTimer = new Timer(SEEK_BAR_INTERVAL_DEFAULT);
            _seekBarTimer.addEventListener(TimerEvent.TIMER, seekBarListener);
            _volumeBarTimer = new Timer(VOLUME_BAR_INTERVAL_DEFAULT);
            _volumeBarTimer.addEventListener(TimerEvent.TIMER, volumeBarListener);
            _bufferingDelayTimer = new Timer(BUFFERING_DELAY_INTERVAL_DEFAULT, 1);
            _bufferingDelayTimer.addEventListener(TimerEvent.TIMER, doBufferingDelay);
            _skinAutoHideTimer = new Timer(SKIN_AUTO_HIDE_INTERVAL);
            _skinAutoHideTimer.addEventListener(TimerEvent.TIMER, skinAutoHideHitTest);
            _skinFadingTimer = new Timer(SKIN_FADING_INTERVAL);
            _skinFadingTimer.addEventListener(TimerEvent.TIMER, skinFadeMore);
            _vc.addEventListener(MetadataEvent.METADATA_RECEIVED, handleIVPEvent);
            _vc.addEventListener(VideoEvent.PLAYHEAD_UPDATE, handleIVPEvent);
            _vc.addEventListener(VideoProgressEvent.PROGRESS, handleIVPEvent);
            _vc.addEventListener(VideoEvent.STATE_CHANGE, handleIVPEvent);
            _vc.addEventListener(VideoEvent.READY, handleIVPEvent);
            _vc.addEventListener(LayoutEvent.LAYOUT, handleLayoutEvent);
            _vc.addEventListener(AutoLayoutEvent.AUTO_LAYOUT, handleLayoutEvent);
            _vc.addEventListener(SoundEvent.SOUND_UPDATE, handleSoundEvent);
            _vc.addEventListener(Event.ADDED_TO_STAGE, handleEvent);
            _vc.addEventListener(Event.REMOVED_FROM_STAGE, handleEvent);
            fullScreenSourceRectMinWidth = FULL_SCREEN_SOURCE_RECT_MIN_WIDTH;
            fullScreenSourceRectMinHeight = FULL_SCREEN_SOURCE_RECT_MIN_HEIGHT;
            fullScreenSourceRectMinAspectRatio = FULL_SCREEN_SOURCE_RECT_MIN_WIDTH / FULL_SCREEN_SOURCE_RECT_MIN_HEIGHT;
            _fullScreen = false;
            _fullScreenTakeOver = true;
            _fullScreenBgColor = 0;
            _fullScreenAccel = false;
            if (_vc.stage != null)
            {
                try
                {
                    _fullScreen = _vc.stage.displayState == StageDisplayState.FULL_SCREEN;
                    _vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreenEvent);
                }
                catch (se:SecurityError)
                {
                }
            }
            if (layoutNameToIndexMappings == null)
            {
                initLayoutNameToIndexMappings();
            }
            return;
        }// end function

        public function get seekBarScrubTolerance() : Number
        {
            return _seekBarScrubTolerance;
        }// end function

        function removeButtonListeners(param1:Sprite) : void
        {
            if (param1 == null)
            {
                return;
            }
            param1.removeEventListener(MouseEvent.ROLL_OVER, handleButtonEvent);
            param1.removeEventListener(MouseEvent.ROLL_OUT, handleButtonEvent);
            param1.removeEventListener(MouseEvent.MOUSE_DOWN, handleButtonEvent);
            param1.removeEventListener(MouseEvent.CLICK, handleButtonEvent);
            param1.removeEventListener(Event.ENTER_FRAME, skinButtonControl);
            return;
        }// end function

        public function set skinFadeTime(param1:int) : void
        {
            _skinFadingMaxTime = param1;
            return;
        }// end function

        public function get skinFadeTime() : int
        {
            return _skinFadingMaxTime;
        }// end function

        function finishLoad(event:Event) : void
        {
            var i:int;
            var cachedActivePlayerIndex:int;
            var state:String;
            var j:int;
            var e:* = event;
            try
            {
                var _loc_4:* = skinLoadDelayCount + 1;
                skinLoadDelayCount = _loc_4;
                if (skinLoadDelayCount < 2)
                {
                    return;
                }
                else
                {
                    _vc.removeEventListener(Event.ENTER_FRAME, finishLoad);
                }
                i;
                while (i < NUM_CONTROLS)
                {
                    
                    if (delayedControls[i] != undefined)
                    {
                        setControl(i, delayedControls[i]);
                    }
                    i = (i + 1);
                }
                if (_fullScreenTakeOver)
                {
                    enterFullScreenTakeOver();
                }
                else
                {
                    exitFullScreenTakeOver();
                }
                layoutSkin();
                setupSkinAutoHide(false);
                skin_mc.visible = __visible;
                _vc.addChild(skin_mc);
                _skinReady = true;
                _vc.skinLoaded();
                cachedActivePlayerIndex = _vc.activeVideoPlayerIndex;
                _vc.activeVideoPlayerIndex = _vc.visibleVideoPlayerIndex;
                state = _vc.state;
                j;
                while (j < NUM_CONTROLS)
                {
                    
                    if (controls[j] == undefined)
                    {
                    }
                    else
                    {
                        setEnabledAndVisibleForState(j, state);
                        if (j < NUM_BUTTONS)
                        {
                            skinButtonControl(controls[j]);
                        }
                    }
                    j = (j + 1);
                }
                _vc.activeVideoPlayerIndex = cachedActivePlayerIndex;
            }
            catch (err:Error)
            {
                _vc.skinError(err.message);
                removeSkin();
            }
            return;
        }// end function

        function downloadSkin() : void
        {
            if (skinLoader == null)
            {
                skinLoader = new Loader();
                skinLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoad);
                skinLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoadErrorEvent);
                skinLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoadErrorEvent);
            }
            skinLoader.load(new URLRequest(_skin));
            return;
        }// end function

        function removeSkin() : void
        {
            var i:int;
            if (skinLoader != null)
            {
                try
                {
                    skinLoader.close();
                }
                catch (e1:Error)
                {
                }
                skinLoader = null;
            }
            if (skin_mc != null)
            {
                i;
                while (i < NUM_CONTROLS)
                {
                    
                    if (controls[i] == undefined)
                    {
                    }
                    else
                    {
                        if (i < NUM_BUTTONS)
                        {
                            removeButtonListeners(controls[i]);
                        }
                        delete ctrlDataDict[controls[i]];
                        delete controls[i];
                    }
                    i = (i + 1);
                }
                try
                {
                    skin_mc.parent.removeChild(skin_mc);
                }
                catch (e2:Error)
                {
                }
                skin_mc = null;
            }
            skinTemplate = null;
            layout_mc = null;
            border_mc = null;
            borderCopy = null;
            borderPrevRect = null;
            borderScale9Rects = null;
            return;
        }// end function

        function positionBar(param1:Sprite, param2:String, param3:Number) : void
        {
            var ctrlData:ControlData;
            var bar:DisplayObject;
            var barData:ControlData;
            var ctrl:* = param1;
            var type:* = param2;
            var percent:* = param3;
            try
            {
                var _loc_5:* = ctrl;
                if (ctrl["positionBar"] is Function && _loc_5.ctrl["positionBar"](type, percent))
                {
                    return;
                }
            }
            catch (re2:ReferenceError)
            {
            }
            ctrlData = ctrlDataDict[ctrl];
            bar = ctrlData[type + "_mc"];
            if (bar == null)
            {
                return;
            }
            barData = ctrlDataDict[bar];
            if (bar.parent == ctrl)
            {
                if (barData.fill_mc == null)
                {
                    bar.scaleX = barData.origScaleX * percent / 100;
                }
                else
                {
                    positionMaskedFill(bar, percent);
                }
            }
            else
            {
                bar.x = ctrl.x + barData.leftMargin;
                bar.y = ctrl.y + barData.origY;
                if (barData.fill_mc == null)
                {
                    bar.width = (ctrl.width - barData.leftMargin - barData.rightMargin) * percent / 100;
                }
                else
                {
                    positionMaskedFill(bar, percent);
                }
            }
            return;
        }// end function

        function setupButtonSkin(param1:int) : Sprite
        {
            var _loc_2:String = null;
            var _loc_3:Sprite = null;
            var _loc_4:ControlData = null;
            _loc_2 = skinClassPrefixes[param1];
            if (_loc_2 == null)
            {
                return null;
            }
            _loc_3 = new Sprite();
            _loc_4 = new ControlData(this, _loc_3, null, param1);
            ctrlDataDict[_loc_3] = _loc_4;
            _loc_4.state_mc = new Array();
            _loc_4.state_mc[NORMAL_STATE] = setupButtonSkinState(_loc_3, skinTemplate, _loc_2 + "NormalState");
            _loc_4.state_mc[NORMAL_STATE].visible = true;
            _loc_4.state_mc[OVER_STATE] = setupButtonSkinState(_loc_3, skinTemplate, _loc_2 + "OverState", _loc_4.state_mc[NORMAL_STATE]);
            _loc_4.state_mc[DOWN_STATE] = setupButtonSkinState(_loc_3, skinTemplate, _loc_2 + "DownState", _loc_4.state_mc[NORMAL_STATE]);
            _loc_4.disabled_mc = setupButtonSkinState(_loc_3, skinTemplate, _loc_2 + "DisabledState", _loc_4.state_mc[NORMAL_STATE]);
            return _loc_3;
        }// end function

        public function get skinReady() : Boolean
        {
            return _skinReady;
        }// end function

        public function get skinAutoHide() : Boolean
        {
            return _skinAutoHide;
        }// end function

        function dispatchMessage(param1:int) : void
        {
            var cachedActivePlayerIndex:int;
            var ctrl:Sprite;
            var ctrlData:ControlData;
            var handle:Sprite;
            var index:* = param1;
            if (index == SEEK_BAR_HANDLE || index == SEEK_BAR_HIT)
            {
                _vc._scrubStart();
            }
            cachedActivePlayerIndex = _vc.activeVideoPlayerIndex;
            _vc.activeVideoPlayerIndex = _vc.visibleVideoPlayerIndex;
            switch(index)
            {
                case PAUSE_BUTTON:
                {
                    _vc.pause();
                    break;
                }
                case PLAY_BUTTON:
                {
                    _vc.play();
                    break;
                }
                case STOP_BUTTON:
                {
                    _vc.stop();
                    break;
                }
                case SEEK_BAR_HIT:
                case SEEK_BAR_HANDLE:
                {
                    ctrl = controls[SEEK_BAR];
                    ctrlData = ctrlDataDict[ctrl];
                    calcPercentageFromHandle(ctrl);
                    _lastScrubPos = ctrlData.percentage;
                    if (index == SEEK_BAR_HIT)
                    {
                        handle = controls[SEEK_BAR_HANDLE];
                        handle.x = handle.parent.mouseX;
                        handle.y = handle.parent.mouseY;
                    }
                    _vc.removeEventListener(VideoEvent.PLAYHEAD_UPDATE, handleIVPEvent);
                    if (_vc.playing || _vc.buffering)
                    {
                        _playAfterScrub = true;
                    }
                    else if (_vc.state != VideoState.SEEKING)
                    {
                        _playAfterScrub = false;
                    }
                    _seekBarTimer.start();
                    startHandleDrag(ctrl);
                    _vc.pause();
                    break;
                }
                case VOLUME_BAR_HIT:
                case VOLUME_BAR_HANDLE:
                {
                    ctrl = controls[VOLUME_BAR];
                    ctrlData = ctrlDataDict[ctrl];
                    calcPercentageFromHandle(ctrl);
                    _lastVolumePos = ctrlData.percentage;
                    if (index == VOLUME_BAR_HIT)
                    {
                        handle = controls[VOLUME_BAR_HANDLE];
                        handle.x = handle.parent.mouseX;
                        handle.y = handle.parent.mouseY;
                    }
                    _vc.removeEventListener(SoundEvent.SOUND_UPDATE, handleSoundEvent);
                    _volumeBarTimer.start();
                    startHandleDrag(ctrl);
                    break;
                }
                case BACK_BUTTON:
                {
                    _vc.seekToPrevNavCuePoint();
                    break;
                }
                case FORWARD_BUTTON:
                {
                    _vc.seekToNextNavCuePoint();
                    break;
                }
                case MUTE_ON_BUTTON:
                {
                    if (!_isMuted)
                    {
                        _isMuted = true;
                        cachedSoundLevel = _vc.volume;
                        _vc.volume = 0;
                        setEnabledAndVisibleForState(MUTE_OFF_BUTTON, VideoState.PLAYING);
                        skinButtonControl(controls[MUTE_OFF_BUTTON]);
                        setEnabledAndVisibleForState(MUTE_ON_BUTTON, VideoState.PLAYING);
                        skinButtonControl(controls[MUTE_ON_BUTTON]);
                    }
                    break;
                }
                case MUTE_OFF_BUTTON:
                {
                    if (_isMuted)
                    {
                        _isMuted = false;
                        _vc.volume = cachedSoundLevel;
                        setEnabledAndVisibleForState(MUTE_OFF_BUTTON, VideoState.PLAYING);
                        skinButtonControl(controls[MUTE_OFF_BUTTON]);
                        setEnabledAndVisibleForState(MUTE_ON_BUTTON, VideoState.PLAYING);
                        skinButtonControl(controls[MUTE_ON_BUTTON]);
                    }
                    break;
                }
                case FULL_SCREEN_ON_BUTTON:
                {
                    if (!_fullScreen && _vc.stage != null)
                    {
                        enterFullScreenDisplayState();
                        setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON, VideoState.PLAYING);
                        skinButtonControl(controls[FULL_SCREEN_OFF_BUTTON]);
                        setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON, VideoState.PLAYING);
                        skinButtonControl(controls[FULL_SCREEN_ON_BUTTON]);
                    }
                    break;
                }
                case FULL_SCREEN_OFF_BUTTON:
                {
                    if (_fullScreen && _vc.stage != null)
                    {
                        try
                        {
                            _vc.stage.displayState = StageDisplayState.NORMAL;
                        }
                        catch (se:SecurityError)
                        {
                        }
                        setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON, VideoState.PLAYING);
                        skinButtonControl(controls[FULL_SCREEN_OFF_BUTTON]);
                        setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON, VideoState.PLAYING);
                        skinButtonControl(controls[FULL_SCREEN_ON_BUTTON]);
                    }
                    break;
                }
                default:
                {
                    throw new Error("Unknown ButtonControl");
                    break;
                }
            }
            _vc.activeVideoPlayerIndex = cachedActivePlayerIndex;
            return;
        }// end function

        function handleFullScreenEvent(event:FullScreenEvent) : void
        {
            _fullScreen = event.fullScreen;
            setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON, VideoState.PLAYING);
            skinButtonControl(controls[FULL_SCREEN_OFF_BUTTON]);
            setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON, VideoState.PLAYING);
            skinButtonControl(controls[FULL_SCREEN_ON_BUTTON]);
            if (_fullScreen && _fullScreenTakeOver)
            {
                enterFullScreenTakeOver();
            }
            else if (!_fullScreen)
            {
                exitFullScreenTakeOver();
            }
            return;
        }// end function

        function handleLayoutEvent(event:LayoutEvent) : void
        {
            var _loc_2:int = 0;
            if (_fullScreen && _fullScreenTakeOver && _fullScreenAccel && _vc.stage != null)
            {
                if (_vc.registrationX != 0 || _vc.registrationY != 0 || _vc.parent != _vc.stage || _vc.registrationWidth != _vc.stage.stageWidth || _vc.registrationHeight != _vc.stage.stageHeight)
                {
                    _vc.stage.displayState = StageDisplayState.NORMAL;
                    return;
                }
                _loc_2 = _vc.activeVideoPlayerIndex;
                _vc.activeVideoPlayerIndex = _vc.visibleVideoPlayerIndex;
                if (_vc.align != VideoAlign.CENTER)
                {
                    cacheFLVPlaybackAlign[_vc.visibleVideoPlayerIndex] = _vc.align;
                    _vc.align = VideoAlign.CENTER;
                }
                if (_vc.scaleMode != VideoScaleMode.MAINTAIN_ASPECT_RATIO)
                {
                    cacheFLVPlaybackScaleMode[_vc.visibleVideoPlayerIndex] = _vc.scaleMode;
                    _vc.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
                    _vc.activeVideoPlayerIndex = _loc_2;
                    return;
                }
                _vc.activeVideoPlayerIndex = _loc_2;
            }
            layoutSkin();
            setupSkinAutoHide(false);
            return;
        }// end function

        function seekBarListener(event:TimerEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Sprite = null;
            var _loc_4:ControlData = null;
            var _loc_5:Number = NaN;
            _loc_2 = _vc.activeVideoPlayerIndex;
            _vc.activeVideoPlayerIndex = _vc.visibleVideoPlayerIndex;
            _loc_3 = controls[SEEK_BAR];
            if (_loc_3 == null)
            {
                return;
            }
            _loc_4 = ctrlDataDict[_loc_3];
            calcPercentageFromHandle(_loc_3);
            _loc_5 = _loc_4.percentage;
            if (event == null)
            {
                _seekBarTimer.stop();
                if (_loc_5 != _lastScrubPos)
                {
                    _vc.seekPercent(_loc_5);
                }
                _vc.addEventListener(VideoEvent.PLAYHEAD_UPDATE, handleIVPEvent);
                if (_playAfterScrub)
                {
                    _vc.play();
                }
            }
            else if (_vc.getVideoPlayer(_vc.visibleVideoPlayerIndex).state == VideoState.SEEKING)
            {
            }
            else if (_seekBarScrubTolerance <= 0 || Math.abs(_loc_5 - _lastScrubPos) > _seekBarScrubTolerance || _loc_5 < _seekBarScrubTolerance || _loc_5 > 100 - _seekBarScrubTolerance)
            {
                if (_loc_5 != _lastScrubPos)
                {
                    _lastScrubPos = _loc_5;
                    _vc.seekPercent(_loc_5);
                }
            }
            _vc.activeVideoPlayerIndex = _loc_2;
            return;
        }// end function

        public function get seekBarInterval() : Number
        {
            return _seekBarTimer.delay;
        }// end function

        public function set skinAutoHide(param1:Boolean) : void
        {
            if (param1 == _skinAutoHide)
            {
                return;
            }
            _skinAutoHide = param1;
            cacheSkinAutoHide = param1;
            setupSkinAutoHide(true);
            return;
        }// end function

        function setCustomClip(param1:DisplayObject) : void
        {
            var dCopy:DisplayObject;
            var ctrlData:ControlData;
            var scale9Grid:Rectangle;
            var diff:Number;
            var numBorderBitmaps:int;
            var i:int;
            var lastXDim:Number;
            var floorLastXDim:Number;
            var lastYDim:Number;
            var floorLastYDim:Number;
            var newRect:Rectangle;
            var dispObj:* = param1;
            dCopy = new dispObj["constructor"];
            skin_mc.addChild(dCopy);
            ctrlData = new ControlData(this, dCopy, null, -1);
            ctrlDataDict[dCopy] = ctrlData;
            ctrlData.avatar = dispObj;
            customClips.push(dCopy);
            if (dispObj.name == "border_mc")
            {
                border_mc = dCopy;
                try
                {
                    borderCopy = ctrlData.avatar["colorMe"] ? (new Sprite()) : (null);
                }
                catch (re:ReferenceError)
                {
                    borderCopy = null;
                }
                if (borderCopy != null)
                {
                    border_mc.visible = false;
                    scale9Grid = border_mc.scale9Grid;
                    scale9Grid.x = Math.round(scale9Grid.x);
                    scale9Grid.y = Math.round(scale9Grid.y);
                    scale9Grid.width = Math.round(scale9Grid.width);
                    diff = scale9Grid.x + scale9Grid.width - border_mc.scale9Grid.right;
                    if (diff > 0.5)
                    {
                        var _loc_3:* = scale9Grid;
                        var _loc_4:* = scale9Grid.width - 1;
                        _loc_3.width = _loc_4;
                    }
                    else if (diff < -0.5)
                    {
                        var _loc_3:* = scale9Grid;
                        var _loc_4:* = scale9Grid.width + 1;
                        _loc_3.width = _loc_4;
                    }
                    scale9Grid.height = Math.round(scale9Grid.height);
                    diff = scale9Grid.y + scale9Grid.height - border_mc.scale9Grid.bottom;
                    if (diff > 0.5)
                    {
                        var _loc_3:* = scale9Grid;
                        var _loc_4:* = scale9Grid.height - 1;
                        _loc_3.height = _loc_4;
                    }
                    else if (diff < -0.5)
                    {
                        var _loc_3:* = scale9Grid;
                        var _loc_4:* = scale9Grid.height + 1;
                        _loc_3.height = _loc_4;
                    }
                    if (scale9Grid != null)
                    {
                        borderScale9Rects = new Array();
                        lastXDim = border_mc.width - (scale9Grid.x + scale9Grid.width);
                        floorLastXDim = Math.floor(lastXDim);
                        if (lastXDim - floorLastXDim < 0.05)
                        {
                            lastXDim = floorLastXDim;
                        }
                        else
                        {
                            lastXDim = (floorLastXDim + 1);
                        }
                        lastYDim = border_mc.height - (scale9Grid.y + scale9Grid.height);
                        floorLastYDim = Math.floor(lastYDim);
                        if (lastYDim - floorLastYDim < 0.05)
                        {
                            lastYDim = floorLastYDim;
                        }
                        else
                        {
                            lastYDim = (floorLastYDim + 1);
                        }
                        newRect = new Rectangle(0, 0, scale9Grid.x, scale9Grid.y);
                        borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? (null) : (newRect));
                        newRect = new Rectangle(scale9Grid.x, 0, scale9Grid.width, scale9Grid.y);
                        borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? (null) : (newRect));
                        newRect = new Rectangle(scale9Grid.x + scale9Grid.width, 0, lastXDim, scale9Grid.y);
                        borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? (null) : (newRect));
                        newRect = new Rectangle(0, scale9Grid.y, scale9Grid.x, scale9Grid.height);
                        borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? (null) : (newRect));
                        newRect = new Rectangle(scale9Grid.x, scale9Grid.y, scale9Grid.width, scale9Grid.height);
                        borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? (null) : (newRect));
                        newRect = new Rectangle(scale9Grid.x + scale9Grid.width, scale9Grid.y, lastXDim, scale9Grid.height);
                        borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? (null) : (newRect));
                        newRect = new Rectangle(0, scale9Grid.y + scale9Grid.height, scale9Grid.x, lastYDim);
                        borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? (null) : (newRect));
                        newRect = new Rectangle(scale9Grid.x, scale9Grid.y + scale9Grid.height, scale9Grid.width, lastYDim);
                        borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? (null) : (newRect));
                        newRect = new Rectangle(scale9Grid.x + scale9Grid.width, scale9Grid.y + scale9Grid.height, lastXDim, lastYDim);
                        borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? (null) : (newRect));
                        i;
                        while (i < borderScale9Rects.length)
                        {
                            
                            if (borderScale9Rects[i] != null)
                            {
                                break;
                            }
                            i = (i + 1);
                        }
                        if (i >= borderScale9Rects.length)
                        {
                            borderScale9Rects = null;
                        }
                    }
                    numBorderBitmaps = borderScale9Rects == null ? (1) : (9);
                    i;
                    while (i < numBorderBitmaps)
                    {
                        
                        if (borderScale9Rects == null || borderScale9Rects[i] != null)
                        {
                            borderCopy.addChild(new Bitmap());
                        }
                        i = (i + 1);
                    }
                    skin_mc.addChild(borderCopy);
                    borderPrevRect = null;
                }
            }
            return;
        }// end function

        public function get fullScreenSkinDelay() : int
        {
            return _skinAutoHideMotionTimeout;
        }// end function

        function doBufferingDelay(event:TimerEvent) : void
        {
            var _loc_2:int = 0;
            _bufferingDelayTimer.reset();
            _loc_2 = _vc.activeVideoPlayerIndex;
            _vc.activeVideoPlayerIndex = _vc.visibleVideoPlayerIndex;
            if (_vc.state == VideoState.BUFFERING)
            {
                _bufferingOn = true;
                handleIVPEvent(new VideoEvent(VideoEvent.STATE_CHANGE, false, false, VideoState.BUFFERING, NaN, _vc.visibleVideoPlayerIndex));
            }
            _vc.activeVideoPlayerIndex = _loc_2;
            return;
        }// end function

        function volumeBarListener(event:TimerEvent) : void
        {
            var _loc_2:Sprite = null;
            var _loc_3:ControlData = null;
            var _loc_4:Number = NaN;
            var _loc_5:Boolean = false;
            _loc_2 = controls[VOLUME_BAR];
            if (_loc_2 == null)
            {
                return;
            }
            _loc_3 = ctrlDataDict[_loc_2];
            calcPercentageFromHandle(_loc_2);
            _loc_4 = _loc_3.percentage;
            _loc_5 = event == null;
            if (_loc_5)
            {
                _volumeBarTimer.stop();
                _vc.addEventListener(SoundEvent.SOUND_UPDATE, handleSoundEvent);
            }
            if (_loc_5 || _volumeBarScrubTolerance <= 0 || Math.abs(_loc_4 - _lastVolumePos) > _volumeBarScrubTolerance || _loc_4 < _volumeBarScrubTolerance || _loc_4 > 100 - _volumeBarScrubTolerance)
            {
                if (_loc_4 != _lastVolumePos)
                {
                    if (_isMuted)
                    {
                        cachedSoundLevel = _loc_4 / 100;
                    }
                    else
                    {
                        _vc.volume = _loc_4 / 100;
                    }
                    _lastVolumePos = _loc_4;
                }
            }
            return;
        }// end function

        public function get visible() : Boolean
        {
            return __visible;
        }// end function

        function fixUpBar(param1:DisplayObject, param2:String, param3:DisplayObject, param4:String) : void
        {
            var ctrlData:ControlData;
            var bar:DisplayObject;
            var barData:ControlData;
            var definitionHolder:* = param1;
            var propPrefix:* = param2;
            var ctrl:* = param3;
            var name:* = param4;
            ctrlData = ctrlDataDict[ctrl];
            if (ctrlData[name] != null)
            {
                return;
            }
            try
            {
                bar = ctrl[name];
            }
            catch (re:ReferenceError)
            {
                bar;
            }
            if (bar == null)
            {
                try
                {
                    bar = createSkin(definitionHolder, propPrefix + "LinkageID");
                }
                catch (ve:VideoError)
                {
                    bar;
                }
                if (bar == null)
                {
                    return;
                }
                if (ctrl.parent != null)
                {
                    if (getBooleanPropSafe(ctrl, propPrefix + "Below"))
                    {
                        ctrl.parent.addChildAt(bar, ctrl.parent.getChildIndex(ctrl));
                    }
                    else
                    {
                        ctrl.parent.addChild(bar);
                    }
                }
            }
            ctrlData[name] = bar;
            barData = ctrlDataDict[bar];
            if (barData == null)
            {
                barData = new ControlData(this, bar, ctrl, -1);
                ctrlDataDict[bar] = barData;
            }
            return;
        }// end function

        public function get volumeBarInterval() : Number
        {
            return _volumeBarTimer.delay;
        }// end function

        public function get bufferingBarHidesAndDisablesOthers() : Boolean
        {
            return _bufferingBarHides;
        }// end function

        function calcLayoutControl(param1:DisplayObject) : Rectangle
        {
            var rect:Rectangle;
            var ctrlData:ControlData;
            var anchorRight:Boolean;
            var anchorLeft:Boolean;
            var anchorTop:Boolean;
            var anchorBottom:Boolean;
            var ctrl:* = param1;
            rect = new Rectangle();
            if (ctrl == null)
            {
                return rect;
            }
            ctrlData = ctrlDataDict[ctrl];
            if (ctrlData == null)
            {
                return rect;
            }
            if (ctrlData.avatar == null)
            {
                return rect;
            }
            anchorRight;
            anchorLeft;
            anchorTop;
            anchorBottom;
            try
            {
                anchorRight = ctrlData.avatar["anchorRight"];
            }
            catch (re1:ReferenceError)
            {
                anchorRight;
                try
                {
                }
                anchorLeft = ctrlData.avatar["anchorLeft"];
            }
            catch (re1:ReferenceError)
            {
                anchorLeft;
                try
                {
                }
                anchorTop = ctrlData.avatar["anchorTop"];
            }
            catch (re1:ReferenceError)
            {
                anchorTop;
                try
                {
                }
                anchorBottom = ctrlData.avatar["anchorBottom"];
            }
            catch (re1:ReferenceError)
            {
                anchorBottom;
            }
            if (anchorRight)
            {
                if (anchorLeft)
                {
                    rect.x = ctrlData.avatar.x - placeholderLeft + videoLeft;
                    rect.width = ctrlData.avatar.x + ctrlData.avatar.width - placeholderRight + videoRight - rect.x;
                    ctrlData.origWidth = NaN;
                }
                else
                {
                    rect.x = ctrlData.avatar.x - placeholderRight + videoRight;
                    rect.width = ctrl.width;
                }
            }
            else
            {
                rect.x = ctrlData.avatar.x - placeholderLeft + videoLeft;
                rect.width = ctrl.width;
            }
            if (anchorTop)
            {
                if (anchorBottom)
                {
                    rect.y = ctrlData.avatar.y - placeholderTop + videoTop;
                    rect.height = ctrlData.avatar.y + ctrlData.avatar.height - placeholderBottom + videoBottom - rect.y;
                    ctrlData.origHeight = NaN;
                }
                else
                {
                    rect.y = ctrlData.avatar.y - placeholderTop + videoTop;
                    rect.height = ctrl.height;
                }
            }
            else
            {
                rect.y = ctrlData.avatar.y - placeholderBottom + videoBottom;
                rect.height = ctrl.height;
            }
            try
            {
                if (ctrl["layoutSelf"] is Function)
                {
                    var _loc_3:* = ctrl;
                    rect = _loc_3.ctrl["layoutSelf"](rect);
                }
            }
            catch (re3:ReferenceError)
            {
            }
            return rect;
        }// end function

        function skinFadeMore(event:TimerEvent) : void
        {
            var _loc_2:Number = NaN;
            if (!_skinFadingIn && skin_mc.alpha <= 0.5 || _skinFadingIn && skin_mc.alpha >= 0.95)
            {
                skin_mc.visible = _skinFadingIn;
                skin_mc.alpha = 1;
                _skinFadingTimer.stop();
            }
            else
            {
                _loc_2 = (getTimer() - _skinFadeStartTime) / _skinFadingMaxTime;
                if (!_skinFadingIn)
                {
                    _loc_2 = 1 - _loc_2;
                }
                if (_loc_2 < 0)
                {
                    _loc_2 = 0;
                }
                else if (_loc_2 > 1)
                {
                    _loc_2 = 1;
                }
                skin_mc.alpha = _loc_2;
            }
            return;
        }// end function

        function bitmapCopyBorder() : void
        {
            var _loc_1:Rectangle = null;
            var _loc_2:BitmapData = null;
            var _loc_3:Matrix = null;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Rectangle = null;
            var _loc_7:int = 0;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:int = 0;
            var _loc_11:Bitmap = null;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            if (border_mc == null || borderCopy == null)
            {
                return;
            }
            _loc_1 = border_mc.getBounds(skin_mc);
            if (borderPrevRect == null || !borderPrevRect.equals(_loc_1))
            {
                borderCopy.x = _loc_1.x;
                borderCopy.y = _loc_1.y;
                _loc_3 = new Matrix(border_mc.scaleX, 0, 0, border_mc.scaleY, 0, 0);
                if (borderScale9Rects == null)
                {
                    _loc_2 = new BitmapData(_loc_1.width, _loc_1.height, true, 0);
                    _loc_2.draw(border_mc, _loc_3, borderColorTransform);
                    Bitmap(borderCopy.getChildAt(0)).bitmapData = _loc_2;
                }
                else
                {
                    _loc_4 = 0;
                    _loc_5 = 0;
                    _loc_6 = new Rectangle(0, 0, 0, 0);
                    _loc_7 = 0;
                    _loc_8 = 0;
                    if (borderScale9Rects[3] != null)
                    {
                        _loc_8 = _loc_8 + borderScale9Rects[3].width;
                    }
                    if (borderScale9Rects[5] != null)
                    {
                        _loc_8 = _loc_8 + borderScale9Rects[5].width;
                    }
                    _loc_9 = 0;
                    if (borderScale9Rects[1] != null)
                    {
                        _loc_9 = _loc_9 + borderScale9Rects[1].height;
                    }
                    if (borderScale9Rects[7] != null)
                    {
                        _loc_9 = _loc_9 + borderScale9Rects[7].height;
                    }
                    _loc_10 = 0;
                    while (_loc_10 < borderScale9Rects.length)
                    {
                        
                        if (_loc_10 % 3 == 0)
                        {
                            _loc_4 = 0;
                            _loc_5 = _loc_5 + _loc_6.height;
                        }
                        if (borderScale9Rects[_loc_10] == null)
                        {
                        }
                        else
                        {
                            _loc_6 = Rectangle(borderScale9Rects[_loc_10]).clone();
                            _loc_3.a = 1;
                            if (_loc_10 == 1 || _loc_10 == 4 || _loc_10 == 7)
                            {
                                _loc_12 = (_loc_1.width - _loc_8) / _loc_6.width;
                                _loc_6.x = _loc_6.x * _loc_12;
                                _loc_6.width = _loc_6.width * _loc_12;
                                _loc_6.width = Math.round(_loc_6.width);
                                _loc_3.a = _loc_3.a * _loc_12;
                            }
                            _loc_3.tx = -_loc_6.x;
                            _loc_6.x = 0;
                            _loc_3.d = 1;
                            if (_loc_10 >= 3 && _loc_10 <= 5)
                            {
                                _loc_13 = (_loc_1.height - _loc_9) / _loc_6.height;
                                _loc_6.y = _loc_6.y * _loc_13;
                                _loc_6.height = _loc_6.height * _loc_13;
                                _loc_6.height = Math.round(_loc_6.height);
                                _loc_3.d = _loc_3.d * _loc_13;
                            }
                            _loc_3.ty = -_loc_6.y;
                            _loc_6.y = 0;
                            _loc_2 = new BitmapData(_loc_6.width, _loc_6.height, true, 0);
                            _loc_2.draw(border_mc, _loc_3, borderColorTransform, null, _loc_6, false);
                            _loc_11 = Bitmap(borderCopy.getChildAt(_loc_7));
                            _loc_7++;
                            _loc_11.bitmapData = _loc_2;
                            _loc_11.x = _loc_4;
                            _loc_11.y = _loc_5;
                            _loc_4 = _loc_4 + _loc_6.width;
                        }
                        _loc_10++;
                    }
                }
                borderPrevRect = _loc_1;
            }
            return;
        }// end function

        function resetPlayPause() : void
        {
            var _loc_1:int = 0;
            if (controls[PLAY_PAUSE_BUTTON] == undefined)
            {
                return;
            }
            _loc_1 = PAUSE_BUTTON;
            while (_loc_1 <= PLAY_BUTTON)
            {
                
                removeButtonListeners(controls[_loc_1]);
                delete ctrlDataDict[controls[_loc_1]];
                delete controls[_loc_1];
                _loc_1++;
            }
            delete ctrlDataDict[controls[PLAY_PAUSE_BUTTON]];
            delete controls[PLAY_PAUSE_BUTTON];
            return;
        }// end function

        public function setControl(param1:int, param2:Sprite) : void
        {
            var ctrlData:ControlData;
            var index:* = param1;
            var ctrl:* = param2;
            if (ctrl == controls[index])
            {
                return;
            }
            switch(index)
            {
                case PAUSE_BUTTON:
                case PLAY_BUTTON:
                {
                    resetPlayPause();
                    break;
                }
                case PLAY_PAUSE_BUTTON:
                {
                    if (ctrl == null || ctrl.parent != skin_mc)
                    {
                        resetPlayPause();
                    }
                    if (ctrl != null)
                    {
                        setControl(PAUSE_BUTTON, Sprite(ctrl.getChildByName("pause_mc")));
                        setControl(PLAY_BUTTON, Sprite(ctrl.getChildByName("play_mc")));
                    }
                    break;
                }
                case FULL_SCREEN_BUTTON:
                {
                    if (ctrl != null)
                    {
                        setControl(FULL_SCREEN_ON_BUTTON, Sprite(ctrl.getChildByName("on_mc")));
                        setControl(FULL_SCREEN_OFF_BUTTON, Sprite(ctrl.getChildByName("off_mc")));
                    }
                    break;
                }
                case MUTE_BUTTON:
                {
                    if (ctrl != null)
                    {
                        setControl(MUTE_ON_BUTTON, Sprite(ctrl.getChildByName("on_mc")));
                        setControl(MUTE_OFF_BUTTON, Sprite(ctrl.getChildByName("off_mc")));
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (controls[index] != null)
            {
                try
                {
                    delete controls[index]["uiMgr"];
                }
                catch (re:ReferenceError)
                {
                }
                if (index < NUM_BUTTONS)
                {
                    removeButtonListeners(controls[index]);
                }
                delete ctrlDataDict[controls[index]];
                delete controls[index];
            }
            if (ctrl == null)
            {
                return;
            }
            ctrlData = ctrlDataDict[ctrl];
            if (ctrlData == null)
            {
                ctrlData = new ControlData(this, ctrl, null, index);
                ctrlDataDict[ctrl] = ctrlData;
            }
            else
            {
                ctrlData.index = index;
            }
            if (index >= NUM_BUTTONS)
            {
                controls[index] = ctrl;
                switch(index)
                {
                    case SEEK_BAR:
                    {
                        addBarControl(ctrl);
                        break;
                    }
                    case VOLUME_BAR:
                    {
                        addBarControl(ctrl);
                        ctrlData.percentage = _vc.volume * 100;
                        break;
                    }
                    case BUFFERING_BAR:
                    {
                        if (ctrl.parent == skin_mc)
                        {
                            finishAddBufferingBar();
                        }
                        else
                        {
                            ctrl.addEventListener(Event.ENTER_FRAME, finishAddBufferingBar);
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                setEnabledAndVisibleForState(index, _vc.state);
            }
            else
            {
                controls[index] = ctrl;
                addButtonControl(ctrl);
            }
            return;
        }// end function

        function createSkin(param1:DisplayObject, param2:String) : DisplayObject
        {
            var stateSkinDesc:*;
            var theClass:Class;
            var definitionHolder:* = param1;
            var skinName:* = param2;
            try
            {
                stateSkinDesc = definitionHolder[skinName];
                if (stateSkinDesc is String)
                {
                    try
                    {
                        theClass = Class(definitionHolder.loaderInfo.applicationDomain.getDefinition(stateSkinDesc));
                    }
                    catch (err1:Error)
                    {
                        theClass = Class(getDefinitionByName(stateSkinDesc));
                    }
                    return DisplayObject(new theClass);
                }
                else if (stateSkinDesc is Class)
                {
                    return new stateSkinDesc;
                }
                else if (stateSkinDesc is DisplayObject)
                {
                    return stateSkinDesc;
                }
            }
            catch (err2:Error)
            {
                throw new VideoError(VideoError.MISSING_SKIN_STYLE, skinName);
            }
            return null;
        }// end function

        function addButtonControl(param1:Sprite) : void
        {
            var _loc_2:ControlData = null;
            var _loc_3:int = 0;
            if (param1 == null)
            {
                return;
            }
            _loc_2 = ctrlDataDict[param1];
            param1.mouseChildren = false;
            _loc_3 = _vc.activeVideoPlayerIndex;
            _vc.activeVideoPlayerIndex = _vc.visibleVideoPlayerIndex;
            _loc_2.state = NORMAL_STATE;
            setEnabledAndVisibleForState(_loc_2.index, _vc.state);
            param1.addEventListener(MouseEvent.ROLL_OVER, handleButtonEvent);
            param1.addEventListener(MouseEvent.ROLL_OUT, handleButtonEvent);
            param1.addEventListener(MouseEvent.MOUSE_DOWN, handleButtonEvent);
            param1.addEventListener(MouseEvent.CLICK, handleButtonEvent);
            if (param1.parent == skin_mc)
            {
                skinButtonControl(param1);
            }
            else
            {
                param1.addEventListener(Event.ENTER_FRAME, skinButtonControl);
            }
            _vc.activeVideoPlayerIndex = _loc_3;
            return;
        }// end function

        function hookUpCustomComponents() : void
        {
            var searchHash:Object;
            var doTheSearch:Boolean;
            var i:int;
            var dispObj:DisplayObject;
            var name:String;
            var index:int;
            var ctrl:Sprite;
            searchHash = new Object();
            doTheSearch;
            i;
            while (i < NUM_CONTROLS)
            {
                
                if (controls[i] == null)
                {
                    searchHash[customComponentClassNames[i]] = i;
                    doTheSearch;
                }
                i = (i + 1);
            }
            if (!doTheSearch)
            {
                return;
            }
            i;
            while (i < _vc.parent.numChildren)
            {
                
                dispObj = _vc.parent.getChildAt(i);
                name = getQualifiedClassName(dispObj);
                if (searchHash[name] != undefined)
                {
                    if (typeof(searchHash[name]) == "number")
                    {
                        index = int(searchHash[name]);
                        try
                        {
                            ctrl = Sprite(dispObj);
                            if ((index >= NUM_BUTTONS || ctrl["placeholder_mc"] is DisplayObject) && ctrl["uiMgr"] == null)
                            {
                                setControl(index, ctrl);
                                searchHash[name] = ctrl;
                            }
                        }
                        catch (err:Error)
                        {
                        }
                    }
                }
                i = (i + 1);
            }
            return;
        }// end function

        function positionHandle(param1:Sprite) : void
        {
            var _loc_2:ControlData = null;
            var _loc_3:Sprite = null;
            var _loc_4:ControlData = null;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            if (param1 == null)
            {
                return;
            }
            var _loc_7:* = param1;
            if (param1["positionHandle"] is Function && _loc_7.param1["positionHandle"]())
            {
                return;
            }
            _loc_2 = ctrlDataDict[param1];
            _loc_3 = _loc_2.handle_mc;
            if (_loc_3 == null)
            {
                return;
            }
            _loc_4 = ctrlDataDict[_loc_3];
            _loc_5 = isNaN(_loc_2.origWidth) ? (param1.width) : (_loc_2.origWidth);
            _loc_6 = _loc_5 - _loc_4.rightMargin - _loc_4.leftMargin;
            _loc_3.x = param1.x + _loc_4.leftMargin + _loc_6 * _loc_2.percentage / 100;
            _loc_3.y = param1.y + _loc_4.origY;
            if (_loc_2.fullness_mc != null)
            {
                positionBar(param1, "fullness", _loc_2.percentage);
            }
            return;
        }// end function

        function exitFullScreenTakeOver() : void
        {
            var fullScreenBG:Sprite;
            var cacheActiveIndex:int;
            var i:int;
            var vp:VideoPlayer;
            if (cacheFLVPlaybackParent == null)
            {
                return;
            }
            _vc.removeEventListener(Event.ADDED_TO_STAGE, handleEvent);
            _vc.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreenEvent);
            try
            {
                if (_fullScreenAccel)
                {
                    _vc.stage.fullScreenSourceRect = new Rectangle(0, 0, -1, -1);
                }
                else
                {
                    _vc.stage.align = cacheStageAlign;
                    _vc.stage.scaleMode = cacheStageScaleMode;
                }
                fullScreenBG = Sprite(_vc.getChildByName("fullScreenBG"));
                if (fullScreenBG != null)
                {
                    _vc.removeChild(fullScreenBG);
                }
                if (_vc.parent != cacheFLVPlaybackParent)
                {
                    cacheFLVPlaybackParent.addChildAt(_vc, cacheFLVPlaybackIndex);
                }
                else
                {
                    cacheFLVPlaybackParent.setChildIndex(_vc, cacheFLVPlaybackIndex);
                }
                cacheActiveIndex = _vc.activeVideoPlayerIndex;
                i;
                while (i < _vc.videoPlayers.length)
                {
                    
                    vp = _vc.videoPlayers[i] as VideoPlayer;
                    if (vp != null)
                    {
                        _vc.activeVideoPlayerIndex = i;
                        if (cacheFLVPlaybackScaleMode[i] != undefined)
                        {
                            _vc.scaleMode = cacheFLVPlaybackScaleMode[i];
                        }
                        if (cacheFLVPlaybackAlign[i])
                        {
                            _vc.align = cacheFLVPlaybackAlign[i];
                        }
                    }
                    i = (i + 1);
                }
                _vc.activeVideoPlayerIndex = cacheActiveIndex;
                _vc.registrationX = cacheFLVPlaybackLocation.x;
                _vc.registrationY = cacheFLVPlaybackLocation.y;
                _vc.setSize(cacheFLVPlaybackLocation.width, cacheFLVPlaybackLocation.height);
            }
            catch (err:Error)
            {
            }
            _vc.addEventListener(Event.ADDED_TO_STAGE, handleEvent);
            _vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreenEvent);
            _fullScreen = false;
            _fullScreenAccel = false;
            cacheStageAlign = null;
            cacheStageScaleMode = null;
            cacheFLVPlaybackParent = null;
            cacheFLVPlaybackIndex = 0;
            cacheFLVPlaybackLocation = null;
            cacheFLVPlaybackScaleMode = null;
            cacheFLVPlaybackAlign = null;
            if (_skinAutoHide != cacheSkinAutoHide)
            {
                _skinAutoHide = cacheSkinAutoHide;
                setupSkinAutoHide(false);
            }
            return;
        }// end function

        function positionMaskedFill(param1:DisplayObject, param2:Number) : void
        {
            var ctrlData:ControlData;
            var fill:DisplayObject;
            var mask:DisplayObject;
            var fillData:ControlData;
            var maskData:ControlData;
            var slideReveal:Boolean;
            var maskSprite:Sprite;
            var barData:ControlData;
            var ctrl:* = param1;
            var percent:* = param2;
            if (ctrl == null)
            {
                return;
            }
            ctrlData = ctrlDataDict[ctrl];
            fill = ctrlData.fill_mc;
            if (fill == null)
            {
                return;
            }
            mask = ctrlData.mask_mc;
            if (ctrlData.mask_mc == null)
            {
                try
                {
                    var _loc_4:* = ctrl["mask_mc"];
                    mask = ctrl["mask_mc"];
                    ctrlData.mask_mc = _loc_4;
                }
                catch (re:ReferenceError)
                {
                    ctrlData.mask_mc = null;
                }
                if (ctrlData.mask_mc == null)
                {
                    maskSprite = new Sprite();
                    var _loc_4:* = maskSprite;
                    mask = maskSprite;
                    ctrlData.mask_mc = _loc_4;
                    maskSprite.graphics.beginFill(16777215);
                    maskSprite.graphics.drawRect(0, 0, 1, 1);
                    maskSprite.graphics.endFill();
                    barData = ctrlDataDict[fill];
                    maskSprite.x = barData.origX;
                    maskSprite.y = barData.origY;
                    maskSprite.width = barData.origWidth;
                    maskSprite.height = barData.origHeight;
                    maskSprite.visible = false;
                    fill.parent.addChild(maskSprite);
                    fill.mask = maskSprite;
                }
                if (ctrlData.mask_mc != null)
                {
                    calcBarMargins(ctrl, "mask", true);
                }
            }
            fillData = ctrlDataDict[fill];
            maskData = ctrlDataDict[mask];
            try
            {
                slideReveal = fill["slideReveal"];
            }
            catch (re:ReferenceError)
            {
                slideReveal;
            }
            if (fill.parent == ctrl)
            {
                if (slideReveal)
                {
                    fill.x = maskData.origX - fillData.origWidth + fillData.origWidth * percent / 100;
                }
                else
                {
                    mask.width = fillData.origWidth * percent / 100;
                }
            }
            else if (fill.parent == ctrl.parent)
            {
                if (slideReveal)
                {
                    mask.x = ctrl.x + maskData.leftMargin;
                    mask.y = ctrl.y + maskData.topMargin;
                    mask.width = ctrl.width - maskData.rightMargin - maskData.leftMargin;
                    mask.height = ctrl.height - maskData.topMargin - maskData.bottomMargin;
                    fill.x = mask.x - fillData.origWidth + maskData.origWidth * percent / 100;
                    fill.y = ctrl.y + fillData.topMargin;
                }
                else
                {
                    fill.x = ctrl.x + fillData.leftMargin;
                    fill.y = ctrl.y + fillData.topMargin;
                    mask.x = fill.x;
                    mask.y = fill.y;
                    mask.width = (ctrl.width - fillData.rightMargin - fillData.leftMargin) * percent / 100;
                    mask.height = ctrl.height - fillData.topMargin - fillData.bottomMargin;
                }
            }
            return;
        }// end function

        function calcPercentageFromHandle(param1:Sprite) : void
        {
            var _loc_2:ControlData = null;
            var _loc_3:Sprite = null;
            var _loc_4:ControlData = null;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            if (param1 == null)
            {
                return;
            }
            _loc_2 = ctrlDataDict[param1];
            var _loc_8:* = param1;
            if (param1["calcPercentageFromHandle"] is Function && _loc_8.param1["calcPercentageFromHandle"]())
            {
                if (_loc_2.percentage < 0)
                {
                    _loc_2.percentage = 0;
                }
                if (_loc_2.percentage > 100)
                {
                    _loc_2.percentage = 100;
                }
                return;
            }
            _loc_3 = _loc_2.handle_mc;
            if (_loc_3 == null)
            {
                return;
            }
            _loc_4 = ctrlDataDict[_loc_3];
            _loc_5 = isNaN(_loc_2.origWidth) ? (param1.width) : (_loc_2.origWidth);
            _loc_6 = _loc_5 - _loc_4.rightMargin - _loc_4.leftMargin;
            _loc_7 = _loc_3.x - (param1.x + _loc_4.leftMargin);
            _loc_2.percentage = _loc_7 / _loc_6 * 100;
            if (_loc_2.percentage < 0)
            {
                _loc_2.percentage = 0;
            }
            if (_loc_2.percentage > 100)
            {
                _loc_2.percentage = 100;
            }
            if (_loc_2.fullness_mc != null)
            {
                positionBar(param1, "fullness", _loc_2.percentage);
            }
            return;
        }// end function

        function handleRelease(param1:int) : void
        {
            var _loc_2:int = 0;
            _loc_2 = _vc.activeVideoPlayerIndex;
            _vc.activeVideoPlayerIndex = _vc.visibleVideoPlayerIndex;
            if (param1 == SEEK_BAR)
            {
                seekBarListener(null);
            }
            else if (param1 == VOLUME_BAR)
            {
                volumeBarListener(null);
            }
            stopHandleDrag(controls[param1]);
            _vc.activeVideoPlayerIndex = _loc_2;
            if (param1 == SEEK_BAR)
            {
                _vc._scrubFinish();
            }
            return;
        }// end function

        function setTwoButtonHolderSkin(param1:int, param2:int, param3:String, param4:int, param5:String) : Sprite
        {
            var _loc_6:Sprite = null;
            var _loc_7:Sprite = null;
            var _loc_8:ControlData = null;
            _loc_7 = new Sprite();
            _loc_8 = new ControlData(this, _loc_7, null, param1);
            ctrlDataDict[_loc_7] = _loc_8;
            skin_mc.addChild(_loc_7);
            _loc_6 = setupButtonSkin(param2);
            _loc_6.name = param3;
            _loc_6.visible = true;
            _loc_7.addChild(_loc_6);
            _loc_6 = setupButtonSkin(param4);
            _loc_6.name = param5;
            _loc_6.visible = false;
            _loc_7.addChild(_loc_6);
            return _loc_7;
        }// end function

        function skinAutoHideHitTest(event:TimerEvent, param2:Boolean = true) : void
        {
            var visibleVP:VideoPlayer;
            var hit:Boolean;
            var e:* = event;
            var doFade:* = param2;
            try
            {
                if (!__visible)
                {
                    skin_mc.visible = false;
                }
                else if (_vc.stage != null)
                {
                    visibleVP = _vc.getVideoPlayer(_vc.visibleVideoPlayerIndex);
                    hit = visibleVP.hitTestPoint(_vc.stage.mouseX, _vc.stage.mouseY, true);
                    if (_fullScreen && _fullScreenTakeOver && e != null)
                    {
                        if (_vc.stage.mouseX == _skinAutoHideMouseX && _vc.stage.mouseY == _skinAutoHideMouseY)
                        {
                            if (getTimer() - _skinAutoHideLastMotionTime > _skinAutoHideMotionTimeout)
                            {
                                hit;
                            }
                        }
                        else
                        {
                            _skinAutoHideLastMotionTime = getTimer();
                            _skinAutoHideMouseX = _vc.stage.mouseX;
                            _skinAutoHideMouseY = _vc.stage.mouseY;
                        }
                    }
                    if (!hit && border_mc != null)
                    {
                        hit = border_mc.hitTestPoint(_vc.stage.mouseX, _vc.stage.mouseY, true);
                        if (hit && _fullScreen && _fullScreenTakeOver)
                        {
                            _skinAutoHideLastMotionTime = getTimer();
                        }
                    }
                    if (!doFade || _skinFadingMaxTime <= 0)
                    {
                        _skinFadingTimer.stop();
                        skin_mc.visible = hit;
                        skin_mc.alpha = 1;
                    }
                    else if (hit && skin_mc.visible && (!_skinFadingTimer.running || _skinFadingIn) || !hit && (!skin_mc.visible || _skinFadingTimer.running && !_skinFadingIn))
                    {
                    }
                    else
                    {
                        _skinFadingTimer.stop();
                        _skinFadingIn = hit;
                        if (_skinFadingIn && skin_mc.alpha == 1)
                        {
                            skin_mc.alpha = 0;
                        }
                        _skinFadeStartTime = getTimer();
                        _skinFadingTimer.start();
                        skin_mc.visible = true;
                    }
                }
            }
            catch (se:SecurityError)
            {
                _skinAutoHideTimer.stop();
                _skinFadingTimer.stop();
                skin_mc.visible = __visible;
                skin_mc.alpha = 1;
            }
            return;
        }// end function

        public function set seekBarInterval(param1:Number) : void
        {
            if (_seekBarTimer.delay == param1)
            {
                return;
            }
            _seekBarTimer.delay = param1;
            return;
        }// end function

        function layoutControl(param1:DisplayObject) : void
        {
            var _loc_2:ControlData = null;
            var _loc_3:Rectangle = null;
            var _loc_4:Sprite = null;
            var _loc_5:Rectangle = null;
            if (param1 == null)
            {
                return;
            }
            _loc_2 = ctrlDataDict[param1];
            if (_loc_2 == null)
            {
                return;
            }
            if (_loc_2.avatar == null)
            {
                return;
            }
            _loc_3 = calcLayoutControl(param1);
            param1.x = _loc_3.x;
            param1.y = _loc_3.y;
            param1.width = _loc_3.width;
            param1.height = _loc_3.height;
            switch(_loc_2.index)
            {
                case SEEK_BAR:
                case VOLUME_BAR:
                {
                    if (_loc_2.hit_mc != null && _loc_2.hit_mc.parent == skin_mc)
                    {
                        _loc_4 = _loc_2.hit_mc;
                        _loc_5 = calcLayoutControl(_loc_4);
                        _loc_4.x = _loc_5.x;
                        _loc_4.y = _loc_5.y;
                        _loc_4.width = _loc_5.width;
                        _loc_4.height = _loc_5.height;
                    }
                    if (_loc_2.progress_mc != null)
                    {
                        if (isNaN(_progressPercent))
                        {
                            _progressPercent = _vc.isRTMP ? (100) : (0);
                        }
                        positionBar(Sprite(param1), "progress", _progressPercent);
                    }
                    positionHandle(Sprite(param1));
                    break;
                }
                case BUFFERING_BAR:
                {
                    positionMaskedFill(param1, 100);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function set fullScreenSkinDelay(param1:int) : void
        {
            _skinAutoHideMotionTimeout = param1;
            return;
        }// end function

        function captureMouseEvent(event:MouseEvent) : void
        {
            event.stopPropagation();
            return;
        }// end function

        function handleMouseUp(event:MouseEvent) : void
        {
            var _loc_2:Sprite = null;
            var _loc_3:ControlData = null;
            _loc_2 = controls[mouseCaptureCtrl];
            if (_loc_2 != null)
            {
                _loc_3 = ctrlDataDict[_loc_2];
                _loc_3.state = _loc_2.hitTestPoint(event.stageX, event.stageY, true) ? (OVER_STATE) : (NORMAL_STATE);
                skinButtonControl(_loc_2);
                switch(mouseCaptureCtrl)
                {
                    case SEEK_BAR_HANDLE:
                    case SEEK_BAR_HIT:
                    {
                        handleRelease(SEEK_BAR);
                        break;
                    }
                    case VOLUME_BAR_HANDLE:
                    case VOLUME_BAR_HIT:
                    {
                        handleRelease(VOLUME_BAR);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, captureMouseEvent, true);
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, captureMouseEvent, true);
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, captureMouseEvent, true);
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
            event.currentTarget.removeEventListener(MouseEvent.ROLL_OUT, captureMouseEvent, true);
            event.currentTarget.removeEventListener(MouseEvent.ROLL_OVER, captureMouseEvent, true);
            return;
        }// end function

        public function set visible(param1:Boolean) : void
        {
            if (__visible == param1)
            {
                return;
            }
            __visible = param1;
            if (!__visible)
            {
                skin_mc.visible = false;
            }
            else
            {
                setupSkinAutoHide(false);
            }
            return;
        }// end function

        public function get bufferingDelayInterval() : Number
        {
            return _bufferingDelayTimer.delay;
        }// end function

        public function set fullScreenBackgroundColor(param1:uint) : void
        {
            if (_fullScreenBgColor != param1)
            {
                _fullScreenBgColor = param1;
                if (_vc)
                {
                }
            }
            return;
        }// end function

        public function get fullScreenTakeOver() : Boolean
        {
            return _fullScreenTakeOver;
        }// end function

        public function set skin(param1:String) : void
        {
            var _loc_2:String = null;
            if (param1 == null)
            {
                removeSkin();
                _skin = null;
                _skinReady = true;
            }
            else
            {
                _loc_2 = String(param1);
                if (param1 == _skin)
                {
                    return;
                }
                removeSkin();
                _skin = String(param1);
                _skinReady = _skin == "";
                if (!_skinReady)
                {
                    downloadSkin();
                }
            }
            return;
        }// end function

        public function set volumeBarInterval(param1:Number) : void
        {
            if (_volumeBarTimer.delay == param1)
            {
                return;
            }
            _volumeBarTimer.delay = param1;
            return;
        }// end function

        function setSkin(param1:int, param2:DisplayObject) : void
        {
            var _loc_3:Sprite = null;
            var _loc_4:ControlData = null;
            var _loc_5:String = null;
            if (param1 >= NUM_CONTROLS)
            {
                return;
            }
            if (param1 < NUM_BUTTONS)
            {
                _loc_3 = setupButtonSkin(param1);
                skin_mc.addChild(_loc_3);
                _loc_4 = ctrlDataDict[_loc_3];
            }
            else
            {
                switch(param1)
                {
                    case PLAY_PAUSE_BUTTON:
                    {
                        _loc_3 = setTwoButtonHolderSkin(param1, PLAY_BUTTON, "play_mc", PAUSE_BUTTON, "pause_mc");
                        _loc_4 = ctrlDataDict[_loc_3];
                        break;
                    }
                    case FULL_SCREEN_BUTTON:
                    {
                        _loc_3 = setTwoButtonHolderSkin(param1, FULL_SCREEN_ON_BUTTON, "on_mc", FULL_SCREEN_OFF_BUTTON, "off_mc");
                        _loc_4 = ctrlDataDict[_loc_3];
                        break;
                    }
                    case MUTE_BUTTON:
                    {
                        _loc_3 = setTwoButtonHolderSkin(param1, MUTE_ON_BUTTON, "on_mc", MUTE_OFF_BUTTON, "off_mc");
                        _loc_4 = ctrlDataDict[_loc_3];
                        break;
                    }
                    case SEEK_BAR:
                    case VOLUME_BAR:
                    {
                        _loc_5 = skinClassPrefixes[param1];
                        _loc_3 = Sprite(createSkin(skinTemplate, _loc_5));
                        if (_loc_3 != null)
                        {
                            skin_mc.addChild(_loc_3);
                            _loc_4 = new ControlData(this, _loc_3, null, param1);
                            ctrlDataDict[_loc_3] = _loc_4;
                            _loc_4.progress_mc = setupBarSkinPart(_loc_3, param2, skinTemplate, _loc_5 + "Progress", "progress_mc");
                            _loc_4.fullness_mc = setupBarSkinPart(_loc_3, param2, skinTemplate, _loc_5 + "Fullness", "fullness_mc");
                            _loc_4.hit_mc = Sprite(setupBarSkinPart(_loc_3, param2, skinTemplate, _loc_5 + "Hit", "hit_mc"));
                            _loc_4.handle_mc = Sprite(setupBarSkinPart(_loc_3, param2, skinTemplate, _loc_5 + "Handle", "handle_mc", true));
                            _loc_3.width = param2.width;
                            _loc_3.height = param2.height;
                        }
                        break;
                    }
                    case BUFFERING_BAR:
                    {
                        _loc_5 = skinClassPrefixes[param1];
                        _loc_3 = Sprite(createSkin(skinTemplate, _loc_5));
                        if (_loc_3 != null)
                        {
                            skin_mc.addChild(_loc_3);
                            _loc_4 = new ControlData(this, _loc_3, null, param1);
                            ctrlDataDict[_loc_3] = _loc_4;
                            _loc_4.fill_mc = setupBarSkinPart(_loc_3, param2, skinTemplate, _loc_5 + "Fill", "fill_mc");
                            _loc_3.width = param2.width;
                            _loc_3.height = param2.height;
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            _loc_4.avatar = param2;
            ctrlDataDict[_loc_3] = _loc_4;
            delayedControls[param1] = _loc_3;
            return;
        }// end function

        public function set bufferingBarHidesAndDisablesOthers(param1:Boolean) : void
        {
            _bufferingBarHides = param1;
            return;
        }// end function

        function handleSoundEvent(event:SoundEvent) : void
        {
            var _loc_2:Sprite = null;
            var _loc_3:ControlData = null;
            if (_isMuted && event.soundTransform.volume > 0)
            {
                _isMuted = false;
                setEnabledAndVisibleForState(MUTE_OFF_BUTTON, VideoState.PLAYING);
                skinButtonControl(controls[MUTE_OFF_BUTTON]);
                setEnabledAndVisibleForState(MUTE_ON_BUTTON, VideoState.PLAYING);
                skinButtonControl(controls[MUTE_ON_BUTTON]);
            }
            _loc_2 = controls[VOLUME_BAR];
            if (_loc_2 != null)
            {
                _loc_3 = ctrlDataDict[_loc_2];
                _loc_3.percentage = (_isMuted ? (cachedSoundLevel) : (event.soundTransform.volume)) * 100;
                if (_loc_3.percentage < 0)
                {
                    _loc_3.percentage = 0;
                }
                else if (_loc_3.percentage > 100)
                {
                    _loc_3.percentage = 100;
                }
                positionHandle(_loc_2);
            }
            return;
        }// end function

        function stopHandleDrag(param1:Sprite) : void
        {
            var ctrlData:ControlData;
            var handle:Sprite;
            var ctrl:* = param1;
            if (ctrl == null)
            {
                return;
            }
            ctrlData = ctrlDataDict[ctrl];
            try
            {
                var _loc_3:* = ctrl;
                if (ctrl["stopHandleDrag"] is Function && _loc_3.ctrl["stopHandleDrag"]())
                {
                    ctrlData.isDragging = false;
                    return;
                }
            }
            catch (re:ReferenceError)
            {
            }
            handle = ctrlData.handle_mc;
            if (handle == null)
            {
                return;
            }
            handle.stopDrag();
            ctrlData.isDragging = false;
            return;
        }// end function

        public function set skinBackgroundAlpha(param1:Number) : void
        {
            if (borderAlpha != param1)
            {
                borderAlpha = param1;
                borderColorTransform.alphaOffset = 255 * param1;
                borderPrevRect = null;
                layoutSkin();
            }
            return;
        }// end function

        public function getControl(param1:int) : Sprite
        {
            return controls[param1];
        }// end function

        public function set skinScaleMaximum(param1:Number) : void
        {
            _skinScaleMaximum = param1;
            return;
        }// end function

        function handleLoad(event:Event) : void
        {
            var i:int;
            var dispObj:DisplayObject;
            var index:Number;
            var e:* = event;
            try
            {
                skin_mc = new Sprite();
                if (e != null)
                {
                    skinTemplate = Sprite(skinLoader.content);
                }
                layout_mc = skinTemplate;
                customClips = new Array();
                delayedControls = new Array();
                i;
                while (i < layout_mc.numChildren)
                {
                    
                    dispObj = layout_mc.getChildAt(i);
                    index = layoutNameToIndexMappings[dispObj.name];
                    if (!isNaN(index))
                    {
                        setSkin(int(index), dispObj);
                    }
                    else if (dispObj.name != "video_mc")
                    {
                        setCustomClip(dispObj);
                    }
                    i = (i + 1);
                }
                skinLoadDelayCount = 0;
                _vc.addEventListener(Event.ENTER_FRAME, finishLoad);
            }
            catch (err:Error)
            {
                _vc.skinError(err.message);
                removeSkin();
            }
            return;
        }// end function

        function calcBarMargins(param1:DisplayObject, param2:String, param3:Boolean) : void
        {
            var ctrlData:ControlData;
            var bar:DisplayObject;
            var barData:ControlData;
            var ctrl:* = param1;
            var type:* = param2;
            var symmetricMargins:* = param3;
            if (ctrl == null)
            {
                return;
            }
            ctrlData = ctrlDataDict[ctrl];
            bar = ctrlData[type + "_mc"];
            if (bar == null)
            {
                try
                {
                    bar = ctrl[type + "_mc"];
                }
                catch (re:ReferenceError)
                {
                    bar;
                }
                if (bar == null)
                {
                    return;
                }
                ctrlData[type + "_mc"] = bar;
            }
            barData = ctrlDataDict[bar];
            if (barData == null)
            {
                barData = new ControlData(this, bar, ctrl, -1);
                ctrlDataDict[bar] = barData;
            }
            barData.leftMargin = getNumberPropSafe(ctrl, type + "LeftMargin");
            if (isNaN(barData.leftMargin) && bar.parent == ctrl.parent)
            {
                barData.leftMargin = bar.x - ctrl.x;
            }
            barData.rightMargin = getNumberPropSafe(ctrl, type + "RightMargin");
            if (isNaN(barData.rightMargin))
            {
                if (symmetricMargins)
                {
                    barData.rightMargin = barData.leftMargin;
                }
                else if (bar.parent == ctrl.parent)
                {
                    barData.rightMargin = ctrl.width - bar.width - bar.x + ctrl.x;
                }
            }
            barData.topMargin = getNumberPropSafe(ctrl, type + "TopMargin");
            if (isNaN(barData.topMargin) && bar.parent == ctrl.parent)
            {
                barData.topMargin = bar.y - ctrl.y;
            }
            barData.bottomMargin = getNumberPropSafe(ctrl, type + "BottomMargin");
            if (isNaN(barData.bottomMargin))
            {
                if (symmetricMargins)
                {
                    barData.bottomMargin = barData.topMargin;
                }
                else if (bar.parent == ctrl.parent)
                {
                    barData.bottomMargin = ctrl.height - bar.height - bar.y + ctrl.y;
                }
            }
            barData.origX = getNumberPropSafe(ctrl, type + "X");
            if (isNaN(barData.origX))
            {
                if (bar.parent == ctrl.parent)
                {
                    barData.origX = bar.x - ctrl.x;
                }
                else if (bar.parent == ctrl)
                {
                    barData.origX = bar.x;
                }
            }
            barData.origY = getNumberPropSafe(ctrl, type + "Y");
            if (isNaN(barData.origY))
            {
                if (bar.parent == ctrl.parent)
                {
                    barData.origY = bar.y - ctrl.y;
                }
                else if (bar.parent == ctrl)
                {
                    barData.origY = bar.y;
                }
            }
            barData.origWidth = bar.width;
            barData.origHeight = bar.height;
            barData.origScaleX = bar.scaleX;
            barData.origScaleY = bar.scaleY;
            return;
        }// end function

        public function set skinBackgroundColor(param1:uint) : void
        {
            if (borderColor != param1)
            {
                borderColor = param1;
                borderColorTransform.redOffset = borderColor >> 16 & 255;
                borderColorTransform.greenOffset = borderColor >> 8 & 255;
                borderColorTransform.blueOffset = borderColor & 255;
                borderPrevRect = null;
                layoutSkin();
            }
            return;
        }// end function

        public function set volumeBarScrubTolerance(param1:Number) : void
        {
            _volumeBarScrubTolerance = param1;
            return;
        }// end function

        function finishAddBufferingBar(event:Event = null) : void
        {
            var _loc_2:Sprite = null;
            if (event != null)
            {
                event.currentTarget.removeEventListener(Event.ENTER_FRAME, finishAddBufferingBar);
            }
            _loc_2 = controls[BUFFERING_BAR];
            calcBarMargins(_loc_2, "fill", true);
            fixUpBar(_loc_2, "fill", _loc_2, "fill_mc");
            positionMaskedFill(_loc_2, 100);
            return;
        }// end function

        function handleButtonEvent(event:MouseEvent) : void
        {
            var ctrlData:ControlData;
            var topLevel:DisplayObject;
            var e:* = event;
            ctrlData = ctrlDataDict[e.currentTarget];
            switch(e.type)
            {
                case MouseEvent.ROLL_OVER:
                {
                    ctrlData.state = OVER_STATE;
                    break;
                }
                case MouseEvent.ROLL_OUT:
                {
                    ctrlData.state = NORMAL_STATE;
                    break;
                }
                case MouseEvent.MOUSE_DOWN:
                {
                    ctrlData.state = DOWN_STATE;
                    mouseCaptureCtrl = ctrlData.index;
                    switch(mouseCaptureCtrl)
                    {
                        case SEEK_BAR_HANDLE:
                        case SEEK_BAR_HIT:
                        case VOLUME_BAR_HANDLE:
                        case VOLUME_BAR_HIT:
                        {
                            dispatchMessage(ctrlData.index);
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    topLevel = _vc.stage;
                    try
                    {
                        topLevel.addEventListener(MouseEvent.MOUSE_DOWN, captureMouseEvent, true);
                    }
                    catch (se:SecurityError)
                    {
                        topLevel = _vc.root;
                        topLevel.addEventListener(MouseEvent.MOUSE_DOWN, captureMouseEvent, true);
                    }
                    topLevel.addEventListener(MouseEvent.MOUSE_OUT, captureMouseEvent, true);
                    topLevel.addEventListener(MouseEvent.MOUSE_OVER, captureMouseEvent, true);
                    topLevel.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
                    topLevel.addEventListener(MouseEvent.ROLL_OUT, captureMouseEvent, true);
                    topLevel.addEventListener(MouseEvent.ROLL_OVER, captureMouseEvent, true);
                    break;
                }
                case MouseEvent.CLICK:
                {
                    switch(mouseCaptureCtrl)
                    {
                        case SEEK_BAR_HANDLE:
                        case SEEK_BAR_HIT:
                        case VOLUME_BAR_HANDLE:
                        case VOLUME_BAR_HIT:
                        {
                            break;
                        }
                        default:
                        {
                            dispatchMessage(ctrlData.index);
                            break;
                            break;
                        }
                    }
                    return;
                }
                default:
                {
                    break;
                }
            }
            skinButtonControl(e.currentTarget);
            return;
        }// end function

        function applySkinState(param1:ControlData, param2:DisplayObject) : void
        {
            if (param2 != param1.currentState_mc)
            {
                if (param1.currentState_mc != null)
                {
                    param1.currentState_mc.visible = false;
                }
                param1.currentState_mc = param2;
                param1.currentState_mc.visible = true;
            }
            return;
        }// end function

        function handleLoadErrorEvent(event:ErrorEvent) : void
        {
            _skinReady = true;
            _vc.skinError(event.toString());
            return;
        }// end function

        function addBarControl(param1:Sprite) : void
        {
            var _loc_2:ControlData = null;
            _loc_2 = ctrlDataDict[param1];
            _loc_2.isDragging = false;
            _loc_2.percentage = 0;
            if (param1.parent == skin_mc && skin_mc != null)
            {
                finishAddBarControl(param1);
            }
            else
            {
                param1.addEventListener(Event.REMOVED_FROM_STAGE, cleanupHandle);
                param1.addEventListener(Event.ENTER_FRAME, finishAddBarControl);
            }
            return;
        }// end function

        function handleEvent(event:Event) : void
        {
            var e:* = event;
            switch(e.type)
            {
                case Event.ADDED_TO_STAGE:
                {
                    _fullScreen = false;
                    if (_vc.stage != null)
                    {
                        try
                        {
                            _fullScreen = _vc.stage.displayState == StageDisplayState.FULL_SCREEN;
                            _vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreenEvent);
                        }
                        catch (se:SecurityError)
                        {
                        }
                    }
                    if (!_fullScreen)
                    {
                        _fullScreenAccel = false;
                    }
                    setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON, VideoState.PLAYING);
                    skinButtonControl(controls[FULL_SCREEN_OFF_BUTTON]);
                    setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON, VideoState.PLAYING);
                    skinButtonControl(controls[FULL_SCREEN_ON_BUTTON]);
                    if (_fullScreen && _fullScreenTakeOver)
                    {
                        enterFullScreenTakeOver();
                    }
                    else if (!_fullScreen)
                    {
                        exitFullScreenTakeOver();
                    }
                    layoutSkin();
                    setupSkinAutoHide(false);
                    break;
                }
                case Event.REMOVED_FROM_STAGE:
                {
                    _vc.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreenEvent);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        function skinButtonControl(param1:Object) : void
        {
            var ctrl:Sprite;
            var ctrlData:ControlData;
            var e:Event;
            var ctrlOrEvent:* = param1;
            if (ctrlOrEvent == null)
            {
                return;
            }
            if (ctrlOrEvent is Event)
            {
                e = Event(ctrlOrEvent);
                ctrl = Sprite(e.currentTarget);
                ctrl.removeEventListener(Event.ENTER_FRAME, skinButtonControl);
            }
            else
            {
                ctrl = Sprite(ctrlOrEvent);
            }
            ctrlData = ctrlDataDict[ctrl];
            if (ctrlData == null)
            {
                return;
            }
            try
            {
                if (ctrl["placeholder_mc"] != undefined)
                {
                    ctrl.removeChild(ctrl["placeholder_mc"]);
                    ctrl["placeholder_mc"] = null;
                }
            }
            catch (re:ReferenceError)
            {
            }
            if (ctrlData.state_mc == null)
            {
                ctrlData.state_mc = new Array();
            }
            if (ctrlData.state_mc[NORMAL_STATE] == undefined)
            {
                ctrlData.state_mc[NORMAL_STATE] = setupButtonSkinState(ctrl, ctrl, buttonSkinLinkageIDs[NORMAL_STATE], null);
            }
            if (ctrlData.enabled && _controlsEnabled)
            {
                if (ctrlData.state_mc[ctrlData.state] == undefined)
                {
                    ctrlData.state_mc[ctrlData.state] = setupButtonSkinState(ctrl, ctrl, buttonSkinLinkageIDs[ctrlData.state], ctrlData.state_mc[NORMAL_STATE]);
                }
                if (ctrlData.state_mc[ctrlData.state] != ctrlData.currentState_mc)
                {
                    if (ctrlData.currentState_mc != null)
                    {
                        ctrlData.currentState_mc.visible = false;
                    }
                    ctrlData.currentState_mc = ctrlData.state_mc[ctrlData.state];
                    ctrlData.currentState_mc.visible = true;
                }
                applySkinState(ctrlData, ctrlData.state_mc[ctrlData.state]);
            }
            else
            {
                ctrlData.state = NORMAL_STATE;
                if (ctrlData.disabled_mc == null)
                {
                    ctrlData.disabled_mc = setupButtonSkinState(ctrl, ctrl, "disabledLinkageID", ctrlData.state_mc[NORMAL_STATE]);
                }
                applySkinState(ctrlData, ctrlData.disabled_mc);
            }
            return;
        }// end function

        public function set controlsEnabled(param1:Boolean) : void
        {
            var _loc_2:int = 0;
            if (_controlsEnabled == param1)
            {
                return;
            }
            _controlsEnabled = param1;
            _loc_2 = 0;
            while (_loc_2 < NUM_BUTTONS)
            {
                
                skinButtonControl(controls[_loc_2]);
                _loc_2++;
            }
            return;
        }// end function

        function setupSkinAutoHide(param1:Boolean) : void
        {
            if (_skinAutoHide && skin_mc != null)
            {
                skinAutoHideHitTest(null, param1);
                _skinAutoHideTimer.start();
            }
            else
            {
                if (skin_mc != null)
                {
                    if (param1 && _skinFadingMaxTime > 0 && (!skin_mc.visible || skin_mc.alpha < 1) && __visible)
                    {
                        _skinFadingTimer.stop();
                        _skinFadeStartTime = getTimer();
                        _skinFadingIn = true;
                        if (skin_mc.alpha == 1)
                        {
                            skin_mc.alpha = 0;
                        }
                        _skinFadingTimer.start();
                    }
                    else if (_skinFadingMaxTime <= 0)
                    {
                        _skinFadingTimer.stop();
                        skin_mc.alpha = 1;
                    }
                    skin_mc.visible = __visible;
                }
                _skinAutoHideTimer.stop();
            }
            return;
        }// end function

        public function enterFullScreenDisplayState() : void
        {
            var theRect:Rectangle;
            var vp:VideoPlayer;
            var effectiveWidth:int;
            var effectiveHeight:int;
            var videoAspectRatio:Number;
            var screenAspectRatio:Number;
            var effectiveMinWidth:int;
            var effectiveMinHeight:int;
            var skinScaleMinWidth:int;
            var skinScaleMinHeight:int;
            if (!_fullScreen && _vc.stage != null)
            {
                if (_fullScreenTakeOver)
                {
                    try
                    {
                        theRect = _vc.stage.fullScreenSourceRect;
                        _fullScreenAccel = true;
                        vp = _vc.getVideoPlayer(_vc.visibleVideoPlayerIndex);
                        effectiveWidth = vp.videoWidth;
                        effectiveHeight = vp.videoHeight;
                        videoAspectRatio = effectiveWidth / effectiveHeight;
                        screenAspectRatio = _vc.stage.fullScreenWidth / _vc.stage.fullScreenHeight;
                        if (videoAspectRatio > screenAspectRatio)
                        {
                            effectiveHeight = effectiveWidth / screenAspectRatio;
                        }
                        else if (videoAspectRatio < screenAspectRatio)
                        {
                            effectiveWidth = effectiveHeight * screenAspectRatio;
                        }
                        effectiveMinWidth = fullScreenSourceRectMinWidth;
                        effectiveMinHeight = fullScreenSourceRectMinHeight;
                        if (fullScreenSourceRectMinAspectRatio > screenAspectRatio)
                        {
                            effectiveMinHeight = effectiveMinWidth / screenAspectRatio;
                        }
                        else if (fullScreenSourceRectMinAspectRatio < screenAspectRatio)
                        {
                            effectiveMinWidth = effectiveMinHeight * screenAspectRatio;
                        }
                        skinScaleMinWidth = _vc.stage.fullScreenWidth / _skinScaleMaximum;
                        skinScaleMinHeight = _vc.stage.fullScreenHeight / _skinScaleMaximum;
                        if (effectiveMinWidth < skinScaleMinWidth || effectiveMinHeight < skinScaleMinHeight)
                        {
                            effectiveMinWidth = skinScaleMinWidth;
                            effectiveMinHeight = skinScaleMinHeight;
                        }
                        if (effectiveWidth < effectiveMinWidth || effectiveHeight < effectiveMinHeight)
                        {
                            effectiveWidth = effectiveMinWidth;
                            effectiveHeight = effectiveMinHeight;
                        }
                        _vc.stage.fullScreenSourceRect = new Rectangle(0, 0, effectiveWidth, effectiveHeight);
                        _vc.stage.displayState = StageDisplayState.FULL_SCREEN;
                    }
                    catch (re:ReferenceError)
                    {
                        _fullScreenAccel = false;
                        ;
                    }
                    catch (re:SecurityError)
                    {
                        _fullScreenAccel = false;
                    }
                    try
                    {
                    }
                    _vc.stage.displayState = StageDisplayState.FULL_SCREEN;
                }
                catch (se:SecurityError)
                {
                }
            }
            return;
        }// end function

        public function get skin() : String
        {
            return _skin;
        }// end function

        function finishAddBarControl(param1:Object) : void
        {
            var ctrl:Sprite;
            var ctrlData:ControlData;
            var e:Event;
            var ctrlOrEvent:* = param1;
            if (ctrlOrEvent == null)
            {
                return;
            }
            if (ctrlOrEvent is Event)
            {
                e = Event(ctrlOrEvent);
                ctrl = Sprite(e.currentTarget);
                ctrl.removeEventListener(Event.ENTER_FRAME, finishAddBarControl);
            }
            else
            {
                ctrl = Sprite(ctrlOrEvent);
            }
            ctrlData = ctrlDataDict[ctrl];
            try
            {
                if (ctrl["addBarControl"] is Function)
                {
                    var _loc_3:* = ctrl;
                    _loc_3.ctrl["addBarControl"]();
                }
            }
            catch (re:ReferenceError)
            {
            }
            ctrlData.origWidth = ctrl.width;
            ctrlData.origHeight = ctrl.height;
            fixUpBar(ctrl, "progress", ctrl, "progress_mc");
            calcBarMargins(ctrl, "progress", false);
            if (ctrlData.progress_mc != null)
            {
                fixUpBar(ctrl, "progressBarFill", ctrlData.progress_mc, "fill_mc");
                calcBarMargins(ctrlData.progress_mc, "fill", false);
                calcBarMargins(ctrlData.progress_mc, "mask", false);
                if (isNaN(_progressPercent))
                {
                    _progressPercent = _vc.isRTMP ? (100) : (0);
                }
                positionBar(ctrl, "progress", _progressPercent);
            }
            fixUpBar(ctrl, "fullness", ctrl, "fullness_mc");
            calcBarMargins(ctrl, "fullness", false);
            if (ctrlData.fullness_mc != null)
            {
                fixUpBar(ctrl, "fullnessBarFill", ctrlData.fullness_mc, "fill_mc");
                calcBarMargins(ctrlData.fullness_mc, "fill", false);
                calcBarMargins(ctrlData.fullness_mc, "mask", false);
            }
            fixUpBar(ctrl, "hit", ctrl, "hit_mc");
            fixUpBar(ctrl, "handle", ctrl, "handle_mc");
            calcBarMargins(ctrl, "handle", true);
            switch(ctrlData.index)
            {
                case SEEK_BAR:
                {
                    setControl(SEEK_BAR_HANDLE, ctrlData.handle_mc);
                    if (ctrlData.hit_mc != null)
                    {
                        setControl(SEEK_BAR_HIT, ctrlData.hit_mc);
                    }
                    break;
                }
                case VOLUME_BAR:
                {
                    setControl(VOLUME_BAR_HANDLE, ctrlData.handle_mc);
                    if (ctrlData.hit_mc != null)
                    {
                        setControl(VOLUME_BAR_HIT, ctrlData.hit_mc);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            positionHandle(ctrl);
            return;
        }// end function

        public function get fullScreenBackgroundColor() : uint
        {
            return _fullScreenBgColor;
        }// end function

        function startHandleDrag(param1:Sprite) : void
        {
            var ctrlData:ControlData;
            var handle:Sprite;
            var handleData:ControlData;
            var theY:Number;
            var theWidth:Number;
            var bounds:Rectangle;
            var ctrl:* = param1;
            if (ctrl == null)
            {
                return;
            }
            ctrlData = ctrlDataDict[ctrl];
            try
            {
                var _loc_3:* = ctrl;
                if (ctrl["startHandleDrag"] is Function && _loc_3.ctrl["startHandleDrag"]())
                {
                    ctrlData.isDragging = true;
                    return;
                }
            }
            catch (re:ReferenceError)
            {
            }
            handle = ctrlData.handle_mc;
            if (handle == null)
            {
                return;
            }
            handleData = ctrlDataDict[handle];
            theY = ctrl.y + handleData.origY;
            theWidth = isNaN(ctrlData.origWidth) ? (ctrl.width) : (ctrlData.origWidth);
            bounds = new Rectangle(ctrl.x + handleData.leftMargin, theY, theWidth - handleData.rightMargin, 0);
            handle.startDrag(false, bounds);
            ctrlData.isDragging = true;
            return;
        }// end function

        function setupBarSkinPart(param1:Sprite, param2:DisplayObject, param3:Sprite, param4:String, param5:String, param6:Boolean = false) : DisplayObject
        {
            var part:DisplayObject;
            var partAvatar:DisplayObject;
            var ctrlData:ControlData;
            var partData:ControlData;
            var ctrl:* = param1;
            var avatar:* = param2;
            var definitionHolder:* = param3;
            var skinName:* = param4;
            var partName:* = param5;
            var required:* = param6;
            try
            {
                part = ctrl[partName];
            }
            catch (re:ReferenceError)
            {
                part;
            }
            if (part == null)
            {
                try
                {
                    part = createSkin(definitionHolder, skinName);
                }
                catch (ve:VideoError)
                {
                    if (required)
                    {
                        throw ve;
                    }
                }
                if (part != null)
                {
                    skin_mc.addChild(part);
                    part.x = ctrl.x;
                    part.y = ctrl.y;
                    partAvatar = layout_mc.getChildByName(skinName + "_mc");
                    if (partAvatar != null)
                    {
                        if (partName == "hit_mc")
                        {
                            ctrlData = ctrlDataDict[ctrl];
                            partData = new ControlData(this, part, controls[ctrlData.index], -1);
                            partData.avatar = partAvatar;
                            ctrlDataDict[part] = partData;
                        }
                        else
                        {
                            part.x = part.x + (partAvatar.x - avatar.x);
                            part.y = part.y + (partAvatar.y - avatar.y);
                            part.width = partAvatar.width;
                            part.height = partAvatar.height;
                        }
                    }
                }
            }
            if (required && part == null)
            {
                throw new VideoError(VideoError.MISSING_SKIN_STYLE, skinName);
            }
            return part;
        }// end function

        public function get skinBackgroundAlpha() : Number
        {
            return borderAlpha;
        }// end function

        public function get volumeBarScrubTolerance() : Number
        {
            return _volumeBarScrubTolerance;
        }// end function

        public function get skinScaleMaximum() : Number
        {
            return _skinScaleMaximum;
        }// end function

        public function get skinBackgroundColor() : uint
        {
            return borderColor;
        }// end function

        public function get controlsEnabled() : Boolean
        {
            return _controlsEnabled;
        }// end function

        function handleIVPEvent(event:IVPEvent) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:int = 0;
            var _loc_4:VideoEvent = null;
            var _loc_5:Sprite = null;
            var _loc_6:ControlData = null;
            var _loc_7:VideoProgressEvent = null;
            var _loc_8:VideoPlayerState = null;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            if (event.fl.video:IVPEvent::vp != _vc.visibleVideoPlayerIndex)
            {
                return;
            }
            _loc_2 = _vc.activeVideoPlayerIndex;
            _vc.activeVideoPlayerIndex = _vc.visibleVideoPlayerIndex;
            switch(event.fl.video:IVPEvent::type)
            {
                case VideoEvent.STATE_CHANGE:
                {
                    _loc_4 = VideoEvent(event);
                    if (_loc_4.state == VideoState.BUFFERING)
                    {
                        if (!_bufferingOn)
                        {
                            _bufferingDelayTimer.reset();
                            _bufferingDelayTimer.start();
                        }
                    }
                    else
                    {
                        _bufferingDelayTimer.reset();
                        _bufferingOn = false;
                    }
                    if (_loc_4.state == VideoState.LOADING)
                    {
                        _progressPercent = _vc.getVideoPlayer(event.fl.video:IVPEvent::vp).isRTMP ? (100) : (0);
                        _loc_3 = SEEK_BAR;
                        while (_loc_3 <= VOLUME_BAR)
                        {
                            
                            _loc_5 = controls[_loc_3];
                            if (controls[_loc_3] == null)
                            {
                            }
                            else
                            {
                                _loc_6 = ctrlDataDict[_loc_5];
                                if (_loc_6.progress_mc != null)
                                {
                                    positionBar(_loc_5, "progress", _progressPercent);
                                }
                            }
                            _loc_3++;
                        }
                    }
                    _loc_3 = 0;
                    while (_loc_3 < NUM_CONTROLS)
                    {
                        
                        if (controls[_loc_3] == undefined)
                        {
                        }
                        else
                        {
                            setEnabledAndVisibleForState(_loc_3, _loc_4.state);
                            if (_loc_3 < NUM_BUTTONS)
                            {
                                skinButtonControl(controls[_loc_3]);
                            }
                        }
                        _loc_3++;
                    }
                    break;
                }
                case VideoEvent.READY:
                case MetadataEvent.METADATA_RECEIVED:
                {
                    _loc_3 = 0;
                    while (_loc_3 < NUM_CONTROLS)
                    {
                        
                        if (controls[_loc_3] == undefined)
                        {
                        }
                        else
                        {
                            setEnabledAndVisibleForState(_loc_3, _vc.state);
                            if (_loc_3 < NUM_BUTTONS)
                            {
                                skinButtonControl(controls[_loc_3]);
                            }
                        }
                        _loc_3++;
                    }
                    if (_vc.getVideoPlayer(event.fl.video:IVPEvent::vp).isRTMP)
                    {
                        _progressPercent = 100;
                        _loc_3 = SEEK_BAR;
                        while (_loc_3 <= VOLUME_BAR)
                        {
                            
                            _loc_5 = controls[_loc_3];
                            if (_loc_5 == null)
                            {
                            }
                            else
                            {
                                _loc_6 = ctrlDataDict[_loc_5];
                                if (_loc_6.progress_mc != null)
                                {
                                    positionBar(_loc_5, "progress", _progressPercent);
                                }
                            }
                            _loc_3++;
                        }
                    }
                    break;
                }
                case VideoEvent.PLAYHEAD_UPDATE:
                {
                    if (controls[SEEK_BAR] != undefined && !_vc.isLive && !isNaN(_vc.totalTime) && _vc.getVideoPlayer(_vc.visibleVideoPlayerIndex).state != VideoState.SEEKING)
                    {
                        _loc_4 = VideoEvent(event);
                        _loc_10 = _loc_4.playheadTime / _vc.totalTime * 100;
                        if (_loc_10 < 0)
                        {
                            _loc_10 = 0;
                        }
                        else if (_loc_10 > 100)
                        {
                            _loc_10 = 100;
                        }
                        _loc_5 = controls[SEEK_BAR];
                        _loc_6 = ctrlDataDict[_loc_5];
                        _loc_6.percentage = _loc_10;
                        positionHandle(_loc_5);
                    }
                    break;
                }
                case VideoProgressEvent.PROGRESS:
                {
                    _loc_7 = VideoProgressEvent(event);
                    _progressPercent = _loc_7.bytesTotal <= 0 ? (100) : (_loc_7.bytesLoaded / _loc_7.bytesTotal * 100);
                    _loc_8 = _vc.videoPlayerStates[event.fl.video:IVPEvent::vp];
                    _loc_9 = _loc_8.minProgressPercent;
                    if (!isNaN(_loc_9) && _loc_9 > _progressPercent)
                    {
                        _progressPercent = _loc_9;
                    }
                    if (!isNaN(_vc.totalTime))
                    {
                        _loc_11 = _vc.playheadTime / _vc.totalTime * 100;
                        if (_loc_11 > _progressPercent)
                        {
                            _progressPercent = _loc_11;
                            _loc_8.minProgressPercent = _progressPercent;
                        }
                    }
                    _loc_3 = SEEK_BAR;
                    while (_loc_3 <= VOLUME_BAR)
                    {
                        
                        _loc_5 = controls[_loc_3];
                        if (_loc_5 == null)
                        {
                        }
                        else
                        {
                            _loc_6 = ctrlDataDict[_loc_5];
                            if (_loc_6.progress_mc != null)
                            {
                                positionBar(_loc_5, "progress", _progressPercent);
                            }
                        }
                        _loc_3++;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            _vc.activeVideoPlayerIndex = _loc_2;
            return;
        }// end function

        function setupButtonSkinState(param1:Sprite, param2:Sprite, param3:String, param4:DisplayObject = null) : DisplayObject
        {
            var stateSkin:DisplayObject;
            var ctrl:* = param1;
            var definitionHolder:* = param2;
            var skinName:* = param3;
            var defaultSkin:* = param4;
            try
            {
                stateSkin = createSkin(definitionHolder, skinName);
            }
            catch (ve:VideoError)
            {
                if (defaultSkin != null)
                {
                    stateSkin;
                }
                else
                {
                    throw ve;
                }
            }
            if (stateSkin != null)
            {
                stateSkin.visible = false;
                ctrl.addChild(stateSkin);
            }
            else if (defaultSkin != null)
            {
                stateSkin = defaultSkin;
            }
            return stateSkin;
        }// end function

        function layoutSkin() : void
        {
            var video_mc:DisplayObject;
            var i:int;
            var borderRect:Rectangle;
            var forceSkinAutoHide:Boolean;
            var minWidth:Number;
            var vidWidth:Number;
            var minHeight:Number;
            var vidHeight:Number;
            if (layout_mc == null)
            {
                return;
            }
            if (skinLoadDelayCount < 2)
            {
                return;
            }
            video_mc = layout_mc["video_mc"];
            if (video_mc == null)
            {
                throw new Error("No layout_mc.video_mc");
            }
            placeholderLeft = video_mc.x;
            placeholderRight = video_mc.x + video_mc.width;
            placeholderTop = video_mc.y;
            placeholderBottom = video_mc.y + video_mc.height;
            videoLeft = _vc.x - _vc.registrationX;
            videoRight = videoLeft + _vc.width;
            videoTop = _vc.y - _vc.registrationY;
            videoBottom = videoTop + _vc.height;
            if (_fullScreen && _fullScreenTakeOver && border_mc != null)
            {
                borderRect = calcLayoutControl(border_mc);
                forceSkinAutoHide;
                if (borderRect.width > 0 && borderRect.height > 0)
                {
                    if (borderRect.x < 0)
                    {
                        placeholderLeft = placeholderLeft + (videoLeft - borderRect.x);
                        forceSkinAutoHide;
                    }
                    if (borderRect.x + borderRect.width > _vc.registrationWidth)
                    {
                        placeholderRight = placeholderRight + (borderRect.x + borderRect.width - videoRight);
                        forceSkinAutoHide;
                    }
                    if (borderRect.y < 0)
                    {
                        placeholderTop = placeholderTop + (videoTop - borderRect.y);
                        forceSkinAutoHide;
                    }
                    if (borderRect.y + borderRect.height > _vc.registrationHeight)
                    {
                        placeholderBottom = placeholderBottom + (borderRect.y + borderRect.height - videoBottom);
                        forceSkinAutoHide;
                    }
                    if (forceSkinAutoHide)
                    {
                        _skinAutoHide = true;
                        setupSkinAutoHide(true);
                    }
                }
            }
            try
            {
                if (!isNaN(layout_mc["minWidth"]))
                {
                    minWidth = layout_mc["minWidth"];
                    vidWidth = videoRight - videoLeft;
                    if (minWidth > 0 && minWidth > vidWidth)
                    {
                        videoLeft = videoLeft - (minWidth - vidWidth) / 2;
                        videoRight = minWidth + videoLeft;
                    }
                }
            }
            catch (re1:ReferenceError)
            {
                try
                {
                }
                if (!isNaN(layout_mc["minHeight"]))
                {
                    minHeight = layout_mc["minHeight"];
                    vidHeight = videoBottom - videoTop;
                    if (minHeight > 0 && minHeight > vidHeight)
                    {
                        videoTop = videoTop - (minHeight - vidHeight) / 2;
                        videoBottom = minHeight + videoTop;
                    }
                }
            }
            catch (re2:ReferenceError)
            {
            }
            i;
            while (i < customClips.length)
            {
                
                layoutControl(customClips[i]);
                if (customClips[i] == border_mc)
                {
                    bitmapCopyBorder();
                }
                i = (i + 1);
            }
            i;
            while (i < NUM_CONTROLS)
            {
                
                layoutControl(controls[i]);
                i = (i + 1);
            }
            return;
        }// end function

        public function set bufferingDelayInterval(param1:Number) : void
        {
            if (_bufferingDelayTimer.delay == param1)
            {
                return;
            }
            _bufferingDelayTimer.delay = param1;
            return;
        }// end function

        function setEnabledAndVisibleForState(param1:int, param2:String) : void
        {
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_5:Sprite = null;
            var _loc_6:ControlData = null;
            var _loc_7:Boolean = false;
            var _loc_8:ControlData = null;
            var _loc_9:ControlData = null;
            var _loc_10:ControlData = null;
            var _loc_11:ControlData = null;
            _loc_3 = _vc.activeVideoPlayerIndex;
            _vc.activeVideoPlayerIndex = _vc.visibleVideoPlayerIndex;
            _loc_4 = param2;
            if (_loc_4 == VideoState.BUFFERING && !_bufferingOn)
            {
                _loc_4 = VideoState.PLAYING;
            }
            _loc_5 = controls[param1];
            if (_loc_5 == null)
            {
                return;
            }
            _loc_6 = ctrlDataDict[_loc_5];
            if (_loc_6 == null)
            {
                return;
            }
            switch(param1)
            {
                case VOLUME_BAR:
                case VOLUME_BAR_HANDLE:
                case VOLUME_BAR_HIT:
                {
                    _loc_6.enabled = true;
                    break;
                }
                case FULL_SCREEN_ON_BUTTON:
                {
                    _loc_6.enabled = !_fullScreen;
                    if (controls[FULL_SCREEN_BUTTON] != undefined)
                    {
                        _loc_5.visible = _loc_6.enabled;
                    }
                    break;
                }
                case FULL_SCREEN_OFF_BUTTON:
                {
                    _loc_6.enabled = _fullScreen;
                    if (controls[FULL_SCREEN_BUTTON] != undefined)
                    {
                        _loc_5.visible = _loc_6.enabled;
                    }
                    break;
                }
                case MUTE_ON_BUTTON:
                {
                    _loc_6.enabled = !_isMuted;
                    if (controls[MUTE_BUTTON] != undefined)
                    {
                        _loc_5.visible = _loc_6.enabled;
                    }
                    break;
                }
                case MUTE_OFF_BUTTON:
                {
                    _loc_6.enabled = _isMuted;
                    if (controls[MUTE_BUTTON] != undefined)
                    {
                        _loc_5.visible = _loc_6.enabled;
                    }
                    break;
                }
                default:
                {
                    switch(_loc_4)
                    {
                        case VideoState.LOADING:
                        case VideoState.CONNECTION_ERROR:
                        {
                            _loc_6.enabled = false;
                            break;
                        }
                        case VideoState.DISCONNECTED:
                        {
                            _loc_6.enabled = _vc.source != null && _vc.source != "";
                            break;
                        }
                        case VideoState.SEEKING:
                        {
                            break;
                        }
                        default:
                        {
                            _loc_6.enabled = true;
                            break;
                            break;
                        }
                    }
                    break;
                    break;
                }
            }
            switch(param1)
            {
                case SEEK_BAR:
                {
                    switch(_loc_4)
                    {
                        case VideoState.STOPPED:
                        case VideoState.PLAYING:
                        case VideoState.PAUSED:
                        case VideoState.REWINDING:
                        case VideoState.SEEKING:
                        {
                            _loc_6.enabled = true;
                            break;
                        }
                        case VideoState.BUFFERING:
                        {
                            _loc_6.enabled = !_bufferingBarHides || controls[BUFFERING_BAR] == undefined;
                            break;
                        }
                        default:
                        {
                            _loc_6.enabled = false;
                            break;
                            break;
                        }
                    }
                    if (_loc_6.enabled)
                    {
                        _loc_6.enabled = !isNaN(_vc.totalTime);
                    }
                    if (_loc_6.handle_mc != null)
                    {
                        _loc_8 = ctrlDataDict[_loc_6.handle_mc];
                        _loc_8.enabled = _loc_6.enabled;
                        _loc_6.handle_mc.visible = _loc_8.enabled;
                    }
                    if (_loc_6.hit_mc != null)
                    {
                        _loc_9 = ctrlDataDict[_loc_6.hit_mc];
                        _loc_9.enabled = _loc_6.enabled;
                        _loc_6.hit_mc.visible = _loc_9.enabled;
                    }
                    _loc_7 = !_bufferingBarHides || _loc_6.enabled || controls[BUFFERING_BAR] == undefined || !controls[BUFFERING_BAR].visible;
                    _loc_5.visible = _loc_7;
                    if (_loc_6.progress_mc != null)
                    {
                        _loc_6.progress_mc.visible = _loc_7;
                        _loc_10 = ctrlDataDict[_loc_6.progress_mc];
                        if (_loc_10.fill_mc != null)
                        {
                            _loc_10.fill_mc.visible = _loc_7;
                        }
                    }
                    if (_loc_6.fullness_mc != null)
                    {
                        _loc_6.fullness_mc.visible = _loc_7;
                        _loc_11 = ctrlDataDict[_loc_6.fullness_mc];
                        if (_loc_11.fill_mc != null)
                        {
                            _loc_11.fill_mc.visible = _loc_7;
                        }
                    }
                    break;
                }
                case BUFFERING_BAR:
                {
                    switch(_loc_4)
                    {
                        case VideoState.STOPPED:
                        case VideoState.PLAYING:
                        case VideoState.PAUSED:
                        case VideoState.REWINDING:
                        case VideoState.SEEKING:
                        {
                            _loc_6.enabled = false;
                            break;
                        }
                        default:
                        {
                            _loc_6.enabled = true;
                            break;
                            break;
                        }
                    }
                    _loc_5.visible = _loc_6.enabled;
                    if (_loc_6.fill_mc != null)
                    {
                        _loc_6.fill_mc.visible = _loc_6.enabled;
                    }
                    break;
                }
                case PAUSE_BUTTON:
                {
                    switch(_loc_4)
                    {
                        case VideoState.DISCONNECTED:
                        case VideoState.STOPPED:
                        case VideoState.PAUSED:
                        case VideoState.REWINDING:
                        {
                            _loc_6.enabled = false;
                            break;
                        }
                        case VideoState.PLAYING:
                        {
                            _loc_6.enabled = true;
                            break;
                        }
                        case VideoState.BUFFERING:
                        {
                            _loc_6.enabled = !_bufferingBarHides || controls[BUFFERING_BAR] == undefined;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    if (controls[PLAY_PAUSE_BUTTON] != undefined)
                    {
                        _loc_5.visible = _loc_6.enabled;
                    }
                    break;
                }
                case PLAY_BUTTON:
                {
                    switch(_loc_4)
                    {
                        case VideoState.PLAYING:
                        {
                            _loc_6.enabled = false;
                            break;
                        }
                        case VideoState.STOPPED:
                        case VideoState.PAUSED:
                        {
                            _loc_6.enabled = true;
                            break;
                        }
                        case VideoState.BUFFERING:
                        {
                            _loc_6.enabled = !_bufferingBarHides || controls[BUFFERING_BAR] == undefined;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    if (controls[PLAY_PAUSE_BUTTON] != undefined)
                    {
                        _loc_5.visible = !controls[PAUSE_BUTTON].visible;
                    }
                    break;
                }
                case STOP_BUTTON:
                {
                    switch(_loc_4)
                    {
                        case VideoState.DISCONNECTED:
                        case VideoState.STOPPED:
                        {
                            _loc_6.enabled = false;
                            break;
                        }
                        case VideoState.PAUSED:
                        case VideoState.PLAYING:
                        case VideoState.BUFFERING:
                        {
                            _loc_6.enabled = true;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    break;
                }
                case BACK_BUTTON:
                case FORWARD_BUTTON:
                {
                    switch(_loc_4)
                    {
                        case VideoState.BUFFERING:
                        {
                            _loc_6.enabled = !_bufferingBarHides || controls[BUFFERING_BAR] == undefined;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                default:
                {
                    break;
                }
            }
            _loc_5.mouseEnabled = _loc_6.enabled;
            _vc.activeVideoPlayerIndex = _loc_3;
            return;
        }// end function

        public function set fullScreenTakeOver(param1:Boolean) : void
        {
            var v:* = param1;
            if (_fullScreenTakeOver != v)
            {
                _fullScreenTakeOver = v;
                if (_fullScreenTakeOver)
                {
                    enterFullScreenTakeOver();
                }
                else
                {
                    if (_vc.stage != null && _fullScreen && _fullScreenAccel)
                    {
                        try
                        {
                            _vc.stage.displayState = StageDisplayState.NORMAL;
                        }
                        catch (se:SecurityError)
                        {
                        }
                    }
                    exitFullScreenTakeOver();
                }
            }
            return;
        }// end function

        function enterFullScreenTakeOver() : void
        {
            var i:int;
            var fullScreenBG:Sprite;
            var vp:VideoPlayer;
            if (!_fullScreen || cacheFLVPlaybackParent != null)
            {
                return;
            }
            _vc.removeEventListener(LayoutEvent.LAYOUT, handleLayoutEvent);
            _vc.removeEventListener(AutoLayoutEvent.AUTO_LAYOUT, handleLayoutEvent);
            _vc.removeEventListener(Event.ADDED_TO_STAGE, handleEvent);
            _vc.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreenEvent);
            try
            {
                cacheFLVPlaybackScaleMode = new Array();
                cacheFLVPlaybackAlign = new Array();
                i;
                while (i < _vc.videoPlayers.length)
                {
                    
                    vp = _vc.videoPlayers[i] as VideoPlayer;
                    if (vp != null)
                    {
                        cacheFLVPlaybackScaleMode[i] = vp.scaleMode;
                        cacheFLVPlaybackAlign[i] = vp.align;
                    }
                    i = (i + 1);
                }
                cacheFLVPlaybackParent = _vc.parent;
                cacheFLVPlaybackIndex = _vc.parent.getChildIndex(_vc);
                cacheFLVPlaybackLocation = new Rectangle(_vc.registrationX, _vc.registrationY, _vc.registrationWidth, _vc.registrationHeight);
                if (!_fullScreenAccel)
                {
                    cacheStageAlign = _vc.stage.align;
                    cacheStageScaleMode = _vc.stage.scaleMode;
                    _vc.stage.align = StageAlign.TOP_LEFT;
                    _vc.stage.scaleMode = StageScaleMode.NO_SCALE;
                }
                _vc.align = VideoAlign.CENTER;
                _vc.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
                _vc.registrationX = 0;
                _vc.registrationY = 0;
                _vc.setSize(_vc.stage.stageWidth, _vc.stage.stageHeight);
                if (_vc.stage != _vc.parent)
                {
                    _vc.stage.addChild(_vc);
                }
                else
                {
                    _vc.stage.setChildIndex(_vc, (_vc.stage.numChildren - 1));
                }
                fullScreenBG = Sprite(_vc.getChildByName("fullScreenBG"));
                if (fullScreenBG == null)
                {
                    fullScreenBG = new Sprite();
                    fullScreenBG.name = "fullScreenBG";
                    _vc.addChildAt(fullScreenBG, 0);
                }
                else
                {
                    _vc.setChildIndex(fullScreenBG, 0);
                }
                fullScreenBG.graphics.beginFill(_fullScreenBgColor);
                fullScreenBG.graphics.drawRect(0, 0, _vc.stage.stageWidth, _vc.stage.stageHeight);
                layoutSkin();
                setupSkinAutoHide(false);
            }
            catch (err:Error)
            {
                cacheFLVPlaybackParent = null;
            }
            _vc.addEventListener(LayoutEvent.LAYOUT, handleLayoutEvent);
            _vc.addEventListener(AutoLayoutEvent.AUTO_LAYOUT, handleLayoutEvent);
            _vc.addEventListener(Event.ADDED_TO_STAGE, handleEvent);
            _vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreenEvent);
            return;
        }// end function

        public function set seekBarScrubTolerance(param1:Number) : void
        {
            _seekBarScrubTolerance = param1;
            return;
        }// end function

        function cleanupHandle(param1:Object) : void
        {
            var e:Event;
            var ctrl:Sprite;
            var ctrlData:ControlData;
            var ctrlOrEvent:* = param1;
            try
            {
                if (ctrlOrEvent is Event)
                {
                    e = Event(ctrlOrEvent);
                }
                ctrl = e == null ? (Sprite(ctrlOrEvent)) : (Sprite(e.currentTarget));
                ctrlData = ctrlDataDict[ctrl];
                if (ctrlData == null || e == null)
                {
                    ctrl.removeEventListener(Event.REMOVED_FROM_STAGE, cleanupHandle, false);
                    if (ctrlData == null)
                    {
                        return;
                    }
                }
                ctrl.removeEventListener(Event.ENTER_FRAME, finishAddBarControl);
                if (ctrlData.handle_mc != null)
                {
                    if (ctrlData.handle_mc.parent != null)
                    {
                        ctrlData.handle_mc.parent.removeChild(ctrlData.handle_mc);
                    }
                    delete ctrlDataDict[ctrlData.handle_mc];
                    ctrlData.handle_mc = null;
                }
                if (ctrlData.hit_mc != null)
                {
                    if (ctrlData.hit_mc.parent != null)
                    {
                        ctrlData.hit_mc.parent.removeChild(ctrlData.hit_mc);
                    }
                    delete ctrlDataDict[ctrlData.hit_mc];
                    ctrlData.hit_mc = null;
                }
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        static function getNumberPropSafe(param1:Object, param2:String) : Number
        {
            var numProp:*;
            var obj:* = param1;
            var propName:* = param2;
            try
            {
                numProp = obj[propName];
                return Number(numProp);
            }
            catch (re:ReferenceError)
            {
            }
            return NaN;
        }// end function

        static function getBooleanPropSafe(param1:Object, param2:String) : Boolean
        {
            var boolProp:*;
            var obj:* = param1;
            var propName:* = param2;
            try
            {
                boolProp = obj[propName];
                return Boolean(boolProp);
            }
            catch (re:ReferenceError)
            {
            }
            return false;
        }// end function

        static function initLayoutNameToIndexMappings() : void
        {
            var _loc_1:int = 0;
            layoutNameToIndexMappings = new Object();
            _loc_1 = 0;
            while (_loc_1 < layoutNameArray.length)
            {
                
                if (layoutNameArray[_loc_1] != null)
                {
                    layoutNameToIndexMappings[layoutNameArray[_loc_1]] = _loc_1;
                }
                _loc_1++;
            }
            return;
        }// end function

    }
}
