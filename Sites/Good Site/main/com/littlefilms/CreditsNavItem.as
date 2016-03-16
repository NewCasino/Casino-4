package com.littlefilms{
	import flash.events.*;
	import flash.text.*;
	import gs.*;
	import gs.easing.*;

	public class CreditsNavItem extends NavItem {

		public function CreditsNavItem(param1:String, param2:String) {
			_navItemFormat = TextFormatter.getTextFmt("_footerNavItem");
			super(param1, param2);
		}

		override protected function navClickHandler(event:MouseEvent):void {
			super.navClickHandler(event);
			_mainMC.sequencer.changeSection(name, "standard");
		}

		override protected function highlightNavItem():void {
			var  highlightColor:uint = TextFormatter.getColor("_yellow");
			TweenMax.to(this, 0.2, {tint:highlightColor, ease:Expo.easeOut});
		}

	}
}