package com.littlefilms{
	import flash.display.*;
	import flash.text.*;

	public class WorkProjectDetails extends Sprite {
		private var _member:XML;
		private var _mainMC:Main;
		private var _section:String;
		private var _subSection:String;
		private var _allCopy:Sprite;
		private var _contentWidth:int = 720;
		private var _contentX:int = 0;
		private var _paragraphYSpace:int = 10;

		public function WorkProjectDetails(param1:XML, param2:int) {
			_member = param1;
			_contentWidth = param2;
			trace("_member = " + _member);
		}

		public function init():void {
			layoutContent();
		}

		public function registerMain(param1:Main):void {
			_mainMC = param1;
			trace("_mainMC = " + _mainMC);
		}

		private function layoutContent():void {
			var _loc_11:Sprite;
			var paragraphSprite:Sprite;
			var nodeName:String;
			var paragraphTextField:TextField;
			_allCopy = new Sprite();
			_allCopy.x = _contentX;
			addChild(_allCopy);
			var headerTF:TextFormat = TextFormatter.getTextFmt("_workProjectHeader");
			var subHeaderTF:TextFormat = TextFormatter.getTextFmt("_workProjectSubHeader");
			var copyTF:TextFormat = TextFormatter.getTextFmt("_workProjectCopy");
			var projectName:String = _member.@name;
			var projectNameTF:TextField = new TextField();
			_allCopy.addChild(projectNameTF);
			setLayout(projectNameTF, headerTF, projectName, "fixed");
			var clientName:String = _member.@client;
			var clientNameTF:TextField = new TextField();
			_allCopy.addChild(clientNameTF);
			setLayout(clientNameTF, subHeaderTF, clientName, "fixed");
			clientNameTF.y = projectNameTF.y + projectNameTF.height;
			var i:int = 0;
			for each (var paragraph:XML in _member.description.children()) {

				trace("item = " + paragraph);
				trace("item.name () = " + paragraph.name());
				paragraphSprite = new Sprite();
				nodeName = paragraph.name().toString();
				switch (nodeName) {
					case "p" : {
							paragraphTextField = new TextField();
							setLayout(paragraphTextField, copyTF, paragraph.toString(), "fixed");
							paragraphSprite.addChild(paragraphTextField);
							break;
						};					
				};
				if (i == 0) {
					paragraphSprite.y = clientNameTF.y + clientNameTF.height + _paragraphYSpace;
				} else {
					paragraphSprite.y = _allCopy.height + _paragraphYSpace;
				}
				_allCopy.addChild(paragraphSprite);
				i++;
			}
			_loc_11 = buildSprite(10, _mainMC.paneManager.collapsedPaneHeight);
			_loc_11.y = _allCopy.height;
			_loc_11.alpha = 0;
			_allCopy.addChild(_loc_11);
		}

		private function setLayout(param1:TextField, param2:TextFormat, param3:String, param4:String):void {
			if (param4 == "fixed") {
				param1.multiline = true;
				param1.wordWrap = true;
				param1.width = _contentWidth;
			} else {
				param1.multiline = false;
				param1.wordWrap = false;
			}
			param1.embedFonts = true;
			param1.selectable = false;
			param1.autoSize = TextFieldAutoSize.LEFT;
			param1.antiAliasType = AntiAliasType.ADVANCED;
			if (param2.size <= 12) {
				param1.thickness = 100;
			}
			param1.htmlText = param3;
			param1.setTextFormat(param2);
			return;
		}
		
		private function buildSprite(spriteWidth:int, spriteHeight:int):Sprite {
			var newSprite:Sprite = new Sprite();
			newSprite.graphics.beginFill(15780865);
			newSprite.graphics.drawRect(0, 0, spriteWidth, spriteHeight);
			newSprite.graphics.endFill();
			newSprite.x = 0;
			newSprite.y = 0;
			return newSprite;
		}

	}
}