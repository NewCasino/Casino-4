package com.playtech.casino3.slots.shared.utils
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.utils.debug.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.events.*;

    public class MovieClipFramesData extends EventDispatcher implements IDisposable
    {
        protected var _frames_labels:Object;
        protected var _previous_frame:int;
        protected var _dispatcher:IEventDispatcher;
        protected var _frame_labels_array:Array;
        protected var _movie_clip:MovieClip;
        protected var _frame_indexes:Object;
        protected var _frame_labels:Vector.<FrameLabel>;
        const creation_index:int;
        public static const FIRST_FRAME_REACHED:String = "FIRST_FRAME_REACHED";
        public static const LAST_FRAME_REACHED:String = "LAST_FRAME_REACHED";
        static var counter:int = 0;

        public function MovieClipFramesData(_movie_clip:MovieClip, _movie_clip:IEventDispatcher = null) : void
        {
            var _loc_3:int = 0;
            var _loc_5:FrameLabel = null;
            var _loc_6:Vector.<String> = null;
            this._frame_indexes = {};
            this._frames_labels = {};
            this.creation_index = counter + 1;
            this._movie_clip = _movie_clip;
            this._frame_labels_array = this._movie_clip.currentLabels;
            this._frame_labels = this.Vector.<FrameLabel>(this._frame_labels_array);
            var _loc_4:* = this._frame_labels.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_5 = this._frame_labels[_loc_3];
                this._frame_indexes[_loc_5.name] = _loc_5.frame;
                _loc_6 = this._frames_labels[_loc_5.frame];
                if (!_loc_6)
                {
                    var _loc_7:* = new Vector.<String>;
                    this._frames_labels[_loc_5.frame] = new Vector.<String>;
                    _loc_6 = _loc_7;
                }
                _loc_6.push(_loc_5.name);
                _loc_3++;
            }
            this.dispatcher = _movie_clip;
            return;
        }// end function

        protected function dispatchFrameLabels() : void
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:LabelActionType = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            if (!this._dispatcher)
            {
                return;
            }
            if (!this._movie_clip)
            {
                return;
            }
            var _loc_1:* = this._movie_clip.currentFrame;
            var _loc_2:* = this.labelsOfFrameWithIndex(_loc_1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_3 in _loc_2)
            {
                
                _loc_5 = null;
                _loc_4 = null;
                _loc_6 = _loc_3.indexOf("$");
                if (_loc_6 != -1)
                {
                    _loc_8 = _loc_6;
                    _loc_6 = int(_loc_3.substring((_loc_6 + 1)));
                    _loc_3 = _loc_3.substring(0, _loc_8);
                }
                _loc_7 = _loc_3.indexOf("#");
                if (_loc_7 != -1)
                {
                    _loc_8 = _loc_7;
                    _loc_7 = int(_loc_3.substring((_loc_7 + 1)));
                    _loc_4 = _loc_3.substring((_loc_8 + 1));
                    _loc_5 = LabelActionType.fromType(_loc_4.toUpperCase());
                    _loc_3 = _loc_3.substring(0, _loc_8);
                }
                this._dispatcher.dispatchEvent(new LabelEvent(_loc_3, _loc_1, _loc_6, _loc_5));
                if (_loc_5)
                {
                    this._dispatcher.dispatchEvent(new LabelEvent(_loc_5.type, _loc_1, _loc_6, _loc_5, _loc_3));
                }
            }
            return;
        }// end function

        public function set dispatcher(_movie_clip:IEventDispatcher) : void
        {
            if (this._dispatcher == _movie_clip)
            {
                return;
            }
            this._dispatcher = _movie_clip;
            if (!_movie_clip)
            {
                return this._movie_clip.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameMovie);
            }
            this._movie_clip.addEventListener(Event.ENTER_FRAME, this.onEnterFrameMovie);
            return;
        }// end function

        public function indexOfFrameWithLabel(_frame_labels:String, _frame_labels:Boolean = false) : int
        {
            var _loc_3:* = Number(_frame_labels);
            if (!isNaN(_loc_3))
            {
                return _loc_3;
            }
            var _loc_4:* = this._frame_indexes[_frame_labels];
            if (!_frame_labels && isNaN(_loc_4))
            {
                Console.write("Warning MovieClipFramesData.indexOfFrameWithLabel cant find label " + _frame_labels + " in " + this._movie_clip + " path " + movieClipPath(this._movie_clip));
            }
            return isNaN(_loc_4) ? (-1) : (_loc_4);
        }// end function

        public function labelsOfFrameWithIndex(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\utils;MovieClipFramesData.as:int) : Vector.<String>
        {
            var _loc_2:* = this._frames_labels[D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\utils;MovieClipFramesData.as] as Vector.<String>;
            return _loc_2;
        }// end function

        function onEnterFrameMovie(event:Event) : void
        {
            if (this._movie_clip.currentFrame == this._previous_frame)
            {
                return;
            }
            this._previous_frame = this._movie_clip.currentFrame;
            if (this._previous_frame == this._movie_clip.totalFrames)
            {
                this._dispatcher.dispatchEvent(new LabelEvent(LAST_FRAME_REACHED, this._movie_clip.totalFrames));
            }
            if (this._previous_frame == 1)
            {
                this._dispatcher.dispatchEvent(new LabelEvent(FIRST_FRAME_REACHED, 1));
            }
            this.dispatchFrameLabels();
            return;
        }// end function

        public function dispose() : void
        {
            if (this._movie_clip)
            {
                this._movie_clip.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameMovie);
            }
            this._movie_clip = null;
            this._frame_indexes = null;
            this._frame_labels_array = null;
            this._frame_labels = null;
            this._frames_labels = null;
            this._dispatcher = null;
            return;
        }// end function

        public function getFrameSuffixFromFrameBeginningWith(FIRST_FRAME_REACHED:String) : String
        {
            var _loc_2:int = 0;
            var _loc_4:FrameLabel = null;
            var _loc_5:int = 0;
            var _loc_3:* = this.labels.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = this._frame_labels[_loc_2];
                _loc_5 = _loc_4.name.indexOf(FIRST_FRAME_REACHED);
                if (_loc_5 == 0)
                {
                    return _loc_4.name.substring(FIRST_FRAME_REACHED.length);
                }
                _loc_2++;
            }
            return "";
        }// end function

        public function get labels() : Array
        {
            return this._frame_labels_array;
        }// end function

    }
}
