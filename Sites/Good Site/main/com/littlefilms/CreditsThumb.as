package com.littlefilms{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import gs.*;
	import gs.easing.*;

	public class CreditsThumb extends GalleryThumb {
		private var _thumbLink:String;
		var _labelRestColor:Number;
		var _labelHighlightColor:Number;
		var _bgHighlightColor:Number;

		public function CreditsThumb(param1:Sprite, param2:String, param3:String, param4:String) {
			super(param1, param2, param3);
			_thumbLink = param4;
		}

		override public function init():void {
			super.init();
			unHighlightNavItem();			
		}

		override protected function highlightNavItem():void {
			TweenMax.to(_thumbBG, 0.5, {tint:ColorScheme.creditsThumbBGHover, ease:Expo.easeOut});
			TweenMax.to(_thumbLabel, 0.5, {tint:ColorScheme.creditsThumbTextHover, ease:Expo.easeOut});
		}

		override protected function unHighlightNavItem():void {
			TweenMax.to(_thumbBG, 0.5, {tint:ColorScheme.creditsThumbBG, ease:Expo.easeOut});
			TweenMax.to(_thumbLabel, 0.5, {tint:ColorScheme.creditsThumbText, ease:Expo.easeOut});
		}

		override protected function navClickHandler(event:MouseEvent):void {
			trace("CreditsThumb::navClickHandler()");
			navigateToURL(new URLRequest(_thumbLink), "_blank");
		}
	}
}