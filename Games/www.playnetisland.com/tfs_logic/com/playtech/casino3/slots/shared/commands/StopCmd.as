package com.playtech.casino3.slots.shared.commands
{
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;

    public class StopCmd extends CommandObject
    {
        private var m_base:SlotsBase;

        public function StopCmd(param1:SlotsBase)
        {
            super(null);
            this.m_base = param1;
            return;
        }// end function

        override public function execute(com.playtech.casino3:IModuleInterface:String) : int
        {
            Console.write("Stop command executed", "[" + GameParameters.shortname + "] ");
            this.m_base.getModI().playAsEffect(NovelSoundMap.SOUND_STOP);
            this.m_base.getQueue().empty();
            var _loc_2:* = this.m_base.getRoundInfo();
            if ((this.m_base as Object).addMarvelJP)
            {
                (this.m_base as Object).addMarvelJP();
            }
            this.m_base.getReelAnimator().showResult(_loc_2.results, _loc_2.reelSymbols.symbols);
            this.m_base.getQueue().add(new CommandFunction(this.m_base.afterSpin));
            return 0;
        }// end function

        override public function clear() : void
        {
            this.m_base = null;
            return;
        }// end function

    }
}
