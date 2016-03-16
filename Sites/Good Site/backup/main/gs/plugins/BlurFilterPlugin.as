package gs.plugins
{
    import flash.filters.*;
    import gs.*;

    public class BlurFilterPlugin extends FilterPlugin
    {
        public static const VERSION:Number = 1;
        public static const API:Number = 1;

        public function BlurFilterPlugin()
        {
            this.propName = "blurFilter";
            this.overwriteProps = ["blurFilter"];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            _target = param1;
            _type = BlurFilter;
            initFilter(param2, new BlurFilter(0, 0, param2.quality || 2));
            return true;
        }// end function

    }
}
