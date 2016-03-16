package com.littlefilms{
	import flash.display.*;
	import flash.text.*;
	import gs.*;
	import gs.easing.*;

	public class ProjectPhotoLabel extends MovieClip {
		public var buttonLabel:TextField;
		public var buttonBG:MovieClip;
		private static  const MAX_BUTTON_WIDTH:uint = 18;
		private static  const BUTTON_TEXT_BUFFER:uint = 8;

		public function ProjectPhotoLabel(label:String = null) {
			mouseChildren = false;
			buttonLabel.text = label != null ? (label) : (buttonLabel.text);
			buttonLabel.autoSize = TextFieldAutoSize.RIGHT;
			buttonBG.width = buttonLabel.width < MAX_BUTTON_WIDTH ? (MAX_BUTTON_WIDTH) : (buttonLabel.width + BUTTON_TEXT_BUFFER);
			buttonLabel.x = -(buttonBG.width - buttonLabel.width) / 2 - buttonLabel.width;
			init();
		}

		public function init():void {
			unHighlightLabel();
		}

		public function highlightLabel():void {
			TweenMax.to(buttonLabel, 0.2, {tint:ColorScheme.projectPhotoLabelTextHover, ease:Expo.easeOut});
			TweenMax.to(buttonBG, 0.2, {tint:ColorScheme.projectPhotoLabelBGHover, ease:Expo.easeOut});
		}

		public function unHighlightLabel():void {
			TweenMax.to(buttonLabel, 0.2, {tint:ColorScheme.projectPhotoLabelText, ease:Expo.easeOut});
			TweenMax.to(buttonBG, 0.2, {tint:ColorScheme.projectPhotoLabelBG, ease:Expo.easeOut});
		}

		public function hideLabel():void {
			unHighlightLabel();
			TweenMax.to(this, 0.2, {autoAlpha:0, ease:Expo.easeOut});
		}

		public function revealLabel():void {
			TweenMax.to(this, 0.2, {autoAlpha:1, ease:Expo.easeOut});
		}

	}
}