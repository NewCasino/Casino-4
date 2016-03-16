package com.playtech.casino3.slots.shared.data
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.utils.*;

    public class MaskedReelsSymbols extends ReelsSymbols
    {
        protected var _unmasked_symbols:Vector.<SlotsSymbol>;
        protected var _mask_symbols:Vector.<SlotsSymbol>;

        public function MaskedReelsSymbols(MaskedReelsSymbols.as$159:ReelsStrips, MaskedReelsSymbols.as$159:Vector.<int> = null, MaskedReelsSymbols.as$159:int = -1) : void
        {
            this._unmasked_symbols = new Vector.<SlotsSymbol>(GameParameters.numReels * GameParameters.numRows, true);
            this._mask_symbols = new Vector.<SlotsSymbol>(GameParameters.numReels * GameParameters.numRows, true);
            super(MaskedReelsSymbols.as$159, MaskedReelsSymbols.as$159, MaskedReelsSymbols.as$159);
            return;
        }// end function

        public function clearMaskOnReels(MaskedReelsSymbols.as$159:Vector.<int> = null) : void
        {
            DimensionalVectorManipulator.setColumnsValue(MaskedReelsSymbols.as$159, null, this._mask_symbols, _num_rows, _num_reels);
            this.maskSymbols();
            return;
        }// end function

        public function setMaskSymbolOnRows(MaskedReelsSymbols.as$159:SlotsSymbol, MaskedReelsSymbols.as$159:Vector.<int> = null) : void
        {
            DimensionalVectorManipulator.setRowsValue(MaskedReelsSymbols.as$159, MaskedReelsSymbols.as$159, this._mask_symbols, _num_rows, _num_reels);
            this.maskSymbols();
            return;
        }// end function

        public function clearMaskOnRow(MaskedReelsSymbols.as$159:SlotsSymbol, MaskedReelsSymbols.as$159:int) : void
        {
            DimensionalVectorManipulator.setRowValue(MaskedReelsSymbols.as$159, null, this._mask_symbols, _num_rows, _num_reels);
            this.maskSymbols();
            return;
        }// end function

        public function clearMaskSymbolOnReel(MaskedReelsSymbols.as$159:SlotsSymbol, MaskedReelsSymbols.as$159:int) : void
        {
            DimensionalVectorManipulator.setColumnValue(MaskedReelsSymbols.as$159, null, this._mask_symbols, _num_rows, _num_reels);
            this.maskSymbols();
            return;
        }// end function

        override public function toString() : String
        {
            var _loc_1:String = "\n";
            var _loc_2:* = "|===> CURRENT MASKED SYMBOLS TRACE ==========" + _loc_1;
            _loc_2 = _loc_2 + ("|------> MASK --------" + _loc_1);
            _loc_2 = _loc_2 + DimensionalVectorManipulator.toStringMulti(this._mask_symbols, _num_rows, _num_reels, ",", "|");
            _loc_2 = _loc_2 + ("|------< MASK --------" + _loc_1);
            _loc_2 = _loc_2 + (super.toString() + _loc_1);
            _loc_2 = _loc_2 + ("|===< CURRENT MASKED SYMBOLS TRACE ========" + _loc_1);
            return _loc_2;
        }// end function

        protected function maskSymbols(MaskedReelsSymbols.as$159:Vector.<SlotsSymbol> = null) : void
        {
            var _loc_2:int = 0;
            var _loc_4:SlotsSymbol = null;
            super.recalculate(MaskedReelsSymbols.as$159);
            var _loc_3:* = _symbols.length;
            this._unmasked_symbols = _symbols.concat();
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = this._mask_symbols[_loc_2];
                if (_loc_4)
                {
                    _symbols[_loc_2] = _loc_4;
                }
                _loc_2++;
            }
            return;
        }// end function

        public function clearMaskSymbolOnIndexes(MaskedReelsSymbols.as$159:SlotsSymbol, MaskedReelsSymbols.as$159:Vector.<int>) : void
        {
            if (!MaskedReelsSymbols.as$159)
            {
                return;
            }
            this.setMaskSymbolOnIndexes(null, MaskedReelsSymbols.as$159);
            return;
        }// end function

        override protected function recalculate(MaskedReelsSymbols.as$159:Vector.<SlotsSymbol> = null) : void
        {
            this.maskSymbols(MaskedReelsSymbols.as$159);
            return;
        }// end function

        public function setMaskSymbolOnReels(MaskedReelsSymbols.as$159:SlotsSymbol, MaskedReelsSymbols.as$159:Vector.<int> = null) : void
        {
            DimensionalVectorManipulator.setColumnsValue(MaskedReelsSymbols.as$159, MaskedReelsSymbols.as$159, this._mask_symbols, _num_rows, _num_reels);
            this.maskSymbols();
            return;
        }// end function

        public function setMaskSymbolOnRow(MaskedReelsSymbols.as$159:SlotsSymbol, MaskedReelsSymbols.as$159:int) : void
        {
            DimensionalVectorManipulator.setRowValue(MaskedReelsSymbols.as$159, MaskedReelsSymbols.as$159, this._mask_symbols, _num_rows, _num_reels);
            this.maskSymbols();
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._mask_symbols = null;
            this._unmasked_symbols = null;
            return;
        }// end function

        public function clearMaskSymbolOnRows(MaskedReelsSymbols.as$159:Vector.<int> = null) : void
        {
            DimensionalVectorManipulator.setRowsValue(MaskedReelsSymbols.as$159, null, this._mask_symbols, _num_rows, _num_reels);
            this.maskSymbols();
            return;
        }// end function

        public function setMaskSymbolOnIndexes(MaskedReelsSymbols.as$159:SlotsSymbol, MaskedReelsSymbols.as$159:Vector.<int>) : void
        {
            var _loc_4:int = 0;
            if (!MaskedReelsSymbols.as$159)
            {
                return;
            }
            var _loc_3:* = MaskedReelsSymbols.as$159.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                this._mask_symbols[MaskedReelsSymbols.as$159[_loc_4]] = MaskedReelsSymbols.as$159;
                _loc_4++;
            }
            this.maskSymbols();
            return;
        }// end function

        override public function get symbols() : ReelsSymbolsState
        {
            return new ReelsSymbolsState(_symbols.concat(), _num_rows, _num_reels, this._unmasked_symbols.concat());
        }// end function

        public function setMaskSymbolOnReel(MaskedReelsSymbols.as$159:SlotsSymbol, MaskedReelsSymbols.as$159:int) : void
        {
            DimensionalVectorManipulator.setColumnValue(MaskedReelsSymbols.as$159, MaskedReelsSymbols.as$159, this._mask_symbols, _num_rows, _num_reels);
            this.maskSymbols();
            return;
        }// end function

    }
}
