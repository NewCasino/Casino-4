package com.playtech.casino3.utils
{
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.text.*;

    public class TextResize extends Object
    {
        private var m_tf:TextField;
        private var m_origX:Number;
        private var m_origY:Number;
        private var m_origW:Number;
        private var m_origF:int;
        private var m_origH:Number;
        private var m_map:Array;
        private var m_inc:Boolean;
        private static var m_fields:Vector.<FieldObject> = null;

        public function TextResize(param1:TextField, param2:Boolean = false)
        {
            this.m_tf = param1;
            this.m_origX = param1.x;
            this.m_origY = param1.y;
            this.m_origW = param1.width;
            this.m_origH = param1.height;
            this.m_origF = int(param1.getTextFormat().size);
            if (this.m_origF == 0)
            {
                this.m_origF = int(param1.defaultTextFormat.size);
            }
            param1.wordWrap = false;
            this.m_inc = param2;
            this.m_map = new Array();
            return;
        }// end function

        public function set htmlText(onRemove:String) : void
        {
            var _loc_5:int = 0;
            var _loc_2:* = this.m_tf.defaultTextFormat;
            switch(_loc_2.align)
            {
                case TextFieldAutoSize.LEFT:
                {
                    this.m_tf.autoSize = TextFieldAutoSize.LEFT;
                    break;
                }
                case TextFieldAutoSize.RIGHT:
                {
                    this.m_tf.autoSize = TextFieldAutoSize.RIGHT;
                    break;
                }
                default:
                {
                    this.m_tf.autoSize = TextFieldAutoSize.CENTER;
                    break;
                    break;
                }
            }
            var _loc_3:* = this.m_inc;
            var _loc_4:Boolean = true;
            if (this.m_map[onRemove] != null || onRemove == "")
            {
                var _loc_7:* = this.m_map[onRemove];
                _loc_5 = this.m_map[onRemove];
                _loc_2.size = _loc_7;
                _loc_3 = false;
                _loc_4 = false;
            }
            else
            {
                var _loc_7:* = this.m_origF;
                _loc_5 = this.m_origF;
                _loc_2.size = _loc_7;
            }
            this.m_tf.defaultTextFormat = _loc_2;
            this.m_tf.text = onRemove;
            while (_loc_3)
            {
                
                if (this.m_tf.width > this.m_origW || this.m_tf.height > this.m_origH)
                {
                    _loc_3 = false;
                    if (_loc_5 != this.m_origF)
                    {
                        _loc_4 = false;
                        _loc_2.size = _loc_5 - 1;
                        this.m_tf.defaultTextFormat = _loc_2;
                    }
                    continue;
                }
                _loc_5 = --_loc_5 + 1;
                _loc_2.size = --_loc_5 + 1;
                this.m_tf.defaultTextFormat = _loc_2;
                this.m_tf.text = onRemove;
            }
            while (_loc_4)
            {
                
                if (_loc_5 <= 5)
                {
                    break;
                }
                if (this.m_tf.width > this.m_origW || this.m_tf.height > this.m_origH)
                {
                    _loc_2.size = _loc_5 - 1;
                    this.m_tf.defaultTextFormat = _loc_2;
                    this.m_tf.text = onRemove;
                    continue;
                }
                _loc_4 = false;
            }
            this.m_tf.y = this.m_origY + this.m_origH / 2 - this.m_tf.height / 2;
            this.m_tf.autoSize = TextFieldAutoSize.NONE;
            var _loc_6:* = this.m_origY + this.m_origH;
            this.m_tf.height = this.m_tf.height + (_loc_6 - (this.m_tf.y + this.m_tf.height));
            this.m_map[onRemove] = _loc_5 - 1;
            return;
        }// end function

        public function getTextField() : TextField
        {
            return this.m_tf;
        }// end function

        public function dispose() : void
        {
            this.m_map = null;
            this.m_tf = null;
            return;
        }// end function

        public static function setMinSize(onRemove:Vector.<TextField>, onRemove:Boolean = false) : void
        {
            var _loc_3:int = 0;
            var _loc_5:TextFormat = null;
            var _loc_6:Number = NaN;
            var _loc_7:TextField = null;
            var _loc_8:Number = NaN;
            var _loc_4:* = Number.MAX_VALUE;
            _loc_3 = 0;
            while (_loc_3 < onRemove.length)
            {
                
                _loc_5 = onRemove[_loc_3].getTextFormat();
                _loc_6 = Number(_loc_5.size);
                _loc_4 = Math.min(_loc_4, _loc_6);
                _loc_3++;
            }
            _loc_3 = 0;
            while (_loc_3 < onRemove.length)
            {
                
                _loc_5 = onRemove[_loc_3].getTextFormat();
                _loc_5.size = _loc_4;
                _loc_7 = onRemove[_loc_3];
                _loc_8 = _loc_7.y + _loc_7.getLineMetrics(0).ascent;
                _loc_7.setTextFormat(_loc_5);
                if (onRemove)
                {
                    _loc_7.y = _loc_8 - _loc_7.getLineMetrics(0).ascent;
                }
                _loc_3++;
            }
            return;
        }// end function

        public static function setTextFixY(onRemove:TextField, onRemove:String, onRemove:Function = null) : void
        {
            var _loc_4:* = onRemove.y + onRemove.getLineMetrics(0).ascent;
            setText(onRemove, onRemove);
            onRemove.y = _loc_4 - onRemove.getLineMetrics(0).ascent;
            return;
        }// end function

        public static function onRemove(event:Event) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_2:* = event.target as TextField;
            _loc_4 = m_fields.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                if (m_fields[_loc_3].equals(_loc_2))
                {
                    _loc_2.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
                    m_fields.splice(_loc_3, 1);
                    return;
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        public static function setText(onRemove:TextField, onRemove:String, onRemove:Boolean = false) : void
        {
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            var _loc_6:Boolean = false;
            var _loc_7:FieldObject = null;
            var _loc_8:TextFormat = null;
            var _loc_9:Number = NaN;
            if (m_fields == null)
            {
                m_fields = new Vector.<FieldObject>;
            }
            _loc_5 = m_fields.length;
            _loc_6 = true;
            _loc_4 = 0;
            while (_loc_4 < _loc_5)
            {
                
                _loc_7 = m_fields[_loc_4];
                if (_loc_7.equals(onRemove))
                {
                    _loc_6 = false;
                    break;
                }
                _loc_4 = _loc_4 + 1;
            }
            if (_loc_6)
            {
                _loc_7 = new FieldObject(onRemove);
                m_fields.unshift(_loc_7);
                onRemove.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
            }
            else
            {
                _loc_8 = onRemove.getTextFormat();
                _loc_8.size = _loc_7.f;
                onRemove.setTextFormat(_loc_8);
            }
            onRemove.autoSize = TextFieldAutoSize.LEFT;
            onRemove.text = onRemove;
            onRemove.y = _loc_7.y;
            var _loc_10:* = _loc_7.w;
            if (onRemove.width <= _loc_10)
            {
                onRemove.autoSize = TextFieldAutoSize.NONE;
                onRemove.width = _loc_10;
                onRemove.height = onRemove.height * 1.3;
                return;
            }
            _loc_8 = onRemove.getTextFormat();
            if (_loc_8.size == null)
            {
                _loc_9 = 12;
            }
            else
            {
                _loc_9 = Number(_loc_8.size);
            }
            while (onRemove.width > _loc_10)
            {
                
                _loc_9 = _loc_9 - 0.5;
                if (_loc_9 <= 8)
                {
                    _loc_9 = 8;
                    onRemove = onRemove.substr(0, (onRemove.length - 1));
                    onRemove.text = onRemove + "...";
                }
                _loc_8.size = _loc_9;
                onRemove.setTextFormat(_loc_8);
                if (onRemove)
                {
                    onRemove.defaultTextFormat = _loc_8;
                }
            }
            if (onRemove.width <= _loc_10)
            {
                onRemove.autoSize = TextFieldAutoSize.NONE;
                onRemove.width = _loc_10;
                onRemove.y = onRemove.y + (_loc_7.h - onRemove.height) / 2;
                onRemove.height = onRemove.height * 1.3;
                return;
            }
            return;
        }// end function

    }
}
