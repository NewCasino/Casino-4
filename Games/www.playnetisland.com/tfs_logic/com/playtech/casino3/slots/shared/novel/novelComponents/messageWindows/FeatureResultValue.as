package com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows
{

    public class FeatureResultValue extends Object
    {
        private var m_money:Boolean;
        private var m_total:Number;
        private var m_ticking:Boolean;
        private var m_tf:String;

        public function FeatureResultValue(param1:String, param2:Number, param3:Boolean = true, param4:Boolean = true)
        {
            this.m_tf = param1;
            this.m_total = param2;
            this.m_money = param3;
            this.m_ticking = param4;
            return;
        }// end function

        public function get total() : Number
        {
            return this.m_total;
        }// end function

        public function get textfield() : String
        {
            return this.m_tf;
        }// end function

        public function get moneyFormat() : Boolean
        {
            return this.m_money;
        }// end function

        public function get isTicking() : Boolean
        {
            return this.m_ticking;
        }// end function

    }
}
