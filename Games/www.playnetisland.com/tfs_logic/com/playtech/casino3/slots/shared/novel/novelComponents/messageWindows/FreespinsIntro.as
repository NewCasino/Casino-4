package com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows
{
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.display.*;
    import flash.text.*;

    public class FreespinsIntro extends MessageWindow
    {
        private var m_tf:TextField;
        protected var m_fsTicking:Boolean;
        protected var m_cSpins:int;
        private var m_innerQID:String;
        protected var m_slotsbase:TypeNovel;
        private var m_num_fs:int;

        public function FreespinsIntro(param1:TypeNovel, param2:int, param3:Boolean = false, param4:WindowParameters = null)
        {
            var _loc_5:WindowParameters = null;
            if (param4 != null)
            {
                _loc_5 = param4;
            }
            else
            {
                _loc_5 = GetWindowParameters.freespinIntro();
            }
            this.m_fsTicking = param3;
            this.m_num_fs = param2;
            this.m_slotsbase = param1;
            super(param1.getModI(), param1.getGFX(), _loc_5);
            return;
        }// end function

        override protected function middleActionsSkipped() : void
        {
            if (this.m_tf != null)
            {
                this.m_tf.text = this.m_num_fs.toString();
            }
            return;
        }// end function

        private function makeTick(Boolean:int = 0, Boolean:String = null) : void
        {
            if (this.m_cSpins == this.m_num_fs)
            {
                QueueEventManager.dispatchEvent(this.m_innerQID);
                return;
            }
            var _loc_3:* = this.m_slotsbase.getModI().playAsEffect(GameParameters.shortname + ".fs_count", null, 0, this.makeTick);
            this.updateSpinValue();
            var _loc_4:String = this;
            var _loc_5:* = this.m_cSpins + 1;
            _loc_4.m_cSpins = _loc_5;
            if (_loc_3 == -1)
            {
                this.makeTick();
            }
            return;
        }// end function

        protected function updateSpinValue() : void
        {
            this.m_tf.text = this.m_cSpins.toString();
            return;
        }// end function

        override public function dispose() : void
        {
            this.m_tf = null;
            this.m_slotsbase = null;
            super.dispose();
            return;
        }// end function

        override protected function middleActions() : void
        {
            if (this.m_fsTicking)
            {
                m_queue.add(new CommandObject(this.tickingAnimation));
            }
            return;
        }// end function

        override protected function beforeWindow() : void
        {
            var _loc_1:* = Sprite(m_panel.getChildByName("fs_info_container"));
            if (_loc_1 == null)
            {
                _loc_1 = m_panel;
            }
            var _loc_2:* = TextField(_loc_1.getChildByName("multi"));
            if (_loc_2 != null)
            {
                _loc_2.text = this.m_slotsbase.getFsManager().getMultiplier().toString();
            }
            this.m_tf = TextField(_loc_1.getChildByName("spins"));
            if (this.m_tf == null)
            {
                this.m_fsTicking = false;
                return;
            }
            if (!this.m_fsTicking)
            {
                this.m_tf.text = (this.m_cSpins + this.m_num_fs).toString();
            }
            return;
        }// end function

        private function tickingAnimation(parameters:String) : int
        {
            this.m_innerQID = parameters;
            this.makeTick();
            return 1;
        }// end function

    }
}
