package com.playtech.casino3.slots.shared
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;

    public class TMUFreeze extends Object
    {
        private var m_mi:IModuleInterface;
        private static var m_qID:String;
        private static var m_isFrozen:Boolean;

        public function TMUFreeze(param1:IModuleInterface)
        {
            this.m_mi = param1;
            this.m_mi.listenGS(SharedCommand.COMMAND_SPCG_FREEZE, this.onFreeze);
            return;
        }// end function

        private function onFreeze(onFreeze:Packet) : void
        {
            if (onFreeze.data[0] == "1")
            {
                m_isFrozen = true;
            }
            else
            {
                m_isFrozen = false;
                if (m_qID != null)
                {
                    QueueEventManager.dispatchEvent(m_qID);
                    m_qID = null;
                }
            }
            return;
        }// end function

        public function dispose() : void
        {
            this.m_mi.unlistenGS(SharedCommand.COMMAND_SPCG_FREEZE, this.onFreeze);
            this.m_mi = null;
            return;
        }// end function

        public static function blocker(m_qID:String) : int
        {
            if (m_isFrozen)
            {
                m_qID = m_qID;
                return 1;
            }
            return 0;
        }// end function

    }
}
