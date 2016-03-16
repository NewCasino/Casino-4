package gs.plugins
{
    import gs.*;

    public class HexColorsPlugin extends TweenPlugin
    {
        protected var _colors:Array;
        public static const VERSION:Number = 1.01;
        public static const API:Number = 1;

        public function HexColorsPlugin()
        {
            this.propName = "hexColors";
            this.overwriteProps = [];
            _colors = [];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            var _loc_4:String = null;
            for (_loc_4 in param2)
            {
                
                initColor(param1, _loc_4, uint(param1[_loc_4]), uint(param2[_loc_4]));
            }
            return true;
        }// end function

        public function initColor(param1:Object, param2:String, param3:uint, param4:uint) : void
        {
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            if (param3 != param4)
            {
                _loc_5 = param3 >> 16;
                _loc_6 = param3 >> 8 & 255;
                _loc_7 = param3 & 255;
                _colors[_colors.length] = [param1, param2, _loc_5, (param4 >> 16) - _loc_5, _loc_6, (param4 >> 8 & 255) - _loc_6, _loc_7, (param4 & 255) - _loc_7];
                this.overwriteProps[this.overwriteProps.length] = param2;
            }
            return;
        }// end function

        override public function killProps(param1:Object) : void
        {
            var _loc_2:* = _colors.length - 1;
            while (_loc_2 > -1)
            {
                
                if (param1[_colors[_loc_2][1]] != undefined)
                {
                    _colors.splice(_loc_2, 1);
                }
                _loc_2 = _loc_2 - 1;
            }
            super.killProps(param1);
            return;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Array = null;
            _loc_2 = _colors.length - 1;
            while (_loc_2 > -1)
            {
                
                _loc_3 = _colors[_loc_2];
                _loc_3[0][_loc_3[1]] = _loc_3[2] + param1 * _loc_3[3] << 16 | _loc_3[4] + param1 * _loc_3[5] << 8 | _loc_3[6] + param1 * _loc_3[7];
                _loc_2 = _loc_2 - 1;
            }
            return;
        }// end function

    }
}
