package com.playtech.casino3.slots.shared.base_game
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;
    import flash.events.*;
    import flash.utils.*;

    public class BaseWinsCalculator extends EventDispatcher implements IDisposable, IWinsCalculator
    {
        protected var _lines:Array;
        protected var _reels_symbols_state:ReelsSymbolsState;
        protected var _win_rules:Array;
        protected var _indexes_winning:Vector.<int>;
        protected var _symbols:Vector.<SlotsSymbol>;
        protected var _multiplier:int = 1;
        protected var _total_win:Number;
        protected var _wins_:Wins;
        protected var _reels_winning:Vector.<Boolean>;
        protected var _wins_transformator:BaseWinsTransformator;

        public function BaseWinsCalculator(param1:Array, param2:BaseWinsTransformator = null)
        {
            this._indexes_winning = new Vector.<int>;
            this._win_rules = param1;
            this._wins_transformator = param2;
            return;
        }// end function

        protected function get multiplier() : int
        {
            return this._multiplier;
        }// end function

        protected function vectorToByterArray(com.playtech.casino3.slots.shared.data:Vector.<int>) : ByteArray
        {
            var _loc_4:int = 0;
            var _loc_2:* = com.playtech.casino3.slots.shared.data.length;
            var _loc_3:* = new ByteArray();
            _loc_4 = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3[_loc_4] = com.playtech.casino3.slots.shared.data[_loc_4];
                _loc_4++;
            }
            return _loc_3;
        }// end function

        protected function limitWinsByRules(Object:Wins) : Wins
        {
            var _loc_3:int = 0;
            var _loc_6:WinInfo = null;
            var _loc_2:* = Array.NUMERIC;
            Object.sortOn(["payline_id", "payout"], [_loc_2, _loc_2]);
            if (Object.is_empty)
            {
                return Object;
            }
            var _loc_4:* = Object.length;
            var _loc_5:* = Object[(_loc_4 - 1)] as WinInfo;
            _loc_3 = _loc_4 - 2;
            while (_loc_3 >= 0)
            {
                
                _loc_6 = Object[_loc_3] as WinInfo;
                if (_loc_6.payline_id == _loc_5.payline_id)
                {
                    Object.splice(_loc_3, 1);
                }
                else
                {
                    _loc_5 = _loc_6;
                }
                _loc_3 = _loc_3 - 1;
            }
            return Object;
        }// end function

        public function getResult(Object:ReelsSymbolsState, Object:Array) : Wins
        {
            this.decideWins(Object, Object);
            if (this._wins_transformator)
            {
                this._wins_transformator.transformWins(this._wins_);
            }
            return this._wins_;
        }// end function

        protected function decideWins(decideWins:ReelsSymbolsState, decideWins:Array) : void
        {
            this._reels_symbols_state = decideWins;
            this._symbols = decideWins.symbols;
            this._lines = decideWins;
            var _loc_3:* = this.getLineWins();
            _loc_3 = this.limitWinsByRules(_loc_3);
            this._reels_winning = _loc_3.calculateWinningReels();
            var _loc_4:* = this.getScatterWins();
            if (_loc_4)
            {
                _loc_3.insertElementFromArray(_loc_4, _loc_3.length);
            }
            this._wins_ = _loc_3;
            return;
        }// end function

        protected function getLineWins() : Wins
        {
            var _loc_2:Vector.<SlotsSymbol> = null;
            var _loc_3:* = undefined;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:* = undefined;
            var _loc_7:int = 0;
            var _loc_8:SlotsPayline = null;
            var _loc_10:ByteArray = null;
            var _loc_12:WinInfo = null;
            var _loc_25:int = 0;
            var _loc_26:* = undefined;
            var _loc_27:int = 0;
            var _loc_28:SlotsWin = null;
            var _loc_29:WinInfo = null;
            var _loc_30:int = 0;
            var _loc_31:SlotsSymbol = null;
            var _loc_32:SlotsSymbol = null;
            var _loc_33:int = 0;
            var _loc_34:int = 0;
            var _loc_37:int = 0;
            var _loc_38:uint = 0;
            var _loc_39:Boolean = false;
            var _loc_40:uint = 0;
            var _loc_41:uint = 0;
            var _loc_42:int = 0;
            var _loc_43:int = 0;
            var _loc_44:int = 0;
            var _loc_45:Vector.<int> = null;
            var _loc_1:int = 0;
            _loc_2 = this._symbols;
            var _loc_9:* = new ByteArray();
            var _loc_11:* = new Wins();
            var _loc_13:* = GameParameters.numReels;
            var _loc_14:* = this._win_rules.length;
            var _loc_15:* = this._lines.length;
            var _loc_16:* = _loc_2.length;
            var _loc_17:* = SlotsWin.LEFT_CONSECUTIVE;
            var _loc_18:* = SlotsWin.RIGHT_CONSECUTIVE;
            var _loc_19:* = SlotsWin.CONSECUTIVE;
            var _loc_20:* = SlotsWin.NON_CONSECUTIVE;
            var _loc_21:* = SlotsWin.ANYWHERE;
            var _loc_22:* = SlotsWin.FIXED_INDEXES;
            var _loc_23:* = this._reels_symbols_state.as_byte_array;
            var _loc_24:* = new ByteArray();
            var _loc_35:* = new Vector.<SlotsPayline>(_loc_15, true);
            _loc_35 = this.Vector.<SlotsPayline>(this._lines);
            var _loc_36:* = new Vector.<SlotsWin>(_loc_14, true);
            _loc_36 = this.Vector.<SlotsWin>(this._win_rules);
            var _loc_46:uint = 0;
            var _loc_47:uint = 0;
            _loc_3 = 0;
            while (_loc_3 < _loc_15)
            {
                
                _loc_8 = _loc_35[_loc_3];
                _loc_10 = _loc_8.positions_byte_array;
                _loc_9.length = 0;
                _loc_25 = _loc_10.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_25)
                {
                    
                    _loc_9[_loc_5] = _loc_23[_loc_10[_loc_5]];
                    _loc_5++;
                }
                _loc_26 = 0;
                while (_loc_26 < _loc_14)
                {
                    
                    _loc_28 = _loc_36[_loc_26];
                    _loc_12 = null;
                    _loc_24.length = 0;
                    _loc_34 = 0;
                    _loc_33 = 0;
                    _loc_32 = _loc_28.symbol;
                    _loc_38 = _loc_32.equal;
                    _loc_41 = _loc_32.type;
                    _loc_40 = _loc_32.sub_type;
                    _loc_42 = _loc_28.type;
                    _loc_43 = _loc_28.count;
                    _loc_44 = 0;
                    _loc_46 = 0;
                    _loc_39 = false;
                    switch(_loc_42)
                    {
                        case _loc_17:
                        {
                            _loc_30 = 0;
                            while (_loc_30 < _loc_25)
                            {
                                
                                _loc_37 = _loc_9[_loc_30];
                                if (!(_loc_38 >>> _loc_37 & 1))
                                {
                                    break;
                                }
                                _loc_34 = _loc_34 + (_loc_41 == _loc_37 ? (1) : (_loc_40 >>> _loc_37 & 1));
                                if (_loc_41 != _loc_37)
                                {
                                    _loc_39 = true;
                                }
                                _loc_47 = _loc_10[_loc_30];
                                _loc_24[_loc_44] = _loc_47;
                                _loc_44++;
                                _loc_47 = _loc_47 % _loc_13;
                                _loc_46 = _loc_46 | 1 << _loc_47;
                                if (_loc_44 != _loc_43)
                                {
                                }
                                else
                                {
                                    if (_loc_34 == 0)
                                    {
                                        break;
                                    }
                                    _loc_45 = this.byteArrayToVector(_loc_24);
                                    _loc_12 = this.constructWinInfo(_loc_28, _loc_45, this._reels_symbols_state.symbolsOnIndexes(_loc_24), _loc_8, null, _loc_46);
                                }
                                _loc_30++;
                            }
                            break;
                        }
                        case _loc_18:
                        {
                            _loc_30 = _loc_25 - 1;
                            while (_loc_30 >= 0)
                            {
                                
                                _loc_37 = _loc_9[_loc_30];
                                if (!(_loc_38 >>> _loc_37 & 1))
                                {
                                    break;
                                }
                                _loc_34 = _loc_34 + (_loc_41 == _loc_37 ? (1) : (_loc_40 >>> _loc_37 & 1));
                                if (_loc_41 != _loc_37)
                                {
                                    _loc_39 = true;
                                }
                                _loc_47 = _loc_10[_loc_30];
                                _loc_24[_loc_44] = _loc_47;
                                _loc_44++;
                                _loc_47 = _loc_47 % _loc_13;
                                _loc_46 = _loc_46 | 1 << _loc_47;
                                if (_loc_44 != _loc_43)
                                {
                                }
                                else
                                {
                                    if (_loc_34 == 0)
                                    {
                                        break;
                                    }
                                    _loc_45 = this.byteArrayToVector(_loc_24);
                                    _loc_12 = this.constructWinInfo(_loc_28, _loc_45, this._reels_symbols_state.symbolsOnIndexes(_loc_24), _loc_8, null, _loc_46);
                                }
                                _loc_30 = _loc_30 - 1;
                            }
                            break;
                        }
                        case _loc_19:
                        {
                            _loc_30 = 0;
                            while (_loc_30 < _loc_25)
                            {
                                
                                _loc_31 = _loc_9[_loc_30] as SlotsSymbol;
                                _loc_33 = _loc_28.symbol.equals(_loc_31.type);
                                if (_loc_33 == -1)
                                {
                                    break;
                                }
                                _loc_34 = _loc_34 + _loc_33;
                                if (_loc_41 != _loc_37)
                                {
                                    _loc_39 = true;
                                }
                                _loc_47 = _loc_10[_loc_30];
                                _loc_24[_loc_44] = _loc_47;
                                _loc_44++;
                                _loc_47 = _loc_47 % _loc_13;
                                _loc_46 = _loc_46 | 1 << _loc_47;
                                if (_loc_24.length != _loc_28.count)
                                {
                                }
                                else
                                {
                                    if (_loc_34 != 0)
                                    {
                                        break;
                                    }
                                    _loc_45 = this.byteArrayToVector(_loc_24);
                                    _loc_12 = this.constructWinInfo(_loc_28, _loc_45, this._reels_symbols_state.symbolsOnIndexes(_loc_24), _loc_8, null, _loc_46);
                                }
                                _loc_30++;
                            }
                            break;
                        }
                        case _loc_20:
                        {
                            _loc_30 = 0;
                            while (_loc_30 < _loc_25)
                            {
                                
                                _loc_31 = _loc_9[_loc_30] as SlotsSymbol;
                                _loc_33 = _loc_28.symbol.equals(_loc_31.type);
                                if (_loc_33 == -1)
                                {
                                }
                                else
                                {
                                    _loc_34 = _loc_34 + _loc_33;
                                    if (_loc_41 != _loc_37)
                                    {
                                        _loc_39 = true;
                                    }
                                    _loc_47 = _loc_10[_loc_30];
                                    _loc_24[_loc_44] = _loc_47;
                                    _loc_44++;
                                    _loc_47 = _loc_47 % _loc_13;
                                    _loc_46 = _loc_46 | 1 << _loc_47;
                                }
                                _loc_30++;
                            }
                            if (_loc_24.length != _loc_28.count || _loc_34 == 0)
                            {
                                break;
                            }
                            _loc_45 = this.byteArrayToVector(_loc_24);
                            _loc_12 = this.constructWinInfo(_loc_28, _loc_45, this._reels_symbols_state.symbolsOnIndexes(_loc_24), _loc_8, null, _loc_46);
                            break;
                        }
                        default:
                        {
                            break;
                            break;
                        }
                    }
                    if (_loc_12)
                    {
                        _loc_12.is_substituted = _loc_39;
                        _loc_11.push(_loc_12);
                    }
                    _loc_26 = _loc_26 + 1;
                }
                _loc_3 = _loc_3 + 1;
            }
            return _loc_11;
        }// end function

        protected function sortWinToWin(param1:WinInfo, param2:WinInfo) : int
        {
            var _loc_3:* = param1.win;
            var _loc_4:* = param2.win;
            var _loc_5:int = -1;
            var _loc_6:int = 1;
            var _loc_7:int = 0;
            if (_loc_3.type < SlotsWin.ANYWHERE && _loc_4.type >= SlotsWin.ANYWHERE)
            {
                return _loc_5;
            }
            if (_loc_3.type >= SlotsWin.ANYWHERE && _loc_4.type < SlotsWin.ANYWHERE)
            {
                return _loc_6;
            }
            if (_loc_3.priority < _loc_4.priority)
            {
                return _loc_5;
            }
            if (_loc_3.priority > _loc_4.priority)
            {
                return _loc_6;
            }
            if (_loc_3.win < _loc_4.win)
            {
                return _loc_5;
            }
            if (_loc_3.win > _loc_4.win)
            {
                return _loc_6;
            }
            if (param1.payline && param2.payline)
            {
                if (param1.payline.id < param2.payline.id)
                {
                    return _loc_5;
                }
                if (param1.payline.id > param2.payline.id)
                {
                    return _loc_6;
                }
            }
            return _loc_7;
        }// end function

        public function dispose() : void
        {
            this._win_rules = null;
            this._symbols = null;
            this._lines = null;
            this._wins_ = null;
            this._wins_transformator = null;
            return;
        }// end function

        public function get total_win() : Number
        {
            return this._total_win;
        }// end function

        public function sortWins(decideWins:Wins) : void
        {
            decideWins.sort(this.sortWinToWin);
            return;
        }// end function

        protected function byteArrayToVector(flash.events:ByteArray) : Vector.<int>
        {
            var _loc_4:int = 0;
            var _loc_2:* = flash.events.length;
            var _loc_3:* = new Vector.<int>(_loc_2, true);
            _loc_4 = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3[_loc_4] = flash.events[_loc_4];
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public function calculateWinAmouts(pay_line:RoundInfo) : Number
        {
            var _loc_5:Vector.<WinInfo> = null;
            var _loc_7:int = 0;
            var _loc_2:* = this.multiplier;
            var _loc_3:* = pay_line.getLineBet();
            var _loc_4:* = pay_line.getTotalBet();
            _loc_5 = this.Vector.<WinInfo>(this._wins_);
            var _loc_6:* = _loc_5.length;
            this._total_win = 0;
            _loc_7 = 0;
            while (_loc_7 < _loc_6)
            {
                
                this._total_win = this._total_win + _loc_5[_loc_7].calculateWinAmount(_loc_4, _loc_3, _loc_2);
                _loc_7++;
            }
            return this._total_win;
        }// end function

        protected function constructWinInfo(int:SlotsWin, int:Vector.<int>, int:Vector.<SlotsSymbol>, int:SlotsPayline = null, int:Vector.<String> = null, int:uint = 0) : WinInfo
        {
            return new WinInfo(int, int, int, int, int, int);
        }// end function

        protected function testRestriction(flash.events:Vector.<int>, flash.events:Vector.<Vector.<int>>) : Vector.<int>
        {
            var _loc_3:int = 0;
            var _loc_5:int = 0;
            var _loc_6:Vector.<int> = null;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_4:* = flash.events.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_6 = flash.events[_loc_3];
                _loc_5 = _loc_6.length;
                _loc_8 = 0;
                _loc_7 = 0;
                while (_loc_7 < _loc_5)
                {
                    
                    if (flash.events.indexOf(_loc_6[_loc_7]) != -1)
                    {
                        _loc_8++;
                    }
                    _loc_7++;
                }
                if (_loc_8 == _loc_5)
                {
                    return _loc_6;
                }
                _loc_3++;
            }
            return null;
        }// end function

        protected function getScatterWins() : Wins
        {
            var _loc_1:Vector.<SlotsSymbol> = null;
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            var _loc_4:int = 0;
            var _loc_5:SlotsSymbol = null;
            var _loc_6:Vector.<int> = null;
            var _loc_7:Vector.<SlotsSymbol> = null;
            var _loc_8:SlotsWin = null;
            var _loc_9:int = 0;
            var _loc_10:Wins = null;
            var _loc_11:SlotsWin = null;
            var _loc_16:int = 0;
            var _loc_17:int = 0;
            var _loc_18:Vector.<int> = null;
            _loc_1 = this._symbols;
            _loc_10 = new Wins();
            var _loc_12:* = _loc_1.length;
            var _loc_13:* = this._win_rules.length;
            var _loc_14:* = SlotsWin.ANYWHERE;
            var _loc_15:* = SlotsWin.FIXED_INDEXES;
            _loc_2 = 0;
            while (_loc_2 < _loc_13)
            {
                
                _loc_11 = this._win_rules[_loc_2] as SlotsWin;
                if (_loc_11.type != _loc_14 && _loc_11.type != _loc_15)
                {
                }
                else
                {
                    _loc_17 = 0;
                    _loc_6 = new Vector.<int>;
                    _loc_7 = new Vector.<SlotsSymbol>;
                    _loc_4 = _loc_1.length;
                    _loc_9 = 0;
                    _loc_3 = 0;
                    while (_loc_3 < _loc_4)
                    {
                        
                        _loc_5 = _loc_1[_loc_3];
                        _loc_16 = _loc_11.symbol.equals(_loc_5.type);
                        if (_loc_16 == -1)
                        {
                        }
                        else
                        {
                            _loc_17 = _loc_17 + _loc_16;
                            _loc_9++;
                            _loc_6.push(_loc_3);
                            _loc_7.push(_loc_5);
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    if (_loc_17 == 0)
                    {
                    }
                    else if (_loc_11.type == SlotsWin.FIXED_INDEXES)
                    {
                        if (_loc_11.restriction != null)
                        {
                            _loc_18 = this.testRestriction(_loc_6, _loc_11.restriction);
                            if (_loc_18)
                            {
                                _loc_10.push(this.constructWinInfo(_loc_11, _loc_18, _loc_7, null));
                            }
                        }
                    }
                    else if (_loc_9 == _loc_11.count)
                    {
                        if (_loc_11.restriction != null)
                        {
                            _loc_18 = this.testRestriction(_loc_6, _loc_11.restriction);
                            if (_loc_18)
                            {
                                _loc_10.push(this.constructWinInfo(_loc_11, _loc_18, _loc_7, null));
                            }
                        }
                        else
                        {
                            _loc_10.push(this.constructWinInfo(_loc_11, _loc_6, _loc_7, null));
                        }
                    }
                }
                _loc_2 = _loc_2 + 1;
            }
            return _loc_10;
        }// end function

    }
}
