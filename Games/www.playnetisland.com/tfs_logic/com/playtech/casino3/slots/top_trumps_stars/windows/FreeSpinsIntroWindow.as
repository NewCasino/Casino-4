package com.playtech.casino3.slots.top_trumps_stars.windows
{
    import com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows.*;
    import com.playtech.casino3.slots.top_trumps_stars.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.display.*;

    public class FreeSpinsIntroWindow extends FreespinsIntro
    {
        protected var _logic:Logic;
        protected var _middle_callback:CommandFunction;

        public function FreeSpinsIntroWindow(param1:Logic, param2:int, param3:Boolean = false, param4:WindowParameters = null)
        {
            this._logic = param1;
            super(this._logic, param2, param3, param4);
            return;
        }// end function

        override protected function middleActionsSkipped() : void
        {
            super.middleActionsSkipped();
            if (this._middle_callback && !this._middle_callback.has_executed)
            {
                this._middle_callback.execute("");
            }
            return;
        }// end function

        override protected function middleActions() : void
        {
            super.middleActions();
            if (this._middle_callback)
            {
                m_queue.add(this._middle_callback);
            }
            return;
        }// end function

        override public function showWindow() : void
        {
            super.showWindow();
            var _loc_1:* = this.window.getChildByName("texts") as MovieClip;
            _loc_1 = _loc_1.getChildAt(0) as MovieClip;
            var _loc_2:* = _loc_1.getChildByName("flags") as MovieClip;
            _loc_2 = _loc_2.getChildAt(0) as MovieClip;
            _loc_2.gotoAndStop(this._logic.freegames_country.type);
            return;
        }// end function

        public function get window() : MovieClip
        {
            return graphics as MovieClip;
        }// end function

        public function set middle_callback(com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows:CommandFunction) : void
        {
            this._middle_callback = com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows;
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._logic = null;
            this._middle_callback = null;
            return;
        }// end function

    }
}
