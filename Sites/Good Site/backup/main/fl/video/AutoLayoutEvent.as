package fl.video
{
    import flash.events.*;
    import flash.geom.*;

    public class AutoLayoutEvent extends LayoutEvent implements IVPEvent
    {
        private var _vp:uint;
        public static const AUTO_LAYOUT:String = "autoLayout";

        public function AutoLayoutEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Rectangle = null, param5:Rectangle = null, param6:uint = 0)
        {
            super(param1, param2, param3, param4, param5);
            _vp = param6;
            return;
        }// end function

        override public function clone() : Event
        {
            return new AutoLayoutEvent(type, bubbles, cancelable, Rectangle(oldBounds.clone()), Rectangle(oldRegistrationBounds.clone()), vp);
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
