package fl.video
{
    import flash.events.*;

    public class VideoProgressEvent extends ProgressEvent implements IVPEvent
    {
        private var _vp:uint;
        public static const PROGRESS:String = "progress";

        public function VideoProgressEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:uint = 0, param5:uint = 0, param6:uint = 0)
        {
            super(param1, param2, param3, param4, param5);
            _vp = param6;
            return;
        }// end function

        override public function clone() : Event
        {
            return new VideoProgressEvent(type, bubbles, cancelable, bytesLoaded, bytesTotal, vp);
        }// end function

        public function set vp(param1:uint) : void
        {
            _vp = param1;
            return;
        }// end function

        public function get vp() : uint
        {
            return _vp;
        }// end function

    }
}
