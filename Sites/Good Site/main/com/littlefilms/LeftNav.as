package com.littlefilms{
	import flash.display.*;
	import gs.*;
	import gs.easing.*;

	public class LeftNav extends Sprite {
		private var _mainMC:Main;
		private var _parentMC:ContentPane;
		private var _navArray:Array;
		private var _navSpace:uint = 0;
		private var _activeNavItem:NavItem = null;
		private var _deadNavItem:NavItem = null;
		private var _activeBlock:ContentBlock = null;
		private var _deadBlock:ContentBlock = null;

		public function LeftNav(content:Array) {
			_navArray = content;
		}

		public function init():void {
			var prevNavItem:LeftNavItem;
			var currentNavItem:LeftNavItem = null;
			for each (var itemData:Array in _navArray) {
				currentNavItem = new LeftNavItem(itemData[0], itemData[1]);
				addChild(currentNavItem);
				currentNavItem.registerController(this);
				currentNavItem.registerMain(_mainMC);
				if (prevNavItem == null) {
					currentNavItem.x = 0;
					currentNavItem.y = 0;
				} else {
					currentNavItem.x = prevNavItem.x;
					currentNavItem.y = prevNavItem.y + prevNavItem.height + _navSpace;
				}
				prevNavItem = currentNavItem;
			}
		}

		public function registerMain(param1:Main):void {
			_mainMC = param1;
		}

		public function registerPane(param1:ContentPane):void {
			_parentMC = param1;
		}

		public function activateFirstItem():void {
			trace("LeftNav::activateFirstItem()");
			if (_activeBlock != null) {
				removeBlock(_activeBlock);
			}
			if (_deadBlock != null && _deadBlock != _activeBlock) {
				removeBlock(_deadBlock);
			}
			_activeBlock = null;
			_deadBlock = null;
			swapNav(getChildByName(_navArray[0][0]) as LeftNavItem);
			addBlock();
		}

		public function swapNav(param1:NavItem):void {
			_activeNavItem = param1;
			_activeNavItem.active = true;
			_parentMC.lastSubSection = _activeNavItem.name;
			if (_deadNavItem != null && _deadNavItem != _activeNavItem) {
				_deadNavItem.active = false;
			}
			_deadNavItem = _activeNavItem;
		}

		public function hideBlock():void {
			trace("LeftNav::hideBlock()");
			TweenMax.to(_deadBlock, 0.5, {autoAlpha:0, ease:Cubic.easeOut, onComplete:removeBlock, onCompleteParams:[_deadBlock]});
			TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);
		}

		public function addBlock():void {
			trace("LeftNav::addBlock()");
			if (_activeBlock == null || _activeNavItem.name != _activeBlock.name) {
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
		}

		public function removeBlock(param1:ContentBlock):void {
			trace("LeftNav::removeBlock()");
			_parentMC.content.removeChild(param1);
		}

	}
}