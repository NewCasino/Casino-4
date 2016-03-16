package com.littlefilms
{
    import com.wirestone.utils.*;
    import flash.display.*;
    import gs.*;

    public class PaneManager extends Sprite
    {
        private var _mainMC:Main;
        private var _bgManager:BGManager;
        private var _testPane:ContentPane;
        private var _activePanes:Array;
        private var _activePrimaryPane:ContentPane = null;
        private var _deadPrimaryPane:ContentPane = null;
        private var _activeSecondaryPane:ContentPane = null;
        private var _deadSecondaryPane:ContentPane = null;
        private var _stageWidth:uint;
        private var _stageHeight:uint;
        private var _headerHeight:Number;
        private var _footerHeight:Number;
        private var _allNavHeight:Number;
        private var _collapsedPaneHeight:uint = 22;

        public function PaneManager()
        {
            _activePanes = [];
            return;
        }// end function

        public function registerMain(param1:Main) : void
        {
            _mainMC = param1;
            ListChildren.listAllChildren(_mainMC);
            _bgManager = _mainMC.getChildByName("bgManager") as BGManager;
            trace("_bgManager = " + _bgManager);
            return;
        }// end function

        public function getPane(param1:String, param2:String) : void
        {
            if (param1 == "primary")
            {
            }
            else if (_activePrimaryPane != null || param1 == "none")
            {
            }
            else
            {
                addPane(param1, param2);
            }
            return;
        }// end function

        public function clearActivePanes() : void
        {
            hidePrimaryPane();
            hideSecondaryPane();
            TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);
            return;
        }// end function

        public function clearSecondaryPane() : void
        {
            hideSecondaryPane();
            TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);
            return;
        }// end function

        public function getDetailPane(param1:String, param2:String) : void
        {
            minimizePrimaryPane();
            return;
        }// end function

        public function minimizePrimaryPane() : void
        {
            _activePrimaryPane.minimizePane();
            return;
        }// end function

        public function maximizePrimaryPane() : void
        {
            trace("PaneManager::maximizePrimaryPane()");
            _activePrimaryPane.maximizePane();
            return;
        }// end function

        private function hidePrimaryPane() : void
        {
            trace("PaneManager::hidePrimaryPane()");
            _activePrimaryPane.paneState = "inactive";
            _activePrimaryPane.updateContent();
            TweenMax.delayedCall(0.5, removePane, [_activePrimaryPane]);
            return;
        }// end function

        public function hideSecondaryPane() : void
        {
            trace("PaneManager::hideSecondaryPane()");
            if (_activeSecondaryPane != null)
            {
                _activeSecondaryPane.paneState = "inactive";
                _activeSecondaryPane.updateContent();
                TweenMax.delayedCall(0.5, removePane, [_activeSecondaryPane]);
            }
            return;
        }// end function

        public function addPane(param1:String, param2:String) : void
        {
            trace("PaneManager::addPane()");
            trace("paneName = " + param1);
            var _loc_3:* = _mainMC.contentManager.getPane(param1, param2);
            _loc_3.setSize(_stageWidth, _stageHeight);
            addChildAt(_loc_3, 0);
            if (param2 != "standard")
            {
                _activeSecondaryPane = _loc_3;
            }
            else
            {
                _activePrimaryPane = _loc_3;
            }
            TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);
            return;
        }// end function

        public function removePane(param1:ContentPane) : void
        {
            removeChild(param1);
            param1.resetButtons();
            if (param1 == _activePrimaryPane)
            {
                _activePrimaryPane = null;
            }
            else
            {
                _activeSecondaryPane = null;
            }
            return;
        }// end function

        public function activatePane(param1:String) : void
        {
            var _loc_2:ContentPane = null;
            trace("PaneManager::activatePane()");
            trace("paneType = " + param1);
            if (param1 != "standard")
            {
                _loc_2 = _activeSecondaryPane;
            }
            else
            {
                _loc_2 = _activePrimaryPane;
            }
            trace("targetPane = " + _loc_2);
            _loc_2.paneState = "active";
            trace("targetPane.paneState = " + _loc_2.paneState);
            _loc_2.updateContent();
            _mainMC.sequencer.nextStep();
            return;
        }// end function

        private function buildSprite(param1:uint, param2:uint) : Sprite
        {
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            var _loc_5:* = new Sprite();
            new Sprite().graphics.beginFill(16777215);
            _loc_5.graphics.drawRect(0, 0, _loc_3, _loc_4);
            _loc_5.graphics.endFill();
            _loc_5.x = 0;
            _loc_5.y = 0;
            return _loc_5;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            _stageWidth = param1;
            _stageHeight = param2;
            if (_activePrimaryPane != null)
            {
                _activePrimaryPane.setSize(param1, param2);
            }
            if (_activeSecondaryPane != null)
            {
                _activeSecondaryPane.setSize(param1, param2);
            }
            var _loc_3:int = 0;
            while (_loc_3 < _activePanes.length)
            {
                
                _activePanes[_loc_3].setSize(param1, param2);
                _loc_3++;
            }
            return;
        }// end function

        public function get activePrimaryPane() : ContentPane
        {
            return _activePrimaryPane;
        }// end function

        public function set activePrimaryPane(param1:ContentPane) : void
        {
            if (param1 !== _activePrimaryPane)
            {
                _activePrimaryPane = param1;
            }
            return;
        }// end function

        public function get activeSecondaryPane() : ContentPane
        {
            return _activeSecondaryPane;
        }// end function

        public function set activeSecondaryPane(param1:ContentPane) : void
        {
            if (param1 !== _activeSecondaryPane)
            {
                _activeSecondaryPane = param1;
            }
            return;
        }// end function

        public function get collapsedPaneHeight() : uint
        {
            return _collapsedPaneHeight;
        }// end function

        public function set collapsedPaneHeight(param1:uint) : void
        {
            if (param1 !== _collapsedPaneHeight)
            {
                _collapsedPaneHeight = param1;
            }
            return;
        }// end function

    }
}
