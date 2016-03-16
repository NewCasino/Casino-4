package com.littlefilms
{
    import com.wirestone.utils.*;
    import flash.display.*;
    import gs.*;

    public class FooterUI extends Sprite
    {
        private var _leftNavItems:Array;
        private var _rightNavItems:Array;
        public var bg:Sprite;
        private var _mainMC:Sprite;
        private var _footerRightNav:Sprite;
        private var _footerLeftNav:Sprite;
        private var _leftNavXSpace:uint = 130;
        private var _rightNavXSpace:uint = 30;
        private var _footerNavYOffset:int = 2;
        private var _navSpace:uint = 15;
        private var _activeNavItem:NavItem = null;
        private var _deadNavItem:NavItem = null;
        private var _preloadAni:SimplePreloadAnimation;
        public static var _instance:FooterUI;

        public function FooterUI(param1:Sprite)
        {
            _leftNavItems = [["whatWeDo", "what we do"], ["whoWeAre", "who we are"], ["ourWork", "our work"], ["ourClients", "our clients"]];
            _rightNavItems = [["contactUs", "contact us"]];
            _mainMC = param1;
            init();
            return;
        }// end function

        private function init() : void
        {
            bg = new FooterBG();
            addChild(bg);
            _footerRightNav = new Sprite();
            addChild(_footerRightNav);
            _footerLeftNav = new Sprite();
            addChild(_footerLeftNav);
            createLeftNav();
            createRightNav();
            _preloadAni = new SimplePreloadAnimation(this.width);
            _preloadAni.y = 0;
            TweenMax.to(_preloadAni, 0, {tint:15156246});
            addChild(_preloadAni);
            positionNav();
            return;
        }// end function

        private function createLeftNav() : void
        {
            var _loc_3:FooterNavItem = null;
            var _loc_1:FooterNavItem = null;
            var _loc_2:int = 0;
            while (_loc_2 < _leftNavItems.length)
            {
                
                _loc_3 = new FooterNavItem(_leftNavItems[_loc_2][0], _leftNavItems[_loc_2][1]);
                _footerLeftNav.addChild(_loc_3);
                _loc_3.registerController(this);
                _loc_3.registerMain(_mainMC);
                if (_loc_1 == null)
                {
                    _loc_3.x = 0;
                    _loc_3.y = 0;
                }
                else
                {
                    _loc_3.x = _loc_1.x + _loc_1.width + _navSpace;
                    _loc_3.y = _loc_1.y;
                }
                _loc_1 = _loc_3;
                _loc_2++;
            }
            return;
        }// end function

        private function createRightNav() : void
        {
            var _loc_4:FooterNavItem = null;
            var _loc_1:FooterNavItem = null;
            var _loc_2:int = 0;
            while (_loc_2 < _rightNavItems.length)
            {
                
                _loc_4 = new FooterNavItem(_rightNavItems[_loc_2][0], _rightNavItems[_loc_2][1]);
                _footerRightNav.addChild(_loc_4);
                _loc_4.registerController(this);
                _loc_4.registerMain(_mainMC);
                if (_loc_1 == null)
                {
                    _loc_4.x = 0;
                    _loc_4.y = 0;
                }
                else
                {
                    _loc_4.x = _loc_1.x + _loc_1.width + _navSpace;
                    _loc_4.y = _loc_1.y;
                }
                _loc_1 = _loc_4;
                _loc_2++;
            }
            var _loc_3:* = new CreditsNavItem("credits", "");
            _footerRightNav.addChild(_loc_3);
            _loc_3.registerController(this);
            _loc_3.registerMain(_mainMC);
            _loc_3.x = _loc_1.x + _loc_1.width + _navSpace;
            _loc_3.y = -3;
            return;
        }// end function

        public function swapNav(param1:NavItem) : void
        {
            _activeNavItem = param1;
            if (_activeNavItem != null)
            {
                _activeNavItem.active = true;
            }
            if (_deadNavItem != null)
            {
                _deadNavItem.active = false;
            }
            _deadNavItem = _activeNavItem;
            return;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            bg.width = param1;
            positionNav();
            return;
        }// end function

        private function positionNav() : void
        {
            _footerLeftNav.x = _leftNavXSpace;
            _footerLeftNav.y = bg.height / 2 - _footerLeftNav.height / 2 + _footerNavYOffset;
            _footerRightNav.x = bg.width - _footerRightNav.width - _rightNavXSpace;
            _footerRightNav.y = bg.height / 2 - _footerRightNav.height / 2 + _footerNavYOffset;
            _preloadAni.width = bg.width;
            return;
        }// end function

        public function get preloadAni() : SimplePreloadAnimation
        {
            return _preloadAni;
        }// end function

        public function set preloadAni(param1:SimplePreloadAnimation) : void
        {
            if (param1 !== _preloadAni)
            {
                _preloadAni = param1;
            }
            return;
        }// end function

        public static function getInstance(param1:Sprite) : FooterUI
        {
            if (_instance == null)
            {
                _instance = new FooterUI(param1);
            }
            return _instance;
        }// end function

    }
}
