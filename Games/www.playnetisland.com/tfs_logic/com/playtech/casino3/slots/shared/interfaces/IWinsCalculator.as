package com.playtech.casino3.slots.shared.interfaces
{
    import com.playtech.casino3.slots.shared.data.*;

    public interface IWinsCalculator extends IDisposable
    {

        public function IWinsCalculator();

        function getResult(param1:ReelsSymbolsState, param2:Array) : Wins;

        function sortWins(com.playtech.casino3.slots.shared.data:Wins) : void;

        function calculateWinAmouts(pay_lines:RoundInfo) : Number;

    }
}
