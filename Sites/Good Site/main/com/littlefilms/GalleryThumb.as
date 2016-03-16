package com.littlefilms{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import gs.*;
	import gs.easing.*;

	public class GalleryThumb extends Sprite {
		protected var _itemXML:XML;
		protected var _targetLabel:String;
		protected var _enabled:Boolean = true;
		protected var _active:Boolean = false;
		protected var _thumbLabelFormat:TextFormat;
		protected var _memberTitleFormat:TextFormat;
		protected var _memberTitle:TextField;
		protected var _memberAvatar:Sprite;
		protected var _thumbImageWidth:int = 211;
		protected var _memberAvatarFloat:int = -10;
		protected var _controller:Object;
		protected var _mainMC:Object;
		protected var _thumbImage:Sprite;
		protected var _thumbText:String;
		protected var _thumbLabel:TextField;
		protected var _thumbBorder:int = 7;
		protected var _thumbBG:Sprite;
		protected var _thumbBaseColor:Number;		
		protected var _bgManager:BGManager;

		public function GalleryThumb(img:Sprite, label:String, thumbName:String) {
			_thumbImage = img;
			_thumbText = label;
			name = thumbName;
			_thumbLabelFormat = TextFormatter.getTextFmt("_workGalleryThumb");			
			_thumbBaseColor = TextFormatter._lightGray;
			cacheAsBitmap = true;
			
		}

		public function init():void {
			layoutButton();
			mouseChildren = false;
			if (_active) {
				trace("NavItem: " + name + " is active by default.");
			} else {
				buttonMode = true;
				mouseEnabled = true;
				addEventListener(MouseEvent.MOUSE_OVER, navOverHandler, false, 0, true);
				addEventListener(MouseEvent.MOUSE_OUT, navOutHandler, false, 0, true);
				addEventListener(MouseEvent.CLICK, navClickHandler, false, 0, true);
			}
		}

		public function toggleEnabled():void {
			trace("LeftNavItem::toggleEnabled()");
			if (_active) {
				trace("Disable " + name);
				buttonMode = false;
				mouseEnabled = false;
				removeEventListener(MouseEvent.MOUSE_OVER, navOverHandler);
				removeEventListener(MouseEvent.MOUSE_OUT, navOutHandler);
				removeEventListener(MouseEvent.CLICK, navClickHandler);
				highlightNavItem();
			} else {
				trace("Enable " + name);
				buttonMode = true;
				mouseEnabled = true;
				addEventListener(MouseEvent.MOUSE_OVER, navOverHandler, false, 0, true);
				addEventListener(MouseEvent.MOUSE_OUT, navOutHandler, false, 0, true);
				addEventListener(MouseEvent.CLICK, navClickHandler, false, 0, true);
				unHighlightNavItem();
			}
		}

		public function registerMain(mainClip:Sprite):void {
			_mainMC = mainClip;
		}

		public function registerController(controller:Sprite):void {
			_controller = controller;
		}

		protected function layoutButton():void {
			trace("GalleryThumb::layoutButton()");
			_thumbImage.x = _thumbBorder;
			_thumbImage.y = _thumbBorder;
			_thumbImage.width = _thumbImageWidth;
			_thumbImage.scaleY = _thumbImage.scaleX;
			addChild(_thumbImage);
			_thumbLabel = new TextField();
			_thumbLabel.x = _thumbImage.x;
			_thumbLabel.y = _thumbImage.y + _thumbImage.height;
			_thumbLabel.width = _thumbImage.width;
			setLayout(_thumbLabel, _thumbLabelFormat, _thumbText);
			addChild(_thumbLabel);
			var bgWidth:int = width + _thumbBorder * 2;
			var bgHeight:int = height + _thumbBorder * 2 - 5;
			_thumbBG = buildSprite(bgWidth, bgHeight);
			addChildAt(_thumbBG, 0);
		}

		protected function highlightNavItem():void {
			TweenMax.to(_thumbBG, 0.5, {tint:ColorScheme.workGalleryThumbBGHover, ease:Expo.easeOut});
			TweenMax.to(_thumbLabel, 0.5, {tint:ColorScheme.workGalleryThumbTextHover, ease:Expo.easeOut});
		}

		protected function unHighlightNavItem():void {
			TweenMax.to(_thumbBG, 0.5, {removeTint:true, ease:Expo.easeOut});
			TweenMax.to(_thumbLabel, 0.5, {removeTint:true, ease:Expo.easeOut});
		}

		private function setLayout(param1:TextField, param2:TextFormat, param3:String):void {
			param1.multiline = true;
			param1.wordWrap = true;
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
			newSprite.graphics.beginFill(ColorScheme.workGalleryThumbBG);
			newSprite.graphics.drawRect(0, 0, spriteWidth, spriteHeight);
			newSprite.graphics.endFill();
			newSprite.x = 0;
			newSprite.y = 0;
			return newSprite;
		}

		protected function navOverHandler(event:MouseEvent):void {
			if (_enabled) {
				highlightNavItem();
			}
		}

		protected function navOutHandler(event:MouseEvent):void {
			unHighlightNavItem();
		}

		protected function navClickHandler(event:MouseEvent):void {
			trace("GalleryThumb::navClickHandler()");
			_mainMC.sequencer.changeSection(name, "project");
		}

		public function get targetLabel():String {
			return _targetLabel;
		}

		public function set targetLabel(param1:String):void {
			if (param1 !== _targetLabel) {
				_targetLabel = param1;
			}
		}

		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled(param1:Boolean):void {
			_enabled = param1;
		}

		public function get active():Boolean {
			return _active;
		}

		public function set active(param1:Boolean):void {
			_active = param1;
			toggleEnabled();
		}

	}
}