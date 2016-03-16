package gs.plugins
{
    import flash.filters.*;
    import gs.utils.tween.*;

    public class FilterPlugin extends TweenPlugin
    {
        protected var _target:Object;
        protected var _type:Class;
        protected var _filter:BitmapFilter;
        protected var _index:int;
        protected var _remove:Boolean;
        public static const VERSION:Number = 1.03;
        public static const API:Number = 1;

        public function FilterPlugin()
        {
            return;
        }// end function

        protected function initFilter(param1:Object, param2:BitmapFilter) : void
        {
            var _loc_4:String = null;
            var _loc_5:int = 0;
            var _loc_6:HexColorsPlugin = null;
            var _loc_3:* = _target.filters;
            _index = -1;
            if (param1.index != null)
            {
                _index = param1.index;
            }
            else
            {
                _loc_5 = _loc_3.length - 1;
                while (_loc_5 > -1)
                {
                    
                    if (_loc_3[_loc_5] is _type)
                    {
                        _index = _loc_5;
                        break;
                    }
                    _loc_5 = _loc_5 - 1;
                }
            }
            if (_index == -1 || _loc_3[_index] == null || param1.addFilter == true)
            {
                _index = param1.index != null ? (param1.index) : (_loc_3.length);
                _loc_3[_index] = param2;
                _target.filters = _loc_3;
            }
            _filter = _loc_3[_index];
            _remove = Boolean(param1.remove == true);
            if (_remove)
            {
                this.onComplete = onCompleteTween;
            }
            var _loc_7:* = param1.isTV == true ? (param1.exposedVars) : (param1);
            for (_loc_4 in _loc_7)
            {
                
                if (!(_loc_4 in _filter) || _filter[_loc_4] == _loc_7[_loc_4] || _loc_4 == "remove" || _loc_4 == "index" || _loc_4 == "addFilter")
                {
                    continue;
                }
                if (_loc_4 == "color" || _loc_4 == "highlightColor" || _loc_4 == "shadowColor")
                {
                    _loc_6 = new HexColorsPlugin();
                    _loc_6.initColor(_filter, _loc_4, _filter[_loc_4], _loc_7[_loc_4]);
                    _tweens[_tweens.length] = new TweenInfo(_loc_6, "changeFactor", 0, 1, _loc_4, false);
                    continue;
                }
                if (_loc_4 == "quality" || _loc_4 == "inner" || _loc_4 == "knockout" || _loc_4 == "hideObject")
                {
                    _filter[_loc_4] = _loc_7[_loc_4];
                    continue;
                }
                addTween(_filter, _loc_4, _filter[_loc_4], _loc_7[_loc_4], _loc_4);
            }
            return;
        }// end function

        public function onCompleteTween() : void
        {
            var _loc_1:int = 0;
            var _loc_2:Array = null;
            if (_remove)
            {
                _loc_2 = _target.filters;
                if (!(_loc_2[_index] is _type))
                {
                    _loc_1 = _loc_2.length - 1;
                    while (_loc_1 > -1)
                    {
                        
                        if (_loc_2[_loc_1] is _type)
                        {
                            _loc_2.splice(_loc_1, 1);
                            break;
                        }
                        _loc_1 = _loc_1 - 1;
                    }
                }
                else
                {
                    _loc_2.splice(_index, 1);
                }
                _target.filters = _loc_2;
            }
            return;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            var _loc_2:int = 0;
            var _loc_3:TweenInfo = null;
            var _loc_4:* = _target.filters;
            _loc_2 = _tweens.length - 1;
            while (_loc_2 > -1)
            {
                
                _loc_3 = _tweens[_loc_2];
                _loc_3.target[_loc_3.property] = _loc_3.start + _loc_3.change * param1;
                _loc_2 = _loc_2 - 1;
            }
            if (!(_loc_4[_index] is _type))
            {
                _index = _loc_4.length - 1;
                _loc_2 = _loc_4.length - 1;
                while (_loc_2 > -1)
                {
                    
                    if (_loc_4[_loc_2] is _type)
                    {
                        _index = _loc_2;
                        break;
                    }
                    _loc_2 = _loc_2 - 1;
                }
            }
            _loc_4[_index] = _filter;
            _target.filters = _loc_4;
            return;
        }// end function

    }
}
