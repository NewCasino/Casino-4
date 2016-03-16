package com.playtech.casino3.slots.shared.utils
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class MovieClipController extends EventDispatcher implements IDisposable
    {
        protected var _end_frame:int;
        protected var _start_frame:int;
        public var debug:Boolean = false;
        public var remove_on_finished:Boolean;
        protected var _movie_clip:MovieClip;
        public var completion_handler:Function;
        protected var _frame_labels:MovieClipFramesData;
        public var completion_arguments:Array;

        public function MovieClipController(completion_arguments:MovieClip, completion_arguments:Boolean = false, completion_arguments = null, completion_arguments = null, completion_arguments:Function = null, ... args) : void
        {
            this._movie_clip = completion_arguments;
            this._frame_labels = new MovieClipFramesData(this._movie_clip, this);
            this.start_frame = completion_arguments;
            this.end_frame = completion_arguments;
            this.remove_on_finished = completion_arguments;
            this.completion_handler = completion_arguments;
            this.completion_arguments = args;
            if (completion_arguments)
            {
                if (completion_arguments)
                {
                    this.playToFrom(this._end_frame, this._start_frame);
                }
                else
                {
                    this.playTo(this._end_frame);
                }
            }
            else if (completion_arguments)
            {
                this._movie_clip.gotoAndStop(this._start_frame);
            }
            this._movie_clip.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
            return;
        }// end function

        public function cancel() : void
        {
            this.removeListeners();
            this.removeMovieClip();
            return;
        }// end function

        public function stop(completion_arguments = null) : void
        {
            if (!completion_arguments)
            {
                this._movie_clip.stop();
            }
            else
            {
                this._movie_clip.gotoAndStop(completion_arguments);
            }
            this.removeListeners();
            return;
        }// end function

        protected function removeMovieClip() : void
        {
            if (!this._movie_clip.parent)
            {
                return;
            }
            this._movie_clip.parent.removeChild(this._movie_clip);
            return;
        }// end function

        public function get end_frame() : int
        {
            return this._end_frame;
        }// end function

        protected function onEnd() : void
        {
            this.removeListeners();
            if (this.completion_handler == null)
            {
                return;
            }
            this.completion_handler.apply(null, this.completion_arguments is Array ? (this.completion_arguments) : ([this.completion_arguments]));
            this.completion_handler = null;
            this.completion_arguments = null;
            return;
        }// end function

        public function playTo(completion_arguments = null, ... args) : void
        {
            this.playToFrom(completion_arguments, this._movie_clip.currentFrame);
            return;
        }// end function

        public function get start_frame() : int
        {
            return this._start_frame;
        }// end function

        public function set end_frame(completion_arguments) : void
        {
            this._end_frame = isNaN(completion_arguments) ? (this._frame_labels.indexOfFrameWithLabel(completion_arguments)) : (completion_arguments);
            return;
        }// end function

        protected function onRemovedFromStage(event:Event = null) : void
        {
            this.onEnd();
            return;
        }// end function

        public function get frame_labels() : MovieClipFramesData
        {
            return this._frame_labels;
        }// end function

        public function playToFrom(completion_arguments = null, completion_arguments = null) : void
        {
            this.start_frame = completion_arguments;
            this.end_frame = completion_arguments;
            this._movie_clip.gotoAndStop(this.start_frame);
            this._movie_clip.addEventListener(Event.ENTER_FRAME, this.play);
            return;
        }// end function

        protected function removeListeners() : void
        {
            if (!this._movie_clip)
            {
                return;
            }
            this._movie_clip.removeEventListener(Event.ENTER_FRAME, this.play);
            this._movie_clip.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
            this._movie_clip.stop();
            return;
        }// end function

        public function dispose() : void
        {
            this.removeListeners();
            if (this._frame_labels)
            {
                this._frame_labels.dispose();
            }
            this._frame_labels = null;
            this.completion_handler = null;
            this.completion_arguments = null;
            return;
        }// end function

        public function set start_frame(completion_arguments) : void
        {
            this._start_frame = isNaN(completion_arguments) ? (this._frame_labels.indexOfFrameWithLabel(completion_arguments)) : (completion_arguments);
            return;
        }// end function

        protected function play(event:Event) : void
        {
            if (this.debug)
            {
                trace(getTimer() + " " + event);
            }
            if (this._movie_clip.currentFrame == this.end_frame)
            {
                this.onEnd();
                if (this.remove_on_finished)
                {
                    this.removeMovieClip();
                }
                return;
            }
            this._movie_clip.debug = this.debug;
            if (this.debug)
            {
                trace("play from " + this._movie_clip.currentFrame + " > " + this._end_frame);
            }
            if (this._movie_clip.currentFrame < this._end_frame)
            {
                this._movie_clip.nextFrame();
            }
            if (this._movie_clip.currentFrame > this._end_frame)
            {
                this._movie_clip.prevFrame();
            }
            if (this.debug)
            {
                trace("after current franme " + this._movie_clip.currentFrame);
            }
            this._frame_labels.onEnterFrameMovie(null);
            return;
        }// end function

        public function get movie_clip() : MovieClip
        {
            return this._movie_clip;
        }// end function

    }
}
