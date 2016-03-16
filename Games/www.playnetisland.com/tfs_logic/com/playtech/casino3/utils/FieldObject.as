package com.playtech.casino3.utils
{
    import flash.text.*;

    public class FieldObject extends Object
    {
        private var m_w:int;
        private var m_x:int;
        private var m_y:int;
        private var m_field:TextField;
        private var m_f:Object;
        private var m_h:int;

        public function FieldObject(param1:TextField)
        {
            this.m_field = param1;
            this.m_x = param1.x;
            this.m_y = param1.y;
            this.m_w = param1.width;
            param1.autoSize = TextFieldAutoSize.LEFT;
            param1.text = "|";
            this.m_h = param1.height;
            param1.autoSize = TextFieldAutoSize.NONE;
            param1.width = this.m_w;
            if (param1.defaultTextFormat.size == null)
            {
                this.m_f = 12;
            }
            else
            {
                this.m_f = Number(param1.defaultTextFormat.size);
            }
            this.m_f = Number(this.m_f) * param1.scaleY;
            var _loc_2:int = 1;
            param1.scaleY = 1;
            param1.scaleX = _loc_2;
            param1.width = this.m_w;
            param1.height = this.m_h;
            param1.x = this.m_x;
            param1.y = this.m_y;
            param1.multiline = false;
            param1.wordWrap = false;
            return;
        }// end function

        public function get h() : int
        {
            return this.m_h;
        }// end function

        public function get f() : Object
        {
            return this.m_f;
        }// end function

        public function get w() : int
        {
            return this.m_w;
        }// end function

        public function get x() : int
        {
            return this.m_x;
        }// end function

        public function get y() : int
        {
            return this.m_y;
        }// end function

        public function toString() : String
        {
            return "TextField dummy";
        }// end function

        public function equals(Number:TextField) : Boolean
        {
            if (Number == this.m_field)
            {
                return true;
            }
            return false;
        }// end function

    }
}
