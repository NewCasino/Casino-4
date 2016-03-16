package gs.plugins
{
    import gs.*;

    public class ShortRotationPlugin extends TweenPlugin
    {
        public static const VERSION:Number = 1;
        public static const API:Number = 1;

        public function ShortRotationPlugin()
        {
            this.propName = "shortRotation";
            this.overwriteProps = [];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            var _loc_4:String = null;
            if (typeof(param2) == "number")
            {
                trace("WARNING: You appear to be using the old shortRotation syntax. Instead of passing a number, please pass an object with properties that correspond to the rotations values For example, TweenMax.to(mc, 2, {shortRotation:{rotationX:-170, rotationY:25}})");
                return false;
            }
            for (_loc_4 in param2)
            {
                
                initRotation(param1, _loc_4, param1[_loc_4], param2[_loc_4]);
            }
            return true;
        }// end function

        public function initRotation(param1:Object, param2:String, param3:Number, param4:Number) : void
        {
            var _loc_5:* = (param4 - param3) % 360;
            if ((param4 - param3) % 360 != (param4 - param3) % 360 % 180)
            {
                _loc_5 = _loc_5 < 0 ? (_loc_5 + 360) : (_loc_5 - 360);
            }
            addTween(param1, param2, param3, param3 + _loc_5, param2);
            this.overwriteProps[this.overwriteProps.length] = param2;
            return;
        }// end function

    }
}
