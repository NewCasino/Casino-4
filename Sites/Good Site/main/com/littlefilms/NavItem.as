package com.littlefilms{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import gs.*;
	import gs.easing.*;

	public class NavItem extends Sprite {
		protected var _targetLabel:String;
		protected var _enabled:Boolean = true;
		protected var _active:Boolean = false;
		protected var _navItemFormat:TextFormat;
		protected var _navItem:TextField;
		protected var _controller:Object;
		protected var _mainMC:Object;
		protected var _bgManager:BGManager;

		public function NavItem(section:String, label:String) {
			trace("NavItem::()");
			trace("section     = " + section);
			trace("targetLabel = " + label);
			name = section;
			_targetLabel = label;
			init();
		}

		protected function init():void {
			layoutCopy();
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
			TweenMax.to(this, 0.2, { removeTint:ColorScheme.defaultNavItem, ease:Expo.easeOut } );
		}

		public function toggleEnabled():void {
			if (_active) {
				buttonMode = false;
				mouseEnabled = false;
				removeEventListener(MouseEvent.MOUSE_OVER, navOverHandler);
				removeEventListener(MouseEvent.MOUSE_OUT, navOutHandler);
				removeEventListener(MouseEvent.CLICK, navClickHandler);
				highlightNavItem();
			} else {
				buttonMode = true;
				mouseEnabled = true;
				addEventListener(MouseEvent.MOUSE_OVER, navOverHandler, false, 0, true);
				addEventListener(MouseEvent.MOUSE_OUT, navOutHandler, false, 0, true);
				addEventListener(MouseEvent.CLICK, navClickHandler, false, 0, true);
				unHighlightNavItem();
			}
		}

		public function registerMain(param1:Sprite):void {
			_mainMC = param1;
		}

		public function registerController(param1:Sprite):void {
			_controller = param1;
		}

		protected function layoutCopy():void {
			_navItem = new TextField();
			_navItem.htmlText = "";
			_navItem.multiline = false;
			_navItem.wordWrap = false;
			_navItem.embedFonts = true;
			_navItem.selectable = false;
			_navItem.autoSize = TextFieldAutoSize.LEFT;
			_navItem.antiAliasType = AntiAliasType.ADVANCED;
			_navItem.htmlText = _targetLabel;
			_navItem.setTextFormat(_navItemFormat);
			addChild(_navItem);
		}

		protected function highlightNavItem():void {
			TweenMax.to(this, 0.2, {tint:ColorScheme.defaultNavItemHover, ease:Expo.easeOut});
		}

		protected function unHighlightNavItem():void {
			TweenMax.to(this, 0.2, { removeTint:ColorScheme.defaultNavItem, ease:Expo.easeOut } );
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
			trace("NavItem::navClickHandler()");
			_controller.swapNav(this);
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