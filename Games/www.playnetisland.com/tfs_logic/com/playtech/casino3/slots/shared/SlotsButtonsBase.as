package com.playtech.casino3.slots.shared
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.button.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.text.*;

    public class SlotsButtonsBase extends Object
    {
        protected var m_gfx:DisplayObjectContainer;
        protected var m_buttons:Object;
        protected var m_coins:Array;
        protected var m_mi:IModuleInterface;
        protected var m_func:Function;
        private var m_coinValueTf:TextField;
        protected var m_tabId:int;

        public function SlotsButtonsBase(param1:DisplayObjectContainer, param2:Function, param3:IModuleInterface, param4:Array = null)
        {
            this.m_buttons = [];
            this.m_gfx = param1;
            this.m_func = param2;
            this.m_mi = param3;
            this.m_tabId = this.m_mi.createKeyboardSet();
            var _loc_5:* = this.initButtons(param4);
            var _loc_6:* = _loc_5.length;
            var _loc_7:int = 0;
            while (_loc_7 < _loc_6)
            {
                
                this.m_mi.addTabElement(this.m_tabId, _loc_5[_loc_7]);
                _loc_7++;
            }
            this.m_coinValueTf = this.m_gfx.getChildByName("coinValue") as TextField;
            this.m_coinValueTf.mouseEnabled = false;
            return;
        }// end function

        public function enable(coinValue:String, coinValue:Boolean) : void
        {
            var _loc_3:* = this.m_buttons[coinValue];
            if (_loc_3 == null)
            {
                Console.write("Sorry, " + coinValue + " button is not available");
            }
            else
            {
                (_loc_3.getLogic() as IButton).disable(!coinValue);
            }
            return;
        }// end function

        public function setCoinValue(coinValue:int) : void
        {
            TextResize.setText(this.m_coinValueTf, Money.format(coinValue));
            return;
        }// end function

        public function enableAll(coinValue:Boolean, coinValue:int, ... args) : void
        {
            var _loc_5:ButtonComponent = null;
            var _loc_6:IButton = null;
            args = !coinValue;
            for each (_loc_5 in this.m_buttons)
            {
                
                _loc_6 = _loc_5.getLogic() as IButton;
                if (args.indexOf(_loc_5) != -1)
                {
                    continue;
                }
                if (args.indexOf(_loc_5.name) != -1)
                {
                    continue;
                }
                _loc_6.disable(args);
            }
            return;
        }// end function

        protected function initButtons(items:Array = null) : Array
        {
            throw new Error("Buttons initialization is not completed, override initButtons method");
        }// end function

        public function isEnabled(getChildByName:String) : Boolean
        {
            var _loc_2:* = this.m_buttons[getChildByName];
            if (_loc_2 == null)
            {
                Console.write("Sorry, " + getChildByName + " button is not available");
                return false;
            }
            return !(_loc_2.getLogic() as IButton).isDisabled();
        }// end function

        public function setCoins(coinValue:Array) : void
        {
            this.m_coins = coinValue;
            return;
        }// end function

        public function dispose() : void
        {
            this.m_mi.removeKeyboardSet(this.m_tabId);
            this.m_mi = null;
            this.m_coins = null;
            this.m_func = null;
            this.m_gfx = null;
            this.m_buttons = null;
            this.m_coinValueTf = null;
            return;
        }// end function

    }
}
