package gs.plugins
{
    import flash.display.*;
    import flash.geom.*;
    import gs.*;
    import gs.utils.tween.*;

    public class TintPlugin extends TweenPlugin
    {
        protected var _target:DisplayObject;
        protected var _ct:ColorTransform;
        protected var _ignoreAlpha:Boolean;
        public static const VERSION:Number = 1.1;
        public static const API:Number = 1;
        static var _props:Array = ["redMultiplier", "greenMultiplier", "blueMultiplier", "alphaMultiplier", "redOffset", "greenOffset", "blueOffset", "alphaOffset"];

        public function TintPlugin()
        {
            this.propName = "tint";
            this.overwriteProps = ["tint"];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            if (!(param1 is DisplayObject))
            {
                return false;
            }
            var _loc_4:* = new ColorTransform();
            if (param2 != null && param3.exposedVars.removeTint != true)
            {
                _loc_4.color = uint(param2);
            }
            _ignoreAlpha = true;
            init(param1 as DisplayObject, _loc_4);
            return true;
        }// end function

        public function init(param1:DisplayObject, param2:ColorTransform) : void
        {
            var _loc_3:int = 0;
            var _loc_4:String = null;
            _target = param1;
            _ct = _target.transform.colorTransform;
            _loc_3 = _props.length - 1;
            while (_loc_3 > -1)
            {
                
                _loc_4 = _props[_loc_3];
                if (_ct[_loc_4] != param2[_loc_4])
                {
                    _tweens[_tweens.length] = new TweenInfo(_ct, _loc_4, _ct[_loc_4], param2[_loc_4] - _ct[_loc_4], "tint", false);
                }
                _loc_3 = _loc_3 - 1;
            }
            return;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            var _loc_2:ColorTransform = null;
            updateTweens(param1);
            if (_ignoreAlpha)
            {
                _loc_2 = _target.transform.colorTransform;
                _ct.alphaMultiplier = _loc_2.alphaMultiplier;
                _ct.alphaOffset = _loc_2.alphaOffset;
            }
            _target.transform.colorTransform = _ct;
            return;
        }// end function

    }
}
