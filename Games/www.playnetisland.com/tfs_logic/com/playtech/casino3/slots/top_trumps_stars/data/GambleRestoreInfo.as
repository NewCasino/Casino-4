package com.playtech.casino3.slots.top_trumps_stars.data
{
    import com.playtech.casino3.slots.shared.base_game.*;
    import flash.utils.*;

    public class GambleRestoreInfo extends BaseRestoreInfo
    {
        protected var _broken_bet:Number;
        public const GAMBLE_CHUNK_INDEX:int = 6;
        protected var _info:Array;
        public const GAMBLE_INFO_CHUNK_INDEX:int = 5;
        public const GAMBLE_BET_CHUNK_INDEX:int = 4;
        protected var _broken_items:Array;
        protected var _is_valid:Boolean;

        public function GambleRestoreInfo(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\top_trumps_stars\data;GambleRestoreInfo.as:Array) : void
        {
            this._info = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\top_trumps_stars\data;GambleRestoreInfo.as;
            this.parse();
            return;
        }// end function

        public function get broket_items() : Array
        {
            return this._broken_items;
        }// end function

        public function get broken_bet() : Number
        {
            return this._broken_bet;
        }// end function

        protected function parse() : void
        {
            this._is_valid = this._info.length > this.GAMBLE_INFO_CHUNK_INDEX && this._info[this.GAMBLE_CHUNK_INDEX][0].indexOf("gamble_highcard") != -1;
            if (!this._is_valid)
            {
                return;
            }
            this._broken_bet = Number(this._info[this.GAMBLE_BET_CHUNK_INDEX][0]);
            this._broken_items = this._info[this.GAMBLE_INFO_CHUNK_INDEX];
            return;
        }// end function

        public function getInfoInGambleAceptableFormat(info_:int) : Array
        {
            return [this._broken_bet, info_, this._broken_items];
        }// end function

        override public function dispose() : void
        {
            this._info = null;
            this._broken_items = null;
            return;
        }// end function

        public function toString() : String
        {
            var _loc_1:* = "------ DATA " + getQualifiedClassName(GambleRestoreInfo) + " -----" + N;
            _loc_1 = _loc_1 + (T + "BROCKEN BET " + this._broken_bet + N);
            _loc_1 = _loc_1 + (T + "BROCKEN ITEMS " + this._broken_items + N);
            _loc_1 = _loc_1 + "------ END DATA -----";
            return _loc_1;
        }// end function

        public function get is_valid() : Boolean
        {
            return this._is_valid;
        }// end function

    }
}
