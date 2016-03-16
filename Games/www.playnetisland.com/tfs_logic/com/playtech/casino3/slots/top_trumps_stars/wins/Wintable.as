package com.playtech.casino3.slots.top_trumps_stars.wins
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip.*;
    import com.playtech.casino3.slots.shared.utils.*;
    import com.playtech.casino3.slots.top_trumps_stars.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.slot_symbols.*;
    import com.playtech.casino3.slots.top_trumps_stars.wins.anims.*;
    import com.playtech.casino3.slots.top_trumps_stars.wins.enum.*;
    import flash.utils.*;

    dynamic public class Wintable extends BaseWintable
    {
        protected const SCATTER_FRAME_ID:int = 13;
        protected var _state:GameState;
        protected const SOUND_PACKAGE_PREFIX:String;
        protected var _logic:Logic;
        var RANDOM_ANIMATION:Dictionary;
        protected const VIDEO_PACKAGE_PREFIX:String;
        var RANDOM_SOUND:Dictionary;
        var extra_win_table:Wintable;

        public function Wintable(Dictionary:Logic = null) : void
        {
            this.VIDEO_PACKAGE_PREFIX = BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE + ".";
            this.SOUND_PACKAGE_PREFIX = BaseSlotSymbols.SOUND_SYMBOLS_PACKAGE + ".";
            this.RANDOM_ANIMATION = new Dictionary();
            this.RANDOM_SOUND = new Dictionary();
            this._logic = Dictionary;
            if (Dictionary)
            {
                this.extra_win_table = new Wintable();
            }
            return;
        }// end function

        public function resetRandomParameters() : void
        {
            this.RANDOM_ANIMATION = new Dictionary();
            this.RANDOM_SOUND = new Dictionary();
            return;
        }// end function

        protected function gameSpecificNormalWinTable() : void
        {
            var slot_win:SlotsWin;
            var flag_video_1:* = function () : String
            {
                return BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE + ".flags." + _logic.country_1.type.toLowerCase();
            }// end function
            ;
            var flag_video_2:* = function () : String
            {
                return BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE + ".flags." + _logic.country_2.type.toLowerCase();
            }// end function
            ;
            var WIN_PARAMETERS_FLAG_1:* = new TextSubstitutions();
            var WIN_PARAMETERS_FLAG_2:* = new TextSubstitutions();
            WIN_PARAMETERS_FLAG_1.vid = flag_video_1;
            WIN_PARAMETERS_FLAG_2.vid = flag_video_2;
            var _loc_2:String = "novel_infobar_freegames";
            WIN_PARAMETERS_FLAG_1.statusKey = "novel_infobar_freegames";
            WIN_PARAMETERS_FLAG_2.statusKey = _loc_2;
            var _loc_2:* = new TextSubstitutions(WinAnimBase.X, null, WinAnimBase.W, null, WinAnimBase.TW, null);
            WIN_PARAMETERS_FLAG_1.statusMap = new TextSubstitutions(WinAnimBase.X, null, WinAnimBase.W, null, WinAnimBase.TW, null);
            WIN_PARAMETERS_FLAG_2.statusMap = _loc_2;
            var FIRST_LAST_REEL_RESTRICTION:* = this.Vector.<Vector.<int>>([this.Vector.<int>([0, 4]), this.Vector.<int>([0, 9]), this.Vector.<int>([0, 14]), this.Vector.<int>([5, 4]), this.Vector.<int>([5, 9]), this.Vector.<int>([5, 14]), this.Vector.<int>([10, 4]), this.Vector.<int>([10, 9]), this.Vector.<int>([10, 14])]);
            slot_win = this.pushRule(Flag_1, 2, 0, BonusAnim, WIN_PARAMETERS_FLAG_1, SlotWinRule.FIXED_INDEXES, WinsSpecial.FREE_GAMES, null, FIRST_LAST_REEL_RESTRICTION);
            slot_win = this.pushRule(Flag_2, 2, 0, BonusAnim, WIN_PARAMETERS_FLAG_2, SlotWinRule.FIXED_INDEXES, WinsSpecial.FREE_GAMES, null, FIRST_LAST_REEL_RESTRICTION);
            return;
        }// end function

        protected function gameSpecificWinTable() : void
        {
            if (this._state == GameState.NORMAL)
            {
                this.gameSpecificNormalWinTable();
            }
            if (this._state == GameState.FREESPIN)
            {
                this.gameSpecificFreeSpinWinTable();
            }
            return;
        }// end function

        protected function freeGamesLineSpecificWinTableCountry1() : void
        {
            this.normalGameLineSpecificWinTableCountry1();
            this.extra_win_table.pushRule(Team_1_Player_1, 4, 500, ThemeAnim, this.getThemeParameters(Team_1_Player_1), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_1_Player_1, 3, 100, ThemeAnim, this.getThemeParameters(Team_1_Player_1), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_1_Player_1, 2, 5, ThemeAnim, this.getThemeParameters(Team_1_Player_1), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_1_Player_2, 4, 250, ThemeAnim, this.getThemeParameters(Team_1_Player_2), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_1_Player_2, 3, 75, ThemeAnim, this.getThemeParameters(Team_1_Player_2), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_1_Player_2, 2, 5, ThemeAnim, this.getThemeParameters(Team_1_Player_2), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_1_Player_3, 4, 125, ThemeAnim, this.getThemeParameters(Team_1_Player_3), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_1_Player_3, 3, 50, ThemeAnim, this.getThemeParameters(Team_1_Player_3), SlotWinRule.RIGHT_CONSECUTIVE);
            var _loc_1:* = this.getThemeParameters();
            this.extra_win_table.pushRule(MixedTeam_1, 4, 60, ThemeAnim, _loc_1, SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(MixedTeam_1, 3, 10, ThemeAnim, _loc_1, SlotWinRule.RIGHT_CONSECUTIVE);
            return;
        }// end function

        protected function freeGamesLineSpecificWinTableCountry2() : void
        {
            this.normalGameLineSpecificWinTableCountry2();
            this.extra_win_table.pushRule(Team_2_Player_1, 4, 500, ThemeAnim, this.getThemeParameters(Team_2_Player_1), SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_1, 3, 100, ThemeAnim, this.getThemeParameters(Team_2_Player_1), SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_1, 2, 5, ThemeAnim, this.getThemeParameters(Team_2_Player_1), SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_2, 4, 250, ThemeAnim, this.getThemeParameters(Team_2_Player_2), SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_2, 3, 75, ThemeAnim, this.getThemeParameters(Team_2_Player_2), SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_2, 2, 5, ThemeAnim, this.getThemeParameters(Team_2_Player_2), SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_3, 4, 125, ThemeAnim, this.getThemeParameters(Team_2_Player_3), SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_3, 3, 50, ThemeAnim, this.getThemeParameters(Team_2_Player_3), SlotWinRule.LEFT_CONSECUTIVE);
            var _loc_1:* = this.getThemeParameters();
            this.extra_win_table.pushRule(MixedTeam_2, 4, 60, ThemeAnim, _loc_1, SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(MixedTeam_2, 3, 10, ThemeAnim, _loc_1, SlotWinRule.LEFT_CONSECUTIVE);
            return;
        }// end function

        protected function normalGameLineSpecificWinTableCountry1() : void
        {
            this.pushRule(Team_1_Player_1, 5, 5000, ThemeAnim, this.getThemeParameters(Team_1_Player_1));
            this.pushRule(Team_1_Player_1, 4, 500, ThemeAnim, this.getThemeParameters(Team_1_Player_1), SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Team_1_Player_1, 3, 100, ThemeAnim, this.getThemeParameters(Team_1_Player_1), SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Team_1_Player_1, 2, 5, ThemeAnim, this.getThemeParameters(Team_1_Player_1), SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Team_1_Player_2, 5, 1000, ThemeAnim, this.getThemeParameters(Team_1_Player_2));
            this.pushRule(Team_1_Player_2, 4, 250, ThemeAnim, this.getThemeParameters(Team_1_Player_2), SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Team_1_Player_2, 3, 75, ThemeAnim, this.getThemeParameters(Team_1_Player_2), SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Team_1_Player_2, 2, 5, ThemeAnim, this.getThemeParameters(Team_1_Player_2), SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Team_1_Player_3, 5, 500, ThemeAnim, this.getThemeParameters(Team_1_Player_3));
            this.pushRule(Team_1_Player_3, 4, 125, ThemeAnim, this.getThemeParameters(Team_1_Player_3), SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Team_1_Player_3, 3, 50, ThemeAnim, this.getThemeParameters(Team_1_Player_3), SlotWinRule.LEFT_CONSECUTIVE);
            var _loc_1:* = this.getThemeParameters();
            this.pushRule(MixedTeam_1, 5, 120, ThemeAnim, _loc_1);
            this.pushRule(MixedTeam_1, 4, 60, ThemeAnim, _loc_1, SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(MixedTeam_1, 3, 10, ThemeAnim, _loc_1, SlotWinRule.LEFT_CONSECUTIVE);
            return;
        }// end function

        protected function normalGameLineSpecificWinTableCountry2() : void
        {
            this.extra_win_table.pushRule(Team_2_Player_1, 5, 5000, ThemeAnim, this.getThemeParameters(Team_2_Player_1));
            this.extra_win_table.pushRule(Team_2_Player_1, 4, 500, ThemeAnim, this.getThemeParameters(Team_2_Player_1), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_1, 3, 100, ThemeAnim, this.getThemeParameters(Team_2_Player_1), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_1, 2, 5, ThemeAnim, this.getThemeParameters(Team_2_Player_1), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_2, 5, 1000, ThemeAnim, this.getThemeParameters(Team_2_Player_2));
            this.extra_win_table.pushRule(Team_2_Player_2, 4, 250, ThemeAnim, this.getThemeParameters(Team_2_Player_2), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_2, 3, 75, ThemeAnim, this.getThemeParameters(Team_2_Player_2), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_2, 2, 5, ThemeAnim, this.getThemeParameters(Team_2_Player_2), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_3, 5, 500, ThemeAnim, this.getThemeParameters(Team_2_Player_3));
            this.extra_win_table.pushRule(Team_2_Player_3, 4, 125, ThemeAnim, this.getThemeParameters(Team_2_Player_3), SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Team_2_Player_3, 3, 50, ThemeAnim, this.getThemeParameters(Team_2_Player_3), SlotWinRule.RIGHT_CONSECUTIVE);
            var _loc_1:* = this.getThemeParameters();
            this.extra_win_table.pushRule(MixedTeam_2, 5, 120, ThemeAnim, _loc_1, SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(MixedTeam_2, 4, 60, ThemeAnim, _loc_1, SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(MixedTeam_2, 3, 10, ThemeAnim, _loc_1, SlotWinRule.RIGHT_CONSECUTIVE);
            return;
        }// end function

        protected function normalGameLineSpecificWinTable() : void
        {
            this.normalGameLineSpecificWinTableCountry1();
            this.normalGameLineSpecificWinTableCountry2();
            return;
        }// end function

        protected function freeGamesLineSpecificWinTable() : void
        {
            this.freeGamesLineSpecificWinTableCountry1();
            return;
        }// end function

        protected function stateNeutralLineSpecificWinTable() : void
        {
            this.pushRule(Wild, 5, 10000, RegularAnim, {snd:this.SOUND_PACKAGE_PREFIX + "wild", vid:"wild"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Wild, 4, 1000, RegularAnim, {snd:this.SOUND_PACKAGE_PREFIX + "wild", vid:"wild"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Wild, 3, 200, RegularAnim, {snd:this.SOUND_PACKAGE_PREFIX + "wild", vid:"wild"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Wild, 2, 10, RegularAnim, {vid:"wild"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(Wild, 4, 1000, RegularAnim, {snd:this.SOUND_PACKAGE_PREFIX + "wild", vid:"wild"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Wild, 3, 200, RegularAnim, {snd:this.SOUND_PACKAGE_PREFIX + "wild", vid:"wild"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Wild, 2, 10, RegularAnim, {vid:"wild"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.pushRule(A, 5, 300, RegularAnim, {vid:"a"});
            this.pushRule(A, 4, 50, RegularAnim, {vid:"a"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(A, 3, 10, RegularAnim, {vid:"a"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(A, 4, 50, RegularAnim, {vid:"a"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(A, 3, 10, RegularAnim, {vid:"a"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.pushRule(K, 5, 300, RegularAnim, {vid:"k"});
            this.pushRule(K, 4, 50, RegularAnim, {vid:"k"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(K, 3, 10, RegularAnim, {vid:"k"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(K, 4, 50, RegularAnim, {vid:"k"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(K, 3, 10, RegularAnim, {vid:"k"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.pushRule(Q, 5, 200, RegularAnim, {vid:"q"});
            this.pushRule(Q, 4, 25, RegularAnim, {vid:"q"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Q, 3, 5, RegularAnim, {vid:"q"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(Q, 4, 25, RegularAnim, {vid:"q"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Q, 3, 5, RegularAnim, {vid:"q"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.pushRule(J, 5, 200, RegularAnim, {vid:"j"});
            this.pushRule(J, 4, 25, RegularAnim, {vid:"j"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(J, 3, 5, RegularAnim, {vid:"j"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(J, 4, 25, RegularAnim, {vid:"j"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(J, 3, 5, RegularAnim, {vid:"j"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.pushRule(Ten, 5, 100, RegularAnim, {vid:"ten"});
            this.pushRule(Ten, 4, 15, RegularAnim, {vid:"ten"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Ten, 3, 5, RegularAnim, {vid:"ten"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(Ten, 4, 15, RegularAnim, {vid:"ten"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Ten, 3, 5, RegularAnim, {vid:"ten"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.pushRule(Nine, 5, 100, RegularAnim, {vid:"nine"});
            this.pushRule(Nine, 4, 15, RegularAnim, {vid:"nine"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.pushRule(Nine, 3, 5, RegularAnim, {vid:"nine"}, SlotWinRule.LEFT_CONSECUTIVE);
            this.extra_win_table.pushRule(Nine, 4, 15, RegularAnim, {vid:"nine"}, SlotWinRule.RIGHT_CONSECUTIVE);
            this.extra_win_table.pushRule(Nine, 3, 5, RegularAnim, {vid:"nine"}, SlotWinRule.RIGHT_CONSECUTIVE);
            return;
        }// end function

        public function get state() : GameState
        {
            return this._state;
        }// end function

        protected function getThemeParameters(com.playtech.casino3.slots.top_trumps_stars.enum:Object = null) : Object
        {
            var _loc_3:String = null;
            var _loc_2:* = com.playtech.casino3.slots.top_trumps_stars.enum ? (com.playtech.casino3.slots.top_trumps_stars.enum.symbol as GameSpecificSlotSymbol) : (null);
            if (_loc_2)
            {
                _loc_3 = _loc_2.is_from_team_1 ? ("team_1_player_" + _loc_2.player_index) : (_loc_3);
                _loc_3 = _loc_2.is_from_team_2 ? ("team_2_player_" + _loc_2.player_index) : (_loc_3);
            }
            var _loc_4:Object = {vid:"highlight"};
            if (_loc_2)
            {
                _loc_4.snd = this.SOUND_PACKAGE_PREFIX + _loc_3;
            }
            return _loc_4;
        }// end function

        public function set state(Dictionary:GameState) : void
        {
            this._state = Dictionary;
            clear();
            this.extra_win_table.clear();
            this.lineSpecificWinTable();
            this.scatterWinTable();
            this.gameSpecificWinTable();
            insertElementFromArray(this.extra_win_table);
            sortDescending();
            return;
        }// end function

        protected function gameSpecificFreeSpinWinTable() : void
        {
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._logic = null;
            this._state = null;
            this.RANDOM_ANIMATION = null;
            this.RANDOM_SOUND = null;
            disposeObjects(this.extra_win_table);
            return;
        }// end function

        protected function scatterWinTable() : void
        {
            var _loc_2:SlotsWin = null;
            var _loc_1:Object = {vid:"scatter", snd:this.SOUND_PACKAGE_PREFIX + "scatter", statusKey:"novel_infobar_scatterwin", statusMap:new TextSubstitutions(WinAnimBase.X, null, WinAnimBase.W, null, WinAnimBase.TW, null)};
            _loc_2 = this.pushRule(Scatter, 5, 125, RegularAnim, _loc_1, SlotWinRule.ANYWHERE);
            _loc_2 = this.pushRule(Scatter, 4, 25, RegularAnim, _loc_1, SlotWinRule.ANYWHERE);
            _loc_2 = this.pushRule(Scatter, 3, 5, RegularAnim, _loc_1, SlotWinRule.ANYWHERE);
            _loc_2 = this.pushRule(Scatter, 2, 1, RegularAnim, _loc_1, SlotWinRule.ANYWHERE);
            return;
        }// end function

        protected function lineSpecificWinTable() : void
        {
            this.stateNeutralLineSpecificWinTable();
            if (this._state == GameState.NORMAL)
            {
                return this.normalGameLineSpecificWinTable();
            }
            if (this._state == GameState.FREESPIN)
            {
                return this.freeGamesLineSpecificWinTable();
            }
            return;
        }// end function

        protected function pushRule(void:Class, void:int, void:Number, void:Class, void:Object = null, void:SlotWinRule = null, void:WinsSpecial = null, void:WinsPriority = null, void:Vector.<Vector.<int>> = null) : SlotWin
        {
            var _loc_10:* = new SlotWin(void, void, void, void, void, void, void, void, void);
            push(_loc_10);
            return _loc_10;
        }// end function

    }
}
