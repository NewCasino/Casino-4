package com.littlefilms{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import gs.*;

	public class ClientsPane extends ContentPane {
		private var _allCopy:Sprite;
		private var _contentAreaWidth:uint = 945;
		private var _paragraphYSpace:uint = 10;
		private var _headerBaselineBuffer:uint = 5;
		private var _copyWidth:uint;
		private var _clientsXMLList:XMLList;

		public function ClientsPane(param1:String) {
			trace("ClientsPane::()");
			super(param1);
		}

		override public function init():void {
			var subSections:XMLList = _mainMC.contentManager.contentXML.section.subSection;
			for each (var subSection:XML in subSections) {
				
				if (subSection.@id == "ourClients") {
					_clientsXMLList = subSection.children();
				}
			}
			trace("_clientsXMLList = " + _clientsXMLList);
			TweenMax.to(_paneBG, 0, { tint:ColorScheme.clientsPaneBG} );
			fetchContent(name);
			fetchGallery();
			super.init();
		}

		private function fetchContent(param1:String):void {
			var paragraph:TextField = null;
			var headerTF:TextFormat = TextFormatter.getTextFmt("_ourClientsHeader");
			var copyTF:TextFormat = TextFormatter.getTextFmt("_ourClientsCopy");
			var clientsText:TextField = new TextField();
			
			var texf:TextFormatter = new TextFormatter();
			var colors:ColorScheme = new ColorScheme();
			
			setLayout(clientsText, headerTF, "our clients", "dynamic");
			content.addChild(clientsText);
			_allCopy = new Sprite();
			_allCopy.x = clientsText.x + clientsText.width + 40;
			content.addChild(_allCopy);
			_copyWidth = _contentAreaWidth - _allCopy.x;
			var clients:XMLList = _clientsXMLList;
			var i:int = 0;
			for each (var node:XML in clients) {
				paragraphContainer = new Sprite();
				nodeName = node.name().toString();
				switch (nodeName) {
					case "p" :
						{
							paragraph = new TextField();
							setLayout(paragraph, copyTF, node.toString(), "fixed");
							paragraphContainer.addChild(paragraph);
							break;

						};
				};
				if (i == 0) {
					paragraphContainer.y = clientsText.height - paragraphContainer.height - _headerBaselineBuffer;
				} else {
					paragraphContainer.y = _allCopy.height + _paragraphYSpace;
				}
				_allCopy.addChild(paragraphContainer);
				i++;
			}
		}

		private function fetchGallery():void {
			var clientGallery:ClientsGallery = new ClientsGallery(_clientsXMLList);
			clientGallery.registerMain(_mainMC);
			clientGallery.x = 0;
			clientGallery.y = content.height + 20;
			clientGallery.alpha = 1;
			clientGallery.init();
			content.addChild(clientGallery);
		}

		private function setLayout(targetTextField:TextField, format:TextFormat, param3:String, param4:String):void {
			var newCSS:StyleSheet = new StyleSheet();
			newCSS.setStyle("a:link", {fontWeight:"bold", color:"#1b1b1b"});
			newCSS.setStyle("a:hover", {fontWeight:"bold", color:"#81735d"});
			newCSS.setStyle("a:active", {fontWeight:"bold", color:"#1b1b1b"});
			if (param4 == "fixed") {
				targetTextField.multiline = true;
				targetTextField.wordWrap = true;
				targetTextField.width = _copyWidth;
			} else {
				targetTextField.multiline = false;
				targetTextField.wordWrap = false;
			}
			targetTextField.addEventListener(TextEvent.LINK, onHyperLinkEvent);
			targetTextField.embedFonts = true;
			targetTextField.selectable = false;
			targetTextField.autoSize = TextFieldAutoSize.LEFT;
			targetTextField.antiAliasType = AntiAliasType.ADVANCED;
			if (format.size <= 12) {
				targetTextField.thickness = 100;
			}
			targetTextField.htmlText = param3;
			targetTextField.setTextFormat(format);
			targetTextField.styleSheet = newCSS;
		}

		private function onHyperLinkEvent(event:TextEvent):void {
			trace("**click**" + event.text);
			var _loc_2:* = event.target.htmlText;
			_loc_2 = _loc_2.split("\'event:" + event.text + "\'").join("\'event:" + event.text + "\' class=\'visited\' ");
			event.target.htmlText = _loc_2;
		}

	}
}