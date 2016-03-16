package com.playtech.casino3.slots.shared.novel
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import flash.display.*;

    public class FreeSpins extends Object
    {
        public var allow_decrease_spins:Boolean = true;
        private var m_featureSyms:ReelsSymbolsState;
        private var m_multiplier:int;
        private var m_featureReels:Vector.<int>;
        private var m_header:FS_Header;
        private var m_base:TypeNovel;
        private var m_gfx:Sprite;
        private var m_totalwin:Number;
        public var total_games_played:int = 0;
        private var m_gameWin:Number;
        private var m_freespins:int;

        public function FreeSpins(param1:Sprite, param2:TypeNovel)
        {
            this.m_gfx = param1;
            this.m_base = param2;
            this.m_gameWin = 0;
            this.m_totalwin = 0;
            return;
        }// end function

        public function getFeatureReels() : Vector.<int>
        {
            return this.m_featureReels;
        }// end function

        public function dispose() : void
        {
            if (this.m_header != null)
            {
                this.m_header.remove();
                this.m_header = null;
            }
            this.m_gfx = null;
            this.m_base = null;
            this.m_featureReels = null;
            this.m_featureSyms = null;
            return;
        }// end function

        public function setMultiplier(com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:int) : void
        {
            this.m_multiplier = com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            if (this.m_header != null)
            {
                this.m_header.updateFsMulti(this.m_multiplier);
            }
            return;
        }// end function

        public function setTriggeredReels(com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:Vector.<int>, com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:ReelsSymbolsState) : void
        {
            this.m_featureReels = com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            this.m_featureSyms = com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            return;
        }// end function

        public function deleteHeader() : void
        {
            this.m_header.remove();
            this.m_header = null;
            return;
        }// end function

        public function initFreeSpinValues(com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:int, com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:Number, com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:int, com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:Number = 0) : void
        {
            this.m_multiplier = com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            this.m_gameWin = com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            this.m_freespins = com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            this.m_totalwin = com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            return;
        }// end function

        public function setGameWin(com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:Number) : void
        {
            this.m_gameWin = com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            return;
        }// end function

        public function getHeader() : FS_Header
        {
            return this.m_header;
        }// end function

        public function newRoundStarted() : void
        {
            if (this.allow_decrease_spins)
            {
                var _loc_1:String = this;
                var _loc_2:* = this.m_freespins - 1;
                _loc_1.m_freespins = _loc_2;
            }
            if (this.m_header)
            {
                this.m_header.updateFsNum(this.m_freespins);
            }
            var _loc_1:String = this;
            var _loc_2:* = this.total_games_played + 1;
            _loc_1.total_games_played = _loc_2;
            return;
        }// end function

        public function getGameWin() : Number
        {
            return this.m_gameWin;
        }// end function

        public function startAssets(com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:Number = -1, com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:Number = 0) : void
        {
            this.m_base.setState(GameStates.STATE_FREESPIN);
            if (com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins == -1)
            {
                com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins = this.m_freespins;
            }
            this.creatHeader(com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins, com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins);
            this.m_base.playAmbient(GameParameters.shortname + ".FS_ambient");
            this.m_base.getWinAnimator().pause(true);
            if (this.m_featureReels == null)
            {
                this.m_featureReels = this.m_base.getRoundInfo().results;
                this.m_featureSyms = this.m_base.getRoundInfo().reelSymbols.symbols;
            }
            return;
        }// end function

        public function updateHeaderWin() : void
        {
            if (!this.m_base.getTicker().isTicking() && this.m_header != null)
            {
                this.m_header.updateWin(this.m_totalwin);
            }
            return;
        }// end function

        public function updateWin(com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:Number) : void
        {
            this.m_totalwin = this.m_totalwin + com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            return;
        }// end function

        public function moreFS(com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:int, com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:Boolean = false) : void
        {
            this.m_freespins = this.m_freespins + com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            if (this.m_header && com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins)
            {
                this.m_header.updateFsNum(this.m_freespins);
            }
            return;
        }// end function

        public function removeAssets() : void
        {
            this.deleteHeader();
            this.m_base.playAmbient(null);
            this.m_base.getWinAnimator().pause(false);
            return;
        }// end function

        public function setFS(com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:int) : void
        {
            this.m_freespins = com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            if (this.m_header)
            {
                this.m_header.updateFsNum(this.m_freespins);
            }
            return;
        }// end function

        public function getFS(flash.display:Boolean = false) : int
        {
            return this.allow_decrease_spins || flash.display ? (this.m_freespins) : (1);
        }// end function

        public function setFSWin(com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:Number) : void
        {
            this.m_totalwin = com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins;
            return;
        }// end function

        public function creatHeader(com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:Number = 0, com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins:Number = 0) : void
        {
            this.m_header = new FS_Header(this.m_gfx, com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins, com.playtech.casino3.slots.shared.novel:FreeSpins/FreeSpins, this.m_multiplier, this.m_base.getTicker().getTextField());
            return;
        }// end function

        public function getMultiplier() : int
        {
            return this.m_multiplier;
        }// end function

        public function getFSWin() : Number
        {
            return this.m_totalwin;
        }// end function

        public function getFeatureSymbols() : ReelsSymbolsState
        {
            return this.m_featureSyms;
        }// end function

    }
}
