package com.littlefilms{
	import com.wirestone.utils.*;
	import flash.display.*;
	import gs.*;

	public class FooterUI extends Sprite {
		private var _leftNavItems:Array;
		private var _rightNavItems:Array;
		public var bg:Sprite;
		private var _mainMC:Main;
		private var _footerRightNav:Sprite;
		private var _footerLeftNav:Sprite;
		private var _leftNavXSpace:uint = 130;
		private var _rightNavXSpace:uint = 30;
		private var _footerNavYOffset:int = 2;
		private var _navSpace:uint = 15;
		private var _activeNavItem:NavItem = null;
		private var _deadNavItem:NavItem = null;
		private var _preloadAni:SimplePreloadAnimation;
		public static  var _instance:FooterUI;

		public function FooterUI(mainClip:Sprite) {
			_leftNavItems = [["whatWeDo", "what we do"], ["whoWeAre", "who we are"], ["ourWork", "our work"], ["ourClients", "our clients"]];
			_rightNavItems = [["contactUs", "contact us"]];
			_mainMC = mainClip;
			init();
		}

		private function init():void {
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
			TweenMax.to(_preloadAni, 0, {tint:ColorScheme.animationPreloader});
			addChild(_preloadAni);
			positionNav();
		}

		private function createLeftNav():void {
			var currentItem:FooterNavItem = null;
			var previousItem:FooterNavItem = null;
			var i:int = 0;
			while (i < _leftNavItems.length) {
				currentItem = new FooterNavItem(_leftNavItems[i][0], _leftNavItems[i][1]);
				_footerLeftNav.addChild(currentItem);
				currentItem.registerController(this);
				currentItem.registerMain(_mainMC);
				if (previousItem == null) {
					currentItem.x = 0;
					currentItem.y = 0;
				} else {
					currentItem.x = previousItem.x + previousItem.width + _navSpace;
					currentItem.y = previousItem.y;
				}
				previousItem = currentItem;
				i++;
			}
		}

		private function createRightNav():void {
			var currentItem:FooterNavItem;
			var previousItem:FooterNavItem;
			var i:int = 0;
			while (i < _rightNavItems.length) {

				currentItem = new FooterNavItem(_rightNavItems[i][0], _rightNavItems[i][1]);
				_footerRightNav.addChild(currentItem);
				currentItem.registerController(this);
				currentItem.registerMain(_mainMC);
				if (previousItem == null) {
					currentItem.x = 0;
					currentItem.y = 0;
				} else {
					currentItem.x = previousItem.x + previousItem.width + _navSpace;
					currentItem.y = previousItem.y;
				}
				previousItem = currentItem;
				i++;
			}
			var creditsNav:CreditsNavItem = new CreditsNavItem("credits", "");
			_footerRightNav.addChild(creditsNav);
			creditsNav.registerController(this);
			creditsNav.registerMain(_mainMC);
			creditsNav.x = previousItem.x + previousItem.width + _navSpace;
			creditsNav.y = -3;
		}

		public function swapNav(param1:NavItem):void {
			_activeNavItem = param1;
			if (_activeNavItem != null) {
				_activeNavItem.active = true;
			}
			if (_deadNavItem != null) {
				_deadNavItem.active = false;
			}
			_deadNavItem = _activeNavItem;
		}

		public function setSize(param1:Number, param2:Number):void {
			bg.width = param1;
			positionNav();
		}

		private function positionNav():void {
			_footerLeftNav.x = _leftNavXSpace;
			_footerLeftNav.y = bg.height / 2 - _footerLeftNav.height / 2 + _footerNavYOffset;
			_footerRightNav.x = bg.width - _footerRightNav.width - _rightNavXSpace;
			_footerRightNav.y = bg.height / 2 - _footerRightNav.height / 2 + _footerNavYOffset;
			_preloadAni.width = bg.width;
			return;
		}

		public function get preloadAni():SimplePreloadAnimation {
			return _preloadAni;
		}

		public function set preloadAni(param1:SimplePreloadAnimation):void {
			if (param1 !== _preloadAni) {
				_preloadAni = param1;
			}
		}

		public static function getInstance(param1:Sprite):FooterUI {
			if (_instance == null) {
				_instance = new FooterUI(param1);
			}
			return _instance;
		}

	}
}