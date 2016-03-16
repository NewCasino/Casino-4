package com.playtech.casino3.ui
{
    import com.playtech.casino3.utils.button.*;
    import com.playtech.core.*;
    import flash.display.*;

    public class PopupMessage extends Object
    {
        private var m_gfx:Sprite;
        private var m_openTime:Number;
        private var m_closeFunc:Function;
        private var m_autoClose:Boolean;
        private var m_closeButton:ButtonComponent;
        static const DEFAULT_SHOWING_TIME:Number = 10000;

        public function PopupMessage(param1:Boolean = false, param2:Number = 10000)
        {
            this.m_autoClose = param1;
            this.m_openTime = param2;
            return;
        }// end function

        public function doAutoClose() : Boolean
        {
            return this.m_autoClose;
        }// end function

        public function dispose() : void
        {
            if (this.m_closeButton != null)
            {
                IButton(this.m_closeButton.getLogic()).disable(true);
            }
            return;
        }// end function

        public function onPopupVisible() : void
        {
            Console.write("popup visible", this);
            return;
        }// end function

        public function getOpenTime() : Number
        {
            return this.m_openTime;
        }// end function

        private function onClose() : void
        {
            this.close();
            return;
        }// end function

        public function canOpen() : Boolean
        {
            return true;
        }// end function

        public function setCloseCallback(http://adobe.com/AS3/2006/builtin:Function) : void
        {
            this.m_closeFunc = http://adobe.com/AS3/2006/builtin;
            return;
        }// end function

        public function createGFX() : Sprite
        {
            return this.m_gfx;
        }// end function

        public function setGFX(http://adobe.com/AS3/2006/builtin:Sprite) : void
        {
            if (http://adobe.com/AS3/2006/builtin.hasOwnProperty("close_btn"))
            {
                this.m_closeButton = http://adobe.com/AS3/2006/builtin.getChildByName("close_btn") as ButtonComponent;
                IButton(this.m_closeButton.getLogic()).registerHandler(this.onClose);
            }
            this.m_gfx = http://adobe.com/AS3/2006/builtin;
            return;
        }// end function

        public function close() : void
        {
            Console.write("popup closed", this);
            if (this.m_closeFunc != null)
            {
                this.m_closeFunc.call();
            }
            return;
        }// end function

    }
}
