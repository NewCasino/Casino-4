package com.littlefilms{
	import flash.display.*;
	import flash.events.*;
	import gs.*;
	import gs.easing.*;

	public class MemberPane extends ContentPane {
		private var _navInfo:Array;
		private var _avatarAreaWidth:int = 190;

		public function MemberPane(param1:String) {
			_navInfo = [];
			trace("MemberPane::()");
			super(param1);
		}

		override public function init():void {
			TweenMax.to(_paneBG, 0, {tint:TextFormatter._mediumGray});
			fetchContent(name);
			super.init();
		}

		private function fetchContent(paneName:String):void {
			var memberNode:XML;
			var imagePath:String;
			var imageName:String;
			var imageWidth:int;
			var imageHeight:int;
			var memberAvatar:Sprite;
			var memberDetails:MemberDetails;
			var members:XMLList = _mainMC.contentManager.contentXML..member;
			
			for each (var member:XML in members) {
				if (member.@id == paneName) {
					memberNode = member;
				}
			}
			
			imagePath = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
			imageName = memberNode.thumbnail.@src.toString();
			imageWidth = memberNode.thumbnail.@width;
			imageHeight = memberNode.thumbnail.@height;
			memberAvatar = _mainMC.contentManager.getImage(imageName, imagePath, imageWidth, imageHeight);
			memberAvatar.x = (_avatarAreaWidth - imageWidth) / 2;
			TweenMax.to(memberAvatar, 0, {dropShadowFilter:{color:0, alpha:0.7, blurX:5, blurY:5, strength:1, distance:2}});
			content.addChild(memberAvatar);
			memberDetails = new MemberDetails(memberNode);
			memberDetails.registerMain(_mainMC);
			memberDetails.x = 0;
			memberDetails.alpha = 0;
			memberDetails.init();
			content.addChild(memberDetails);
			TweenMax.to(memberDetails, 0.5, {autoAlpha:1, ease:Expo.easeInOut});
			trace("memberNode = " + memberNode);
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

		override protected function closeClickHandler(event:MouseEvent):void {
			_mainMC.sequencer.changeSection("primary", "");
		}

	}
}