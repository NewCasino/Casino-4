package com.playtech.casino3.utils.queue
{

    public class CommandFunction extends CommandObject
    {

        public function CommandFunction(param1:Function, ... args)
        {
            super(param1, args);
            return;
        }// end function

        override public function execute(com.playtech.casino3.utils.queue:CommandFunction/CommandFunction:String) : int
        {
            m_executed = true;
            if (m_args != null)
            {
                m_function.apply(null, m_args);
            }
            else
            {
                m_function();
            }
            return 0;
        }// end function

    }
}
