package com.littlefilms
{
    import flash.display.*;

    public class TeamNav extends Sprite
    {
        private var _mainMC:Main;
        private var _parentMC:ContentPane;
        private var _teamXML:XML;
        private var _navArray:Array;
        private var _navSpace:uint = 120;

        public function TeamNav(param1:XML)
        {
            _navArray = [];
            _teamXML = param1;
            return;
        }// end function

        public function init() : void
        {
            var _loc_2:TeamNavItem = null;
            var _loc_3:XML = null;
            var _loc_4:TeamNavItem = null;
            var _loc_1:* = _teamXML..member;
            for each (_loc_3 in _loc_1)
            {
                
                _loc_4 = new TeamNavItem(_loc_3);
                _loc_4.registerMain(_mainMC);
                _loc_4.registerController(this);
                _loc_4.init();
                addChild(_loc_4);
                if (_loc_2 == null)
                {
                    _loc_4.x = 0;
                    _loc_4.y = 0;
                }
                else
                {
                    _loc_4.x = _loc_2.x + _navSpace;
                    _loc_4.y = _loc_2.y;
                }
                _loc_2 = _loc_4;
            }
            return;
        }// end function

        public function registerMain(param1:Main) : void
        {
            _mainMC = param1;
            return;
        }// end function

        public function registerPane(param1:ContentPane) : void
        {
            _parentMC = param1;
            return;
        }// end function

        public function swapNav(param1:NavItem) : void
        {
            return;
        }// end function

    }
}
