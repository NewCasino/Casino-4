package fl.video
{
    import flash.events.*;

    public class VideoEvent extends Event implements IVPEvent
    {
        private var _vp:uint;
        private var _playheadTime:Number;
        private var _state:String;
        public static const FAST_FORWARD:String = "fastForward";
        public static const READY:String = "ready";
        public static const SKIN_LOADED:String = "skinLoaded";
        public static const SCRUB_FINISH:String = "scrubFinish";
        public static const BUFFERING_STATE_ENTERED:String = "bufferingStateEntered";
        public static const STOPPED_STATE_ENTERED:String = "stoppedStateEntered";
        public static const AUTO_REWOUND:String = "autoRewound";
        public static const SCRUB_START:String = "scrubStart";
        public static const PLAYHEAD_UPDATE:String = "playheadUpdate";
        public static const SEEKED:String = "seeked";
        public static const PLAYING_STATE_ENTERED:String = "playingStateEntered";
        public static const CLOSE:String = "close";
        public static const PAUSED_STATE_ENTERED:String = "pausedStateEntered";
        public static const COMPLETE:String = "complete";
        public static const REWIND:String = "rewind";
        public static const STATE_CHANGE:String = "stateChange";

        public function VideoEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = null, param5:Number = NaN, param6:uint = 0)
        {
            super(param1, param2, param3);
            _state = param4;
            _playheadTime = param5;
            _vp = param6;
            return;
        }// end function

        public function set playheadTime(param1:Number) : void
        {
            _playheadTime = param1;
            return;
        }// end function

        public function get playheadTime() : Number
        {
            return _playheadTime;
        }// end function

        public function get state() : String
        {
            return _state;
        }// end function

        public function get vp() : uint
        {
            return _vp;
        }// end function

        override public function clone() : Event
        {
            return new VideoEvent(type, bubbles, cancelable, state, playheadTime, vp);
        }// end function

        public function set state(param1:String) : void
        {
            _state = param1;
            return;
        }// end function

        public function set vp(param1:uint) : void
        {
            _vp = param1;
            return;
        }// end function

    }
}
