package com.playtech.casino3.slots.top_trumps_stars.wins
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.slot_symbols.*;
    import com.playtech.casino3.slots.top_trumps_stars.wins.anims.*;
    import com.playtech.casino3.slots.top_trumps_stars.wins.enum.*;
    import com.playtech.core.*;
    import flash.utils.*;

    public class WinsCalculator extends BaseWinsCalculator
    {
        protected var _state:GameState;
        public var BALL_WINS:Vector.<GameWinInfo>;
        protected const FOURTH_REEL_INDEX:int = 3;
        var CUSTOM_WIN_PARAMETERS:Dictionary;
        protected var _logic:Logic;
        var _wins:Wins;
        protected const SECOND_REEL_INDEX:int = 1;
        protected var _win_table:Wintable;

        public function WinsCalculator(CUSTOM_WIN_PARAMETERS:Wintable, CUSTOM_WIN_PARAMETERS:Logic, CUSTOM_WIN_PARAMETERS:WinsTransformator = null) : void
        {
            this.CUSTOM_WIN_PARAMETERS = new Dictionary(false);
            this.BALL_WINS = new Vector.<GameWinInfo>;
            super(CUSTOM_WIN_PARAMETERS, CUSTOM_WIN_PARAMETERS);
            this._win_table = CUSTOM_WIN_PARAMETERS as Wintable;
            this._logic = CUSTOM_WIN_PARAMETERS;
            return;
        }// end function

        override protected function get multiplier() : int
        {
            if (this._state == GameState.NORMAL)
            {
                return 1;
            }
            return this._logic._free_spins_manager.getMultiplier();
        }// end function

        protected function getNextMaxWinIndexOfType(com.playtech.casino3.slots.shared.data:Vector.<GameWinInfo>, com.playtech.casino3.slots.shared.data:SlotWinRule, com.playtech.casino3.slots.shared.data:int = 0, com.playtech.casino3.slots.shared.data:GameSpecificSlotSymbol = null, com.playtech.casino3.slots.shared.data = null) : int
        {
            var _loc_6:GameWinInfo = null;
            var _loc_7:int = 0;
            var _loc_8:* = com.playtech.casino3.slots.shared.data.length;
            var _loc_9:* = com.playtech.casino3.slots.shared.data.type;
            _loc_7 = com.playtech.casino3.slots.shared.data;
            while (_loc_7 < _loc_8)
            {
                
                _loc_6 = com.playtech.casino3.slots.shared.data[_loc_7];
                if (_loc_6.win.type == _loc_9)
                {
                    if (com.playtech.casino3.slots.shared.data)
                    {
                        if (com.playtech.casino3.slots.shared.data == _loc_6.win.symbol)
                        {
                            if (com.playtech.casino3.slots.shared.data !== null)
                            {
                                if (_loc_6.is_substituted == com.playtech.casino3.slots.shared.data)
                                {
                                    return _loc_7;
                                }
                            }
                            else
                            {
                                return _loc_7;
                            }
                        }
                    }
                    else if (com.playtech.casino3.slots.shared.data !== null)
                    {
                        if (_loc_6.is_substituted == com.playtech.casino3.slots.shared.data)
                        {
                            return _loc_7;
                        }
                    }
                    else
                    {
                        return _loc_7;
                    }
                }
                _loc_7++;
            }
            return -1;
        }// end function

        protected function pushIndexesOfSymbol(com.playtech.casino3.slots.shared.enum:GameSpecificSlotSymbol, com.playtech.casino3.slots.shared.enum:Vector.<int>) : Vector.<int>
        {
            var _loc_3:* = _reels_symbols_state.indexesOfSymbol(com.playtech.casino3.slots.shared.enum);
            if (!_loc_3)
            {
                return com.playtech.casino3.slots.shared.enum;
            }
            return com.playtech.casino3.slots.shared.enum.concat(_loc_3);
        }// end function

        override protected function limitWinsByRules(BALL_WINS:Wins) : Wins
        {
            var _loc_5:int = 0;
            var _loc_7:GameWinInfo = null;
            var _loc_8:GameWinInfo = null;
            var _loc_11:Vector.<GameWinInfo> = null;
            var _loc_13:int = 0;
            var _loc_14:GameWinInfo = null;
            var _loc_15:GameWinInfo = null;
            var _loc_16:GameWinInfo = null;
            var _loc_2:* = new Wins();
            var _loc_3:* = Array.NUMERIC | Array.DESCENDING;
            BALL_WINS.sortOn(["payline_id", "payout"], [_loc_3, _loc_3]);
            if (BALL_WINS.is_empty)
            {
                return _loc_2;
            }
            var _loc_4:* = GameParameters.maxLines;
            var _loc_6:* = BALL_WINS.length;
            var _loc_9:* = this.Vector.<GameWinInfo>(BALL_WINS);
            var _loc_10:* = new Vector.<Vector.<GameWinInfo>>(_loc_4);
            _loc_5 = 0;
            while (_loc_5 < _loc_6)
            {
                
                _loc_8 = BALL_WINS[_loc_5] as GameWinInfo;
                _loc_11 = _loc_10[_loc_8.payline_id];
                if (!_loc_11)
                {
                    var _loc_18:* = new Vector.<GameWinInfo>;
                    _loc_11 = new Vector.<GameWinInfo>;
                    _loc_10[_loc_8.payline_id] = _loc_18;
                }
                _loc_11.push(_loc_8);
                _loc_5++;
            }
            var _loc_12:int = 0;
            var _loc_17:* = this.state == GameState.FREESPIN;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_11 = _loc_10[_loc_5];
                if (!_loc_11)
                {
                }
                else
                {
                    this.insertSecondary5ofAKind(_loc_11);
                    _loc_13 = 0;
                    _loc_8 = _loc_11[0];
                    _loc_14 = null;
                    _loc_15 = null;
                    _loc_16 = null;
                    Console.write("FIRST WIN " + _loc_8, 1);
                    if (_loc_8.win.count == 5)
                    {
                        Console.write("5 OF A KIND", 2);
                        _loc_2[++_loc_12] = _loc_8;
                        if (_loc_17)
                        {
                            Console.write("IN_FREESPINS_STATE", 3);
                            if (_loc_8.is_mixed)
                            {
                                Console.write("IS MIXED", 4);
                                _loc_14 = this.getNextMaxWinWithoutMix(_loc_11, SlotWinRule.LEFT_CONSECUTIVE, 1);
                                _loc_15 = this.getNextMaxWinWithoutMix(_loc_11, SlotWinRule.RIGHT_CONSECUTIVE, 1);
                                _loc_16 = _loc_14;
                                if (!_loc_16)
                                {
                                    _loc_16 = _loc_15;
                                }
                                if (_loc_14 && _loc_15)
                                {
                                    _loc_16 = _loc_14.payout >= _loc_15.payout ? (_loc_14) : (_loc_15);
                                }
                                Console.write("LEFT NOT MIXED " + _loc_14, 4);
                                Console.write("RIGHT NOT MIXED " + _loc_15, 4);
                                Console.write("ACTUAL WIN " + _loc_16, 4);
                                if (_loc_16)
                                {
                                    _loc_2[++_loc_12] = _loc_16;
                                }
                            }
                            else if (_loc_8.is_substituted)
                            {
                                Console.write("IS SUBSTITUTED", 4);
                                _loc_16 = this.getNextMaxWinWithWild(_loc_11, _loc_8.win_rule == SlotWinRule.LEFT_CONSECUTIVE.type ? (SlotWinRule.RIGHT_CONSECUTIVE) : (SlotWinRule.LEFT_CONSECUTIVE), 1);
                                if (!_loc_16)
                                {
                                    _loc_14 = this.getNextMaxWinWithWild(_loc_11, SlotWinRule.LEFT_CONSECUTIVE, 1);
                                    _loc_15 = this.getNextMaxWinWithWild(_loc_11, SlotWinRule.RIGHT_CONSECUTIVE, 1);
                                    if (_loc_14)
                                    {
                                        _loc_16 = _loc_14;
                                    }
                                    if (_loc_15)
                                    {
                                        _loc_16 = _loc_15;
                                    }
                                }
                                Console.write("LEFT WIN WITH WILD " + _loc_14, 4);
                                Console.write("RIGHT WIN WITH WILD " + _loc_15, 4);
                                Console.write("ACTUAL WIN " + _loc_16, 4);
                                if (_loc_16)
                                {
                                    _loc_2[++_loc_12] = _loc_16;
                                }
                            }
                        }
                        else
                        {
                            Console.write("IS THERE OTHER WIN ?", 3);
                            if (_loc_8.is_substituted && !_loc_8.is_mixed)
                            {
                                Console.write("FIRST WIN IS SUBSTITUTED AND NOT MIXED", 4);
                                _loc_13 = this.getNextMaxWinIndexOfType(_loc_11, SlotWinRule.LEFT_CONSECUTIVE, 1, null, false);
                                _loc_14 = _loc_13 != -1 ? (_loc_11[_loc_13]) : (null);
                                _loc_13 = this.getNextMaxWinIndexOfType(_loc_11, SlotWinRule.RIGHT_CONSECUTIVE, 1, null, false);
                                _loc_15 = _loc_13 != -1 ? (_loc_11[_loc_13]) : (null);
                                Console.write("LEFT WIN " + _loc_14, 4);
                                Console.write("RIGHT WIN " + _loc_15, 4);
                                if (_loc_14 && _loc_15)
                                {
                                    _loc_16 = _loc_14.payout >= _loc_15.payout ? (_loc_14) : (_loc_15);
                                }
                                else
                                {
                                    if (_loc_14)
                                    {
                                        _loc_16 = _loc_14;
                                    }
                                    if (_loc_15)
                                    {
                                        _loc_16 = _loc_15;
                                    }
                                }
                                Console.write("ACTUAL WIN " + _loc_16, 4);
                                if (_loc_16)
                                {
                                    _loc_2[++_loc_12] = _loc_16;
                                }
                            }
                        }
                    }
                    else
                    {
                        Console.write("NO 5 OF A KIND IN PAYLINE " + _loc_5, 3);
                        _loc_13 = this.getNextMaxWinIndexOfType(_loc_11, SlotWinRule.LEFT_CONSECUTIVE, 0);
                        if (_loc_13 != -1)
                        {
                            _loc_14 = _loc_11[_loc_13];
                        }
                        _loc_13 = this.getNextMaxWinIndexOfType(_loc_11, SlotWinRule.RIGHT_CONSECUTIVE, 0);
                        if (_loc_13 != -1)
                        {
                            _loc_15 = _loc_11[_loc_13];
                        }
                        if (_loc_14)
                        {
                            _loc_2[++_loc_12] = _loc_14;
                        }
                        if (_loc_15)
                        {
                            _loc_2[++_loc_12] = _loc_15;
                        }
                        Console.write("LEFT WIN " + _loc_14, 3);
                        Console.write("RIGHT WIN " + _loc_15, 3);
                    }
                }
                _loc_5++;
            }
            return _loc_2;
        }// end function

        protected function checkBallFeature() : void
        {
            var _loc_3:int = 0;
            var _loc_4:Vector.<int> = null;
            var _loc_5:GameSpecificSlotSymbol = null;
            this.BALL_WINS = new Vector.<GameWinInfo>;
            var _loc_1:* = _reels_symbols_state.indexOfSymbolOnReel(Ball.symbol, this.SECOND_REEL_INDEX);
            var _loc_2:* = _reels_symbols_state.indexOfSymbolOnReel(Ball.symbol, this.FOURTH_REEL_INDEX);
            if (_loc_1 != -1)
            {
                _loc_4 = new Vector.<int>;
                _loc_3 = _loc_1 - 1;
                _loc_5 = _reels_symbols_state.symbols[_loc_3] as GameSpecificSlotSymbol;
                if (_loc_5.is_from_team_1)
                {
                    _loc_4 = this.pushIndexesOfSymbol(Team_1_Player_1.symbol, _loc_4);
                    _loc_4 = this.pushIndexesOfSymbol(Team_1_Player_2.symbol, _loc_4);
                    _loc_4 = this.pushIndexesOfSymbol(Team_1_Player_3.symbol, _loc_4);
                    this.pushBallWin(_loc_1, _loc_3, _loc_4, true);
                }
            }
            if (_loc_2 != -1)
            {
                _loc_4 = new Vector.<int>;
                _loc_3 = _loc_2 + 1;
                _loc_5 = _reels_symbols_state.symbols[_loc_3] as GameSpecificSlotSymbol;
                if (_loc_5.is_from_team_2)
                {
                    _loc_4 = this.pushIndexesOfSymbol(Team_2_Player_1.symbol, _loc_4);
                    _loc_4 = this.pushIndexesOfSymbol(Team_2_Player_2.symbol, _loc_4);
                    _loc_4 = this.pushIndexesOfSymbol(Team_2_Player_3.symbol, _loc_4);
                    this.pushBallWin(_loc_2, _loc_3, _loc_4, false);
                }
            }
            return;
        }// end function

        public function get state() : GameState
        {
            return this._state;
        }// end function

        override protected function constructWinInfo(http://adobe.com/AS3/2006/builtin:SlotsWin, http://adobe.com/AS3/2006/builtin:Vector.<int>, http://adobe.com/AS3/2006/builtin:Vector.<SlotsSymbol>, http://adobe.com/AS3/2006/builtin:SlotsPayline = null, http://adobe.com/AS3/2006/builtin:Vector.<String> = null, http://adobe.com/AS3/2006/builtin:uint = 0) : WinInfo
        {
            return new GameWinInfo(http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin);
        }// end function

        protected function sortLeftToRight(com.playtech.casino3.slots.shared.data:int, com.playtech.casino3.slots.shared.data:int) : int
        {
            var _loc_3:int = -1;
            var _loc_4:int = 1;
            var _loc_5:int = 0;
            var _loc_6:* = com.playtech.casino3.slots.shared.data % GameParameters.numReels;
            var _loc_7:* = com.playtech.casino3.slots.shared.data % GameParameters.numReels;
            if (_loc_6 < _loc_7)
            {
                return _loc_3;
            }
            if (_loc_6 > _loc_7)
            {
                return _loc_4;
            }
            if (com.playtech.casino3.slots.shared.data < com.playtech.casino3.slots.shared.data)
            {
                return _loc_3;
            }
            if (com.playtech.casino3.slots.shared.data > com.playtech.casino3.slots.shared.data)
            {
                return _loc_4;
            }
            return 0;
        }// end function

        override protected function decideWins(CUSTOM_WIN_PARAMETERS:ReelsSymbolsState, CUSTOM_WIN_PARAMETERS:Array) : void
        {
            super.decideWins(CUSTOM_WIN_PARAMETERS, CUSTOM_WIN_PARAMETERS);
            this._wins = _wins_;
            this.checkGameSpecificWins();
            return;
        }// end function

        public function set state(CUSTOM_WIN_PARAMETERS:GameState) : void
        {
            this._state = CUSTOM_WIN_PARAMETERS;
            return;
        }// end function

        protected function checkGameSpecificWins() : void
        {
            if (this._state == GameState.NORMAL)
            {
                this.checkBallFeature();
            }
            return;
        }// end function

        protected function pushBallWin(CUSTOM_WIN_PARAMETERS:int, CUSTOM_WIN_PARAMETERS:int, CUSTOM_WIN_PARAMETERS:Vector.<int>, CUSTOM_WIN_PARAMETERS:Boolean) : void
        {
            var _loc_5:int = 0;
            var _loc_8:Vector.<SlotsSymbol> = null;
            CUSTOM_WIN_PARAMETERS = CUSTOM_WIN_PARAMETERS.sort(this.sortLeftToRight);
            if (!CUSTOM_WIN_PARAMETERS)
            {
                CUSTOM_WIN_PARAMETERS.reverse();
            }
            _loc_5 = CUSTOM_WIN_PARAMETERS.length;
            var _loc_6:* = CUSTOM_WIN_PARAMETERS.indexOf(CUSTOM_WIN_PARAMETERS);
            CUSTOM_WIN_PARAMETERS.splice(_loc_6, 1);
            CUSTOM_WIN_PARAMETERS.unshift(CUSTOM_WIN_PARAMETERS);
            CUSTOM_WIN_PARAMETERS.unshift(CUSTOM_WIN_PARAMETERS);
            var _loc_7:* = vectorToByterArray(CUSTOM_WIN_PARAMETERS);
            _loc_8 = _reels_symbols_state.symbolsOnIndexes(_loc_7);
            var _loc_9:* = this.constructWinInfo(new SlotWin(Ball, 1, _loc_5, BallAnim, {logic:this._logic}, null, null, CUSTOM_WIN_PARAMETERS ? (WinsPriority.LEFT_BALL) : (WinsPriority.RIGHT_BALL)), CUSTOM_WIN_PARAMETERS, _loc_8) as GameWinInfo;
            this.BALL_WINS.push(_loc_9);
            this._wins.push(_loc_9);
            return;
        }// end function

        protected function getNextMaxWinWithWild(win_table_:Vector.<GameWinInfo>, win_table_:SlotWinRule, win_table_:int = 0) : GameWinInfo
        {
            var _loc_4:* = this.getNextMaxWinIndexOfType(win_table_, win_table_, win_table_, Wild.symbol);
            if (_loc_4 == -1)
            {
                return null;
            }
            return win_table_[_loc_4];
        }// end function

        protected function getNextMaxWinWithoutMix(win_table_:Vector.<GameWinInfo>, win_table_:SlotWinRule, win_table_:int = 0) : GameWinInfo
        {
            var _loc_4:GameWinInfo = null;
            var _loc_5:* = win_table_.length;
            while (win_table_ < _loc_5)
            {
                
                win_table_ = this.getNextMaxWinIndexOfType(win_table_, win_table_, win_table_);
                if (win_table_ == -1)
                {
                    break;
                }
                _loc_4 = win_table_[win_table_];
                if (!_loc_4.is_mixed)
                {
                    break;
                }
                win_table_++;
            }
            return !_loc_4.is_mixed ? (_loc_4) : (null);
        }// end function

        override public function dispose() : void
        {
            this._wins = null;
            this._win_table = null;
            _wins_transformator = null;
            this.CUSTOM_WIN_PARAMETERS = null;
            super.dispose();
            return;
        }// end function

        protected function insertSecondary5ofAKind(CUSTOM_WIN_PARAMETERS:Vector.<GameWinInfo>) : void
        {
            var _loc_2:int = 0;
            var _loc_4:GameWinInfo = null;
            var _loc_5:GameSpecificSlotSymbol = null;
            var _loc_3:* = CUSTOM_WIN_PARAMETERS.length;
            _loc_2 = 1;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = CUSTOM_WIN_PARAMETERS[_loc_2];
                if (_loc_4.win.count == 5)
                {
                    if (this._state == GameState.NORMAL)
                    {
                        _loc_5 = _loc_4.win.symbol as GameSpecificSlotSymbol;
                        if (_loc_4.is_mixed || _loc_5.is_from_team_1 || _loc_5.is_from_team_2)
                        {
                            ;
                        }
                    }
                    _loc_4 = _loc_4.clone() as GameWinInfo;
                    _loc_4.win.type = _loc_4.win.type == SlotWinRule.LEFT_CONSECUTIVE.type ? (SlotWinRule.RIGHT_CONSECUTIVE.type) : (SlotWinRule.LEFT_CONSECUTIVE.type);
                    CUSTOM_WIN_PARAMETERS.splice(_loc_2++, 0, _loc_4);
                }
                _loc_2++;
            }
            return;
        }// end function

    }
}
