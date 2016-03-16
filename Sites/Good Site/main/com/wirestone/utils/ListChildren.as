package com.wirestone.utils
{
    import flash.display.*;

    public class ListChildren extends Sprite
    {

        public function ListChildren()
        {
            return;
        }// end function

        public static function listAllChildren(param1:Sprite) : void
        {
            var _loc_3:DisplayObject = null;
            trace("");
            trace("=============================");
            trace(param1.name + " children:");
            trace(param1.name + ".numChildren = " + param1.numChildren);
            var _loc_2:uint = 0;
            while (_loc_2 < param1.numChildren)
            {
                
                _loc_3 = param1.getChildAt(_loc_2);
                trace(_loc_3.name + " x = " + _loc_3.x + " y = " + _loc_3.y + " width = " + _loc_3.width + " height = " + _loc_3.height);
                _loc_2 = _loc_2 + 1;
            }
            trace("=============================");
            trace("");
            return;
        }// end function

    }
}
