package com.playtech.casino3.slots.top_trumps_stars.wins
{
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.top_trumps_stars.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;

    public class WinsTransformator extends BaseWinsTransformator
    {
        protected var _logic:Logic;
        protected var _state:GameState;

        public function WinsTransformator(param1:Logic)
        {
            this._logic = param1;
            this._state = GameState.NORMAL;
            return;
        }// end function

        public function set state(NORMAL:GameState) : void
        {
            this._state = NORMAL;
            unFreezeIndexes();
            if (this._state == GameState.NORMAL)
            {
                unExpandedReels();
            }
            return;
        }// end function

        override public function transformWins(NORMAL:Wins) : void
        {
            _wins = NORMAL;
            if (this._state == GameState.NORMAL)
            {
                return this.transformNormalGameWins();
            }
            if (this._state == GameState.FREESPIN)
            {
                return this.transformFreeSpinsWins();
            }
            return;
        }// end function

        protected function transformFreeSpinsWins() : void
        {
            this.transformNormalGameWins();
            return;
        }// end function

        public function get state() : GameState
        {
            return this._state;
        }// end function

        protected function transformNormalGameWins() : void
        {
            var _loc_2:int = 0;
            var _loc_3:GameWinInfo = null;
            var _loc_4:Object = null;
            return;
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._logic = null;
            this._state = null;
            return;
        }// end function

    }
}
