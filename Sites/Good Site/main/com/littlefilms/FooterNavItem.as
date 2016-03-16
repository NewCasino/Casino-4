package com.littlefilms{
	import flash.events.*;
	import gs.*;
	import gs.easing.*;

	public class FooterNavItem extends NavItem {

		public function FooterNavItem(section:String, label:String) {
			_navItemFormat = TextFormatter.getTextFmt("_footerNavItem");
			super(section, label);
		}

		override protected function navClickHandler(event:MouseEvent):void {
			super.navClickHandler(event);
			_mainMC.sequencer.changeSection(name, "standard");
		}

		override protected function highlightNavItem():void {
			TweenMax.to(this, 0.2, {tint:ColorScheme.footerNavItemHover, ease:Expo.easeOut});
		}

	}
}