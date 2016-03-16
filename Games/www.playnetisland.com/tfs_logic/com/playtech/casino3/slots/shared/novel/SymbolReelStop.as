package com.playtech.casino3.slots.shared.novel
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;

    public class SymbolReelStop extends Object
    {
        private var m_s:SlotsSymbol;
        public var is_real_count:Boolean;
        private var m_mask:Vector.<int>;
        private var m_video:String;
        private var m_sound:String;
        private var m_onlyWin:Boolean;

        public function SymbolReelStop(param1:SlotsSymbol, param2:Vector.<int>, param3:String = null, param4:String = null)
        {
            this.m_s = param1;
            this.m_mask = param2;
            this.m_video = param3;
            this.m_sound = param4;
            return;
        }// end function

        public function set onlyWin(m_sound:Boolean) : void
        {
            this.m_onlyWin = m_sound;
            return;
        }// end function

        public function toString() : String
        {
            return "[ SymbolReelStop " + this.m_s + " ] " + this.m_mask + " " + this.m_video + " " + this.m_sound;
        }// end function

        public function get mask() : Vector.<int>
        {
            return this.m_mask;
        }// end function

        public function get sound() : String
        {
            return this.m_sound;
        }// end function

        public function get onlyWin() : Boolean
        {
            return this.m_onlyWin;
        }// end function

        public function get symbol() : SlotsSymbol
        {
            return this.m_s;
        }// end function

        public function get video() : String
        {
            return this.m_video;
        }// end function

        public function dispose() : void
        {
            this.m_s = null;
            this.m_mask = null;
            return;
        }// end function

    }
}
