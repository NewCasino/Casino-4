package com.littlefilms{
	import flash.display.*;
	import flash.events.*;
	import gs.*;
	import gs.easing.*;

	public class WorkProjectPane extends ContentPane {
		private var _navInfo:Array;
		private var _memberNode:XML;
		private var _avatarAreaWidth:int = 190;
		private var _contentAreaWidth:int = 945;
		private var _photoLabel:ProjectPhotoLabel;
		private var _thumbPhotoArray:Array;
		private var _activeItem:int = 0;
		private var _activeVideoScreen:VideoScreen = null;

		public function WorkProjectPane(param1:String) {
			_navInfo = [];
			_thumbPhotoArray = [];
			trace("WorkProjectPane::()");
			super(param1);
		}

		override public function init():void {
			TweenMax.to(_paneBG, 0, { tint:ColorScheme.workProjectPaneBG } );
			fetchContent(name);
			super.init();
		}

		private function fetchContent(paneName:String):void {
			var imageButton:Sprite;
			
			var copyWidth:int;
			var projectDetails:WorkProjectDetails;
			var imageName:String;
			var imageWidth:int;
			var imageHeight:int;
			var videoThumbnail:Sprite;
			var titleLabel:ProjectPhotoLabel;
			var numberLabel:ProjectPhotoLabel;
			
			var projects:XMLList = _mainMC.contentManager.workXML..project;
			for each (var project:XML in projects) {
				if (project.@id == paneName) {
					_memberNode = project;
				}
			}
			
			imageButton = new Sprite();
			imageButton.buttonMode = true;
			imageButton.mouseEnabled = true;
			imageButton.mouseChildren = true;
			imageButton.addEventListener(MouseEvent.ROLL_OVER, photoOverHandler, false, 0, true);
			imageButton.addEventListener(MouseEvent.ROLL_OUT, photoOutHandler, false, 0, true);
			imageButton.addEventListener(MouseEvent.CLICK, photoClickHandler, false, 0, true);
			var titleLabelHolder:Sprite = new Sprite();
			var numberLabelHolder:Sprite = new Sprite();
			var imagePath:String = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
			var totalVideos:int = _memberNode..video.length();
			var i:int = 1;
			var videos:XMLList = _memberNode..video;
			var thumbInfoArray:Array;
			for each (var item:XML in videos) {
				imageName = item.thumbnail.@src.toString();
				imageWidth = item.thumbnail.@width;
				imageHeight = item.thumbnail.@height;
				videoThumbnail = _mainMC.contentManager.getImage(imageName, imagePath, imageWidth, imageHeight);
				videoThumbnail.x = _contentAreaWidth - imageWidth;
				videoThumbnail.y = 0;
				imageButton.addChild(videoThumbnail);
				titleLabel = new ProjectPhotoLabel(item.label);
				titleLabel.name = "titleLabel" + i.toString();
				titleLabelHolder.addChild(titleLabel);
				thumbInfoArray = [];
				thumbInfoArray.push(videoThumbnail);
				thumbInfoArray.push(titleLabel);
				
				if (totalVideos > 1) {
					numberLabel = new ProjectPhotoLabel(i.toString());
					numberLabel.name = "numberLabel" + i.toString();
					numberLabel.x = -numberLabel.width * (totalVideos - i) - (totalVideos - i);
					numberLabel.addEventListener(MouseEvent.ROLL_OVER, numberOverHandler, false, 0, true);
					numberLabelHolder.addChild(numberLabel);
				}
				thumbInfoArray.push(numberLabel);
				_thumbPhotoArray.push(thumbInfoArray);
				i++;
			}
			imageButton.addChild(numberLabelHolder);
			numberLabelHolder.x = _contentAreaWidth;
			trace("numberLabelHolder.x = " + numberLabelHolder.x);
			trace("numberLabelHolder.y = " + numberLabelHolder.y);
			imageButton.addChild(titleLabelHolder);
			titleLabelHolder.x = numberLabelHolder.x - numberLabelHolder.width - (totalVideos - 2);
			trace("titleLabelHolder.x = " + titleLabelHolder.x);
			trace("titleLabelHolder.y = " + titleLabelHolder.y);
			content.addChild(imageButton);
			swapThumbs(0);
			copyWidth = _contentAreaWidth - imageButton.width - 10;
			projectDetails = new WorkProjectDetails(_memberNode, copyWidth);
			projectDetails.registerMain(_mainMC);
			projectDetails.x = 0;
			projectDetails.alpha = 0;
			projectDetails.init();
			content.addChild(projectDetails);
			TweenMax.to(projectDetails, 0.5, {autoAlpha:1, ease:Expo.easeInOut});
			trace("_memberNode = " + _memberNode);
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

		private function swapThumbs(param1:int):void {
			_activeItem = param1;
			
			for (var i:int = 0; i < _thumbPhotoArray.length; i++) {
				if (i == _activeItem) {
					revealThumb(_thumbPhotoArray[i][0]);
					_thumbPhotoArray[i][1].revealLabel();
					if (_thumbPhotoArray[i][2] != null) {
						_thumbPhotoArray[i][2].highlightLabel();
					}
				} else {
					hideThumb(_thumbPhotoArray[i][0]);
					_thumbPhotoArray[i][1].hideLabel();
					if (_thumbPhotoArray[i][2] != null) {
						_thumbPhotoArray[i][2].unHighlightLabel();
					}
				}
			}
		}

		private function revealThumb(param1:Sprite):void {
			TweenMax.to(param1, 0.2, {autoAlpha:1, ease:Expo.easeOut});
		}

		private function hideThumb(param1:Sprite):void {
			TweenMax.to(param1, 0.2, {autoAlpha:0, ease:Expo.easeOut});
		}

		protected function highlightNavItem():void {
			_thumbPhotoArray[_activeItem][1].highlightLabel();
		}

		protected function unHighlightNavItem():void {
			_thumbPhotoArray[_activeItem][1].unHighlightLabel();
		}

		override public function setSize(param1:Number, param2:Number):void {
			super.setSize(param1, param2);
			if (_activeVideoScreen != null) {
				_activeVideoScreen.setSize(param1, param2);
			}
		}

		override protected function closeClickHandler(event:MouseEvent):void {
			_mainMC.sequencer.changeSection("primary", "");
		}

		protected function photoOverHandler(event:MouseEvent):void {
			highlightNavItem();
		}

		protected function photoOutHandler(event:MouseEvent):void {
			unHighlightNavItem();
		}

		protected function photoClickHandler(event:MouseEvent):void {
			var fileName:String = _memberNode.videos.video[_activeItem].@src.toString();
			var videoWidth:int = _memberNode.videos.video[_activeItem].@width;
			var videoHeight:int = _memberNode.videos.video[_activeItem].@height;
			_activeVideoScreen = _mainMC.contentManager.getVideoScreen(fileName, videoWidth, videoHeight);
			_activeVideoScreen.setSize(_stageWidth, _stageHeight);
			_activeVideoScreen.init();
			var logo:LittleFilmsLogo = _mainMC.logo;
			_mainMC.addChildAt(_activeVideoScreen, _mainMC.getChildIndex(logo));
		}

		private function numberOverHandler(event:MouseEvent):void {
			var _loc_3:int = 0;
			var photoLabel:ProjectPhotoLabel = event.target as ProjectPhotoLabel;
			for each (var _loc_4:Array in _thumbPhotoArray) {
				if (_loc_4[2] == photoLabel) {
					_loc_3 = _thumbPhotoArray.indexOf(_loc_4);
				}
			}
			swapThumbs(_loc_3);
			_thumbPhotoArray[_activeItem][1].highlightLabel();
		}

	}
}