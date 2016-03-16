package com.playtech.casino3.slots.shared.utils
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;

    public class DimensionalVectorManipulator extends Object
    {
        public static const NEW_LINE:String = "\n";
        public static const TAB:String = "\t";
        public static const TAB2COMMA:String = "\t\t,";

        public function DimensionalVectorManipulator()
        {
            return;
        }// end function

        public static function setColumnValue(row_index:int, row_index:SlotsSymbol, row_index:Vector.<SlotsSymbol>, row_index:int, row_index:int) : void
        {
            var _loc_6:int = 0;
            _loc_6 = 0;
            while (_loc_6 < row_index)
            {
                
                row_index[_loc_6 * row_index + row_index] = row_index;
                _loc_6++;
            }
            return;
        }// end function

        public static function setColumnsValue(row_index:Vector.<int>, row_index:SlotsSymbol, row_index:Vector.<SlotsSymbol>, row_index:int, row_index:int) : void
        {
            var _loc_7:int = 0;
            var _loc_6:* = row_index ? (row_index.length) : (row_index);
            if (row_index)
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    setColumnValue(row_index[_loc_7], row_index, row_index, row_index, row_index);
                    _loc_7++;
                }
            }
            else
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    setColumnValue(_loc_7, row_index, row_index, row_index, row_index);
                    _loc_7++;
                }
            }
            return;
        }// end function

        public static function toStringColumn(DimensionalVectorManipulator.as$249:int, DimensionalVectorManipulator.as$249:Vector.<SlotsSymbol>, DimensionalVectorManipulator.as$249:int, DimensionalVectorManipulator.as$249:int) : String
        {
            return toStringSingle(column(DimensionalVectorManipulator.as$249, DimensionalVectorManipulator.as$249, DimensionalVectorManipulator.as$249, DimensionalVectorManipulator.as$249));
        }// end function

        public static function toStringMulti(DimensionalVectorManipulator.as$249:Vector.<SlotsSymbol>, DimensionalVectorManipulator.as$249:int, DimensionalVectorManipulator.as$249:int, DimensionalVectorManipulator.as$249:String = "\t\t,", DimensionalVectorManipulator.as$249:String = "") : String
        {
            var _loc_7:int = 0;
            var _loc_6:String = "";
            _loc_7 = 0;
            while (_loc_7 < DimensionalVectorManipulator.as$249)
            {
                
                _loc_6 = _loc_6 + (DimensionalVectorManipulator.as$249 + toStringSingle(row(_loc_7, DimensionalVectorManipulator.as$249, DimensionalVectorManipulator.as$249, DimensionalVectorManipulator.as$249), DimensionalVectorManipulator.as$249));
                _loc_7++;
            }
            return _loc_6;
        }// end function

        public static function toStringRow(DimensionalVectorManipulator.as$249:int, DimensionalVectorManipulator.as$249:Vector.<SlotsSymbol>, DimensionalVectorManipulator.as$249:int, DimensionalVectorManipulator.as$249:int) : String
        {
            return toStringSingle(row(DimensionalVectorManipulator.as$249, DimensionalVectorManipulator.as$249, DimensionalVectorManipulator.as$249, DimensionalVectorManipulator.as$249));
        }// end function

        public static function toStringSingle(DimensionalVectorManipulator.as$249:Vector.<SlotsSymbol>, DimensionalVectorManipulator.as$249:String = "\t\t,") : String
        {
            return DimensionalVectorManipulator.as$249.join(DimensionalVectorManipulator.as$249) + NEW_LINE;
        }// end function

        public static function setRowsValue(row_index:Vector.<int>, row_index:SlotsSymbol, row_index:Vector.<SlotsSymbol>, row_index:int, row_index:int) : void
        {
            var _loc_7:int = 0;
            var _loc_6:* = row_index ? (row_index.length) : (row_index);
            if (row_index)
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    setRowValue(row_index[_loc_7], row_index, row_index, row_index, row_index);
                    _loc_7++;
                }
            }
            else
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    setRowValue(_loc_7, row_index, row_index, row_index, row_index);
                    _loc_7++;
                }
            }
            return;
        }// end function

        public static function setRowValue(row_index:int, row_index:SlotsSymbol, row_index:Vector.<SlotsSymbol>, row_index:int, row_index:int) : void
        {
            var _loc_6:int = 0;
            _loc_6 = 0;
            while (_loc_6 < row_index)
            {
                
                row_index[row_index * row_index + _loc_6] = row_index;
                _loc_6++;
            }
            return;
        }// end function

        public static function row(TAB2COMMA:int, TAB2COMMA:Vector.<SlotsSymbol>, TAB2COMMA:int, TAB2COMMA:int) : Vector.<SlotsSymbol>
        {
            var _loc_6:int = 0;
            var _loc_5:* = new Vector.<SlotsSymbol>(TAB2COMMA, true);
            _loc_6 = 0;
            while (_loc_6 < TAB2COMMA)
            {
                
                _loc_5[_loc_6] = TAB2COMMA[TAB2COMMA * TAB2COMMA + _loc_6];
                _loc_6++;
            }
            return _loc_5;
        }// end function

        public static function column(TAB2COMMA:int, TAB2COMMA:Vector.<SlotsSymbol>, TAB2COMMA:int, TAB2COMMA:int) : Vector.<SlotsSymbol>
        {
            var _loc_6:int = 0;
            var _loc_5:* = new Vector.<SlotsSymbol>(TAB2COMMA, true);
            _loc_6 = 0;
            while (_loc_6 < TAB2COMMA)
            {
                
                _loc_5[_loc_6] = TAB2COMMA[_loc_6 * TAB2COMMA + TAB2COMMA];
                _loc_6++;
            }
            return _loc_5;
        }// end function

    }
}
