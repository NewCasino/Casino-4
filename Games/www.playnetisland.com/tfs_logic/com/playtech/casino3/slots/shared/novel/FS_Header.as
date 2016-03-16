package com.playtech.casino3.slots.shared.novel
{
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;

    public class FS_Header extends Object
    {
        private var m_leftField:TextField;
        private var m_gfx:Sprite;
        private var m_basewinTf:TextField;
        private var m_winField:TextField;
        private var m_multiplier:TextField;
        private var m_current:Number;

        public function FS_Header(param1:Sprite, param2:int, param3:Number, param4:int, param5:TextField)
        {
            var _loc_6:* = getDefinitionByName(GameParameters.shortname + ".FS_header") as Class;
            this.m_gfx = new _loc_6 as Sprite;
            this.m_leftField = this.m_gfx.getChildByName("sl") as TextField;
            this.m_leftField.text = String(param2);
            this.m_winField = this.m_gfx.getChildByName("total") as TextField;
            TextResize.setText(this.m_winField, Money.format(param3));
            this.m_multiplier = this.m_gfx.getChildByName("multiplier") as TextField;
            this.updateFsMulti(param4);
            param1.addChild(this.m_gfx);
            this.m_current = param3;
            this.m_basewinTf = param5;
            this.m_basewinTf.addEventListener(WinTicker.CHANGE, this.updateWinTF);
            this.m_basewinTf.addEventListener(WinTicker.DONE, this.updateDone);
            return;
        }// end function

        public function updateFsMulti(format:int) : void
        {
            this.m_multiplier.text = format + "";
            var _loc_2:* = this.m_gfx as MovieClip;
            if (_loc_2)
            {
                _loc_2.gotoAndStop(format);
            }
            return;
        }// end function

        public function remove() : void
        {
            this.m_basewinTf.removeEventListener(WinTicker.CHANGE, this.updateWinTF);
            this.m_basewinTf.removeEventListener(WinTicker.DONE, this.updateDone);
            this.m_basewinTf = null;
            this.m_gfx.parent.removeChild(this.m_gfx);
            this.m_gfx = null;
            this.m_leftField = null;
            this.m_winField = null;
            this.m_multiplier = null;
            return;
        }// end function

        private function updateWinTF(event:RegularEvent) : void
        {
            TextResize.setText(this.m_winField, Money.format(this.m_current + event.data, Money.ZERO));
            this.m_current = this.m_current + event.data;
            return;
        }// end function

        public function getGfx() : Sprite
        {
            return this.m_gfx;
        }// end function

        public function updateWin(format:Number) : void
        {
            if (this.m_current != format)
            {
                this.m_current = format;
                TextResize.setText(this.m_winField, Money.format(this.m_current));
            }
            return;
        }// end function

        private function updateDone(event:Event) : void
        {
            TextResize.setText(this.m_winField, Money.format(this.m_current));
            return;
        }// end function

        public function getWinField() : TextField
        {
            return this.m_winField;
        }// end function

        public function updateFsNum(format:int) : void
        {
            this.m_leftField.text = String(format);
            return;
        }// end function

    }
}
