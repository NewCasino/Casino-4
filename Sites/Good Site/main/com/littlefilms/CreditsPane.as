package com.littlefilms{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import gs.*;

	public class CreditsPane extends ContentPane {
		private var _allCopy:Sprite;
		private var _contentAreaWidth:int = 945;
		private var _paragraphYSpace:int = 10;
		private var _headerBaselineBuffer:int = 5;
		private var _copyWidth:int;
		private var _imagesXML:XML;

		public function CreditsPane(param1:String) {
			trace("CreditsPane::()");
			super(param1);
		}

		override public function init():void {
			_imagesXML = _mainMC.contentManager.imagesXML;
			TweenMax.to(_paneBG, 0, { tint:ColorScheme.creditsPaneBG} );
			fetchContent(name);
			fetchGallery();
			super.init();
		}

		private function fetchContent(param1:String):void {			
			var textSprite:Sprite;
			var paragraphName:String;
			var paragraphTF:TextField;
			var headerFormat:TextFormat = TextFormatter.getTextFmt("_contentBlockHeader");
			var paragraphFormat:TextFormat = TextFormatter.getTextFmt("_contentBlockCopy");
			var headerTF:TextField = new TextField();
			setLayout(headerTF, headerFormat, "photo credits", "dynamic");
			content.addChild(headerTF);
			_allCopy = new Sprite();
			_allCopy.x = headerTF.x + headerTF.width + 40;
			content.addChild(_allCopy);
			_copyWidth = _contentAreaWidth - _allCopy.x;
			var _loc_5:XMLList = _imagesXML.creditCopy;
			var i:int = 0;
			
			for each (var paragraphXml:XML in _loc_5.children()) {
				textSprite = new Sprite();
				paragraphName = paragraphXml.name().toString();
				switch (paragraphName) {
					case "p" : {
						paragraphTF = new TextField();
						setLayout(paragraphTF, paragraphFormat, paragraphXml.toString(), "fixed");
						textSprite.addChild(paragraphTF);
						break;
					};
					
				};
				textSprite.y = _allCopy.height + _paragraphYSpace;
				_allCopy.addChild(textSprite);
				i++;
			}
		}

		private function fetchGallery():void {
			trace("CreditsPane::fetchGallery()");
			var gallery:CreditsGallery = new CreditsGallery(_imagesXML);
			gallery.registerMain(_mainMC);
			gallery.x = 0;
			gallery.y = content.height + 20;
			gallery.alpha = 1;
			gallery.init();
			content.addChild(gallery);
		}

		private function setLayout(param1:TextField, param2:TextFormat, param3:String, param4:String):void {			
			var newCSS:StyleSheet = new StyleSheet();			
			newCSS.setStyle("a:link", {fontWeight:"bold", color:"#1b1b1b"});
			newCSS.setStyle("a:hover", {fontWeight:"bold", color:"#81735d"});
			newCSS.setStyle("a:active", {fontWeight:"bold", color:"#1b1b1b"});
			
			if (param4 == "fixed") {
				param1.multiline = true;
				param1.wordWrap = true;
				param1.width = _copyWidth;
			} else {
				param1.multiline = false;
				param1.wordWrap = false;
			}
			param1.addEventListener(TextEvent.LINK, onHyperLinkEvent);
			param1.embedFonts = true;
			param1.selectable = false;
			param1.autoSize = TextFieldAutoSize.LEFT;
			param1.antiAliasType = AntiAliasType.ADVANCED;
			if (param2.size <= 12) {
				param1.thickness = 100;
			}
			param1.htmlText = param3;
			param1.setTextFormat(param2);
			param1.styleSheet = newCSS;
			var textHeight:int = param1.height;
			param1.autoSize = TextFieldAutoSize.NONE;
			param1.height = textHeight + param1.getTextFormat().leading + 1;
		}

		private function onHyperLinkEvent(event:TextEvent):void {
			trace("**click**" + event.text);
			var _loc_2:* = event.target.htmlText;
			_loc_2 = _loc_2.split("\'event:" + event.text + "\'").join("\'event:" + event.text + "\' class=\'visited\' ");
			event.target.htmlText = _loc_2;
		}

	}
}