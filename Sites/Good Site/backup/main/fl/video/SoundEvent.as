package fl.video
{
    import flash.events.*;
    import flash.media.*;

    public class SoundEvent extends Event
    {
        private var _soundTransform:SoundTransform;
        public static const SOUND_UPDATE:String = "soundUpdate";

        public function SoundEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:SoundTransform = null)
        {
            super(param1, param2, param3);
            _soundTransform = param4;
            return;
        }// end function

        public function get soundTransform() : SoundTransform
        {
            return _soundTransform;
        }// end function

        override public function clone() : Event
        {
            return new SoundEvent(type, bubbles, cancelable, soundTransform);
        }// end function

    }
}
