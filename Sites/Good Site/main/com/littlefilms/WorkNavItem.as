package com.littlefilms{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import gs.*;
	import gs.easing.*;

	public class WorkNavItem extends NavItem {
		private var _highlightDescriptionText:TextField;
		private var _highlightTextFmt:TextFormat;

		public function WorkNavItem(param1:String, param2:String, param3:String) {
			trace("WorkNavItem::()");
			trace("section       = " + param1);
			trace("targetLabel   = " + param2);
			trace("highlightCopy = " + param3);
			trace("WorkNavItem::()");
			_navItemFormat = TextFormatter.getTextFmt("_leftNavItem");
			//_highlightTextFmt = TextFormatter.getTextFmt("_workDescriptionToggleHighlight");
			var hitSpace:Sprite = buildSprite(width, height);
			hitSpace.alpha = 0;
			addChild(hitSpace);
			super(param1, param2);
			/*_highlightDescriptionText = new TextField();
			_highlightDescriptionText.x = 55;
			_highlightDescriptionText.y = 2;
			_highlightDescriptionText.alpha = 0;
			setLayout(_highlightDescriptionText, _highlightTextFmt, param3);
			addChild(_highlightDescriptionText);*/
			unHighlightNavItem();
			trace("WorkNavItem name = " + name);
		}

		override protected function highlightNavItem():void {
			TweenMax.to(this, 0.2, {tint:ColorScheme.workNavItemHover, ease:Expo.easeOut});
			//TweenMax.to(_highlightDescriptionText, 0.2, {alpha:1, ease:Expo.easeOut});
		}

		override protected function unHighlightNavItem():void {
			super.unHighlightNavItem();
			TweenMax.to(this, 0.2, {tint:ColorScheme.workNavItem, ease:Expo.easeOut});
			//TweenMax.to(_highlightDescriptionText, 0.2, {alpha:0, ease:Expo.easeOut});
		}

		override protected function navClickHandler(event:MouseEvent):void {
			trace("WorkNavItem::navClickHandler()");
			_mainMC.sequencer.changeSubSection(this);
		}

		private function setLayout(param1:TextField, param2:TextFormat, param3:String):void {
			param1.multiline = false;
			param1.wordWrap = false;
			param1.embedFonts = true;
			param1.selectable = false;
			param1.autoSize = TextFieldAutoSize.LEFT;
			param1.antiAliasType = AntiAliasType.ADVANCED;
			if (param2.size <= 12) {
				param1.thickness = 100;
			}
			param1.htmlText = param3;
			param1.setTextFormat(param2);
		}

		private function buildSprite(spriteWidth:int, spriteHeight:int):Sprite {
			var newSprite:Sprite = new Sprite();
			newSprite.graphics.beginFill(0);
			newSprite.graphics.drawRect(0, 0, spriteWidth, spriteHeight);
			newSprite.graphics.endFill();
			newSprite.x = 0;
			newSprite.y = 0;
			return newSprite;
		}

	}
}