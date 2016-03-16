package fl.video
{
    import flash.events.*;

    public class MetadataEvent extends Event implements IVPEvent
    {
        private var _info:Object;
        private var _vp:uint;
        public static const METADATA_RECEIVED:String = "metadataReceived";
        public static const CUE_POINT:String = "cuePoint";

        public function MetadataEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null, param5:uint = 0)
        {
            super(param1, param2, param3);
            _info = param4;
            _vp = param5;
            return;
        }// end function

        public function get vp() : uint
        {
            return _vp;
        }// end function

        public function set info(param1:Object) : void
        {
            _info = param1;
            return;
        }// end function

        override public function clone() : Event
        {
            return new MetadataEvent(type, bubbles, cancelable, info, vp);
        }// end function

        public function get info() : Object
        {
            return _info;
        }// end function

        public function set vp(param1:uint) : void
        {
            _vp = param1;
            return;
        }// end function

    }
}
