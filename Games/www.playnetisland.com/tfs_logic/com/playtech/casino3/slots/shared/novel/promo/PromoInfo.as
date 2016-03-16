package com.playtech.casino3.slots.shared.novel.promo
{

    public class PromoInfo extends Object
    {
        private var m_inAnimType:int;
        private var m_outAnimType:int;
        private var m_running:Boolean;
        private var m_name:String;
        private var m_time:int;

        public function PromoInfo(param1:String, param2:int, param3:int, param4:int)
        {
            this.m_name = param1;
            this.m_time = param2;
            this.m_outAnimType = param3;
            this.m_inAnimType = param4;
            return;
        }// end function

        public function set running(m_name:Boolean) : void
        {
            this.m_running = m_name;
            return;
        }// end function

        public function get running() : Boolean
        {
            return this.m_running;
        }// end function

        public function get name() : String
        {
            return this.m_name;
        }// end function

        public function toString() : String
        {
            var _loc_1:String = "\n";
            var _loc_2:* = _loc_1 + "------------------PromoInfo--------------------" + _loc_1;
            _loc_2 = _loc_2 + ("NAME " + this.m_name + _loc_1);
            _loc_2 = _loc_2 + ("TIME " + this.m_time + _loc_1);
            _loc_2 = _loc_2 + ("------------------PromoInfo-----------------" + _loc_1);
            return _loc_2;
        }// end function

        public function get outAnimationType() : int
        {
            return this.m_outAnimType;
        }// end function

        public function get time() : int
        {
            return this.m_time;
        }// end function

        public function get inAnimationType() : int
        {
            return this.m_inAnimType;
        }// end function

    }
}
