package com.littlefilms{
	import flash.display.*;

	public class TeamNav extends Sprite {
		private var _mainMC:Main;
		private var _parentMC:ContentPane;
		private var _teamXML:XML;
		private var _navArray:Array;
		private var _navSpace:uint = 120;

		public function TeamNav(param1:XML) {
			_navArray = [];
			_teamXML = param1;
		}

		public function init():void {
			var prevItem:TeamNavItem;
			var curItem:TeamNavItem;
			var members:XMLList = _teamXML..member;
			for each (var _loc_3:XML in members) {
				curItem = new TeamNavItem(_loc_3);
				curItem.registerMain(_mainMC);
				curItem.registerController(this);
				curItem.init();
				addChild(curItem);
				if (prevItem == null) {
					curItem.x = 0;
					curItem.y = 0;
				} else {
					curItem.x = prevItem.x + _navSpace;
					curItem.y = prevItem.y;
				}
				prevItem = curItem;
			}
		}

		public function registerMain(param1:Main):void {
			_mainMC = param1;
		}

		public function registerPane(param1:ContentPane):void {
			_parentMC = param1;
		}

		public function swapNav(param1:NavItem):void {
			
		}

	}
}