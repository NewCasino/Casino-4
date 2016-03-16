package com.littlefilms{
	import flash.display.*;

	public class CreditsGallery extends Sprite {
		private var _mainMC:Main;
		private var _parentMC:ContentPane;
		private var _galleryXML:XML;
		private var _navArray:Array;
		private var _navColumns:int = 4;
		private var _navXSpace:int;
		private var _navYSpace:int = 12;

		public function CreditsGallery(param1:XML) {
			_navArray = [];
			_navXSpace = 945 / _navColumns;
			trace("CreditsGallery::()");
			_galleryXML = param1;
		}

		public function init():void {
			var previousThumbnail:CreditsThumb;
			var path:String;
			var fileName:String;
			var imgWidth:int;
			var imgHeight:int;
			var imgLoader:Sprite;
			var imageID:String;
			var cutName:String;
			var link:String;
			var currentThumbnail:CreditsThumb;
			var imagesList:XMLList = _galleryXML.main.background;
			var thumbsArray:Array = [];
			var i:int = 0;
			for each (var imageXml:XML in imagesList) {

				path = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
				fileName = imageXml.@thumbSrc.toString();
				imgWidth = 211;
				imgHeight = 72;
				imgLoader = _mainMC.contentManager.getImage(fileName, path, imgWidth, imgHeight);
				imageID = imageXml.@title.toString() + "\r" + imageXml.@photographer.toString();
				cutName = fileName.slice(0, fileName.indexOf("."));
				link = imageXml.@commonsLink.toString();
				currentThumbnail = new CreditsThumb(imgLoader, imageID, cutName, link);
				currentThumbnail.registerMain(_mainMC);
				currentThumbnail.registerController(this);
				currentThumbnail.init();
				addChild(currentThumbnail);
				if (previousThumbnail == null) {
					currentThumbnail.x = 0;
					currentThumbnail.y = 0;
				} else if (i < _navColumns) {
					currentThumbnail.x = previousThumbnail.x + _navXSpace;
					currentThumbnail.y = previousThumbnail.y;
				} else {
					currentThumbnail.x = thumbsArray[i - _navColumns].x;
					currentThumbnail.y = thumbsArray[i - _navColumns].y + thumbsArray[i - _navColumns].height + _navYSpace;
				}
				previousThumbnail = currentThumbnail;
				thumbsArray.push(currentThumbnail);
				i++;
			}
		}

		public function registerMain(param1:Main):void {
			_mainMC = param1;
		}

		public function registerPane(param1:ContentPane):void {
			_parentMC = param1;
		}

		public function swapNav(param1:NavItem):void {
			
		}

	}
}