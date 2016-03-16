package com.playtech.casino3.slots.top_trumps_stars
{
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.slots.shared.novel.promo.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.slot_symbols.*;
    import flash.display.*;
    import flash.events.*;

    dynamic class Promo extends Object implements IDisposable
    {
        protected var _promo:PromoArea;
        protected var _state:GameState;
        protected var _promo_display:DisplayObjectContainer;
        const FIRST_REEL_INDEX:int = 0;
        protected var _logic:Logic;
        const LAST_REEL_INDEX:int = 4;
        protected const speed_devisor:int = 1;
        protected var _promo_display_object:DisplayObjectContainer;

        function Promo(param1:Logic, param2:PromoArea)
        {
            this._logic = param1;
            this._promo = param2;
            this._promo_display_object = this._promo.getArea();
            this._promo_display_object.addEventListener(PromoEnum.PROMO_VISIBLE, this.onPromoChange);
            return;
        }// end function

        public function onPromoChange(event:Event = null) : void
        {
            if (!this._promo_display_object || this._promo_display_object.numChildren == 0)
            {
                return;
            }
            this._promo_display = this._promo_display_object.getChildAt(0) as MovieClip;
            this.setStateCountry1("flag_1");
            this.setStateCountry2("flag_2");
            this.setStateCountry1("country_1");
            this.setStateCountry2("country_2");
            return;
        }// end function

        protected function setStateCountry(PromoArea:String, PromoArea:Country) : void
        {
            if (!this._promo_display)
            {
                return;
            }
            var _loc_3:* = this._promo_display.getChildByName(PromoArea) as MovieClip;
            if (!_loc_3)
            {
                return;
            }
            _loc_3 = _loc_3.getChildAt(0) as MovieClip;
            if (!_loc_3)
            {
                return;
            }
            _loc_3.gotoAndStop(PromoArea.type);
            return;
        }// end function

        protected function setStateCountry1(PromoArea:String) : void
        {
            this.setStateCountry(PromoArea, this._logic.country_1);
            return;
        }// end function

        protected function setStateCountry2(PromoArea:String) : void
        {
            this.setStateCountry(PromoArea, this._logic.country_2);
            return;
        }// end function

        public function eventMessage(PromoArea:String, PromoArea:int) : void
        {
            this._promo.eventMessage(GameParameters.shortname + ".promo." + PromoArea, PromoArea / this.speed_devisor);
            return;
        }// end function

        public function get state() : GameState
        {
            return this._state;
        }// end function

        protected function promosNormalGame() : void
        {
            this.addMessage("logo", PromoEnum.TIME_LONG_MAIN);
            this.addMessage("wild_5x_pays_10000x_line_bet", PromoEnum.TIME_LONG_OTHER);
            this.addMessage("logo", PromoEnum.TIME_LONG_MAIN);
            this.addMessage("mixed_pay_for_players_from_the_same_team", PromoEnum.TIME_LONG_OTHER);
            this.addMessage("logo", PromoEnum.TIME_LONG_MAIN);
            this.addMessage("bonus_country_1_wins_free_games", PromoEnum.TIME_LONG_OTHER);
            this.addMessage("logo", PromoEnum.TIME_LONG_MAIN);
            this.addMessage("bonus_country_2_wins_free_games", PromoEnum.TIME_LONG_OTHER);
            return;
        }// end function

        public function set state(PromoArea:GameState) : void
        {
            this._promo.empty();
            this._promo.reset();
            this._state = PromoArea;
            if (this._state == GameState.NORMAL)
            {
                this.promosNormalGame();
            }
            if (this._state == GameState.FREESPIN)
            {
                this.promosFreeGame();
            }
            return;
        }// end function

        public function checkForEventDrivenMessages(PromoArea:RoundInfo) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = PromoArea.wins;
            var _loc_4:* = this._state == GameState.NORMAL ? (PromoEnum.TIME_LONG_OTHER) : (PromoEnum.TIME_SHORT_OTHER);
            var _loc_5:* = PromoArea.reelSymbols.symbols;
            if (_loc_2.hasInWinsKindOf(5))
            {
                return;
            }
            if (_loc_5.reelContains(Flag_1.symbol, this.FIRST_REEL_INDEX) && !_loc_5.reelContains(Flag_1.symbol, this.LAST_REEL_INDEX))
            {
                _loc_3 = "bonus_country_1_wins_free_games";
            }
            else if (_loc_5.reelContains(Flag_2.symbol, this.FIRST_REEL_INDEX) && !_loc_5.reelContains(Flag_2.symbol, this.LAST_REEL_INDEX))
            {
                _loc_3 = "bonus_country_2_wins_free_games";
            }
            else
            {
                return;
            }
            this.eventMessage(_loc_3, _loc_4);
            return;
        }// end function

        public function addMessage(PromoArea:String, PromoArea:int) : void
        {
            this._promo.addMessage(GameParameters.shortname + ".promo." + PromoArea, PromoArea / this.speed_devisor);
            return;
        }// end function

        public function dispose() : void
        {
            if (this._promo_display_object)
            {
                this._promo_display_object.removeEventListener(PromoEnum.PROMO_VISIBLE, this.onPromoChange);
            }
            this._logic = null;
            this._promo = null;
            this._state = null;
            this._promo_display_object = null;
            this._promo_display = null;
            return;
        }// end function

        protected function promosFreeGame() : void
        {
            var _loc_1:String = "free_spins_logo";
            this.addMessage(_loc_1, PromoEnum.TIME_SHORT_MAIN);
            return;
        }// end function

    }
}
