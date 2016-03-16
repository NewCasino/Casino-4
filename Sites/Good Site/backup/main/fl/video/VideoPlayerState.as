package fl.video
{

    public class VideoPlayerState extends Object
    {
        public var autoPlay:Boolean;
        public var isWaiting:Boolean;
        public var isLiveSet:Boolean;
        public var index:int;
        public var prevState:String;
        public var preSeekTime:Number;
        public var minProgressPercent:Number;
        public var url:String;
        public var totalTime:Number;
        public var owner:VideoPlayer;
        public var isLive:Boolean;
        public var cmdQueue:Array;
        public var totalTimeSet:Boolean;

        public function VideoPlayerState(param1:VideoPlayer, param2:int)
        {
            this.owner = param1;
            this.index = param2;
            this.url = "";
            this.isLive = false;
            this.isLiveSet = true;
            this.totalTime = NaN;
            this.totalTimeSet = true;
            this.autoPlay = param2 == 0;
            this.isWaiting = false;
            this.preSeekTime = NaN;
            this.cmdQueue = null;
            return;
        }// end function

    }
}
