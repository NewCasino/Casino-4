package com.playtech.casino3.slots.shared.novel.novelCmd
{
    import com.playtech.casino3.slots.shared.slotsUtils.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.display.*;

    public class TweenCmd extends CommandBase implements ICommand
    {
        private var m_obj:DisplayObject;
        private var m_tweener:TweenMovie;
        private var m_remove:Boolean;
        private var m_params:Object;

        public function TweenCmd(param1:DisplayObject, param2:Object, param3:Boolean = false)
        {
            this.m_obj = param1;
            this.m_params = param2;
            this.m_remove = param3;
            return;
        }// end function

        override public function cancel() : void
        {
            this.m_tweener.clear();
            return;
        }// end function

        private function finish(Boolean:String) : void
        {
            QueueEventManager.dispatchEvent(Boolean);
            return;
        }// end function

        public function clear() : void
        {
            if (this.m_tweener != null)
            {
                this.m_tweener = null;
            }
            this.m_obj = null;
            this.m_params = null;
            return;
        }// end function

        public function execute(com.playtech.casino3.slots.shared.novel.novelCmd:TweenCmd/TweenCmd:String) : int
        {
            this.m_tweener = new TweenMovie(this.m_obj, this.m_params, this.m_remove, this.finish, com.playtech.casino3.slots.shared.novel.novelCmd:TweenCmd/TweenCmd);
            return 1;
        }// end function

    }
}
