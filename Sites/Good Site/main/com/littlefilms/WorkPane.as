package com.littlefilms{
	import flash.text.*;
	import gs.*;

	public class WorkPane extends ContentPane {
		private var _navInfo:Array;
		private var _subNav:WorkNav;

		public function WorkPane(param1:String) {
			_navInfo = [];
			trace("WorkPane::()");
			super(param1);
			_maximizeButton.buttonLabel.text = "back to gallery";
		}

		override public function init():void {
			TweenMax.to(_paneBG, 0, {tint:TextFormatter._mediumGray});
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

		private function fetchContent(param1:String):void {
			trace("WorkPane::fetchContent()");
			trace("paneName = " + param1);
			var format:TextFormat = TextFormatter.getTextFmt("_contentBlockHeader");
			var tf:TextField = new TextField();
			setLayout(tf, format, "our work");
			content.addChild(tf);
			var navSummary:Array = fetchWorkNavInfo(param1);
			_subNav = new WorkNav(navSummary);
			_subNav.registerMain(_mainMC);
			_subNav.registerPane(this);
			_subNav.x = tf.x + tf.width + 40;
			_subNav.y = -3;
			_subNav.init();
			content.addChild(_subNav);
		}

		private function fetchWorkNavInfo(param1:String):Array {
			var summary:Array;
			trace("WorkPane::fetchWorkNavInfo()");
			var folios:XMLList = _mainMC.contentManager.workXML.folio;
			trace("folioList = " + folios);
			for each (var xFolio:XML in folios) {

				trace("item.@id         = " + xFolio.@id);
				trace("item.label       = " + xFolio.label);
				trace("item.description = " + xFolio.description);
				summary = [];
				summary.push(xFolio.@id);
				summary.push(xFolio.label);
				summary.push(xFolio.description);
				_navInfo.push(summary);
			}
			trace("_navInfo = " + _navInfo);
			return _navInfo;
		}

		private function setLayout(targetTextField:TextField, format:TextFormat, text:String):void {
			targetTextField.multiline = false;
			targetTextField.wordWrap = false;
			targetTextField.embedFonts = true;
			targetTextField.selectable = false;
			targetTextField.autoSize = TextFieldAutoSize.LEFT;
			targetTextField.antiAliasType = AntiAliasType.ADVANCED;
			if (format.size <= 12) {
				targetTextField.thickness = 100;
			}
			targetTextField.htmlText = text;
			targetTextField.setTextFormat(format);
		}

	}
}