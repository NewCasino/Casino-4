package gs
{
    import gs.utils.tween.*;

    public class OverwriteManager extends Object
    {
        public static const version:Number = 3.12;
        public static const NONE:int = 0;
        public static const ALL:int = 1;
        public static const AUTO:int = 2;
        public static const CONCURRENT:int = 3;
        public static var mode:int;
        public static var enabled:Boolean;

        public function OverwriteManager()
        {
            return;
        }// end function

        public static function init(param1:int = 2) : int
        {
            if (TweenLite.version < 10.09)
            {
                trace("TweenLite warning: Your TweenLite class needs to be updated to work with OverwriteManager (or you may need to clear your ASO files). Please download and install the latest version from http://www.tweenlite.com.");
            }
            TweenLite.overwriteManager = OverwriteManager;
            mode = param1;
            enabled = true;
            return mode;
        }// end function

        public static function manageOverwrites(param1:TweenLite, param2:Array) : void
        {
            var _loc_7:int = 0;
            var _loc_8:TweenLite = null;
            var _loc_10:Array = null;
            var _loc_11:Object = null;
            var _loc_12:int = 0;
            var _loc_13:TweenInfo = null;
            var _loc_14:Array = null;
            var _loc_3:* = param1.vars;
            var _loc_4:* = _loc_3.overwrite == undefined ? (mode) : (int(_loc_3.overwrite));
            if ((_loc_3.overwrite == undefined ? (mode) : (int(_loc_3.overwrite))) < 2 || param2 == null)
            {
                return;
            }
            var _loc_5:* = param1.startTime;
            var _loc_6:Array = [];
            var _loc_9:int = -1;
            _loc_7 = param2.length - 1;
            while (_loc_7 > -1)
            {
                
                _loc_8 = param2[_loc_7];
                if (_loc_8 == param1)
                {
                    _loc_9 = _loc_7;
                }
                else if (_loc_7 < _loc_9 && _loc_8.startTime <= _loc_5 && _loc_8.startTime + _loc_8.duration * 1000 / _loc_8.combinedTimeScale > _loc_5)
                {
                    _loc_6[_loc_6.length] = _loc_8;
                }
                _loc_7 = _loc_7 - 1;
            }
            if (_loc_6.length == 0 || param1.tweens.length == 0)
            {
                return;
            }
            if (_loc_4 == AUTO)
            {
                _loc_10 = param1.tweens;
                _loc_11 = {};
                _loc_7 = _loc_10.length - 1;
                while (_loc_7 > -1)
                {
                    
                    _loc_13 = _loc_10[_loc_7];
                    if (_loc_13.isPlugin)
                    {
                        if (_loc_13.name == "_MULTIPLE_")
                        {
                            _loc_14 = _loc_13.target.overwriteProps;
                            _loc_12 = _loc_14.length - 1;
                            while (_loc_12 > -1)
                            {
                                
                                _loc_11[_loc_14[_loc_12]] = true;
                                _loc_12 = _loc_12 - 1;
                            }
                        }
                        else
                        {
                            _loc_11[_loc_13.name] = true;
                        }
                        _loc_11[_loc_13.target.propName] = true;
                    }
                    else
                    {
                        _loc_11[_loc_13.name] = true;
                    }
                    _loc_7 = _loc_7 - 1;
                }
                _loc_7 = _loc_6.length - 1;
                while (_loc_7 > -1)
                {
                    
                    killVars(_loc_11, _loc_6[_loc_7].exposedVars, _loc_6[_loc_7].tweens);
                    _loc_7 = _loc_7 - 1;
                }
            }
            else
            {
                _loc_7 = _loc_6.length - 1;
                while (_loc_7 > -1)
                {
                    
                    _loc_6[_loc_7].enabled = false;
                    _loc_7 = _loc_7 - 1;
                }
            }
            return;
        }// end function

        public static function killVars(param1:Object, param2:Object, param3:Array) : void
        {
            var _loc_4:int = 0;
            var _loc_5:String = null;
            var _loc_6:TweenInfo = null;
            _loc_4 = param3.length - 1;
            while (_loc_4 > -1)
            {
                
                _loc_6 = param3[_loc_4];
                if (_loc_6.name in param1)
                {
                    param3.splice(_loc_4, 1);
                }
                else if (_loc_6.isPlugin && _loc_6.name == "_MULTIPLE_")
                {
                    _loc_6.target.killProps(param1);
                    if (_loc_6.target.overwriteProps.length == 0)
                    {
                        param3.splice(_loc_4, 1);
                    }
                }
                _loc_4 = _loc_4 - 1;
            }
            for (_loc_5 in param1)
            {
                
                delete param2[_loc_5];
            }
            return;
        }// end function

    }
}
