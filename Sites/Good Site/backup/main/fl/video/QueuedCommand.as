package fl.video
{

    public class QueuedCommand extends Object
    {
        public var type:uint;
        public var time:Number;
        public var url:String;
        public var isLive:Boolean;
        public static const LOAD:uint = 1;
        public static const STOP:uint = 3;
        public static const PLAY_WHEN_ENOUGH:uint = 5;
        public static const PLAY:uint = 0;
        public static const PAUSE:uint = 2;
        public static const SEEK:uint = 4;

        public function QueuedCommand(param1:uint, param2:String, param3:Boolean, param4:Number)
        {
            this.type = param1;
            this.url = param2;
            this.isLive = param3;
            this.time = param4;
            return;
        }// end function

    }
}
