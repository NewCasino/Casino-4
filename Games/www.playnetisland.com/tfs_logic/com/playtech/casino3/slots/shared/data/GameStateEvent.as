package com.playtech.casino3.slots.shared.data
{
    import flash.events.*;

    public class GameStateEvent extends Event
    {
        private var m_old:int;
        private var m_new:int;

        public function GameStateEvent(param1:String, param2:int, param3:int)
        {
            super(param1);
            this.m_old = param2;
            this.m_new = param3;
            return;
        }// end function

        public function get newState() : int
        {
            return this.m_new;
        }// end function

        public function get oldState() : int
        {
            return this.m_old;
        }// end function

        override public function toString() : String
        {
            return formatToString("GameStateChange", "type", "bubbles", "cancelable", "eventPhase");
        }// end function

        override public function clone() : Event
        {
            return new GameStateEvent(type, this.oldState, this.newState);
        }// end function

    }
}
