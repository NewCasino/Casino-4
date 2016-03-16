package com.littlefilms {
	import com.wirestone.utils.*;
	import flash.display.*;
	import gs.*;

	public class PaneManager extends Sprite {
		private var _mainMC:Main;
		private var _bgManager:BGManager;
		private var _testPane:ContentPane;
		private var _activePanes:Array;
		private var _activePrimaryPane:ContentPane = null;
		private var _deadPrimaryPane:ContentPane = null;
		private var _activeSecondaryPane:ContentPane = null;
		private var _deadSecondaryPane:ContentPane = null;
		private var _stageWidth:int;
		private var _stageHeight:int;
		private var _headerHeight:Number;
		private var _footerHeight:Number;
		private var _allNavHeight:Number;
		private var _collapsedPaneHeight:int = 22;

		public function PaneManager() {
			_activePanes = [];
		}

		public function registerMain(param1:Main):void {
			_mainMC = param1;
			ListChildren.listAllChildren(_mainMC);
			_bgManager = _mainMC.getChildByName("bgManager") as BGManager;
			trace("_bgManager = " + _bgManager);
		}

		public function getPane(param1:String, param2:String):void {
			if (param1 == "primary") {
			} else if (_activePrimaryPane != null || param1 == "none") {
			} else {
				addPane(param1, param2);
			}
		}

		public function clearActivePanes():void {
			hidePrimaryPane();
			hideSecondaryPane();
			TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);
		}

		public function clearSecondaryPane():void {
			hideSecondaryPane();
			TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);
		}

		public function getDetailPane(param1:String, param2:String):void {
			minimizePrimaryPane();
		}

		public function minimizePrimaryPane():void {
			_activePrimaryPane.minimizePane();
		}

		public function maximizePrimaryPane():void {
			trace("PaneManager::maximizePrimaryPane()");
			_activePrimaryPane.maximizePane();
		}

		private function hidePrimaryPane():void {
			trace("PaneManager::hidePrimaryPane()");
			_activePrimaryPane.paneState = "inactive";
			_activePrimaryPane.updateContent();
			TweenMax.delayedCall(0.5, removePane, [_activePrimaryPane]);
		}

		public function hideSecondaryPane():void {
			trace("PaneManager::hideSecondaryPane()");
			if (_activeSecondaryPane != null) {
				_activeSecondaryPane.paneState = "inactive";
				_activeSecondaryPane.updateContent();
				TweenMax.delayedCall(0.5, removePane, [_activeSecondaryPane]);
			}
		};
	

		public function addPane(param1:String, param2:String):void {
			trace("PaneManager::addPane()");
			trace("paneName = " + param1);
			var _loc_3:ContentPane = _mainMC.contentManager.getPane(param1, param2);
			_loc_3.setSize(_stageWidth, _stageHeight);
			addChildAt(_loc_3, 0);
			if (param2 != "standard") {
				_activeSecondaryPane = _loc_3;
			} else {
				_activePrimaryPane = _loc_3;
			}
			TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);
		}
	
		public function removePane(param1:ContentPane):void {
			removeChild(param1);
			param1.resetButtons();
			if (param1 == _activePrimaryPane) {
				_activePrimaryPane = null;
			} else {
				_activeSecondaryPane = null;
			}
		}
	
		public function activatePane(param1:String):void {
			var _loc_2:ContentPane = null;
			trace("PaneManager::activatePane()");
			trace("paneType = " + param1);
			if (param1 != "standard") {
				_loc_2 = _activeSecondaryPane;
			} else {
				_loc_2 = _activePrimaryPane;
			}
			trace("targetPane = " + _loc_2);
			_loc_2.paneState = "active";
			trace("targetPane.paneState = " + _loc_2.paneState);
			_loc_2.updateContent();
			_mainMC.sequencer.nextStep();
		}
		
		private function buildSprite(spriteWidth:int, spriteHeight:int):Sprite {
			var newSprite:Sprite = new Sprite();
			newSprite.graphics.beginFill(16777215);
			newSprite.graphics.drawRect(0, 0, spriteWidth, spriteHeight);
			newSprite.graphics.endFill();
			newSprite.x = 0;
			newSprite.y = 0;
			return newSprite;
		}
	
		public function setSize(param1:Number, param2:Number):void {
			_stageWidth = param1;
			_stageHeight = param2;
			if (_activePrimaryPane != null) {
				_activePrimaryPane.setSize(param1, param2);
			}
			if (_activeSecondaryPane != null) {
				_activeSecondaryPane.setSize(param1, param2);
			}
			var _loc_3:int = 0;
			while (_loc_3 < _activePanes.length) {
				_activePanes[_loc_3].setSize(param1, param2);
				_loc_3++;
			}
		}
	
		public function get activePrimaryPane():ContentPane {
			return _activePrimaryPane;
		}
	
		public function set activePrimaryPane(param1:ContentPane):void {
			if (param1 !== _activePrimaryPane) {
				_activePrimaryPane = param1;
			}
		}
	
		public function get activeSecondaryPane():ContentPane {
			return _activeSecondaryPane;
		}
	
		public function set activeSecondaryPane(param1:ContentPane):void {
			if (param1 !== _activeSecondaryPane) {
				_activeSecondaryPane = param1;
			}
		}
	
		public function get collapsedPaneHeight():int {
			return _collapsedPaneHeight;
		}
	
		public function set collapsedPaneHeight(param1:int):void {
			if (param1 !== _collapsedPaneHeight) {
				_collapsedPaneHeight = param1;
			}
		}
	}
}