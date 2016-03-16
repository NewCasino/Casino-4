package com.playtech.casino3.utils.queue
{

    public class CommandBase extends Object
    {
        private var m_id:int;

        public function CommandBase()
        {
            return;
        }// end function

        public function hasFrameChange() : Boolean
        {
            return true;
        }// end function

        public function setId(com.playtech.casino3.utils.queue:CommandBase:int) : void
        {
            this.m_id = com.playtech.casino3.utils.queue:CommandBase;
            return;
        }// end function

        public function isCancelable() : Boolean
        {
            return true;
        }// end function

        public function getId() : int
        {
            return this.m_id;
        }// end function

        public function decreaseLocks() : int
        {
            return 0;
        }// end function

        public function cancel() : void
        {
            return;
        }// end function

        public function getRepeatCount() : int
        {
            return 0;
        }// end function

    }
}
