package com.playtech.casino3.slots.top_trumps_stars.data
{
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.core.*;

    public class RestoreInfo extends BaseRestoreInfo
    {
        protected var _free_spins_manager:FreeSpins;
        protected var _info:Array;
        protected var _free_games_restore_info:FreeGamesRestoreInfo;
        protected var _gamble_restore_info:GambleRestoreInfo;

        public function RestoreInfo(info_:Array, info_:FreeSpins) : void
        {
            this._info = info_;
            this._free_spins_manager = info_;
            this.parse();
            return;
        }// end function

        public function get free_games_restore_info() : FreeGamesRestoreInfo
        {
            return this._free_games_restore_info;
        }// end function

        protected function parse() : void
        {
            var _loc_1:Array = null;
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:int = 0;
            var _loc_5:* = this._info.length;
            Console.debugObject(this._info);
            this._gamble_restore_info = new GambleRestoreInfo(this._info);
            if (!this._gamble_restore_info.is_valid)
            {
                this._gamble_restore_info = null;
            }
            _loc_1 = this._info.shift() as Array;
            _loc_2 = _loc_1.shift();
            this._free_games_restore_info = new FreeGamesRestoreInfo(handleNamedChunkData(_loc_1), this._free_spins_manager);
            if (!this._free_games_restore_info.is_valid)
            {
                this._free_games_restore_info = null;
            }
            return;
        }// end function

        public function get gamble_restore_info() : GambleRestoreInfo
        {
            return this._gamble_restore_info;
        }// end function

        override public function dispose() : void
        {
            this._info = null;
            this._free_spins_manager = null;
            this._free_games_restore_info = null;
            this._gamble_restore_info = null;
            return;
        }// end function

    }
}
