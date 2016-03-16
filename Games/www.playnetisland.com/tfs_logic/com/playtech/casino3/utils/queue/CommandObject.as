package com.playtech.casino3.utils.queue
{

    public class CommandObject extends CommandBase implements ICommand
    {
        private var m_cFunction:Function;
        private var m_locks:int;
        private var m_delFunc:Function;
        protected var m_executed:Boolean;
        private var m_cancelable:Boolean;
        protected var m_function:Function;
        private var m_repeat:int;
        protected var m_args:Object;
        private var m_delArgs:Object;

        public function CommandObject(param1:Function, param2 = null, param3:Function = null, param4:Boolean = true, param5:int = 1)
        {
            this.m_function = param1;
            this.m_args = param2;
            this.m_repeat = param5;
            this.m_cancelable = param4;
            this.m_cFunction = param3;
            return;
        }// end function

        override public function isCancelable() : Boolean
        {
            return this.m_cancelable;
        }// end function

        override public function getRepeatCount() : int
        {
            return this.m_repeat;
        }// end function

        public function clear() : void
        {
            if (this.m_delFunc != null)
            {
                if (!this.m_executed)
                {
                    if (this.m_delArgs != null)
                    {
                        this.m_delFunc.apply(null, this.m_delArgs);
                    }
                    else
                    {
                        this.m_delFunc();
                    }
                }
                this.m_delFunc = null;
                this.m_delArgs = null;
            }
            this.m_function = null;
            this.m_cFunction = null;
            this.m_args = null;
            return;
        }// end function

        public function setDeleteFunc(Function:Function, ... args) : void
        {
            this.m_delFunc = Function;
            this.m_delArgs = args;
            return;
        }// end function

        public function get has_executed() : Boolean
        {
            return this.m_executed;
        }// end function

        override public function cancel() : void
        {
            if (this.m_cFunction != null)
            {
                this.m_cFunction();
            }
            return;
        }// end function

        public function getArguments()
        {
            return this.m_args;
        }// end function

        public function setFunction(Function:Function) : void
        {
            this.m_function = Function;
            return;
        }// end function

        public function execute(repeat:String) : int
        {
            this.m_executed = true;
            var _loc_2:String = this;
            var _loc_3:* = this.m_repeat - 1;
            _loc_2.m_repeat = _loc_3;
            if (this.m_args != null)
            {
                this.m_locks = this.m_args is Array ? (this.m_function.apply(null, this.m_args.concat(repeat))) : (this.m_function(this.m_args, repeat));
            }
            else
            {
                this.m_locks = this.m_function(repeat);
            }
            return this.m_locks;
        }// end function

        override public function decreaseLocks() : int
        {
            var _loc_1:String = this;
            _loc_1.m_locks = this.m_locks - 1;
            return --this.m_locks;
        }// end function

    }
}
