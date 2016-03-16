package com.littlefilms{
	import flash.display.*;
	import gs.*;
	import gs.easing.*;

	public class WorkNav extends Sprite {
		private var _mainMC:Main;
		private var _parentMC:ContentPane;
		private var _navArray:Array;
		private var _navSpace:uint = 0;
		private var _activeNavItem:NavItem;
		private var _deadNavItem:NavItem;
		private var _activeGallery:WorkGallery;
		private var _deadGallery:WorkGallery;
		private var _navigationItems:Sprite;

		public function WorkNav(param1:Array) {
			_navArray = [];
			_navArray = param1;
		}

		public function init():void {
			_navigationItems = new Sprite();
			addChild(_navigationItems);
			var previousItem:WorkNavItem;
			var currentItem:WorkNavItem;
			trace("WorkNav::init()");
			for each (var summary:Array in _navArray) {
				trace("item[0] = " + summary[0]);
				trace("item[1] = " + summary[1]);
				trace("item[2] = " + summary[2]);
				currentItem = new WorkNavItem(summary[0], summary[1], summary[2]);
				_navigationItems.addChild(currentItem);
				currentItem.registerController(this);
				currentItem.registerMain(_mainMC);
				if (previousItem == null) {
					currentItem.x = 0;
					currentItem.y = 0;
				} else {
					currentItem.x = previousItem.x + previousItem.width + _navSpace;
					currentItem.y = previousItem.y;// + previousItem.height + _navSpace;
				}
				previousItem = currentItem;
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
			if (_activeGallery != null) {
				removeBlock(_activeGallery);
			}
			if (_deadGallery != null && _deadGallery != _activeGallery) {
				removeBlock(_deadGallery);
			}
			_activeGallery = null;
			_deadGallery = null;
			swapNav(_navigationItems.getChildByName(_navArray[0][0]) as WorkNavItem);
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

		public function swapBlock(param1:String):void {
			trace("WorkNav::swapBlock()");
			trace("");
			if (_activeGallery != null) {
				hideBlock();
			} else {
				addBlock();
			}
		}

		public function hideBlock():void {
			trace("Main::hideBlock()");
			TweenMax.to(_deadGallery, 0.5, {autoAlpha:0, ease:Cubic.easeOut, onComplete:removeBlock, onCompleteParams:[_deadGallery]});
			TweenMax.delayedCall(0.6, _mainMC.sequencer.nextStep);
		}

		public function addBlock():void {
			trace("WorkNav::addBlock()");
			if (_activeGallery == null || _activeNavItem.name != _activeGallery.name) {
				removeChild(_navigationItems);
				_activeGallery = _mainMC.contentManager.getWorkGallery(_activeNavItem.name);
				_parentMC.content.addChild(_activeGallery);
				_activeGallery.registerMain(_mainMC);
				_activeGallery.x = 0;
				_activeGallery.y = _parentMC.content.height + 20;
				_activeGallery.alpha = 0;
				_activeGallery.init();
				TweenMax.to(_activeGallery, 0.5, { autoAlpha:1, ease:Cubic.easeOut } );
				addChild(_navigationItems);
				_navigationItems.y = _activeGallery.y + _activeGallery.height + 20;
				_navigationItems.x = (_activeGallery.width - _navigationItems.width) / 2 - 200;
			}
			_parentMC.updateContent();
			_deadGallery = _activeGallery;
			_mainMC.sequencer.nextStep();
		}

		public function removeBlock(param1:WorkGallery):void {
			_parentMC.content.removeChild(param1);
		}

	}
}