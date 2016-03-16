package com.playtech.casino3.utils
{
    import com.playtech.core.*;
    import flash.display.*;
    import flash.utils.*;

    public class Lib extends Object
    {

        public function Lib()
        {
            return;
        }// end function

        public static function createSimpleButton(Console:String = "", Console:uint = 120, Console:uint = 22) : SimpleButton
        {
            var _loc_4:* = new SimpleButton();
            if (Console)
            {
                _loc_4.name = Console;
            }
            var _loc_5:* = new Shape();
            _loc_5.graphics.beginFill(0);
            _loc_5.graphics.drawRect(0, 0, Console, Console);
            _loc_5.graphics.endFill();
            _loc_4.hitTestState = _loc_5;
            return _loc_4;
        }// end function

        public static function getLibClass(param1:String) : Class
        {
            var id:* = param1;
            try
            {
                return getDefinitionByName(id) as Class;
            }
            catch (err:Error)
            {
                Console.write("WARNING: Lib.getLibClass() missing graphic class id: " + id);
            }
            return null;
        }// end function

        public static function getBtnFromLib(Console:String) : SimpleButton
        {
            var classReference:Class;
            var id:* = Console;
            try
            {
                classReference = getDefinitionByName(id) as Class;
                return new classReference as SimpleButton;
            }
            catch (err:Error)
            {
                Console.write("WARNING: Lib.getBtnFromLib() missing button id: " + id);
            }
            return null;
        }// end function

        public static function getImgFromLib(com.playtech.core:String) : BitmapData
        {
            var classReference:Class;
            var id:* = com.playtech.core;
            try
            {
                classReference = getDefinitionByName(id) as Class;
                return new classReference(0, 0) as BitmapData;
            }
            catch (err:Error)
            {
                Console.write("WARNING: Lib.getBtnFromLib() missing image id: " + id);
            }
            return null;
        }// end function

        public static function getMCFromLib(Error:String) : MovieClip
        {
            var classReference:Class;
            var id:* = Error;
            try
            {
                classReference = getDefinitionByName(id) as Class;
                return new classReference as MovieClip;
            }
            catch (err:Error)
            {
                Console.write("WARNING: Lib.getMCFromLib() missing clip id: " + id);
            }
            return null;
        }// end function

    }
}
