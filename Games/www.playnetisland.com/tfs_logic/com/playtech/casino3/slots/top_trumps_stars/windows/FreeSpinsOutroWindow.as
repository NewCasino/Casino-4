package com.playtech.casino3.slots.top_trumps_stars.windows
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.display.*;

    public class FreeSpinsOutroWindow extends FreespinsOutro
    {
        protected var _total_games_played:int = 0;
        protected var _middle_callback:Function;

        public function FreeSpinsOutroWindow(param1:IModuleInterface, param2:Sprite, param3:Number, param4:Number, param5:WindowParameters = null, param6:int = 0)
        {
            super(param1, param2, param3, param4, param5);
            this._total_games_played = param6;
            return;
        }// end function

        override protected function middleActions() : void
        {
            super.middleActions();
            m_mi.playAsEffect(GameParameters.shortname + ".FS_outro", SND_SOURCE);
            if (this._middle_callback != null)
            {
                m_queue.add(new CommandFunction(this._middle_callback));
            }
            return;
        }// end function

        override protected function middleActionsSkipped() : void
        {
            super.middleActionsSkipped();
            if (this._middle_callback != null)
            {
                this._middle_callback();
            }
            return;
        }// end function

        override public function showWindow() : void
        {
            super.showWindow();
            return;
        }// end function

        public function get window() : MovieClip
        {
            return graphics as MovieClip;
        }// end function

        public function set middle_callback(int:Function) : void
        {
            this._middle_callback = int;
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._middle_callback = null;
            return;
        }// end function

    }
}
