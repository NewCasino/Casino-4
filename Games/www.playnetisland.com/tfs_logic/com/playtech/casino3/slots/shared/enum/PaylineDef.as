package com.playtech.casino3.slots.shared.enum
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;

    public class PaylineDef extends Object
    {
        public static const ROW_10:int = enumeration_row_index + 1;
        public static const LINE_50:int = enumeration_line_index + 1;
        public static const LINE_30:int = enumeration_line_index + 1;
        public static const LINE_15:int = enumeration_line_index + 1;
        static const LINE_DEFINITIONS:Vector.<Vector.<Array>> = new Vector.<Vector.<Array>>;
        public static const ROW_3:int = enumeration_row_index + 1;
        static const NUMBER_TO_LINE_ENUM:Object = {};
        public static const LINE_40:int = enumeration_line_index + 1;
        public static const LINE_20:int = enumeration_line_index + 1;
        public static const LINE_5:int = enumeration_line_index + 1;
        public static const ROW_1:int = enumeration_row_index + 1;
        public static const LINE_8:int = enumeration_line_index + 1;
        public static const LINE_9:int = enumeration_line_index + 1;
        public static const ROW_5:int = enumeration_row_index + 1;
        static const ROW_DEFINITIONS:Vector.<Vector.<Array>> = new Vector.<Vector.<Array>>;
        static const NUMBER_TO_ROW_ENUM:Object = {};
        private static var enumeration_row_index:int = 0;
        public static const LINE_25:int = enumeration_line_index + 1;
        private static var enumeration_line_index:int = 0;

        public function PaylineDef()
        {
            return;
        }// end function

        public static function getLineDefByRow(LINE_DEFINITIONS:int) : Array
        {
            return getDefinition(NUMBER_TO_ROW_ENUM[LINE_DEFINITIONS], ROW_DEFINITIONS);
        }// end function

        public static function getLineDefByLines(LINE_DEFINITIONS:int) : Array
        {
            return getDefinition(NUMBER_TO_LINE_ENUM[LINE_DEFINITIONS], LINE_DEFINITIONS);
        }// end function

        static function getDefinition(LINE_DEFINITIONS:int, LINE_DEFINITIONS:Vector.<Vector.<Array>>) : Array
        {
            var _loc_3:Vector.<Array> = null;
            var _loc_6:int = 0;
            _loc_3 = LINE_DEFINITIONS[LINE_DEFINITIONS];
            var _loc_4:Array = [];
            var _loc_5:* = _loc_3.length;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_4.push(new SlotsPayline(_loc_6, _loc_3[_loc_6]));
                _loc_6++;
            }
            return _loc_4;
        }// end function

        NUMBER_TO_LINE_ENUM[5] = LINE_5;
        NUMBER_TO_LINE_ENUM[8] = LINE_8;
        NUMBER_TO_LINE_ENUM[9] = LINE_9;
        NUMBER_TO_LINE_ENUM[15] = LINE_15;
        NUMBER_TO_LINE_ENUM[20] = LINE_20;
        NUMBER_TO_LINE_ENUM[25] = LINE_25;
        NUMBER_TO_LINE_ENUM[30] = LINE_30;
        NUMBER_TO_LINE_ENUM[40] = LINE_40;
        NUMBER_TO_LINE_ENUM[50] = LINE_50;
        NUMBER_TO_ROW_ENUM[1] = ROW_1;
        NUMBER_TO_ROW_ENUM[3] = ROW_3;
        NUMBER_TO_ROW_ENUM[5] = ROW_5;
        NUMBER_TO_ROW_ENUM[10] = ROW_10;
        LINE_DEFINITIONS[LINE_5] = PaylineDef.Vector.<Array>([[5, 6, 7, 8, 9], [0, 1, 2, 3, 4], [10, 11, 12, 13, 14], [0, 6, 12, 8, 4], [10, 6, 2, 8, 14]]);
        LINE_DEFINITIONS[LINE_8] = PaylineDef.Vector.<Array>([[3, 4, 5], [0, 1, 2], [6, 7, 8], [0, 4, 8], [6, 4, 2], [0, 3, 6], [1, 4, 7], [2, 5, 8]]);
        LINE_DEFINITIONS[LINE_9] = PaylineDef.Vector.<Array>([[5, 6, 7, 8, 9], [0, 1, 2, 3, 4], [10, 11, 12, 13, 14], [0, 6, 12, 8, 4], [10, 6, 2, 8, 14], [0, 1, 7, 3, 4], [10, 11, 7, 13, 14], [5, 1, 2, 3, 9], [5, 11, 12, 13, 9]]);
        LINE_DEFINITIONS[LINE_15] = PaylineDef.Vector.<Array>([[5, 6, 7, 8, 9], [0, 1, 2, 3, 4], [10, 11, 12, 13, 14], [0, 6, 12, 8, 4], [10, 6, 2, 8, 14], [5, 1, 2, 3, 9], [5, 11, 12, 13, 9], [0, 1, 7, 13, 14], [10, 11, 7, 3, 4], [5, 11, 7, 3, 9], [5, 1, 7, 13, 9], [0, 6, 7, 8, 4], [10, 6, 7, 8, 14], [0, 6, 2, 8, 4], [10, 6, 12, 8, 14]]);
        LINE_DEFINITIONS[LINE_20] = PaylineDef.Vector.<Array>([[5, 6, 7, 8, 9], [0, 1, 2, 3, 4], [10, 11, 12, 13, 14], [0, 6, 12, 8, 4], [10, 6, 2, 8, 14], [5, 1, 2, 3, 9], [5, 11, 12, 13, 9], [0, 1, 7, 13, 14], [10, 11, 7, 3, 4], [5, 11, 7, 3, 9], [5, 1, 7, 13, 9], [0, 6, 7, 8, 4], [10, 6, 7, 8, 14], [0, 6, 2, 8, 4], [10, 6, 12, 8, 14], [5, 6, 2, 8, 9], [5, 6, 12, 8, 9], [0, 1, 12, 3, 4], [10, 11, 2, 13, 14], [0, 11, 12, 13, 4]]);
        LINE_DEFINITIONS[LINE_25] = PaylineDef.Vector.<Array>([[5, 6, 7, 8, 9], [0, 1, 2, 3, 4], [10, 11, 12, 13, 14], [0, 6, 12, 8, 4], [10, 6, 2, 8, 14], [5, 1, 2, 3, 9], [5, 11, 12, 13, 9], [0, 1, 7, 13, 14], [10, 11, 7, 3, 4], [5, 11, 7, 3, 9], [5, 1, 7, 13, 9], [0, 6, 7, 8, 4], [10, 6, 7, 8, 14], [0, 6, 2, 8, 4], [10, 6, 12, 8, 14], [5, 6, 2, 8, 9], [5, 6, 12, 8, 9], [0, 1, 12, 3, 4], [10, 11, 2, 13, 14], [0, 11, 12, 13, 4], [10, 1, 2, 3, 14], [5, 11, 2, 13, 9], [5, 1, 12, 3, 9], [0, 11, 2, 13, 4], [10, 1, 12, 3, 14]]);
        LINE_DEFINITIONS[LINE_30] = PaylineDef.Vector.<Array>([[5, 6, 7, 8, 9], [0, 1, 2, 3, 4], [10, 11, 12, 13, 14], [0, 6, 12, 8, 4], [10, 6, 2, 8, 14], [5, 1, 2, 3, 9], [5, 11, 12, 13, 9], [0, 1, 7, 13, 14], [10, 11, 7, 3, 4], [5, 11, 7, 3, 9], [5, 1, 7, 13, 9], [0, 6, 7, 8, 4], [10, 6, 7, 8, 14], [0, 6, 2, 8, 4], [10, 6, 12, 8, 14], [5, 6, 2, 8, 9], [5, 6, 12, 8, 9], [0, 1, 12, 3, 4], [10, 11, 2, 13, 14], [0, 11, 12, 13, 4], [10, 1, 2, 3, 14], [5, 11, 2, 13, 9], [5, 1, 12, 3, 9], [0, 11, 2, 13, 4], [10, 1, 12, 3, 14], [0, 11, 7, 3, 14], [10, 1, 7, 13, 4], [5, 1, 12, 8, 14], [0, 11, 7, 13, 4], [10, 6, 2, 3, 9]]);
        LINE_DEFINITIONS[LINE_40] = PaylineDef.Vector.<Array>([[0, 1, 2, 3, 4], [5, 6, 7, 8, 9], [10, 11, 12, 13, 14], [15, 16, 17, 18, 19], [0, 1, 7, 3, 4], [5, 6, 12, 8, 9], [10, 11, 17, 13, 14], [15, 16, 12, 18, 19], [10, 11, 7, 13, 14], [5, 6, 2, 8, 9], [0, 6, 7, 8, 4], [5, 11, 12, 13, 9], [10, 16, 17, 18, 14], [15, 11, 12, 13, 19], [10, 6, 7, 8, 14], [5, 1, 2, 3, 9], [0, 6, 12, 8, 4], [15, 11, 7, 13, 19], [0, 6, 2, 8, 4], [5, 11, 7, 13, 9], [10, 16, 12, 18, 14], [15, 11, 17, 13, 19], [10, 6, 12, 8, 14], [5, 1, 7, 3, 9], [0, 1, 2, 8, 4], [5, 6, 7, 13, 9], [10, 11, 12, 18, 14], [15, 16, 17, 13, 19], [10, 11, 12, 8, 14], [5, 6, 7, 3, 9], [0, 6, 2, 3, 4], [5, 11, 7, 8, 9], [10, 16, 12, 13, 14], [15, 11, 17, 18, 19], [10, 6, 12, 13, 14], [5, 1, 7, 8, 9], [0, 1, 7, 8, 4], [15, 16, 12, 13, 19], [0, 6, 7, 3, 4], [15, 11, 12, 18, 19]]);
        LINE_DEFINITIONS[LINE_50] = PaylineDef.Vector.<Array>([[5, 6, 7, 8, 9], [10, 11, 12, 13, 14], [0, 1, 2, 3, 4], [15, 16, 17, 18, 19], [0, 6, 12, 8, 4], [15, 11, 7, 13, 19], [0, 1, 7, 3, 4], [15, 16, 12, 18, 19], [5, 6, 12, 8, 9], [10, 11, 7, 13, 14], [5, 6, 2, 8, 9], [10, 11, 17, 13, 19], [10, 6, 12, 8, 14], [5, 11, 7, 13, 9], [0, 6, 2, 8, 4], [15, 11, 17, 13, 19], [5, 1, 12, 8, 14], [0, 11, 7, 18, 19], [15, 16, 2, 8, 4], [15, 11, 2, 3, 4], [0, 1, 12, 13, 19], [15, 16, 7, 13, 9], [5, 11, 17, 18, 19], [10, 6, 2, 3, 4], [0, 1, 17, 8, 14], [10, 1, 2, 13, 19], [15, 11, 12, 13, 14], [0, 6, 7, 8, 9], [5, 1, 17, 8, 4], [15, 6, 12, 18, 14], [10, 16, 17, 18, 19], [5, 1, 2, 3, 4], [0, 6, 17, 3, 9], [10, 6, 7, 8, 9], [5, 11, 12, 13, 14], [10, 1, 7, 13, 9], [5, 6, 17, 13, 14], [10, 11, 2, 8, 9], [5, 16, 7, 13, 14], [10, 1, 12, 8, 9], [10, 1, 17, 8, 4], [0, 11, 2, 13, 14], [15, 6, 7, 8, 9], [5, 11, 2, 13, 19], [5, 16, 2, 13, 9], [5, 16, 12, 8, 9], [10, 16, 12, 8, 14], [10, 6, 17, 13, 14], [5, 1, 7, 13, 14], [10, 16, 2, 3, 9]]);
        ROW_DEFINITIONS[ROW_1] = new Vector.<Array>([[0, 1, 2]]);
        ROW_DEFINITIONS[ROW_3] = new Vector.<Array>([[0, 1, 2], [3, 4, 5], [6, 7, 8]]);
        ROW_DEFINITIONS[ROW_5] = new Vector.<Array>([[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14]]);
        ROW_DEFINITIONS[ROW_10] = new Vector.<Array>([[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14], [15, 16, 17], [18, 19, 20], [21, 22, 23], [24, 25, 26], [27, 28, 29]]);
    }
}
