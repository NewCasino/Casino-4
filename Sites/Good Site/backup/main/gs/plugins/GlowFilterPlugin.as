package gs.plugins
{
    import flash.filters.*;
    import gs.*;

    public class GlowFilterPlugin extends FilterPlugin
    {
        public static const VERSION:Number = 1;
        public static const API:Number = 1;

        public function GlowFilterPlugin()
        {
            this.propName = "glowFilter";
            this.overwriteProps = ["glowFilter"];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            _target = param1;
            _type = GlowFilter;
            initFilter(param2, new GlowFilter(16777215, 0, 0, 0, param2.strength || 1, param2.quality || 2, param2.inner, param2.knockout));
            return true;
        }// end function

    }
}
