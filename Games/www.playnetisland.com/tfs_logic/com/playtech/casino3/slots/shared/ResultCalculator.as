package com.playtech.casino3.slots.shared
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;

    public class ResultCalculator extends Object implements IWinsCalculator
    {
        protected var m_wins:Array;

        public function ResultCalculator(param1:Array)
        {
            this.m_wins = param1;
            return;
        }// end function

        private function testWinConsecutive(__AS3__.vec, __AS3__.vec) : WinInfo
        {
            var _loc_3:* = undefined;
            var _loc_4:int = 0;
            var _loc_5:SlotsSymbol = null;
            var _loc_8:SlotsWin = null;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_6:* = new Vector.<int>;
            var _loc_7:* = new Vector.<SlotsSymbol>;
            _loc_4 = __AS3__.vec.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_5 = __AS3__.vec[_loc_3];
                _loc_9 = __AS3__.vec.symbol.equals(_loc_5.type);
                if (_loc_9 != -1)
                {
                    _loc_10 = _loc_10 + _loc_9;
                    _loc_6.push(_loc_3);
                    _loc_7.push(_loc_5);
                    if (_loc_6.length == __AS3__.vec.count)
                    {
                        if (_loc_10 == 0)
                        {
                            return null;
                        }
                        return new WinInfo(__AS3__.vec, _loc_6, _loc_7);
                    }
                }
                else if (_loc_6.length != 0)
                {
                    return null;
                }
                _loc_3 = _loc_3 + 1;
            }
            return null;
        }// end function

        private function testRestriction(payline:Vector.<int>, payline:Vector.<Vector.<int>>) : Vector.<int>
        {
            var _loc_4:int = 0;
            var _loc_5:Vector.<int> = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_3:* = payline.length;
            var _loc_8:int = 0;
            while (_loc_8 < _loc_3)
            {
                
                _loc_5 = payline[_loc_8];
                _loc_4 = _loc_5.length;
                _loc_7 = 0;
                _loc_6 = 0;
                while (_loc_6 < _loc_4)
                {
                    
                    if (payline.indexOf(_loc_5[_loc_6]) != -1)
                    {
                        _loc_7++;
                    }
                    _loc_6++;
                }
                if (_loc_7 == _loc_4)
                {
                    return _loc_5;
                }
                _loc_8++;
            }
            return null;
        }// end function

        private function testForWin(__AS3__.vec:Vector.<SlotsSymbol>) : WinInfo
        {
            var _loc_2:* = undefined;
            var _loc_3:int = 0;
            var _loc_4:SlotsWin = null;
            var _loc_5:WinInfo = null;
            _loc_3 = this.m_wins.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = this.m_wins[_loc_2];
                if (_loc_4.type != SlotsWin.ANYWHERE && _loc_4.type != SlotsWin.FIXED_INDEXES)
                {
                    if (_loc_4.type == SlotsWin.LEFT_CONSECUTIVE)
                    {
                        _loc_5 = this.testWinLeftConsecutive(_loc_4, __AS3__.vec);
                    }
                    else if (_loc_4.type == SlotsWin.RIGHT_CONSECUTIVE)
                    {
                        _loc_5 = this.testWinRightConsecutive(_loc_4, __AS3__.vec);
                    }
                    else if (_loc_4.type == SlotsWin.CONSECUTIVE)
                    {
                        _loc_5 = this.testWinConsecutive(_loc_4, __AS3__.vec);
                    }
                    else if (_loc_4.type == SlotsWin.NON_CONSECUTIVE)
                    {
                        _loc_5 = this.testWinNonConsecutive(_loc_4, __AS3__.vec);
                    }
                    else
                    {
                        _loc_5 = this.extendedWinTest(_loc_4, __AS3__.vec);
                    }
                    if (_loc_5 != null)
                    {
                        return _loc_5;
                    }
                }
                _loc_2 = _loc_2 + 1;
            }
            return null;
        }// end function

        public function dispose() : void
        {
            this.m_wins = null;
            return;
        }// end function

        private function testWinNonConsecutive(__AS3__.vec, __AS3__.vec) : WinInfo
        {
            var _loc_3:* = undefined;
            var _loc_4:int = 0;
            var _loc_5:SlotsSymbol = null;
            var _loc_8:SlotsWin = null;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_6:* = new Vector.<int>;
            var _loc_7:* = new Vector.<SlotsSymbol>;
            _loc_4 = __AS3__.vec.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_5 = __AS3__.vec[_loc_3];
                _loc_9 = __AS3__.vec.symbol.equals(_loc_5.type);
                if (_loc_9 != -1)
                {
                    _loc_10 = _loc_10 + _loc_9;
                    _loc_6.push(_loc_3);
                    _loc_7.push(_loc_5);
                }
                _loc_3 = _loc_3 + 1;
            }
            if (_loc_6.length == __AS3__.vec.count && _loc_10 != 0)
            {
                return new WinInfo(__AS3__.vec, _loc_6, _loc_7);
            }
            return null;
        }// end function

        private function compareWinToWin(symbol_indexes:WinInfo, symbol_indexes:WinInfo) : int
        {
            if (symbol_indexes.win.priority < symbol_indexes.win.priority)
            {
                return -1;
            }
            if (symbol_indexes.win.priority > symbol_indexes.win.priority)
            {
                return 1;
            }
            if (symbol_indexes.win.win < symbol_indexes.win.win)
            {
                return -1;
            }
            if (symbol_indexes.win.win > symbol_indexes.win.win)
            {
                return 1;
            }
            return 0;
        }// end function

        private function testForScatter(com.playtech.casino3.slots.shared:ResultCalculator/com.playtech.casino3.slots.shared:ResultCalculator:Vector.<SlotsSymbol>) : Wins
        {
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            var _loc_4:* = undefined;
            var _loc_5:int = 0;
            var _loc_6:SlotsWin = null;
            var _loc_7:SlotsSymbol = null;
            var _loc_10:SlotsWin = null;
            var _loc_11:int = 0;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_15:Vector.<int> = null;
            var _loc_16:WinInfo = null;
            var _loc_8:* = new Vector.<int>;
            var _loc_9:* = new Vector.<SlotsSymbol>;
            var _loc_12:* = new Wins();
            _loc_3 = this.m_wins.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                if (this.m_wins[_loc_2].type == SlotsWin.ANYWHERE || this.m_wins[_loc_2].type == SlotsWin.FIXED_INDEXES)
                {
                    _loc_14 = 0;
                    _loc_6 = this.m_wins[_loc_2];
                    _loc_8 = new Vector.<int>;
                    _loc_9 = new Vector.<SlotsSymbol>;
                    _loc_5 = com.playtech.casino3.slots.shared:ResultCalculator/com.playtech.casino3.slots.shared:ResultCalculator.length;
                    _loc_11 = 0;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_5)
                    {
                        
                        _loc_7 = com.playtech.casino3.slots.shared:ResultCalculator/com.playtech.casino3.slots.shared:ResultCalculator[_loc_4];
                        _loc_13 = _loc_6.symbol.equals(_loc_7.type);
                        if (_loc_13 != -1)
                        {
                            _loc_14 = _loc_14 + _loc_13;
                            _loc_11++;
                            _loc_8.push(_loc_4);
                            _loc_9.push(_loc_7);
                        }
                        _loc_4 = _loc_4 + 1;
                    }
                    if (_loc_14 != 0)
                    {
                        if (_loc_6.type == SlotsWin.FIXED_INDEXES)
                        {
                            if (_loc_6.restriction != null)
                            {
                                _loc_15 = this.testRestriction(_loc_8, _loc_6.restriction);
                                if (_loc_15 != null)
                                {
                                    _loc_12.push(new WinInfo(_loc_6, _loc_15, _loc_9, null));
                                }
                            }
                        }
                        else if (_loc_11 == _loc_6.count)
                        {
                            if (_loc_6.restriction != null)
                            {
                                _loc_15 = this.testRestriction(_loc_8, _loc_6.restriction);
                                if (_loc_15 != null)
                                {
                                    _loc_12.push(new WinInfo(_loc_6, _loc_15, _loc_9, null));
                                }
                            }
                            else
                            {
                                _loc_12.push(new WinInfo(_loc_6, _loc_8, _loc_9, null));
                            }
                        }
                    }
                }
                else
                {
                    _loc_16 = this.extendedScatterTest(com.playtech.casino3.slots.shared:ResultCalculator/com.playtech.casino3.slots.shared:ResultCalculator);
                    if (_loc_16 != null)
                    {
                        _loc_12.push(_loc_16);
                    }
                }
                _loc_2 = _loc_2 + 1;
            }
            return _loc_12;
        }// end function

        public function getResult(com.playtech.casino3.slots.shared:ResultCalculator/com.playtech.casino3.slots.shared:ResultCalculator:ReelsSymbolsState, com.playtech.casino3.slots.shared:ResultCalculator/com.playtech.casino3.slots.shared:ResultCalculator:Array) : Wins
        {
            var _loc_3:* = undefined;
            var _loc_4:* = undefined;
            var _loc_5:* = undefined;
            var _loc_6:int = 0;
            var _loc_7:Vector.<SlotsSymbol> = null;
            var _loc_8:Array = null;
            var _loc_10:Wins = null;
            var _loc_12:SlotsPayline = null;
            var _loc_13:WinInfo = null;
            var _loc_9:* = new Wins();
            var _loc_11:* = com.playtech.casino3.slots.shared:ResultCalculator/com.playtech.casino3.slots.shared:ResultCalculator.symbols;
            _loc_5 = com.playtech.casino3.slots.shared:ResultCalculator/com.playtech.casino3.slots.shared:ResultCalculator.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_5)
            {
                
                _loc_12 = com.playtech.casino3.slots.shared:ResultCalculator/com.playtech.casino3.slots.shared:ResultCalculator[_loc_3] as SlotsPayline;
                _loc_8 = _loc_12.positions;
                _loc_6 = _loc_8.length;
                _loc_7 = new Vector.<SlotsSymbol>;
                _loc_4 = 0;
                while (_loc_4 < _loc_6)
                {
                    
                    _loc_7.push(_loc_11[_loc_8[_loc_4]]);
                    _loc_4 = _loc_4 + 1;
                }
                _loc_13 = null;
                _loc_13 = this.testForWin(_loc_7);
                if (_loc_13 != null)
                {
                    _loc_6 = _loc_13.symbol_indexes.length;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_6)
                    {
                        
                        _loc_13.symbol_indexes[_loc_4] = _loc_8[_loc_13.symbol_indexes[_loc_4]];
                        _loc_4 = _loc_4 + 1;
                    }
                    _loc_13.payline = _loc_12;
                    _loc_9.push(_loc_13);
                }
                _loc_3 = _loc_3 + 1;
            }
            _loc_10 = this.testForScatter(_loc_11);
            if (_loc_10)
            {
                _loc_9.insertElementFromArray(_loc_10, _loc_9.length);
            }
            return _loc_9;
        }// end function

        protected function extendedWinTest(__AS3__.vec:SlotsWin, __AS3__.vec:Vector.<SlotsSymbol>) : WinInfo
        {
            return null;
        }// end function

        public function calculateWinAmouts(RIGHT_CONSECUTIVE:RoundInfo) : Number
        {
            throw new Error("ResultCalculator  does not calculte the value , but TypeNovel does for it");
        }// end function

        protected function extendedScatterTest(__AS3__.vec:Vector.<SlotsSymbol>) : WinInfo
        {
            return null;
        }// end function

        private function testWinRightConsecutive(__AS3__.vec:SlotsWin, __AS3__.vec) : WinInfo
        {
            var _loc_3:* = undefined;
            var _loc_4:int = 0;
            var _loc_5:SlotsSymbol = null;
            var _loc_8:SlotsWin = null;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_6:* = new Vector.<int>;
            var _loc_7:* = new Vector.<SlotsSymbol>;
            _loc_4 = __AS3__.vec.length;
            _loc_3 = _loc_4 - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_5 = __AS3__.vec[_loc_3];
                _loc_9 = __AS3__.vec.symbol.equals(_loc_5.type);
                if (_loc_9 != -1)
                {
                    _loc_10 = _loc_10 + _loc_9;
                    _loc_6.push(_loc_3);
                    _loc_7.push(_loc_5);
                    if (_loc_6.length == __AS3__.vec.count)
                    {
                        if (_loc_10 == 0)
                        {
                            return null;
                        }
                        return new WinInfo(__AS3__.vec, _loc_6, _loc_7);
                    }
                }
                else
                {
                    return null;
                }
                _loc_3 = _loc_3 - 1;
            }
            return null;
        }// end function

        private function testWinLeftConsecutive(__AS3__.vec, __AS3__.vec) : WinInfo
        {
            var _loc_3:* = undefined;
            var _loc_4:int = 0;
            var _loc_5:SlotsSymbol = null;
            var _loc_8:SlotsWin = null;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_6:* = new Vector.<int>;
            var _loc_7:* = new Vector.<SlotsSymbol>;
            _loc_4 = __AS3__.vec.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_5 = __AS3__.vec[_loc_3];
                _loc_9 = __AS3__.vec.symbol.equals(_loc_5.type);
                if (_loc_9 != -1)
                {
                    _loc_10 = _loc_10 + _loc_9;
                    _loc_6.push(_loc_3);
                    _loc_7.push(_loc_5);
                    if ((_loc_3 + 1) == __AS3__.vec.count)
                    {
                        if (_loc_10 == 0)
                        {
                            return null;
                        }
                        return new WinInfo(__AS3__.vec, _loc_6, _loc_7);
                    }
                }
                else
                {
                    return null;
                }
                _loc_3 = _loc_3 + 1;
            }
            return null;
        }// end function

        public function sortWins(NON_CONSECUTIVE:Wins) : void
        {
            NON_CONSECUTIVE.sort(this.compareWinToWin);
            return;
        }// end function

    }
}
