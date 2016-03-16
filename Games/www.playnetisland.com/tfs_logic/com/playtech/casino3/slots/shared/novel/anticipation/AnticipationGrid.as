package com.playtech.casino3.slots.shared.novel.anticipation
{
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.utils.*;

    public class AnticipationGrid extends Object
    {
        private var m_reelEff:ReelEffects;

        public function AnticipationGrid(param1:ReelEffects)
        {
            this.m_reelEff = param1;
            EventPool.addEventListener(ReelSpinInfo.REEL_STOP_START, this.showAnticipation);
            EventPool.addEventListener(ReelSpinInfo.REEL_END, this.removeAnticipation);
            return;
        }// end function

        private function removeAnticipation(event:RegularEvent) : void
        {
            this.m_reelEff.removeMovie("anticipation", event.data[0], 2);
            return;
        }// end function

        private function showAnticipation(event:RegularEvent) : void
        {
            if ((event.data[1] & ReelSpinInfo.ANTICIPATION_STOP) > 0)
            {
                this.m_reelEff.showMovie("anticipation", event.data[0], 2);
            }
            return;
        }// end function

        public function dispose() : void
        {
            this.m_reelEff = null;
            EventPool.removeEventListener(ReelSpinInfo.REEL_STOP_START, this.showAnticipation);
            EventPool.removeEventListener(ReelSpinInfo.REEL_END, this.removeAnticipation);
            return;
        }// end function

    }
}
