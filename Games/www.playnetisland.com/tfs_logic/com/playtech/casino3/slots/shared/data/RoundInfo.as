package com.playtech.casino3.slots.shared.data
{
    import __AS3__.vec.*;

    public class RoundInfo extends Object
    {
        private var m_activeBets:Array;
        private var m_jpwin:Number;
        private var m_coinValue:int;
        private var m_reelSyms:ReelsSymbols;
        private var m_backup:Object;
        private var m_linesCount:int;
        private var m_results:Vector.<int>;
        private var m_wins:Wins;
        private var m_totalwin:Number;
        private var m_numLineBet:int;
        private var m_moneyIn:Number;
        private var m_paylines:Array;
        public static var ACTIVATE_SINGLE_ID:int = 2;
        public static var LINEBET_MAX:int = 0;
        public static var ACTIVATE_MULTI_ID:int = 1;
        public static var LINEBET_STEP:int = 1;
        public static var LINEBET_VALUE:int = 2;
        public static var ACTIVATE_ALL:int = 0;

        public function RoundInfo()
        {
            this.m_activeBets = [];
            var _loc_1:* = GameParameters.maxLines;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                this.m_activeBets.push(-1);
                _loc_2++;
            }
            this.m_wins = new Wins();
            this.m_totalwin = 0;
            this.m_moneyIn = 0;
            this.m_jpwin = 0;
            return;
        }// end function

        public function set coinValue(Wins:int) : void
        {
            this.m_coinValue = Wins;
            return;
        }// end function

        public function set reelSymbols(Wins:ReelsSymbols) : void
        {
            this.m_reelSyms = Wins;
            this.m_reelSyms.positions = this.m_results;
            return;
        }// end function

        public function get moneyIn() : Number
        {
            return this.m_moneyIn;
        }// end function

        public function getLineBet(m_wins:Boolean = true) : Number
        {
            return m_wins ? (this.m_numLineBet * this.m_coinValue) : (this.m_numLineBet);
        }// end function

        public function set moneyIn(Wins:Number) : void
        {
            this.m_moneyIn = Wins;
            return;
        }// end function

        public function dispose() : void
        {
            this.m_activeBets = null;
            if (this.m_backup != null)
            {
                this.m_backup.activeBets = null;
                this.m_backup = null;
            }
            this.m_results = null;
            this.m_reelSyms = null;
            this.m_wins = null;
            this.m_paylines = null;
            return;
        }// end function

        public function activateLine(Wins:int, Wins:int = 0) : void
        {
            var _loc_4:int = 0;
            var _loc_3:* = this.m_activeBets.length;
            switch(Wins)
            {
                case ACTIVATE_ALL:
                {
                    Wins = _loc_3 - 1;
                }
                case ACTIVATE_MULTI_ID:
                {
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3)
                    {
                        
                        this.m_activeBets[_loc_4] = _loc_4 > Wins ? (-1) : (this.m_numLineBet);
                        _loc_4++;
                    }
                    this.m_linesCount = Wins + 1;
                    break;
                }
                case ACTIVATE_SINGLE_ID:
                {
                    if (this.m_activeBets[Wins] == -1)
                    {
                        this.m_activeBets[Wins] = this.m_numLineBet;
                        var _loc_5:String = this;
                        var _loc_6:* = this.m_linesCount + 1;
                        _loc_5.m_linesCount = _loc_6;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function backupInfo() : void
        {
            this.m_backup = {activeBets:this.m_activeBets.slice(), numLineBet:this.m_numLineBet, coinValue:this.m_coinValue, linesCount:this.m_linesCount};
            return;
        }// end function

        public function get jpwin() : Number
        {
            return this.m_jpwin;
        }// end function

        public function get paylines() : Array
        {
            return this.m_paylines;
        }// end function

        public function get wins() : Wins
        {
            return this.m_wins;
        }// end function

        public function get totalwin() : Number
        {
            return this.m_totalwin;
        }// end function

        public function get coinValue() : int
        {
            return this.m_coinValue;
        }// end function

        public function getTotalBet() : Number
        {
            var _loc_3:int = 0;
            var _loc_1:Number = 0;
            var _loc_2:* = this.m_activeBets.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3 = this.m_activeBets[_loc_4];
                if (_loc_3 != -1)
                {
                    _loc_1 = _loc_1 + _loc_3 * this.m_coinValue;
                }
                _loc_4++;
            }
            return _loc_1;
        }// end function

        public function getActiveBets() : Array
        {
            return this.m_activeBets.slice();
        }// end function

        public function restoreInfo() : void
        {
            this.m_activeBets = this.m_backup.activeBets;
            this.m_numLineBet = this.m_backup.numLineBet;
            this.m_coinValue = this.m_backup.coinValue;
            this.m_linesCount = this.m_backup.linesCount;
            return;
        }// end function

        public function set jpwin(Wins:Number) : void
        {
            this.m_jpwin = Wins;
            return;
        }// end function

        public function changeLineBet(Wins:int, Wins:int = 1, Wins:int = 1) : void
        {
            switch(Wins)
            {
                case LINEBET_MAX:
                {
                    this.m_numLineBet = GameParameters.maxLineBet;
                    break;
                }
                case LINEBET_STEP:
                {
                    this.m_numLineBet = this.m_numLineBet + Wins;
                    if (this.m_numLineBet > GameParameters.maxLineBet)
                    {
                        this.m_numLineBet = Wins;
                    }
                    if (this.m_numLineBet < Wins)
                    {
                        this.m_numLineBet = GameParameters.maxLineBet;
                    }
                    break;
                }
                case LINEBET_VALUE:
                {
                    this.m_numLineBet = Wins;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_4:* = this.m_activeBets.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4)
            {
                
                if (this.m_activeBets[_loc_5] > -1)
                {
                    this.m_activeBets[_loc_5] = this.m_numLineBet;
                }
                _loc_5++;
            }
            return;
        }// end function

        public function set paylines(Wins:Array) : void
        {
            this.m_paylines = Wins;
            return;
        }// end function

        public function getNumActiveLines() : int
        {
            return this.m_linesCount;
        }// end function

        public function set wins(Wins:Wins) : void
        {
            this.m_wins = Wins;
            return;
        }// end function

        public function get results() : Vector.<int>
        {
            return this.m_results;
        }// end function

        public function get reelSymbols() : ReelsSymbols
        {
            return this.m_reelSyms;
        }// end function

        public function set results(Wins:Vector.<int>) : void
        {
            this.m_results = Wins;
            if (this.m_reelSyms)
            {
                this.m_reelSyms.positions = Wins;
            }
            return;
        }// end function

        public function isLineActive(Vector:int) : Boolean
        {
            return this.m_activeBets[Vector] != -1;
        }// end function

        public function set totalwin(Wins:Number) : void
        {
            this.m_totalwin = Wins;
            return;
        }// end function

    }
}
