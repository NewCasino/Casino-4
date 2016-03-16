package com.playtech.casino3.slots.shared
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.core.*;

    public class SlotsHistory extends Object
    {
        protected var FREE_SPINS_SEPARATOR:String = ",";
        private var m_entry:HistoryEntry;
        protected var FREE_SPINS_NAME:String = "bonus: spins ";
        private var m_mi:IModuleInterface;
        protected var LINE_WIN_PARAMETERS_SEPARATOR:String = ",";
        static const LINE_WINS_SEPARATOR:String = ":";
        static const SEPARATOR:String = ";";

        public function SlotsHistory(param1:IModuleInterface)
        {
            this.m_mi = param1;
            return;
        }// end function

        protected function lineWinChunk(HistoryEntry:Vector.<WinInfo>, HistoryEntry:int, HistoryEntry:int, HistoryEntry:int) : String
        {
            var _loc_7:int = 0;
            var _loc_5:String = "";
            var _loc_6:String = "";
            var _loc_8:* = HistoryEntry ? (HistoryEntry.length) : (1);
            _loc_7 = 0;
            while (_loc_7 < _loc_8)
            {
                
                _loc_6 = (HistoryEntry + 1) + this.LINE_WIN_PARAMETERS_SEPARATOR + HistoryEntry + this.LINE_WIN_PARAMETERS_SEPARATOR + (HistoryEntry ? (HistoryEntry[_loc_7].win.win) : (0)) + (HistoryEntry == (HistoryEntry - 1) ? ("") : (LINE_WINS_SEPARATOR));
                _loc_5 = _loc_5 + _loc_6;
                _loc_7++;
            }
            return _loc_5;
        }// end function

        protected function processScatterWins(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:Array) : void
        {
            return;
        }// end function

        public function addBonus(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:int = 0, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:String = "bonus") : void
        {
            this.m_entry = new HistoryEntry();
            this.m_entry.bet = 0;
            this.m_entry.win = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as;
            this.m_entry.endBalance = this.m_mi.getDisplayCredit();
            this.m_entry.data = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as;
            this.m_mi.writeRoundHistory(this.m_entry);
            return;
        }// end function

        public function createNewEntry() : void
        {
            this.m_entry = new HistoryEntry();
            return;
        }// end function

        public function addFreeSpinBonus(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:int, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:int, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:int = 0, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:String = "") : void
        {
            this.createFreeSpinBonusEntry(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as, this.createFreeSpinEntryData(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as));
            Console.write("addFreeSpinBonus() ->  entry: " + this.m_entry, SlotsHistory);
            this.m_mi.writeRoundHistory(this.m_entry);
            return;
        }// end function

        protected function createExtraFreeSpinsMultiplierChunk(HistoryEntry:int) : String
        {
            return " mult " + HistoryEntry;
        }// end function

        protected function createFreeSpinBonusEntry(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:int, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:String) : void
        {
            this.m_entry = new HistoryEntry();
            this.m_entry.bet = 0;
            this.m_entry.win = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as;
            this.m_entry.endBalance = this.m_mi.getDisplayCredit();
            this.m_entry.data = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as;
            Console.write("createFreeSpinBonusEntry() -> data:" + D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as, SlotsHistory);
            return;
        }// end function

        public function dispose() : void
        {
            this.m_mi = null;
            this.m_entry = null;
            return;
        }// end function

        protected function processPaylineWins(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:Array) : void
        {
            return;
        }// end function

        protected function devidePaylineAndScatterWins(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:RoundInfo, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:Array, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:Array) : void
        {
            var _loc_4:Wins = null;
            var _loc_6:SlotsPayline = null;
            var _loc_7:WinInfo = null;
            var _loc_8:Number = NaN;
            var _loc_9:SlotsSymbol = null;
            var _loc_10:int = 0;
            var _loc_11:Vector.<WinInfo> = null;
            _loc_4 = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as.wins;
            var _loc_5:* = _loc_4.length;
            _loc_10 = 0;
            while (_loc_10 < _loc_5)
            {
                
                _loc_7 = _loc_4[_loc_10] as WinInfo;
                _loc_8 = _loc_7.win.win;
                if (_loc_8 == 0)
                {
                }
                else
                {
                    _loc_6 = _loc_7.payline;
                    if (_loc_6 != null)
                    {
                        _loc_11 = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as[_loc_6.id];
                        if (!_loc_11)
                        {
                            var _loc_12:* = new Vector.<WinInfo>;
                            _loc_11 = new Vector.<WinInfo>;
                            D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as[_loc_6.id] = _loc_12;
                        }
                        _loc_11.push(_loc_7);
                    }
                    else
                    {
                        _loc_9 = _loc_7.win.symbol;
                        D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as.push((_loc_9.getAlias() != null ? (_loc_9.getAlias().type) : (_loc_9.type)) + "," + _loc_7.win.count + "," + _loc_8);
                    }
                }
                _loc_10++;
            }
            return;
        }// end function

        protected function createEntryData(HistoryEntry:RoundInfo, HistoryEntry:String) : String
        {
            var _loc_3:* = HistoryEntry.results.join(" ") + SEPARATOR;
            var _loc_4:Array = [];
            var _loc_5:Array = [];
            this.devidePaylineAndScatterWins(HistoryEntry, _loc_4, _loc_5);
            this.processPaylineWins(_loc_4);
            this.processScatterWins(_loc_5);
            _loc_3 = _loc_3 + this.createPaylineWinsChunk(HistoryEntry, _loc_4);
            _loc_3 = _loc_3 + this.createScatterChunk(_loc_5);
            _loc_3 = _loc_3 + (HistoryEntry ? (HistoryEntry) : (this.createAdditionalChunk()));
            return _loc_3;
        }// end function

        protected function createAdditionalChunk() : String
        {
            return "";
        }// end function

        protected function createScatterChunk(HistoryEntry:Array) : String
        {
            var _loc_2:String = "";
            if (HistoryEntry.length != 0)
            {
                _loc_2 = _loc_2 + (SEPARATOR + HistoryEntry.join(","));
            }
            else
            {
                _loc_2 = _loc_2 + SEPARATOR;
            }
            _loc_2 = _loc_2 + SEPARATOR;
            return _loc_2;
        }// end function

        protected function setEntry(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:int, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:RoundInfo, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:String) : void
        {
            this.m_entry.bet = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as == GameStates.STATE_FREESPIN || D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as == GameStates.STATE_RESPIN ? (0) : (D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as.getTotalBet());
            this.m_entry.win = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as.totalwin;
            this.m_entry.jpwin = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as.jpwin;
            this.m_entry.endBalance = this.m_mi.getDisplayCredit();
            this.m_entry.data = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as;
            Console.write("setEntry() -> data:" + D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as, SlotsHistory);
            return;
        }// end function

        protected function createFreeSpinEntryData(HistoryEntry:int, HistoryEntry:int, HistoryEntry:String = "") : String
        {
            var _loc_4:* = this.FREE_SPINS_NAME + HistoryEntry + this.FREE_SPINS_SEPARATOR;
            _loc_4 = _loc_4 + this.createExtraFreeSpinsMultiplierChunk(HistoryEntry);
            _loc_4 = _loc_4 + (this.FREE_SPINS_SEPARATOR + " " + (HistoryEntry != "" ? (HistoryEntry) : (this.createExtraFreeSpinsBonusChunk())));
            return _loc_4;
        }// end function

        protected function createPaylineWinsChunk(HistoryEntry:RoundInfo, HistoryEntry:Array) : String
        {
            var _loc_4:Array = null;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:Vector.<Number> = null;
            var _loc_11:Number = NaN;
            var _loc_3:String = "";
            _loc_4 = HistoryEntry.getActiveBets();
            var _loc_5:* = HistoryEntry.getLineBet();
            var _loc_6:* = _loc_4.length;
            _loc_7 = 0;
            while (_loc_7 < _loc_6)
            {
                
                if (_loc_4[_loc_7] <= 0)
                {
                }
                else
                {
                    _loc_3 = _loc_3 + this.lineWinChunk(HistoryEntry[_loc_7], _loc_7, _loc_6, _loc_5);
                }
                _loc_7++;
            }
            return _loc_3;
        }// end function

        public function addOrdinaryWin(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:RoundInfo, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:int, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as:String = null) : void
        {
            this.setEntry(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as, this.createEntryData(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as, D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared;SlotsHistory.as));
            this.m_mi.writeRoundHistory(this.m_entry);
            return;
        }// end function

        protected function createExtraFreeSpinsBonusChunk() : String
        {
            return "";
        }// end function

    }
}
