package com.littlefilms
{
    import flash.display.*;
    import gs.*;
    import gs.easing.*;

    public class LeftNav extends Sprite
    {
        private var _mainMC:Main;
        private var _parentMC:ContentPane;
        private var _navArray:Array;
        private var _navSpace:uint = 0;
        private var _activeNavItem:NavItem = null;
        private var _deadNavItem:NavItem = null;
        private var _activeBlock:ContentBlock = null;
        private var _deadBlock:ContentBlock = null;

        public function LeftNav(param1:Array)
        {
            _navArray = [];
            _navArray = param1;
            return;
        }// end function

        public function init() : void
        {
            var _loc_1:LeftNavItem = null;
            var _loc_2:Object = null;
            var _loc_3:LeftNavItem = null;
            for each (_loc_2 in _navArray)
            {
                
                _loc_3 = new LeftNavItem(_loc_2[0], _loc_2[1]);
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
            if (_activeBlock != null)
            {
                removeBlock(_activeBlock);
            }
            if (_deadBlock != null && _deadBlock != _activeBlock)
            {
                removeBlock(_deadBlock);
            }
            _activeBlock = null;
            _deadBlock = null;
            swapNav(getChildByName(_navArray[0][0]) as LeftNavItem);
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

        public function hideBlock() : void
        {
            trace("LeftNav::hideBlock()");
            TweenMax.to(_deadBlock, 0.5, {autoAlpha:0, ease:Cubic.easeOut, onComplete:removeBlock, onCompleteParams:[_deadBlock]});
            TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);
            return;
        }// end function

        public function addBlock() : void
        {
            trace("LeftNav::addBlock()");
            if (_activeBlock == null || _activeNavItem.name != _activeBlock.name)
            {
                _activeBlock = _mainMC.contentManager.getContentBlock(_parentMC.name, _activeNavItem.name);
                _activeBlock.name = _activeNavItem.name;
                _parentMC.content.addChild(_activeBlock);
                _activeBlock.registerMain(_mainMC);
                _activeBlock.x = 0;
                _activeBlock.alpha = 0;
                _activeBlock.init();
                TweenMax.to(_activeBlock, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
            }
            _parentMC.updateContent();
            _deadBlock = _activeBlock;
            _mainMC.sequencer.nextStep();
            return;
        }// end function

        public function removeBlock(param1:ContentBlock) : void
        {
            trace("LeftNav::removeBlock()");
            _parentMC.content.removeChild(param1);
            return;
        }// end function

    }
}
