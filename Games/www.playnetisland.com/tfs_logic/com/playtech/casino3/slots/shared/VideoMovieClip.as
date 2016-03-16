package com.playtech.casino3.slots.shared
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.utils.*;
    import com.playtech.casino3.slots.shared.utils.debug.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    dynamic public class VideoMovieClip extends MovieClip
    {
        protected var _is_smoothed:Boolean = false;
        public var _linkage:String;
        public var is_synchronized:Boolean = true;
        protected var _loop_after_frame_object:Object = null;
        protected var force_fps:int = 0;
        protected var is_playing:Boolean = false;
        protected var missig:TextField;
        protected var up:VideoMovieClip;
        protected var loops_count:int = 0;
        protected var shape:Shape;
        protected var down:VideoMovieClip;
        protected var frames:Vector.<BitmapData>;
        protected var compound:MovieClip = null;
        protected var loop_after_frame:int = 0;
        protected var static_init:Object;
        protected var _height:int = 0;
        protected var _width:int = 0;
        protected var _currentFrame:int = 0;
        public var debug:Boolean = false;
        protected var frame_time:Number = 0;
        protected var loops_finished:int = 0;
        protected var fps:int = 0;
        protected var frame:MovieClip;
        protected var _frame_labels:MovieClipFramesData;
        protected var last_update_time:uint = 0;
        public var loops_finished_handler:Function;
        static var videos_playing:Dictionary;
        static const FPS_PREFIX:String = "fps_";
        static var frames_played:int = 0;
        static const SYNCHRONIZE_INSTANCES:Boolean = true;
        static var frame_labels:Object;
        static const ENTER_FRAME_BROADCASTER:Sprite = new Sprite();
        static const FRAME_POSITION:String = "framePos";
        static var videos:Object;
        static var frame_buffers:Object;
        static const SIZE_POSITION:String = "size_position";
        static const LOOPS_PREFIX:String = "loops_";
        static const LOOP_START:String = "loop_start";
        static const DEFAULT_FRAME_RATE:int = 25;
        static var frames_bounds:Dictionary;
        static const FORCE_FPS_PREFIX:String = "force_fps_";
        static const FRAME_TIME:Number = 40;

        public function VideoMovieClip(frame_labels:String, frame_labels:int = 0, frame_labels:int = 0, frame_labels = "loop_start") : void
        {
            this.shape = new Shape();
            this.static_init = VideoMovieClip.init() + "";
            this._width = frame_labels;
            this._height = frame_labels;
            this._loop_after_frame_object = frame_labels;
            this.linkage = frame_labels;
            return;
        }// end function

        public function set is_smoothed(frame_labels:Boolean) : void
        {
            this._is_smoothed = frame_labels;
            if (this.up)
            {
                this.up.is_smoothed = this._is_smoothed;
            }
            if (this.down)
            {
                this.down.is_smoothed = this._is_smoothed;
            }
            this.showFrame(this._currentFrame);
            return;
        }// end function

        public function set linkage(frame_labels:String) : void
        {
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            this._linkage = frame_labels;
            var _loc_2:* = constructFrames(this._linkage, this._width, this._height);
            this.frames = frame_buffers[this._linkage];
            if (this.up)
            {
                removeChild(this.up);
                this.up.stop();
                this.up = null;
            }
            if (this.frame)
            {
                removeChild(this.frame);
                this.frame = null;
            }
            if (this.down)
            {
                removeChild(this.down);
                this.down.stop();
                this.down = null;
            }
            if (this.shape && contains(this.shape))
            {
                _loc_3 = getChildIndex(this.shape);
                removeChild(this.shape);
            }
            if (_loc_2 && _loc_2.getChildByName(FRAME_POSITION) != null)
            {
                _loc_4 = getQualifiedClassName(_loc_2.getChildAt(0));
                this.down = new VideoMovieClip(_loc_4);
                this.down.stop();
                this.down.is_smoothed = this.is_smoothed;
                addChild(this.down);
                this.frame = addChild(new MovieClip()) as MovieClip;
                this.frame.name = FRAME_POSITION;
                _loc_5 = getQualifiedClassName(_loc_2.getChildAt(2));
                this.up = new VideoMovieClip(_loc_5);
                this.up.stop();
                this.up.is_smoothed = this.is_smoothed;
                addChild(this.up);
            }
            else
            {
                addChildAt(this.shape, _loc_3);
            }
            if (!_loc_2)
            {
                this.shape.graphics.clear();
                this.shape.graphics.beginFill(65280);
                this.shape.graphics.drawRect((-this._width) / 2, (-this._height) / 2, this._width, this._height);
                if (!this.missig)
                {
                    this.missig = new TextField();
                    this.missig.autoSize = TextFieldAutoSize.CENTER;
                    this.missig.defaultTextFormat = new TextFormat("_sans", 20, 16711680, true, null, null, null, null, TextFormatAlign.CENTER);
                }
                this.missig.text = "MISSING" + "\r" + this._linkage;
                this.missig.x = (-this.missig.width) / 2;
                this.missig.y = (-this.missig.height) / 2;
                addChild(this.missig);
                return;
            }
            this._frame_labels = frame_labels[this._linkage] as MovieClipFramesData;
            if (this.missig && contains(this.missig))
            {
                removeChild(this.missig);
            }
            this.loop_after_frame = this._frame_labels.indexOfFrameWithLabel(this._loop_after_frame_object, true);
            this.loops_finished = 0;
            this.loops_count = int(this._frame_labels.getFrameSuffixFromFrameBeginningWith(LOOPS_PREFIX));
            this.fps = int(this._frame_labels.getFrameSuffixFromFrameBeginningWith(FPS_PREFIX));
            this.force_fps = int(this._frame_labels.getFrameSuffixFromFrameBeginningWith(FORCE_FPS_PREFIX));
            if (!this.fps)
            {
                this.fps = DEFAULT_FRAME_RATE;
            }
            if (!this.force_fps)
            {
                this.force_fps = this.fps;
            }
            this.frame_time = 1000 / this.force_fps;
            this.loops_finished_handler = null;
            this.is_playing = false;
            this.gotoAndPlay(1);
            return;
        }// end function

        override public function get totalFrames() : int
        {
            return this.frames ? (this.frames.length) : (0);
        }// end function

        override public function gotoAndStop(frame_labels:Object, frame_labels:String = null) : void
        {
            this.currentFrame = this._frame_labels.indexOfFrameWithLabel(frame_labels + "");
            this.stop();
            return;
        }// end function

        override public function stop() : void
        {
            if (!videos_playing)
            {
                return;
            }
            delete videos_playing[this];
            if (this.debug)
            {
                trace("stop " + movieClipPath(this));
            }
            if (this.up)
            {
                this.up.stop();
            }
            if (this.down)
            {
                this.down.stop();
            }
            this.is_playing = false;
            return;
        }// end function

        public function dispose() : void
        {
            this.stop();
            if (this.up)
            {
                this.up.stop();
            }
            if (this.up && contains(this.up))
            {
                removeChild(this.up);
            }
            if (this.frame && contains(this.frame))
            {
                removeChild(this.frame);
            }
            if (this.down)
            {
                this.down.stop();
            }
            if (this.down && contains(this.down))
            {
                removeChild(this.down);
            }
            if (this.shape && contains(this.shape))
            {
                removeChild(this.shape);
            }
            this.shape.graphics.clear();
            this.up = null;
            this.frame = null;
            this.down = null;
            this.shape = null;
            this.compound = null;
            this.missig = null;
            this.frames = null;
            this._frame_labels = null;
            return;
        }// end function

        override public function nextFrame() : void
        {
            this.currentFrame = this._currentFrame + 2;
            return;
        }// end function

        override public function play() : void
        {
            if (this.is_playing)
            {
                return;
            }
            this.is_playing = true;
            if (this.debug)
            {
                if (this.up)
                {
                    this.up.debug = true;
                }
                if (this.down)
                {
                    this.down.debug = true;
                }
            }
            if (this.debug)
            {
                trace("play " + movieClipPath(this));
            }
            if (this.up)
            {
                this.up.play();
            }
            if (this.down)
            {
                this.down.play();
            }
            if (this.totalFrames > 1)
            {
                this.last_update_time = getTimer();
                videos_playing[this] = true;
                return;
            }
            this.currentFrame = 1;
            return;
        }// end function

        override public function gotoAndPlay(frame_labels:Object, frame_labels:String = null) : void
        {
            this._currentFrame = this._frame_labels.indexOfFrameWithLabel(frame_labels.toString()) - 1;
            this.play();
            return;
        }// end function

        public function get is_smoothed() : Boolean
        {
            return this._is_smoothed;
        }// end function

        public function get linkage() : String
        {
            return this._linkage;
        }// end function

        override public function get currentLabels() : Array
        {
            return this._frame_labels.labels;
        }// end function

        protected function onEnterFrameNavigate(frame_labels:int = 1) : void
        {
            this._currentFrame = this._currentFrame + frame_labels;
            if (this._currentFrame >= this.totalFrames)
            {
                var _loc_2:String = this;
                var _loc_3:* = this.loops_finished + 1;
                _loc_2.loops_finished = _loc_3;
                if (this.loop_after_frame > 0)
                {
                    this._currentFrame = this.loop_after_frame;
                }
            }
            if (this.loops_count && this.loops_finished >= this.loops_count)
            {
                if (this._currentFrame > this.totalFrames)
                {
                    this.currentFrame = this.totalFrames;
                }
                if (this.loops_finished_handler != null)
                {
                    this.loops_finished_handler();
                }
                return this.stop();
            }
            if (this.debug)
            {
                trace("onEnterFrameNavigate " + (this._currentFrame + 1));
            }
            this.currentFrame = this._currentFrame + 1;
            return;
        }// end function

        public function set currentFrame(frame_labels:int) : void
        {
            frame_labels = frame_labels - 1;
            frame_labels = frame_labels >= this.totalFrames ? (frame_labels - this.totalFrames) : (frame_labels < 0 ? (this._currentFrame - frame_labels - 1) : (frame_labels));
            this._currentFrame = frame_labels;
            if (this.debug)
            {
                trace("showFrame " + this._currentFrame);
            }
            this.showFrame(this._currentFrame);
            return;
        }// end function

        protected function showFrame(frame_labels:int) : void
        {
            if (!this.frames)
            {
                this.shape.graphics.clear();
                return;
            }
            frame_labels = frame_labels % this.frames.length;
            var _loc_2:* = this.frames[frame_labels] as BitmapData;
            var _loc_3:* = frames_bounds[_loc_2] as Rectangle;
            var _loc_4:* = new Matrix();
            _loc_4.translate(_loc_3.x, _loc_3.y);
            this.shape.graphics.clear();
            this.shape.graphics.beginBitmapFill(_loc_2, _loc_4, false, this._is_smoothed);
            this.shape.graphics.moveTo(_loc_3.x, _loc_3.y);
            this.shape.graphics.lineTo(_loc_3.right, _loc_3.y);
            this.shape.graphics.lineTo(_loc_3.right, _loc_3.bottom);
            this.shape.graphics.lineTo(_loc_3.x, _loc_3.bottom);
            return;
        }// end function

        override public function prevFrame() : void
        {
            this.currentFrame = this._currentFrame;
            return;
        }// end function

        override public function get currentFrame() : int
        {
            return (this._currentFrame + 1);
        }// end function

        public static function dispose() : void
        {
            var _loc_1:VideoMovieClip = null;
            var _loc_2:Object = null;
            for (_loc_2 in videos_playing)
            {
                
                _loc_1 = _loc_2 as VideoMovieClip;
                _loc_1.dispose();
            }
            videos_playing = null;
            frame_buffers = null;
            frame_labels = null;
            frames_bounds = null;
            videos = null;
            ENTER_FRAME_BROADCASTER.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            return;
        }// end function

        static function init() : void
        {
            if (frame_buffers)
            {
                return;
            }
            frame_buffers = {};
            frame_labels = {};
            frames_bounds = new Dictionary(true);
            videos = {};
            videos_playing = new Dictionary(true);
            frames_played = 0;
            ENTER_FRAME_BROADCASTER.addEventListener(Event.ENTER_FRAME, onEnterFrame);
            return;
        }// end function

        public static function constructFrames(instance_frame:String, instance_frame:int = 0, instance_frame:int = 0) : MovieClip
        {
            var _loc_8:int = 0;
            var _loc_10:BitmapData = null;
            var _loc_11:Matrix = null;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_15:Rectangle = null;
            var _loc_4:* = frame_buffers[instance_frame] as Vector.<BitmapData>;
            var _loc_5:* = videos[instance_frame] as MovieClip;
            if (_loc_5)
            {
                return _loc_5;
            }
            if (!ApplicationDomain.currentDomain.hasDefinition(instance_frame))
            {
                Console.write("Warning VideoMovieClip.constructFrames - " + instance_frame + " does not exists !!!");
                return null;
            }
            var _loc_6:* = getDefinitionByName(instance_frame) as Class;
            _loc_5 = new _loc_6 as MovieClip;
            videos[instance_frame] = _loc_5;
            _loc_5.stop();
            frame_labels[instance_frame] = new MovieClipFramesData(_loc_5);
            if (_loc_5.getChildByName(FRAME_POSITION) != null)
            {
                return _loc_5;
            }
            var _loc_7:* = _loc_5.getChildByName(SIZE_POSITION) as DisplayObject;
            if (_loc_7)
            {
                _loc_7.visible = false;
            }
            _loc_4 = new Vector.<BitmapData>(_loc_5.totalFrames, true);
            var _loc_9:* = _loc_4.length;
            var _loc_12:* = new Rectangle(0, 0, instance_frame, instance_frame);
            _loc_8 = 0;
            while (_loc_8 < _loc_9)
            {
                
                _loc_5.gotoAndStop((_loc_8 + 1));
                _loc_13 = instance_frame > 0 ? (instance_frame) : (_loc_5.width);
                _loc_14 = instance_frame > 0 ? (instance_frame) : (_loc_5.height);
                _loc_15 = _loc_7 ? (_loc_7.getBounds(_loc_5)) : (new Rectangle((-_loc_13) / 2, (-_loc_14) / 2, _loc_13, _loc_14));
                _loc_12.width = _loc_15.width;
                _loc_12.height = _loc_15.height;
                _loc_11 = new Matrix();
                _loc_11.translate(-_loc_15.x, -_loc_15.y);
                _loc_10 = new BitmapData(_loc_15.width, _loc_15.height, true, 0);
                _loc_10.draw(_loc_5, _loc_11, null, null, _loc_12, true);
                _loc_4[_loc_8] = _loc_10;
                frames_bounds[_loc_10] = _loc_15;
                _loc_8++;
            }
            frame_buffers[instance_frame] = _loc_4;
            return _loc_5;
        }// end function

        public static function getActiveMoviesFrames(param1:String)
        {
            var _loc_2:VideoMovieClip = null;
            var _loc_3:Object = null;
            for (_loc_3 in videos_playing)
            {
                
                _loc_2 = _loc_3 as VideoMovieClip;
                if (_loc_2.linkage == param1)
                {
                    return _loc_2.currentFrame;
                }
            }
            return;
        }// end function

        public static function resetActiveMoviesFrames(param1:String, param2:int = 1)
        {
            var _loc_3:VideoMovieClip = null;
            var _loc_4:Object = null;
            Console.write("resetActiveMoviesFrames " + param1);
            for (_loc_4 in videos_playing)
            {
                
                _loc_3 = _loc_4 as VideoMovieClip;
                if (_loc_3.linkage == param1)
                {
                    _loc_3.currentFrame = param2;
                }
            }
            return;
        }// end function

        static function onEnterFrame(event:Event) : void
        {
            var _loc_3:Object = null;
            var _loc_4:int = 0;
            var _loc_5:VideoMovieClip = null;
            var _loc_6:Object = null;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_2:Object = {};
            var _loc_11:* = frames_played + 1;
            frames_played = _loc_11;
            var _loc_7:* = getTimer();
            for (_loc_6 in videos_playing)
            {
                
                _loc_9 = 1;
                _loc_5 = _loc_6 as VideoMovieClip;
                if (_loc_5.fps)
                {
                    _loc_8 = _loc_7 - _loc_5.last_update_time;
                    if (_loc_8 <= 0)
                    {
                        continue;
                    }
                    _loc_9 = int(_loc_8 / _loc_5.frame_time);
                    _loc_8 = _loc_9 * _loc_5.frame_time;
                    _loc_9 = _loc_9 * Math.round(_loc_5.fps / _loc_5.force_fps);
                    if (_loc_9 == 0)
                    {
                        continue;
                    }
                    _loc_5.last_update_time = _loc_5.last_update_time + _loc_8;
                }
                if (SYNCHRONIZE_INSTANCES && _loc_5.is_synchronized)
                {
                    _loc_3 = _loc_2[_loc_5.linkage];
                    if (_loc_3 != null)
                    {
                        _loc_4 = int(_loc_3);
                        if (_loc_5.currentFrame + _loc_9 != _loc_4)
                        {
                            _loc_9 = _loc_4 - _loc_5.currentFrame;
                        }
                    }
                    else
                    {
                        _loc_2[_loc_5.linkage] = _loc_5.currentFrame + _loc_9;
                    }
                }
                _loc_5.onEnterFrameNavigate(_loc_9);
            }
            return;
        }// end function

    }
}
