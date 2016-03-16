package com.littlefilms{
	import flash.display.*;
	import flash.events.*;
	import gs.*;
	import gs.easing.*;

	public class ContentPane extends Sprite {
		protected var _mainMC:Main;
		public var closeButton:Sprite;
		protected var _paneBG:Sprite;
		protected var _maximizeButton:MaximizePaneButton;
		protected var _tempHeight:uint = 300;
		public var contentArea:Sprite;
		public var content:Sprite;
		protected var _contentYBuffer:uint = 35;
		protected var _stageHeight:Number;
		protected var _stageWidth:Number;
		protected var _active:Boolean = false;
		protected var _paneState:String = "inactive";
		private var _collapsedPaneHeight:uint = 22;
		private var _targetY:Number;
		protected var _lastSubSection:String;
		protected var _bgManager:BGManager;

		public function ContentPane(param1:String) {
			name = param1;
			cacheAsBitmap = true;
			_paneBG = new PaneBG();
			_paneBG.name = "paneBG";
			addChild(_paneBG);
			contentArea = new Sprite();
			contentArea.name = "contentArea";
			addChild(contentArea);
			content = new Sprite();
			content.name = "content";
			content.y = _contentYBuffer;
			contentArea.addChild(content);
			closeButton = new CloseButton();
			closeButton.name = "closeButton";
			closeButton.x = 945;
			closeButton.y = 0;
			closeButton.buttonMode = true;
			closeButton.mouseEnabled = true;
			closeButton.mouseChildren = false;
			closeButton.addEventListener(MouseEvent.MOUSE_OVER, closeOverHandler, false, 0, true);
			closeButton.addEventListener(MouseEvent.MOUSE_OUT, closeOutHandler, false, 0, true);
			closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler, false, 0, true);
			contentArea.addChild(closeButton);
			_maximizeButton = new MaximizePaneButton();
		}

		public function init():void {
			_maximizeButton.name = "_maximizeButton";
			_maximizeButton.x = 945;
			_maximizeButton.y = 0;
			_maximizeButton.alpha = 0;
			_maximizeButton.visible = false;
			_maximizeButton.buttonMode = true;
			_maximizeButton.mouseEnabled = true;
			_maximizeButton.mouseChildren = false;
			_maximizeButton.addEventListener(MouseEvent.MOUSE_OVER, maximizeOverHandler, false, 0, true);
			_maximizeButton.addEventListener(MouseEvent.MOUSE_OUT, maximizeOutHandler, false, 0, true);
			_maximizeButton.addEventListener(MouseEvent.CLICK, maximizeClickHandler, false, 0, true);
			contentArea.addChild(_maximizeButton);
			closeOutHandler(null);
			maximizeOutHandler(null);
		}

		public function registerMain(param1:Main):void {
			_mainMC = param1;
			setSize(_mainMC.stageHeight, _mainMC.stageWidth);
			y = _mainMC.stageHeight;
		}

		public function setUpPane():void {
			_mainMC.sequencer.nextStep();
		}

		public function removeCurrentContent(param1:NavItem):void {
			_mainMC.sequencer.nextStep();
		}

		public function revealNewContent(param1:String):void {
			_mainMC.sequencer.nextStep();
		}

		public function updateContent():void {
			updateTargetY();
			animateYPosition(0.5);
		}

		public function animateYPosition(param1:Number):void {
			var _loc_2:* = _targetY == _stageHeight ? (Cubic.easeIn) : (Cubic.easeOut);
			_targetY = Math.round(_targetY);
			TweenMax.to(this, param1, {y:_targetY, ease:_loc_2});
		}

		public function setSize(param1:Number, param2:Number):void {
			_stageHeight = param2;
			_stageWidth = param1;
			positionContent();
		}

		private function positionContent():void {
			_paneBG.x = 0;
			_paneBG.width = _stageWidth;
			_paneBG.height = _stageHeight;
			updateTargetY();
			_targetY = Math.round(_targetY);
			y = _targetY;
			contentArea.x = Math.round((_stageWidth - contentArea.width) / 2);
		}

		protected function updateTargetY():void {
			switch (_paneState) {
				case "active" : {
					_targetY = _stageHeight - contentArea.height - _contentYBuffer * 2;
					break;
				};
				case "inactive" :{
					_targetY = _stageHeight;
					break;

				};
				case "minimized" : {
					_targetY = _stageHeight - _collapsedPaneHeight - _mainMC.footerHeight;
					break;

				};				
			};
		}

		public function minimizePane():void {
			paneState = "minimized";
			updateContent();
			TweenMax.to(closeButton, 0.5, {alpha:0, ease:Expo.easeOut});
			TweenMax.to(_maximizeButton, 0.5, {autoAlpha:1, ease:Expo.easeOut});
			TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);
		}

		public function maximizePane():void {
			paneState = "active";
			updateContent();
			TweenMax.to(closeButton, 0.5, {autoAlpha:1, ease:Expo.easeOut});
			TweenMax.to(_maximizeButton, 0.5, {autoAlpha:0, ease:Expo.easeOut});
			TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);
		}

		public function resetButtons():void {
			closeButton.alpha = 1;
			_maximizeButton.alpha = 0;
			_maximizeButton.visible = false;
		}

		protected function closeOverHandler(event:MouseEvent):void {
			TweenMax.to(closeButton.closeBG, 0.2, {width:event.target.closeArea.width, ease:Expo.easeInOut});
			TweenMax.to(closeButton.buttonLabel, 0.2, {tint:ColorScheme.closeTextHover, ease:Expo.easeInOut});
		}

		protected function closeOutHandler(event:MouseEvent):void {
			TweenMax.to(closeButton.closeBG, 0.2, {width:17, ease:Expo.easeInOut});
			TweenMax.to(closeButton.buttonLabel, 0.2, {tint:ColorScheme.closeText, ease:Expo.easeInOut});
		}

		protected function closeClickHandler(event:MouseEvent):void {
			_mainMC.sequencer.changeSection("none", "");
			_mainMC.footer.swapNav(null);
		}

		protected function maximizeOverHandler(event:MouseEvent):void {
			TweenMax.to(_maximizeButton, 0.2, {tint:ColorScheme.maximizeButtonHover, ease:Expo.easeInOut});
		}

		protected function maximizeOutHandler(event:MouseEvent):void {
			TweenMax.to(_maximizeButton, 0.2, {tint:ColorScheme.maximizeButton, ease:Expo.easeInOut});
		}

		protected function maximizeClickHandler(event:MouseEvent):void {
			_mainMC.sequencer.changeSection("primary", "");
		}

		public function get paneState():String {
			return _paneState;
		}

		public function set paneState(param1:String):void {
			if (param1 !== _paneState) {
				_paneState = param1;
			}
		}

		public function get lastSubSection():String {
			return _lastSubSection;
		}

		public function set lastSubSection(param1:String):void {
			if (param1 !== _lastSubSection) {
				_lastSubSection = param1;
			}
		}
	}
}