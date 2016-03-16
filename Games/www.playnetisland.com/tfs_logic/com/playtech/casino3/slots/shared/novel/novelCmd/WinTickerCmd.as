package com.playtech.casino3.slots.shared.novel.novelCmd
{
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.text.*;

    public class WinTickerCmd extends WinTicker implements ICommand
    {
        private var m_qId:String;
        private var m_id:int;

        public function WinTickerCmd(param1:TextField, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean = true, param7:Boolean = true, param8:Boolean = true)
        {
            super(param1, param6);
            setVariables(param2, param3, param4, param5, param7, param8);
            return;
        }// end function

        public function getRepeatCount() : int
        {
            return 0;
        }// end function

        public function hasFrameChange() : Boolean
        {
            return true;
        }// end function

        public function decreaseLocks() : int
        {
            return 0;
        }// end function

        override protected function animDone() : void
        {
            QueueEventManager.dispatchEvent(this.m_qId);
            return;
        }// end function

        public function execute(pace:String) : int
        {
            this.m_qId = pace;
            startAnim();
            return 1;
        }// end function

        public function isCancelable() : Boolean
        {
            return true;
        }// end function

        public function getId() : int
        {
            return this.m_id;
        }// end function

        public function setId(noCents:int) : void
        {
            this.m_id = noCents;
            return;
        }// end function

    }
}
