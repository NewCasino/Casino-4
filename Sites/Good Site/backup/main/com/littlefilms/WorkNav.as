package com.littlefilms
{
    import flash.display.*;
    import gs.*;
    import gs.easing.*;

    public class WorkNav extends Sprite
    {
        private var _mainMC:Main;
        private var _parentMC:ContentPane;
        private var _navArray:Array;
        private var _navSpace:uint = 0;
        private var _activeNavItem:NavItem = null;
        private var _deadNavItem:NavItem = null;
        private var _activeGallery:WorkGallery = null;
        private var _deadGallery:WorkGallery = null;

        public function WorkNav(param1:Array)
        {
            _navArray = [];
            _navArray = param1;
            return;
        }// end function

        public function init() : void
        {
            var _loc_1:WorkNavItem = null;
            var _loc_2:Object = null;
            var _loc_3:WorkNavItem = null;
            trace("WorkNav::init()");
            for each (_loc_2 in _navArray)
            {
                
                trace("item[0] = " + _loc_2[0]);
                trace("item[1] = " + _loc_2[1]);
                trace("item[2] = " + _loc_2[2]);
                _loc_3 = new WorkNavItem(_loc_2[0], _loc_2[1], _loc_2[2]);
                addChild(_loc_3);
                _loc_3.registerController(this);
                _loc_3.registerMain(_mainMC);
                if (_loc_1 == null)
                {
                    _loc_3.x = 0;
                    _loc_3.y = 0;
                }
                else
                {
                    _loc_3.x = _loc_1.x;
                    _loc_3.y = _loc_1.y + _loc_1.height + _navSpace;
                }
                _loc_1 = _loc_3;
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

        public function activateFirstItem() : void
        {
            trace("LeftNav::activateFirstItem()");
            if (_activeGallery != null)
            {
                removeBlock(_activeGallery);
            }
            if (_deadGallery != null && _deadGallery != _activeGallery)
            {
                removeBlock(_deadGallery);
            }
            _activeGallery = null;
            _deadGallery = null;
            swapNav(getChildByName(_navArray[0][0]) as WorkNavItem);
            addBlock();
            return;
        }// end function

        public function swapNav(param1:NavItem) : void
        {
            _activeNavItem = param1;
            _activeNavItem.active = true;
            _parentMC.lastSubSection = _activeNavItem.name;
            if (_deadNavItem != null && _deadNavItem != _activeNavItem)
            {
                _deadNavItem.active = false;
            }
            _deadNavItem = _activeNavItem;
            return;
        }// end function

        public function swapBlock(param1:String) : void
        {
            trace("WorkNav::swapBlock()");
            trace("");
            if (_activeGallery != null)
            {
                hideBlock();
            }
            else
            {
                addBlock();
            }
            return;
        }// end function

        public function hideBlock() : void
        {
            trace("Main::hideBlock()");
            TweenMax.to(_deadGallery, 0.5, {autoAlpha:0, ease:Cubic.easeOut, onComplete:removeBlock, onCompleteParams:[_deadGallery]});
            TweenMax.delayedCall(0.6, _mainMC.sequencer.nextStep);
            return;
        }// end function

        public function addBlock() : void
        {
            trace("WorkNav::addBlock()");
            if (_activeGallery == null || _activeNavItem.name != _activeGallery.name)
            {
                _activeGallery = _mainMC.contentManager.getWorkGallery(_activeNavItem.name);
                _parentMC.content.addChild(_activeGallery);
                _activeGallery.registerMain(_mainMC);
                _activeGallery.x = 0;
                _activeGallery.y = _parentMC.content.height + 20;
                _activeGallery.alpha = 0;
                _activeGallery.init();
                TweenMax.to(_activeGallery, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
            }
            _parentMC.updateContent();
            _deadGallery = _activeGallery;
            _mainMC.sequencer.nextStep();
            return;
        }// end function

        public function removeBlock(param1:WorkGallery) : void
        {
            _parentMC.content.removeChild(param1);
            return;
        }// end function

    }
}
