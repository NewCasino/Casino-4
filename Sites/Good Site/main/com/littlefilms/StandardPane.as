package com.littlefilms{
	import gs.*;

	public class StandardPane extends ContentPane {
		private var _navInfo:Array;
		private var _childCount:int;
		private var _subNav:LeftNav;

		public function StandardPane(param1:String) {
			_navInfo = [];
			super(param1);
			_maximizeButton.buttonLabel.text = "back to team";
		}

		override public function init():void {
			switch (name) {
				case "whoWeAre" : {
						TweenMax.to(_paneBG, 0, {tint:ColorScheme.whoWeAreBG});
						break;
					};
				case "whatWeDo" : {
						TweenMax.to(_paneBG, 0, {tint:ColorScheme.whatWeDoBG});
						break;
					};
				case "contactUs" : {
						TweenMax.to(_paneBG, 0, {tint:ColorScheme.contactUsBG});
						break;
				}

			};
			fetchContent(name);
			super.init();
		}

		override public function setUpPane():void {
			_subNav.activateFirstItem();
		}

		override public function removeCurrentContent(param1:NavItem):void {
			_subNav.swapNav(param1);
			_subNav.hideBlock();
		}

		override public function revealNewContent(param1:String):void {
			_subNav.addBlock();
		}

		private function fetchContent(section:String):void {
			var navigationData:Array = fetchLeftNavInfo(section);
			_subNav = new LeftNav(navigationData);
			_subNav.registerMain(_mainMC);
			_subNav.registerPane(this);
			trace("_childCount = " + _childCount);
			if (_childCount > 1) {
				content.addChild(_subNav);
			}
			_subNav.init();
		}

		private function fetchLeftNavInfo(sectionID:String):Array {
			var sections:XMLList = _mainMC.contentManager.contentXML.section;
			var sectionNode:XMLList = new XMLList("");

			for each (var item:XML in sections) {
				if (item.@id == sectionID) {
					sectionNode = item.children();
				}
			}

			var navItem:Array;
			 _childCount = sectionNode.length();
			for each (item in sectionNode) {
				navItem = [];
				navItem.push(item.@id.toString());
				navItem.push(item.@name.toString());
				_navInfo.push(navItem);
			}
			return _navInfo;
		}

		public function get subNav():LeftNav {
			return _subNav;
		}

		public function set subNav(param1:LeftNav):void {
			if (param1 !== _subNav) {
				_subNav = param1;
			}
		}

	}
}