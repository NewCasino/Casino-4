package gs.plugins
{
    import gs.*;

    public class BezierPlugin extends TweenPlugin
    {
        protected var _target:Object;
        protected var _orientData:Array;
        protected var _orient:Boolean;
        protected var _future:Object;
        protected var _beziers:Object;
        public static const VERSION:Number = 1.01;
        public static const API:Number = 1;
        static const _RAD2DEG:Number = 57.2958;

        public function BezierPlugin()
        {
            _future = {};
            this.propName = "bezier";
            this.overwriteProps = [];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            if (!(param2 is Array))
            {
                return false;
            }
            init(param3, param2 as Array, false);
            return true;
        }// end function

        protected function init(param1:TweenLite, param2:Array, param3:Boolean) : void
        {
            var _loc_5:int = 0;
            var _loc_6:String = null;
            _target = param1.target;
            if (param1.exposedVars.orientToBezier == true)
            {
                _orientData = [["x", "y", "rotation", 0]];
                _orient = true;
            }
            else if (param1.exposedVars.orientToBezier is Array)
            {
                _orientData = param1.exposedVars.orientToBezier;
                _orient = true;
            }
            var _loc_4:Object = {};
            _loc_5 = 0;
            while (_loc_5 < param2.length)
            {
                
                for (_loc_6 in param2[_loc_5])
                {
                    
                    if (_loc_4[_loc_6] == undefined)
                    {
                        _loc_4[_loc_6] = [param1.target[_loc_6]];
                    }
                    if (typeof(param2[_loc_5][_loc_6]) == "number")
                    {
                        _loc_4[_loc_6].push(param2[_loc_5][_loc_6]);
                        continue;
                    }
                    _loc_4[_loc_6].push(param1.target[_loc_6] + Number(param2[_loc_5][_loc_6]));
                }
                _loc_5++;
            }
            for (_loc_6 in _loc_4)
            {
                
                this.overwriteProps[this.overwriteProps.length] = _loc_6;
                if (param1.exposedVars[_loc_6] != undefined)
                {
                    if (typeof(param1.exposedVars[_loc_6]) == "number")
                    {
                        _loc_4[_loc_6].push(param1.exposedVars[_loc_6]);
                    }
                    else
                    {
                        _loc_4[_loc_6].push(param1.target[_loc_6] + Number(param1.exposedVars[_loc_6]));
                    }
                    delete param1.exposedVars[_loc_6];
                    _loc_5 = param1.tweens.length - 1;
                    while (_loc_5 > -1)
                    {
                        
                        if (param1.tweens[_loc_5].name == _loc_6)
                        {
                            param1.tweens.splice(_loc_5, 1);
                        }
                        _loc_5 = _loc_5 - 1;
                    }
                }
            }
            _beziers = parseBeziers(_loc_4, param3);
            return;
        }// end function

        override public function killProps(param1:Object) : void
        {
            var _loc_2:String = null;
            for (_loc_2 in _beziers)
            {
                
                if (_loc_2 in param1)
                {
                    delete _beziers[_loc_2];
                }
            }
            super.killProps(param1);
            return;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            var _loc_2:int = 0;
            var _loc_3:String = null;
            var _loc_4:Object = null;
            var _loc_5:Number = NaN;
            var _loc_6:uint = 0;
            var _loc_7:Number = NaN;
            var _loc_8:int = 0;
            var _loc_9:Object = null;
            var _loc_10:Boolean = false;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Array = null;
            var _loc_14:Number = NaN;
            if (param1 == 1)
            {
                for (_loc_3 in _beziers)
                {
                    
                    _loc_2 = _beziers[_loc_3].length - 1;
                    _target[_loc_3] = _beziers[_loc_3][_loc_2][2];
                }
            }
            else
            {
                for (_loc_3 in _beziers)
                {
                    
                    _loc_6 = _beziers[_loc_3].length;
                    if (param1 < 0)
                    {
                        _loc_2 = 0;
                    }
                    else if (param1 >= 1)
                    {
                        _loc_2 = _loc_6 - 1;
                    }
                    else
                    {
                        _loc_2 = int(_loc_6 * param1);
                    }
                    _loc_5 = (param1 - _loc_2 * (1 / _loc_6)) * _loc_6;
                    _loc_4 = _beziers[_loc_3][_loc_2];
                    if (this.round)
                    {
                        _loc_7 = _loc_4[0] + _loc_5 * (2 * (1 - _loc_5) * (_loc_4[1] - _loc_4[0]) + _loc_5 * (_loc_4[2] - _loc_4[0]));
                        _loc_8 = _loc_7 < 0 ? (-1) : (1);
                        _target[_loc_3] = _loc_7 % 1 * _loc_8 > 0.5 ? (int(_loc_7) + _loc_8) : (int(_loc_7));
                        continue;
                    }
                    _target[_loc_3] = _loc_4[0] + _loc_5 * (2 * (1 - _loc_5) * (_loc_4[1] - _loc_4[0]) + _loc_5 * (_loc_4[2] - _loc_4[0]));
                }
            }
            if (_orient)
            {
                _loc_9 = _target;
                _loc_10 = this.round;
                _target = _future;
                this.round = false;
                _orient = false;
                this.changeFactor = param1 + 0.01;
                _target = _loc_9;
                this.round = _loc_10;
                _orient = true;
                _loc_2 = 0;
                while (_loc_2 < _orientData.length)
                {
                    
                    _loc_13 = _orientData[_loc_2];
                    _loc_14 = _loc_13[3] || 0;
                    _loc_11 = _future[_loc_13[0]] - _target[_loc_13[0]];
                    _loc_12 = _future[_loc_13[1]] - _target[_loc_13[1]];
                    _target[_loc_13[2]] = Math.atan2(_loc_12, _loc_11) * _RAD2DEG + _loc_14;
                    _loc_2++;
                }
            }
            return;
        }// end function

        public static function parseBeziers(param1:Object, param2:Boolean = false) : Object
        {
            var _loc_3:int = 0;
            var _loc_4:Array = null;
            var _loc_5:Object = null;
            var _loc_6:String = null;
            var _loc_7:Object = {};
            if (param2)
            {
                for (_loc_6 in param1)
                {
                    
                    _loc_4 = param1[_loc_6];
                    var _loc_10:* = [];
                    _loc_5 = [];
                    _loc_7[_loc_6] = _loc_10;
                    if (_loc_4.length > 2)
                    {
                        _loc_5[_loc_5.length] = [_loc_4[0], _loc_4[1] - (_loc_4[2] - _loc_4[0]) / 4, _loc_4[1]];
                        _loc_3 = 1;
                        while (_loc_3 < (_loc_4.length - 1))
                        {
                            
                            _loc_5[_loc_5.length] = [_loc_4[_loc_3], _loc_4[_loc_3] + (_loc_4[_loc_3] - _loc_5[(_loc_3 - 1)][1]), _loc_4[(_loc_3 + 1)]];
                            _loc_3++;
                        }
                        continue;
                    }
                    _loc_5[_loc_5.length] = [_loc_4[0], (_loc_4[0] + _loc_4[1]) / 2, _loc_4[1]];
                }
            }
            else
            {
                for (_loc_6 in param1)
                {
                    
                    _loc_4 = param1[_loc_6];
                    var _loc_10:* = [];
                    _loc_5 = [];
                    _loc_7[_loc_6] = _loc_10;
                    if (_loc_4.length > 3)
                    {
                        _loc_5[_loc_5.length] = [_loc_4[0], _loc_4[1], (_loc_4[1] + _loc_4[2]) / 2];
                        _loc_3 = 2;
                        while (_loc_3 < _loc_4.length - 2)
                        {
                            
                            _loc_5[_loc_5.length] = [_loc_5[_loc_3 - 2][2], _loc_4[_loc_3], (_loc_4[_loc_3] + _loc_4[(_loc_3 + 1)]) / 2];
                            _loc_3++;
                        }
                        _loc_5[_loc_5.length] = [_loc_5[(_loc_5.length - 1)][2], _loc_4[_loc_4.length - 2], _loc_4[(_loc_4.length - 1)]];
                        continue;
                    }
                    if (_loc_4.length == 3)
                    {
                        _loc_5[_loc_5.length] = [_loc_4[0], _loc_4[1], _loc_4[2]];
                        continue;
                    }
                    if (_loc_4.length == 2)
                    {
                        _loc_5[_loc_5.length] = [_loc_4[0], (_loc_4[0] + _loc_4[1]) / 2, _loc_4[1]];
                    }
                }
            }
            return _loc_7;
        }// end function

    }
}
