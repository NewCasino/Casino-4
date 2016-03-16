package gs.plugins
{
    import flash.filters.*;
    import gs.*;

    public class ColorMatrixFilterPlugin extends FilterPlugin
    {
        protected var _matrix:Array;
        protected var _matrixTween:EndArrayPlugin;
        public static const VERSION:Number = 1.1;
        public static const API:Number = 1;
        static var _idMatrix:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
        static var _lumR:Number = 0.212671;
        static var _lumG:Number = 0.71516;
        static var _lumB:Number = 0.072169;

        public function ColorMatrixFilterPlugin()
        {
            this.propName = "colorMatrixFilter";
            this.overwriteProps = ["colorMatrixFilter"];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            _target = param1;
            _type = ColorMatrixFilter;
            var _loc_4:* = param2;
            initFilter({remove:param2.remove, index:param2.index, addFilter:param2.addFilter}, new ColorMatrixFilter(_idMatrix.slice()));
            _matrix = ColorMatrixFilter(_filter).matrix;
            var _loc_5:Array = [];
            if (_loc_4.matrix != null && _loc_4.matrix is Array)
            {
                _loc_5 = _loc_4.matrix;
            }
            else
            {
                if (_loc_4.relative == true)
                {
                    _loc_5 = _matrix.slice();
                }
                else
                {
                    _loc_5 = _idMatrix.slice();
                }
                _loc_5 = setBrightness(_loc_5, _loc_4.brightness);
                _loc_5 = setContrast(_loc_5, _loc_4.contrast);
                _loc_5 = setHue(_loc_5, _loc_4.hue);
                _loc_5 = setSaturation(_loc_5, _loc_4.saturation);
                _loc_5 = setThreshold(_loc_5, _loc_4.threshold);
                if (!isNaN(_loc_4.colorize))
                {
                    _loc_5 = colorize(_loc_5, _loc_4.colorize, _loc_4.amount);
                }
            }
            _matrixTween = new EndArrayPlugin();
            _matrixTween.init(_matrix, _loc_5);
            return true;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            _matrixTween.changeFactor = param1;
            ColorMatrixFilter(_filter).matrix = _matrix;
            super.changeFactor = param1;
            return;
        }// end function

        public static function colorize(param1:Array, param2:Number, param3:Number = 1) : Array
        {
            if (isNaN(param2))
            {
                return param1;
            }
            if (isNaN(param3))
            {
                param3 = 1;
            }
            var _loc_4:* = (param2 >> 16 & 255) / 255;
            var _loc_5:* = (param2 >> 8 & 255) / 255;
            var _loc_6:* = (param2 & 255) / 255;
            var _loc_7:* = 1 - param3;
            var _loc_8:Array = [1 - param3 + param3 * _loc_4 * _lumR, param3 * _loc_4 * _lumG, param3 * _loc_4 * _lumB, 0, 0, param3 * _loc_5 * _lumR, _loc_7 + param3 * _loc_5 * _lumG, param3 * _loc_5 * _lumB, 0, 0, param3 * _loc_6 * _lumR, param3 * _loc_6 * _lumG, _loc_7 + param3 * _loc_6 * _lumB, 0, 0, 0, 0, 0, 1, 0];
            return applyMatrix(_loc_8, param1);
        }// end function

        public static function setThreshold(param1:Array, param2:Number) : Array
        {
            if (isNaN(param2))
            {
                return param1;
            }
            var _loc_3:Array = [_lumR * 256, _lumG * 256, _lumB * 256, 0, -256 * param2, _lumR * 256, _lumG * 256, _lumB * 256, 0, -256 * param2, _lumR * 256, _lumG * 256, _lumB * 256, 0, -256 * param2, 0, 0, 0, 1, 0];
            return applyMatrix(_loc_3, param1);
        }// end function

        public static function setHue(param1:Array, param2:Number) : Array
        {
            if (isNaN(param2))
            {
                return param1;
            }
            param2 = param2 * (Math.PI / 180);
            var _loc_3:* = Math.cos(param2);
            var _loc_4:* = Math.sin(param2);
            var _loc_5:Array = [_lumR + _loc_3 * (1 - _lumR) + _loc_4 * (-_lumR), _lumG + _loc_3 * (-_lumG) + _loc_4 * (-_lumG), _lumB + _loc_3 * (-_lumB) + _loc_4 * (1 - _lumB), 0, 0, _lumR + _loc_3 * (-_lumR) + _loc_4 * 0.143, _lumG + _loc_3 * (1 - _lumG) + _loc_4 * 0.14, _lumB + _loc_3 * (-_lumB) + _loc_4 * -0.283, 0, 0, _lumR + _loc_3 * (-_lumR) + _loc_4 * (-(1 - _lumR)), _lumG + _loc_3 * (-_lumG) + _loc_4 * _lumG, _lumB + _loc_3 * (1 - _lumB) + _loc_4 * _lumB, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
            return applyMatrix(_loc_5, param1);
        }// end function

        public static function setBrightness(param1:Array, param2:Number) : Array
        {
            if (isNaN(param2))
            {
                return param1;
            }
            param2 = param2 * 100 - 100;
            return applyMatrix([1, 0, 0, 0, param2, 0, 1, 0, 0, param2, 0, 0, 1, 0, param2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], param1);
        }// end function

        public static function setSaturation(param1:Array, param2:Number) : Array
        {
            if (isNaN(param2))
            {
                return param1;
            }
            var _loc_3:* = 1 - param2;
            var _loc_4:* = _loc_3 * _lumR;
            var _loc_5:* = _loc_3 * _lumG;
            var _loc_6:* = _loc_3 * _lumB;
            var _loc_7:Array = [_loc_4 + param2, _loc_5, _loc_6, 0, 0, _loc_4, _loc_5 + param2, _loc_6, 0, 0, _loc_4, _loc_5, _loc_6 + param2, 0, 0, 0, 0, 0, 1, 0];
            return applyMatrix(_loc_7, param1);
        }// end function

        public static function setContrast(param1:Array, param2:Number) : Array
        {
            if (isNaN(param2))
            {
                return param1;
            }
            param2 = param2 + 0.01;
            var _loc_3:Array = [param2, 0, 0, 0, 128 * (1 - param2), 0, param2, 0, 0, 128 * (1 - param2), 0, 0, param2, 0, 128 * (1 - param2), 0, 0, 0, 1, 0];
            return applyMatrix(_loc_3, param1);
        }// end function

        public static function applyMatrix(param1:Array, param2:Array) : Array
        {
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            if (!(param1 is Array) || !(param2 is Array))
            {
                return param2;
            }
            var _loc_3:Array = [];
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            _loc_6 = 0;
            while (_loc_6 < 4)
            {
                
                _loc_7 = 0;
                while (_loc_7 < 5)
                {
                    
                    if (_loc_7 == 4)
                    {
                        _loc_5 = param1[_loc_4 + 4];
                    }
                    else
                    {
                        _loc_5 = 0;
                    }
                    _loc_3[_loc_4 + _loc_7] = param1[_loc_4] * param2[_loc_7] + param1[(_loc_4 + 1)] * param2[_loc_7 + 5] + param1[_loc_4 + 2] * param2[_loc_7 + 10] + param1[_loc_4 + 3] * param2[_loc_7 + 15] + _loc_5;
                    _loc_7++;
                }
                _loc_4 = _loc_4 + 5;
                _loc_6++;
            }
            return _loc_3;
        }// end function

    }
}
