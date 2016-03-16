package com.playtech.casino3.slots.shared.data
{
    import __AS3__.vec.*;

    public class ReelsSymbols extends Object implements IDisposable
    {
        protected var _reels_strips:ReelsStrips;
        protected var _num_reels:int;
        protected var _positions:Vector.<int>;
        protected var _middle_row:int;
        protected var _num_rows:int;
        protected var _symbols:Vector.<SlotsSymbol>;

        public function ReelsSymbols(_num_rows:ReelsStrips, _num_rows:Vector.<int> = null, _num_rows:int = -1) : void
        {
            this._num_rows = GameParameters.numRows;
            this._num_reels = GameParameters.numReels;
            this._reels_strips = _num_rows;
            this._middle_row = _num_rows == -1 ? (1) : (_num_rows);
            this._positions = _num_rows;
            if (_num_rows)
            {
                this.recalculate();
            }
            return;
        }// end function

        public function get positions() : Vector.<int>
        {
            return this._positions.concat();
        }// end function

        public function toString() : String
        {
            return this.symbols.toString();
        }// end function

        public function set positions(_num_rows:Vector.<int>) : void
        {
            this._positions = _num_rows.concat();
            this.recalculate();
            return;
        }// end function

        protected function recalculate(_num_rows:Vector.<SlotsSymbol> = null) : void
        {
            if (!_num_rows)
            {
                _num_rows = this._reels_strips.getSymbolsFromPositions(this._positions, this._num_rows, this._middle_row);
            }
            this._symbols = _num_rows;
            return;
        }// end function

        public function get symbols() : ReelsSymbolsState
        {
            return new ReelsSymbolsState(this._symbols.concat(), this._num_rows, this._num_reels);
        }// end function

        public function set symbols(_num_rows:ReelsSymbolsState) : void
        {
            this.recalculate(_num_rows.symbols);
            return;
        }// end function

        public function dispose() : void
        {
            this._symbols = null;
            this._positions = null;
            this._reels_strips = null;
            return;
        }// end function

    }
}
