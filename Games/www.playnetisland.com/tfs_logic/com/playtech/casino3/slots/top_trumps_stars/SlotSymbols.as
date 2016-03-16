package com.playtech.casino3.slots.top_trumps_stars
{
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.slot_symbols.*;

    public class SlotSymbols extends BaseSlotSymbols
    {
        protected var _state:GameState;
        protected var _logic:Logic;

        public function SlotSymbols(Flag_1:Logic) : void
        {
            this._logic = Flag_1;
            STATIC_SYMBOLS_PACKAGE = "symbols.static";
            VIDEO_SYMBOLS_PACKAGE = "symbols.videos";
            SOUND_SYMBOLS_PACKAGE = "symbols.sounds";
            pushSymbol(Wild.symbol);
            pushSymbol(Team_1_Player_1.symbol);
            pushSymbol(Team_2_Player_1.symbol);
            pushSymbol(Team_1_Player_2.symbol);
            pushSymbol(Team_2_Player_2.symbol);
            pushSymbol(Team_1_Player_3.symbol);
            pushSymbol(Team_2_Player_3.symbol);
            pushSymbol(A.symbol);
            pushSymbol(K.symbol);
            pushSymbol(Q.symbol);
            pushSymbol(J.symbol);
            pushSymbol(Ten.symbol);
            pushSymbol(Nine.symbol);
            pushSymbol(Flag_1.symbol);
            pushSymbol(Flag_2.symbol);
            pushSymbol(Ball.symbol);
            pushSymbol(Scatter.symbol);
            pushSymbol(MixedTeam_1.symbol);
            pushSymbol(MixedTeam_2.symbol);
            this.state = GameState.NORMAL;
            return;
        }// end function

        protected function stateNeutralParameters() : void
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            Wild.symbol.winvideo = "wild_substitute";
            Team_1_Player_1.symbol.winvideo = "highlight";
            Team_1_Player_2.symbol.winvideo = "highlight";
            Team_1_Player_3.symbol.winvideo = "highlight";
            Team_2_Player_1.symbol.winvideo = "highlight";
            Team_2_Player_2.symbol.winvideo = "highlight";
            Team_2_Player_3.symbol.winvideo = "highlight";
            Ball.symbol.winvideo = "ball";
            var _loc_1:* = SubstituentSubType.EXACTLY_THE_SAME;
            var _loc_2:* = SubstituentSubType.SUBSTITUTES;
            Team_1_Player_1.symbol.addTypedSubstituents(Wild, _loc_1);
            Team_1_Player_2.symbol.addTypedSubstituents(Wild, _loc_1);
            Team_1_Player_3.symbol.addTypedSubstituents(Wild, _loc_1);
            Team_2_Player_1.symbol.addTypedSubstituents(Wild, _loc_1);
            Team_2_Player_2.symbol.addTypedSubstituents(Wild, _loc_1);
            Team_2_Player_3.symbol.addTypedSubstituents(Wild, _loc_1);
            A.symbol.addTypedSubstituents(Wild, _loc_1);
            K.symbol.addTypedSubstituents(Wild, _loc_1);
            Q.symbol.addTypedSubstituents(Wild, _loc_1);
            J.symbol.addTypedSubstituents(Wild, _loc_1);
            Ten.symbol.addTypedSubstituents(Wild, _loc_1);
            Nine.symbol.addTypedSubstituents(Wild, _loc_1);
            MixedTeam_1.symbol.addTypedSubstituents(Team_1_Player_1, _loc_2, Team_1_Player_2, _loc_2, Team_1_Player_3, _loc_2);
            MixedTeam_2.symbol.addTypedSubstituents(Team_2_Player_1, _loc_2, Team_2_Player_2, _loc_2, Team_2_Player_3, _loc_2);
            _loc_3 = STATIC_SYMBOLS_PACKAGE + "." + this._logic.country_1.type.toLowerCase() + ".";
            _loc_4 = STATIC_SYMBOLS_PACKAGE + "." + this._logic.country_2.type.toLowerCase() + ".";
            var _loc_5:* = _loc_3 + "players.";
            var _loc_6:* = _loc_4 + "players.";
            Wild.symbol.image = "wild";
            Team_2_Player_1.symbol.image = _loc_6 + "player_1";
            Team_2_Player_2.symbol.image = _loc_6 + "player_2";
            Team_2_Player_3.symbol.image = _loc_6 + "player_3";
            A.symbol.image = "a";
            K.symbol.image = "k";
            Q.symbol.image = "q";
            J.symbol.image = "j";
            Ten.symbol.image = "ten";
            Nine.symbol.image = "nine";
            Flag_1.symbol.image = _loc_3 + "flag";
            Flag_2.symbol.image = _loc_4 + "flag";
            Ball.symbol.image = "ball";
            Scatter.symbol.image = "scatter";
            return;
        }// end function

        public function get state() : GameState
        {
            return this._state;
        }// end function

        protected function stateFreeGame() : void
        {
            var _loc_1:* = STATIC_SYMBOLS_PACKAGE + "." + this._logic.freegames_country.type.toLowerCase() + ".players.";
            this.setTeam1Images(_loc_1);
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._state = null;
            this._logic = null;
            return;
        }// end function

        public function set state(Flag_1:GameState) : void
        {
            this._state = Flag_1;
            clearSymbols();
            this.stateNeutralParameters();
            if (this._state == GameState.NORMAL)
            {
                return this.stateNormalGame();
            }
            if (this._state == GameState.FREESPIN)
            {
                return this.stateFreeGame();
            }
            return;
        }// end function

        protected function setTeam1Images(Flag_1:String) : void
        {
            Team_1_Player_1.symbol.image = Flag_1 + "player_1";
            Team_1_Player_2.symbol.image = Flag_1 + "player_2";
            Team_1_Player_3.symbol.image = Flag_1 + "player_3";
            return;
        }// end function

        protected function stateNormalGame() : void
        {
            var _loc_1:* = STATIC_SYMBOLS_PACKAGE + "." + this._logic.country_1.type.toLowerCase() + ".players.";
            this.setTeam1Images(_loc_1);
            return;
        }// end function

    }
}
