package com.playtech.casino3.slots.shared.interfaces
{

    public interface IWinsAnimator
    {

        public function IWinsAnimator();

        function stopAnim() : void;

        function showWins(param1, param2:int, param3:String) : int;

        function pause(wins:Boolean = true) : void;

        function dispose() : void;

    }
}
