package com.playtech.casino3.slots.shared.novel.winAnimations
{
    import com.playtech.casino3.slots.shared.data.*;

    public interface IWinAnimation
    {

        public function IWinAnimation();

        function isBlockingToggle() : Boolean;

        function dispose() : void;

        function get slotswin() : SlotsWin;

    }
}
