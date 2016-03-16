package com.littlefilms{
	import flash.events.*;
	import gs.*;
	import gs.easing.*;

	public class LeftNavItem extends NavItem {

		public function LeftNavItem(section:String, label:String) {
			_navItemFormat = TextFormatter.getTextFmt("_leftNavItem");
			super(section, label);
		}

		override protected function navClickHandler(event:MouseEvent):void {
			trace("override protected function navClickHandler()");
			_mainMC.sequencer.changeSubSection(this);
		}

		override protected function highlightNavItem():void {
			trace("override protected function highlightNavItem");
			TweenMax.to(this, 0.2, {tint:ColorScheme.leftNavItemHover, ease:Expo.easeOut});
		}

	}
}