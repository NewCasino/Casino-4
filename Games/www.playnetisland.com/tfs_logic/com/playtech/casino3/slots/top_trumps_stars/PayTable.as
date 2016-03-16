package com.playtech.casino3.slots.top_trumps_stars
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import flash.display.*;

    public class PayTable extends NovelPaytable implements IDisposable
    {
        protected var _module_interface:IModuleInterface;
        protected var _graphics:MovieClip;
        protected var _replace:Object;
        public static const NUM_INFO_PAGES:int = 6;

        public function PayTable(param1:MovieClip, param2:IModuleInterface, param3:Object = null)
        {
            this._graphics = param1;
            this._module_interface = param2;
            this._replace = param3;
            super(this._graphics, this._module_interface, NUM_INFO_PAGES, this._replace);
            return;
        }// end function

        protected function onPassTheBall() : void
        {
            return;
        }// end function

        protected function onChooseTeamPage() : void
        {
            this.setFlags();
            return;
        }// end function

        override protected function openFrame(MovieClip:int) : void
        {
            super.openFrame(MovieClip);
            if (MovieClip == 0)
            {
                this.onPaytablePage();
            }
            if (MovieClip == 1)
            {
                this.onChooseTeamPage();
            }
            if (MovieClip == 2)
            {
                this.onMixedPay();
            }
            if (MovieClip == 3)
            {
                this.onFreeGamesPage();
            }
            return;
        }// end function

        protected function onMixedPay() : void
        {
            this.setFlags();
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._graphics = null;
            this._module_interface = null;
            this._replace = null;
            return;
        }// end function

        protected function setSmallFlags() : void
        {
            var _loc_1:* = m_PageWnd.getChildByName("texts") as MovieClip;
            _loc_1 = _loc_1.getChildAt(0) as MovieClip;
            var _loc_2:* = _loc_1.getChildByName("flag_small_1") as MovieClip;
            _loc_2 = _loc_2.getChildAt(0) as MovieClip;
            var _loc_3:* = _loc_1.getChildByName("flag_small_2") as MovieClip;
            _loc_3 = _loc_3.getChildAt(0) as MovieClip;
            this.setStateCountry1(_loc_2);
            this.setStateCountry2(_loc_3);
            return;
        }// end function

        protected function setStateCountry2(MovieClip:MovieClip) : void
        {
            MovieClip.gotoAndStop(this._replace.country_2.type);
            return;
        }// end function

        protected function onFreeGamesPage() : void
        {
            this.setFlags();
            this.setSmallFlags();
            return;
        }// end function

        protected function setTeams() : void
        {
            var _loc_1:* = m_PageWnd.getChildByName("team_1") as MovieClip;
            _loc_1 = _loc_1.getChildAt(0) as MovieClip;
            var _loc_2:* = m_PageWnd.getChildByName("team_2") as MovieClip;
            _loc_2 = _loc_2.getChildAt(0) as MovieClip;
            this.setStateCountry1(_loc_1);
            this.setStateCountry2(_loc_2);
            return;
        }// end function

        protected function setStateCountry1(MovieClip:MovieClip) : void
        {
            MovieClip.gotoAndStop(this._replace.country_1.type);
            return;
        }// end function

        protected function onPaytablePage() : void
        {
            this.setFlags();
            this.setSmallFlags();
            this.setTeams();
            return;
        }// end function

        protected function setFlags() : void
        {
            var _loc_1:* = m_PageWnd.getChildByName("flag_1") as MovieClip;
            _loc_1 = _loc_1.getChildAt(0) as MovieClip;
            var _loc_2:* = m_PageWnd.getChildByName("flag_2") as MovieClip;
            _loc_2 = _loc_2.getChildAt(0) as MovieClip;
            this.setStateCountry1(_loc_1);
            this.setStateCountry2(_loc_2);
            return;
        }// end function

    }
}
