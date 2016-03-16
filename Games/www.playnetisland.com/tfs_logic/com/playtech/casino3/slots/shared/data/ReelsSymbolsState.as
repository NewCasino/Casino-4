package com.playtech.casino3.slots.shared.data
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.utils.*;
    import flash.utils.*;

    public class ReelsSymbolsState extends Object implements IDisposable
    {
        protected var _byte_array_representation:ByteArray;
        protected var _num_rows:int;
        protected var _symbols:Vector.<SlotsSymbol>;
        protected var _unmasked_symbols:Vector.<SlotsSymbol>;
        protected var _num_reels:int;

        public function ReelsSymbolsState(numRows:Vector.<SlotsSymbol>, numRows:int = 0, numRows:int = 0, numRows:Vector.<SlotsSymbol> = null) : void
        {
            this._num_rows = numRows == 0 ? (GameParameters.numRows) : (numRows);
            this._num_reels = numRows == 0 ? (GameParameters.numReels) : (numRows);
            this._symbols = numRows;
            this._unmasked_symbols = numRows;
            this._byte_array_representation = this.types_as_byte_array;
            return;
        }// end function

        public function get unmasked_symbols() : Vector.<SlotsSymbol>
        {
            return this._unmasked_symbols ? (this._unmasked_symbols) : (this._symbols);
        }// end function

        public function symbolsOnIndexes(_num_reels:ByteArray) : Vector.<SlotsSymbol>
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            _loc_3 = _num_reels.length;
            var _loc_4:* = new Vector.<SlotsSymbol>(_loc_3, true);
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4[_loc_2] = this._symbols[_num_reels[_loc_2]];
                _loc_2++;
            }
            return _loc_4;
        }// end function

        public function countSymbol(_symbols:SlotsSymbol) : int
        {
            var _loc_2:* = this.indexesOfSymbol(_symbols);
            return _loc_2 ? (_loc_2.length) : (0);
        }// end function

        protected function get types_as_byte_array() : ByteArray
        {
            var _loc_2:int = 0;
            var _loc_1:* = new ByteArray();
            var _loc_3:* = this._symbols.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_1[_loc_2] = this._symbols[_loc_2].type;
                _loc_2++;
            }
            return _loc_1;
        }// end function

        public function countSymbolOnReel(_symbols:SlotsSymbol, _symbols:int) : int
        {
            var _loc_3:* = this.indexesOfSymbolOnReel(_symbols, _symbols);
            return _loc_3 ? (_loc_3.length) : (0);
        }// end function

        public function get as_byte_array() : ByteArray
        {
            var _loc_1:* = new ByteArray();
            this._byte_array_representation.position = 0;
            this._byte_array_representation.readBytes(_loc_1);
            return _loc_1;
        }// end function

        public function reelContains(position:SlotsSymbol, position:int) : Boolean
        {
            var _loc_3:* = this.indexOfSymbolOnReel(position, position);
            return _loc_3 != -1;
        }// end function

        public function reel(_num_reels:int) : Vector.<SlotsSymbol>
        {
            return DimensionalVectorManipulator.column(_num_reels, this._symbols, this._num_rows, this._num_reels);
        }// end function

        public function get symbols() : Vector.<SlotsSymbol>
        {
            return this._symbols;
        }// end function

        public function symbolOnReelTheSame(position:int) : Boolean
        {
            var _loc_2:Vector.<SlotsSymbol> = null;
            var _loc_3:int = 0;
            var _loc_6:SlotsSymbol = null;
            _loc_2 = this.reel(position);
            var _loc_4:* = _loc_2.length;
            var _loc_5:* = _loc_2[0];
            _loc_3 = 1;
            while (_loc_3 < _loc_4)
            {
                
                _loc_6 = _loc_2[_loc_3];
                if (_loc_5 != _loc_6)
                {
                    return false;
                }
                _loc_5 = _loc_6;
                _loc_3++;
            }
            return true;
        }// end function

        public function indexesOfSymbolOnReel(copy:SlotsSymbol, copy:int) : Vector.<int>
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:* = new Vector.<int>;
            _loc_3 = 0;
            while (_loc_3 < this._num_rows)
            {
                
                _loc_4 = copy + _loc_3 * this._num_reels;
                if (copy && this._symbols[_loc_4] != copy)
                {
                }
                else
                {
                    _loc_6[++_loc_5] = _loc_4;
                }
                _loc_3++;
            }
            return _loc_5 == 0 ? (null) : (_loc_6);
        }// end function

        public function row(_num_reels:int) : Vector.<SlotsSymbol>
        {
            return DimensionalVectorManipulator.row(_num_reels, this._symbols, this._num_rows, this._num_reels);
        }// end function

        public function toString() : String
        {
            var _loc_1:String = "\n";
            var _loc_2:String = "";
            _loc_2 = _loc_2 + "|>  REELS SYMBOLS STATE  --------------";
            _loc_2 = _loc_2 + ("|------>  SYMBOLS  --------------------" + _loc_1);
            _loc_2 = _loc_2 + DimensionalVectorManipulator.toStringMulti(this._symbols, this._num_rows, this._num_reels, ",", "|");
            _loc_2 = _loc_2 + ("|------<  SYMBOLS  -------------------" + _loc_1);
            _loc_2 = _loc_2 + ("|------>  SYMBOLS UNMASKED  ----------" + _loc_1);
            _loc_2 = _loc_2 + DimensionalVectorManipulator.toStringMulti(this.unmasked_symbols, this._num_rows, this._num_reels, ",", "|");
            _loc_2 = _loc_2 + ("|------<  SYMBOLS UNMASKED  ----------" + _loc_1);
            _loc_2 = _loc_2 + "|----<  REELS SYMBOLS STATE  ---------";
            return _loc_2;
        }// end function

        public function dispose() : void
        {
            this._symbols = null;
            this._unmasked_symbols = null;
            this._byte_array_representation = null;
            return;
        }// end function

        public function indexesOfSymbol(copy:SlotsSymbol) : Vector.<int>
        {
            var _loc_4:int = 0;
            var _loc_2:* = new Vector.<int>;
            var _loc_3:int = 0;
            var _loc_5:* = this._symbols.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_5)
            {
                
                if (this._symbols[_loc_4] == copy)
                {
                    _loc_2[++_loc_3] = _loc_4;
                }
                _loc_4++;
            }
            return _loc_2.length == 0 ? (null) : (_loc_2);
        }// end function

        public function indexOfSymbolOnReel(_symbols:SlotsSymbol, _symbols:int) : int
        {
            var _loc_3:* = this.indexesOfSymbolOnReel(_symbols, _symbols);
            return _loc_3 ? (_loc_3[0]) : (-1);
        }// end function

    }
}
