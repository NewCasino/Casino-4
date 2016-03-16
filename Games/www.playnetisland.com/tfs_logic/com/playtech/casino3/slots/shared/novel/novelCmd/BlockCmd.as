package com.playtech.casino3.slots.shared.novel.novelCmd
{
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;
    import flash.events.*;

    public class BlockCmd extends CommandBase implements ICommand
    {
        protected var _unblock_event:String;
        protected var _check_condition_at_execute:Function;
        protected var _id:String;

        public function BlockCmd(check_condition_at_execute_:String, check_condition_at_execute_:Function = null) : void
        {
            Console.write("new BlockCmd unblock event:" + check_condition_at_execute_);
            this._unblock_event = check_condition_at_execute_;
            this._check_condition_at_execute = check_condition_at_execute_;
            return;
        }// end function

        protected function finish(event:Event) : void
        {
            Console.write("BlockCmd.finish unblock with event  : " + this._unblock_event + " queue id: " + this._id);
            EventPool.removeEventListener(this._unblock_event, this.finish);
            QueueEventManager.dispatchEvent(this._id);
            return;
        }// end function

        public function clear() : void
        {
            EventPool.removeEventListener(this._unblock_event, this.finish);
            this._check_condition_at_execute = null;
            return;
        }// end function

        public function execute(com.playtech.casino3.slots.shared.novel.novelCmd:BlockCmd/BlockCmd:String) : int
        {
            this._id = com.playtech.casino3.slots.shared.novel.novelCmd:BlockCmd/BlockCmd;
            EventPool.addEventListener(this._unblock_event, this.finish);
            Console.write("BlockCmd.execute unblock event:" + this._unblock_event + " should block:" + (this._check_condition_at_execute != null ? (this._check_condition_at_execute()) : (true)));
            if (this._check_condition_at_execute == null)
            {
                return 1;
            }
            if (!this._check_condition_at_execute())
            {
                return 0;
            }
            return 1;
        }// end function

    }
}
