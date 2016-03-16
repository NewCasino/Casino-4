package com.playtech.casino3.slots.shared
{
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.*;

    public class SimpleAP extends Object
    {
        private var m_base:TypeNovel;
        private var m_done:int;
        private var m_isActivated:Boolean;
        private var m_left:int;
        private static const MAX:int = 99;

        public function SimpleAP(param1:TypeNovel)
        {
            this.m_base = param1;
            this.m_left = 10;
            return;
        }// end function

        public function getApLeft() : int
        {
            return this.m_left;
        }// end function

        public function dispose() : void
        {
            this.m_base = null;
            return;
        }// end function

        public function checkContinue() : Boolean
        {
            var _loc_1:* = this.m_left > 0 && this.m_isActivated;
            if (_loc_1)
            {
                var _loc_2:String = this;
                var _loc_3:* = this.m_done + 1;
                _loc_2.m_done = _loc_3;
            }
            return _loc_1;
        }// end function

        public function activate() : Boolean
        {
            if (this.m_left == 0)
            {
                this.showAlert(this.m_base.getModI().readText("novel_alert_AP_enterspins"));
                return false;
            }
            this.m_done = 0;
            this.m_isActivated = true;
            this.m_base.setState(GameStates.STATE_AUTOPLAY);
            this.m_base.getServer().activateAP(true);
            return true;
        }// end function

        public function setApLeft(STATE_AUTOPLAY:int) : void
        {
            this.m_left = STATE_AUTOPLAY;
            return;
        }// end function

        public function finish() : void
        {
            var _loc_1:Object = {spincount:this.m_done};
            this.showAlert(this.m_base.getModI().readText("novel_alert_AP_stopped", _loc_1));
            this.m_left = this.m_done > MAX ? (MAX) : (this.m_done);
            this.deactivate();
            return;
        }// end function

        public function deactivate(STATE_AUTOPLAY:int = -1) : void
        {
            this.m_base.getModI().updateStatusBar("novel_infobar_autostop", null, 2000);
            if (STATE_AUTOPLAY != -1 && this.m_left < STATE_AUTOPLAY)
            {
                this.m_left = STATE_AUTOPLAY;
            }
            this.m_isActivated = false;
            if (this.m_base.getState() == GameStates.STATE_AUTOPLAY)
            {
                this.m_base.setPrevStateBack();
            }
            else
            {
                this.m_base.removeState(GameStates.STATE_AUTOPLAY);
            }
            this.m_base.getServer().activateAP(false);
            return;
        }// end function

        protected function showAlert(STATE_AUTOPLAY:String = "") : void
        {
            this.m_base.getModI().openDialog(SharedDialog.ALERT, STATE_AUTOPLAY);
            return;
        }// end function

    }
}
