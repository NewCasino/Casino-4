package com.playtech.casino3.slots.shared.data
{
    import flash.utils.*;

    public class SlotsPayline extends Object
    {
        private var m_id:int;
        public const positions_byte_array:ByteArray;
        private var m_positions:Array;

        public function SlotsPayline(flash.utils:int, flash.utils:Array) : void
        {
            this.positions_byte_array = new ByteArray();
            this.m_id = flash.utils;
            this.m_positions = flash.utils.concat();
            this.positions_to_byte_array();
            return;
        }// end function

        public function get positions() : Array
        {
            return this.m_positions.concat();
        }// end function

        public function toString() : String
        {
            return "SlotsPayline [id:" + this.m_id + "] " + this.m_positions;
        }// end function

        protected function positions_to_byte_array() : void
        {
            var _loc_1:int = 0;
            var _loc_2:* = this.m_positions.length;
            this.positions_byte_array.length = 0;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                this.positions_byte_array[_loc_1] = this.m_positions[_loc_1];
                _loc_1++;
            }
            return;
        }// end function

        public function get id() : int
        {
            return this.m_id;
        }// end function

        public function dispose() : void
        {
            this.m_positions = null;
            return;
        }// end function

    }
}
