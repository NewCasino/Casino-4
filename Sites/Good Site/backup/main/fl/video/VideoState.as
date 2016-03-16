package fl.video
{

    final public class VideoState extends Object
    {
        public static const CONNECTION_ERROR:String = "connectionError";
        public static const BUFFERING:String = "buffering";
        public static const SEEKING:String = "seeking";
        public static const STOPPED:String = "stopped";
        public static const PAUSED:String = "paused";
        public static const RESIZING:String = "resizing";
        public static const PLAYING:String = "playing";
        public static const DISCONNECTED:String = "disconnected";
        public static const LOADING:String = "loading";
        static var EXEC_QUEUED_CMD:String = "execQueuedCmd";
        public static const REWINDING:String = "rewinding";

        public function VideoState()
        {
            return;
        }// end function

    }
}
