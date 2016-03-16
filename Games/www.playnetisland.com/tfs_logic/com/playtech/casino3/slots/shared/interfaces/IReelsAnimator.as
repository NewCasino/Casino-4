package com.playtech.casino3.slots.shared.interfaces
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;

    public interface IReelsAnimator
    {

        public function IReelsAnimator();

        function getGlobalPositions() : Vector.<Point>;

        function stopSpin(result:int, result:int, result:int, result:String) : int;

        function showResult(param1:Vector.<int>, param2:ReelsSymbolsState) : void;

        function startSpin(param1:int = 0, param2:int = 0) : void;

        function dispose() : void;

    }
}
