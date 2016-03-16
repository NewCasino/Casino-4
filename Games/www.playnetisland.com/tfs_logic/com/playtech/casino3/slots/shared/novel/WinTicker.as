package com.playtech.casino3.slots.shared.novel
{
    import com.playtech.casino3.utils.*;
    import flash.events.*;
    import flash.text.*;

    public class WinTicker extends Object
    {
        private var m_viewValue:Number;
        protected var m_TF:TextField;
        private var m_end:Number;
        private var m_format:Boolean;
        private var m_unit:Number;
        private var m_step:Number;
        private var m_pace:Number;
        protected var m_current:Number;
        private var m_noCents:Boolean;
        public static const CHANGE:String = "WinTicker_change";
        public static const DONE:String = "WinTicker_done";

        public function WinTicker(param1:TextField, param2:Boolean = true)
        {
            this.m_TF = param1;
            this.m_format = param2;
            return;
        }// end function

        public function clear() : void
        {
            this.cancel();
            this.m_TF = null;
            return;
        }// end function

        public function startAnim() : void
        {
            this.m_TF.addEventListener(Event.ENTER_FRAME, this.tick);
            return;
        }// end function

        public function getTextField() : TextField
        {
            return this.m_TF;
        }// end function

        private function tick(event:Event) : void
        {
            this.m_current = this.m_current + this.m_step;
            var _loc_2:* = this.m_current - this.m_current % this.m_unit;
            if (_loc_2 >= this.m_end)
            {
                this.cancel();
                this.animDone();
            }
            else if (this.m_viewValue != _loc_2)
            {
                TextResize.setText(this.m_TF, this.m_format ? (Money.format(_loc_2, Money.ZERO)) : (_loc_2.toString()));
                this.m_TF.dispatchEvent(new RegularEvent(CHANGE, _loc_2 - this.m_viewValue));
                this.m_viewValue = _loc_2;
            }
            return;
        }// end function

        protected function animDone() : void
        {
            return;
        }// end function

        public function setVariables(start:Number, start:Number, start:Number, start:Number, start:Boolean = true, start:Boolean = true) : void
        {
            this.m_end = start;
            var _loc_7:* = start;
            this.m_viewValue = start;
            this.m_current = _loc_7;
            this.m_pace = start ? (Math.max(start, 8 * start)) : (start);
            this.m_unit = start;
            this.m_step = this.m_pace / 25;
            this.m_noCents = start;
            return;
        }// end function

        public function cancel() : void
        {
            if (!this.m_TF)
            {
                return;
            }
            if (!this.m_TF.hasEventListener(Event.ENTER_FRAME))
            {
                return;
            }
            this.m_TF.removeEventListener(Event.ENTER_FRAME, this.tick);
            if (this.m_noCents == true)
            {
                TextResize.setText(this.m_TF, this.m_format ? (Money.format(this.m_end)) : (this.m_end.toString()));
            }
            else
            {
                TextResize.setText(this.m_TF, this.m_format ? (Money.format(this.m_end, Money.ZERO)) : (this.m_end.toString()));
            }
            this.m_TF.dispatchEvent(new RegularEvent(CHANGE, this.m_end - this.m_viewValue));
            this.m_current = this.m_end;
            this.m_TF.dispatchEvent(new Event(DONE));
            return;
        }// end function

    }
}
