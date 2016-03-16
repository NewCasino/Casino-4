package com.playtech.casino3.utils
{
    import flash.display.*;
    import flash.filters.*;
    import flash.utils.*;

    public class Card extends MovieClip
    {
        private var m_isBack:Boolean;
        private var m_cardBackGfxDefPrefix:String;
        private var m_gfxDefPrefix:String;
        private var m_value:int;
        private var m_suit:int;
        private var m_shadow:Sprite;
        private var m_cardGfx:MovieClip;

        public function Card(param1:int = -1, param2:int = -1, param3:Boolean = true, param4:String = "tablecommon.", param5:String = null)
        {
            this.m_suit = param1;
            this.m_value = param2;
            this.m_isBack = param3;
            this.m_gfxDefPrefix = param4;
            if (param5 == null)
            {
                this.m_cardBackGfxDefPrefix = this.m_gfxDefPrefix;
            }
            else
            {
                this.m_cardBackGfxDefPrefix = param5;
            }
            if (param1 == EnumCard.NOT_SET || param2 == EnumCard.NOT_SET)
            {
                this.m_isBack = true;
            }
            this.showGfx();
            this.createShadow();
            return;
        }// end function

        public function remove() : void
        {
            this.clearGfx();
            if (this.m_shadow != null)
            {
                if (this.m_shadow.parent != null)
                {
                    this.m_shadow.parent.removeChild(this.m_shadow);
                }
                this.m_shadow = null;
            }
            return;
        }// end function

        public function getGfx(com.playtech.casino3.utils:Card/Card:int) : MovieClip
        {
            var _loc_2:String = null;
            var _loc_3:MovieClip = null;
            if (com.playtech.casino3.utils:Card/Card == EnumCard.GFX_FRONT)
            {
                _loc_2 = this.m_gfxDefPrefix + "card" + this.m_suit + this.m_value;
            }
            else
            {
                _loc_2 = this.m_cardBackGfxDefPrefix + "cardback";
            }
            var _loc_4:* = getDefinitionByName(_loc_2) as Class;
            if (_loc_4 != null)
            {
                _loc_3 = new _loc_4 as MovieClip;
            }
            return _loc_3;
        }// end function

        public function showGfx() : void
        {
            var _loc_1:int = 0;
            if (this.m_isBack || this.m_suit == EnumCard.NOT_SET || this.m_value == EnumCard.NOT_SET)
            {
                _loc_1 = EnumCard.GFX_BACK;
            }
            else
            {
                _loc_1 = EnumCard.GFX_FRONT;
            }
            this.clearGfx();
            this.m_cardGfx = this.getGfx(_loc_1);
            return;
        }// end function

        public function get suit() : int
        {
            return this.m_suit;
        }// end function

        public function toHistoryString() : String
        {
            return EnumCard.convertToHistoryString(this.m_suit, this.m_value);
        }// end function

        public function getBjValue() : int
        {
            return EnumCard.getBjValue(this.m_value);
        }// end function

        private function createShadow() : void
        {
            this.m_shadow = new Sprite();
            this.m_shadow.graphics.beginFill(0, 0.6);
            this.m_shadow.graphics.drawRect((-this.width) / 2, (-this.height) / 2, this.width, this.height);
            this.m_shadow.graphics.endFill();
            var _loc_1:* = new BlurFilter(20, 20, 1);
            this.m_shadow.filters = [_loc_1];
            return;
        }// end function

        public function getShadow() : Sprite
        {
            return this.m_shadow;
        }// end function

        public function changeCardBackPrefix(int:String) : void
        {
            this.m_cardBackGfxDefPrefix = int;
            return;
        }// end function

        public function set suit(int:int) : void
        {
            this.m_suit = int;
            return;
        }// end function

        public function set value(int:int) : void
        {
            this.m_value = int;
            return;
        }// end function

        private function clearGfx() : void
        {
            if (this.m_cardGfx != null)
            {
                this.removeChild(this.m_cardGfx);
                this.m_cardGfx = null;
            }
            return;
        }// end function

        public function flip(int:Number = 0, int:Number = 0, int:Number = 0) : void
        {
            if (this.m_suit == EnumCard.NOT_SET || this.m_value == EnumCard.NOT_SET)
            {
                this.m_isBack = true;
                this.showGfx();
            }
            else
            {
                this.m_isBack = !this.m_isBack;
                this.showGfx();
                if (int != 0 && int % 180 == 0)
                {
                    this.m_cardGfx.scaleX = 1 + 360 / int;
                }
                if (int != 0 && int % 180 == 0)
                {
                    this.m_cardGfx.scaleY = 1 + 360 / int;
                }
            }
            return;
        }// end function

        public function get value() : int
        {
            return this.m_value;
        }// end function

        public function flipBack() : void
        {
            if (this.m_isBack == false)
            {
                this.flip();
            }
            else
            {
                this.showGfx();
            }
            return;
        }// end function

        public function isBack() : Boolean
        {
            return this.m_isBack;
        }// end function

        override public function toString() : String
        {
            return "[Card " + EnumCard.convertToString(this.m_suit, this.m_value) + " " + (this.m_isBack ? ("back") : ("front")) + "]";
        }// end function

        public function flipFront() : void
        {
            if (this.m_isBack)
            {
                this.flip();
            }
            else
            {
                this.showGfx();
            }
            return;
        }// end function

    }
}
