package com.littlefilms{
	import flash.display.*;
	import flash.text.*;

	public class MemberDetails extends Sprite {
		private var _member:XML;
		private var _mainMC:Main;
		private var _section:String;
		private var _subSection:String;
		private var _allCopy:Sprite;
		private var _contentWidth:int = 720;
		private var _contentX:int = 225;
		private var _paragraphYSpace:int = 10;

		public function MemberDetails(param1:XML) {
			_member = param1;
		}

		public function init():void {
			layoutContent();
		}

		public function registerMain(param1:Main):void {
			_mainMC = param1;
		}

		private function layoutContent():void {
			var coverSprite:Sprite;
			var paragraphContainer:Sprite;
			var paragraphNodeName:String;
			var paragraphTF:TextField;
			_allCopy = new Sprite();
			_allCopy.x = _contentX;
			addChild(_allCopy);
			var headerFormat:TextFormat = TextFormatter.getTextFmt("_contentBlockHeader");
			var titleFormat:TextFormat = TextFormatter.getTextFmt("_teamMemberTitle");
			var blockFormat:TextFormat = TextFormatter.getTextFmt("_contentBlockCopy");
			var memberName:String = _member.@name;
			var memberNameTF:TextField = new TextField();
			_allCopy.addChild(memberNameTF);
			setLayout(memberNameTF, headerFormat, memberName, "dynamic");
			var memberTitle:String = _member.@title;
			var memberTitleTF:TextField = new TextField();
			_allCopy.addChild(memberTitleTF);
			setLayout(memberTitleTF, titleFormat, memberTitle, "dynamic");
			memberTitleTF.x = memberNameTF.x + memberNameTF.width + 10;
			memberTitleTF.y = memberNameTF.y + memberNameTF.height - memberTitleTF.height - 4;
			var i:int = 0;
			
			for each (var paragraph:XML in _member.description.children()) {
				paragraphContainer = new Sprite();
				paragraphNodeName = paragraph.name().toString();
				switch (paragraphNodeName) {
					case "p" : {
						paragraphTF = new TextField();
						setLayout(paragraphTF, blockFormat, paragraph.toString(), "fixed");
						paragraphContainer.addChild(paragraphTF);
						break;

					};
				};
				if (i == 0) {
					paragraphContainer.y = memberNameTF.y + memberNameTF.height + _paragraphYSpace;
				} else {
					paragraphContainer.y = _allCopy.height + _paragraphYSpace;
				}
				_allCopy.addChild(paragraphContainer);
				i++;
			}
			coverSprite = buildSprite(10, _mainMC.paneManager.collapsedPaneHeight);
			coverSprite.y = _allCopy.height;
			coverSprite.alpha = 0;
			_allCopy.addChild(coverSprite);
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