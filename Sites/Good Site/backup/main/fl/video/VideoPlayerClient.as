package fl.video
{

    dynamic public class VideoPlayerClient extends Object
    {
        protected var _owner:VideoPlayer;
        protected var gotMetadata:Boolean;

        public function VideoPlayerClient(param1:VideoPlayer)
        {
            _owner = param1;
            gotMetadata = false;
            return;
        }// end function

        public function get ready() : Boolean
        {
            return gotMetadata;
        }// end function

        public function onMetaData(param1:Object, ... args) : void
        {
            _owner.onMetaData(param1);
            gotMetadata = true;
            return;
        }// end function

        public function get owner() : VideoPlayer
        {
            return _owner;
        }// end function

        public function onCuePoint(param1:Object, ... args) : void
        {
            _owner.onCuePoint(param1);
            return;
        }// end function

    }
}
