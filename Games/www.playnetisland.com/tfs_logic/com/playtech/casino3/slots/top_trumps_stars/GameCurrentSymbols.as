package com.playtech.casino3.slots.top_trumps_stars
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import flash.utils.*;

    public class GameCurrentSymbols extends MaskedReelsSymbols
    {
        protected var _state:GameState;
        protected const EXPANDING_WILD_INDEX:uint = 2;
        var CUSTOM_WIN_PARAMETERS:Dictionary;

        public function GameCurrentSymbols(middle_row_:ReelsStrips, middle_row_:Vector.<int> = null, middle_row_:int = -1) : void
        {
            this.CUSTOM_WIN_PARAMETERS = new Dictionary(false);
            super(middle_row_, middle_row_, middle_row_);
            this._state = GameState.NORMAL;
            return;
        }// end function

        public function set state(middle_row_:GameState) : void
        {
            clearMaskOnReels();
            this._state = middle_row_;
            return;
        }// end function

        protected function disposeGameSpecific() : void
        {
            return;
        }// end function

        public function get state() : GameState
        {
            return this._state;
        }// end function

        override protected function recalculate(middle_row_:Vector.<SlotsSymbol> = null) : void
        {
            clearMaskOnReels();
            super.recalculate(middle_row_);
            if (this._state == GameState.NORMAL)
            {
                return;
            }
            maskSymbols(middle_row_);
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._state = null;
            this.CUSTOM_WIN_PARAMETERS = null;
            this.disposeGameSpecific();
            return;
        }// end function

    }
}
