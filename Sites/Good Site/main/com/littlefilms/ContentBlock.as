package com.littlefilms{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;

	public class ContentBlock extends Sprite {
		private var _mainMC:Main;
		private var _section:String;
		private var _subSection:String;
		private var _allCopy:Sprite;
		private var _contentWidth:int;
		private var _contentX:int = 225;
		private var _paragraphYSpace:int = 10;

		public function ContentBlock(section:String, subSection:String, contentWidth:int) {
			_section = section;
			_subSection = subSection;
			_contentWidth = contentWidth;
		}

		public function init():void {
			layoutContent();
		}

		public function registerMain(param1:Main):void {
			_mainMC = param1;
		}

		private function layoutContent():void {
			var contentParagraphFmt:TextFormat;
			var headerCopy:String;
			var contentHeader:TextField;
			var childCount:int;
			var contentContainer:Sprite;
			var itemName:String;
			var newParagraph:TextField;
			var imagePath:String;
			var imageName:String;
			var imageWidth:int;
			var imageHeight:int;
			var contentImage:Sprite;
			var teamNav:TeamNav;
			_allCopy = new Sprite();
			_allCopy.x = _contentX;
			addChild(_allCopy);
			trace("_section = " + _section);
			if (_section == "contactUs") {
				contentParagraphFmt = TextFormatter.getTextFmt("_contactUsCopy");
			} else {
				contentParagraphFmt = TextFormatter.getTextFmt("_contentBlockCopy");
			}
			var contentHeaderFmt:* = TextFormatter.getTextFmt("_contentBlockHeader");
			
			var sections:XMLList = _mainMC.contentManager.contentXML.section;
			var subSections:XMLList = new XMLList("");
			for each (var section:XML in sections) {				
				if (section.@id == _section) {
					subSections = section.subSection
				}
			}
			var blockSource:XML;
			for each (var subSection:XML in subSections) {
				if (subSection.@id == _subSection) {
					blockSource = subSection;
				}
			}
			headerCopy = blockSource.@name;
			contentHeader = new TextField();
			_allCopy.addChild(contentHeader);
			setLayout(contentHeader, contentHeaderFmt, headerCopy);
			childCount = blockSource.children().length();
			
			var i:int = 0;			
			for each (var item:XML in blockSource.children()) {
				contentContainer = new Sprite();
				itemName = item.name().toString();
				switch (itemName) {
					case "p" : {
						newParagraph = new TextField();
						setLayout(newParagraph, contentParagraphFmt, item.toString());
						contentContainer.addChild(newParagraph);
						break;
					};
					case "image" : {
						imagePath = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
						imageName = item.@src.toString();
						imageWidth = item.@width;
						imageHeight = item.@height;
						contentImage = _mainMC.contentManager.getImage(imageName, imagePath, imageWidth, imageHeight);
						contentContainer.addChild(contentImage);
						break;
					};
					case "crew" : {
						teamNav = new TeamNav(item);
						teamNav.registerMain(_mainMC);
						teamNav.init();
						contentContainer.addChild(teamNav);
						break;
					};
				};
				if (i == 0) {
					contentContainer.y = contentHeader.y + contentHeader.height + _paragraphYSpace;
				} else if (itemName == "crew") {
					contentContainer.y = _allCopy.height + _paragraphYSpace + 10;
				} else {
					contentContainer.y = _allCopy.height + _paragraphYSpace;
				}
				_allCopy.addChild(contentContainer);
				i++;
			}
		}

		private function setLayout(targetTextField:TextField, format:TextFormat, text:String):void {
			var newCSS:StyleSheet = new StyleSheet();			
			newCSS.setStyle("a:link", {fontWeight:"bold", color:"#1b1b1b"});
			newCSS.setStyle("a:hover", {fontWeight:"bold", color:"#81735d"});
			newCSS.setStyle("a:active", {fontWeight:"bold", color:"#1b1b1b"});
			targetTextField.addEventListener(TextEvent.LINK, onHyperLinkEvent);
			targetTextField.multiline = true;
			targetTextField.wordWrap = true;
			targetTextField.embedFonts = true;
			targetTextField.selectable = false;
			targetTextField.width = _contentWidth;
			targetTextField.autoSize = TextFieldAutoSize.LEFT;
			targetTextField.antiAliasType = AntiAliasType.ADVANCED;
			if (format.size <= 12) {
				targetTextField.thickness = 100;
			}
			targetTextField.htmlText = text;
			targetTextField.setTextFormat(format);
			targetTextField.styleSheet = newCSS;
		}

		private function onHyperLinkEvent(event:TextEvent):void {
			trace("**click**" + event.text);
			trace("event.target = " + event.target);
			var _loc_2:* = event.target.htmlText;
			_loc_2 = _loc_2.split("\'event:" + event.text + "\'").join("\'event:" + event.text + "\' class=\'visited\' ");
			event.target.htmlText = _loc_2;
		}

		private function buildSprite(param1:int, param2:int):Sprite {
			var _loc_3:* = param1;
			var _loc_4:* = param2;
			var _loc_5:* = new Sprite();
			new Sprite  .graphics.beginFill(15780865);
			_loc_5.graphics.drawRect(0, 0, _loc_3, _loc_4);
			_loc_5.graphics.endFill();
			_loc_5.x = 0;
			_loc_5.y = 0;
			return _loc_5;
		}

	}
}