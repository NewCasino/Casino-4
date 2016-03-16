package com.playtech.casino3.slots.shared.utils
{
    import flash.events.*;

    public class LabelEvent extends Event
    {
        protected var _frame_index:int;
        protected var _action_type:LabelActionType;
        protected var _label_index:int;
        protected var _data:String;

        public function LabelEvent(frame_index_:String, frame_index_:int, frame_index_:int = 0, frame_index_:LabelActionType = null, frame_index_:String = null, frame_index_:Boolean = false, frame_index_:Boolean = false) : void
        {
            super(frame_index_, frame_index_, frame_index_);
            this._frame_index = frame_index_;
            this._label_index = frame_index_;
            this._action_type = frame_index_;
            this._data = frame_index_;
            return;
        }// end function

        public function get frame_index() : int
        {
            return this._frame_index;
        }// end function

        public function get label_index() : int
        {
            return this._label_index;
        }// end function

        public function get data() : String
        {
            return this._data;
        }// end function

        public function get action() : LabelActionType
        {
            return this._action_type;
        }// end function

        override public function clone() : Event
        {
            return new LabelEvent(type, this._frame_index, this._label_index, this._action_type, this._data);
        }// end function

    }
}
