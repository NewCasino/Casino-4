package com.playtech.casino3.table
{
    import com.playtech.casino3.utils.*;

    public class Deck extends Object
    {
        private var m_deckCount:uint;
        private var m_deck:Array;

        public function Deck(param1:uint = 1)
        {
            this.m_deck = [];
            this.m_deckCount = param1;
            return;
        }// end function

        public function setCards(uint:Array) : void
        {
            this.m_deck = uint.slice();
            return;
        }// end function

        public function giveCard() : String
        {
            if (this.m_deck.length == 0)
            {
                this.makeDeck();
            }
            var _loc_1:* = Math.round(Math.random() * (this.m_deck.length - 1));
            var _loc_2:* = this.m_deck.splice(_loc_1, 1)[0];
            return _loc_2;
        }// end function

        public function makeDeck(uint:uint = 0) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            this.m_deck = [];
            var _loc_2:uint = 0;
            while (_loc_2 < this.m_deckCount)
            {
                
                _loc_3 = uint;
                _loc_4 = 0;
                while (_loc_4 < 4)
                {
                    
                    _loc_5 = 0;
                    while (_loc_5 < 13)
                    {
                        
                        this.m_deck.push(_loc_4 + EnumCard.FS + _loc_5);
                        _loc_5 = _loc_5 + 1;
                    }
                    if (_loc_3 > 0)
                    {
                        this.m_deck.push(_loc_4 + EnumCard.FS + EnumCard.VAL_JOKER);
                        _loc_3 = _loc_3 - 1;
                    }
                    _loc_4 = _loc_4 + 1;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function clone() : Deck
        {
            var _loc_1:* = new Deck(this.m_deckCount);
            _loc_1.setCards(this.m_deck);
            return _loc_1;
        }// end function

        public function dispose() : void
        {
            this.m_deck = null;
            return;
        }// end function

    }
}
