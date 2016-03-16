package com.playtech.casino3.slots.shared.base_game
{

    public class BaseRestoreInfo extends Object implements IDisposable
    {
        public static const T:String = "\t";
        public static const N:String = "\n";

        public function BaseRestoreInfo()
        {
            return;
        }// end function

        protected function handleNamedChunkData(param1:Array) : Object
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:int = 0;
            var _loc_2:Object = {};
            do
            {
                
                _loc_6 = _loc_3.indexOf("=");
                if (_loc_6 == -1)
                {
                }
                else
                {
                    _loc_5 = _loc_3.substring(0, _loc_6);
                    _loc_4 = _loc_3.substring((_loc_6 + 1));
                    _loc_2[_loc_5] = _loc_4;
                }
                var _loc_7:* = param1.shift();
                _loc_3 = param1.shift();
            }while (_loc_7)
            return _loc_2;
        }// end function

        public function dispose() : void
        {
            return;
        }// end function

    }
}
