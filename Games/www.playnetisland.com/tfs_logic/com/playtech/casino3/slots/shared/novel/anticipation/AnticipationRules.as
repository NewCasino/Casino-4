package com.playtech.casino3.slots.shared.novel.anticipation
{
    import com.playtech.casino3.slots.shared.data.*;

    public class AnticipationRules extends Object
    {
        private var m_s:SlotsSymbol;
        private var m_mask:Array;

        public function AnticipationRules(param1:SlotsSymbol, param2:Array)
        {
            this.m_s = param1;
            this.m_mask = param2;
            return;
        }// end function

        public function get symbol() : SlotsSymbol
        {
            return this.m_s;
        }// end function

        public function get mask() : Array
        {
            return this.m_mask;
        }// end function

        public function dispose() : void
        {
            this.m_s = null;
            this.m_mask = null;
            return;
        }// end function

    }
}
