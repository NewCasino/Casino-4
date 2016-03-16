package com.littlefilms {
	import flash.display.*;

	public class WorkGallery extends Sprite {
		private var _mainMC:Main;
		private var _parentMC:ContentPane;
		private var _galleryXML:XML;
		private var _navArray:Array;
		private var _navColumns:int = 4;
		private var _navXSpace:int;
		private var _navYSpace:int = 12;

		public function WorkGallery(galleryXML:XML) {
			_navArray = [];
			_navXSpace = 945 / _navColumns;
			_galleryXML = galleryXML;
		}

		public function init():void {
			var previousThumbnail:GalleryThumb;
			var currentThumbnail:GalleryThumb;
			var path:String;
			var fileName:String;
			var imgWidth:int;
			var imgHeight:int;
			var imgSprite:Sprite;
			var projectName:String;
			var projectID:String;
			
			var projects:XMLList = _galleryXML..project;
			var thumbArray:Array = [];
			var i:int = 0;
			for each (var projectItem:XML in projects) {
				path = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
				fileName = projectItem.videos.video.thumbnail[0].@src.toString();
				imgWidth = projectItem.videos.video.thumbnail[0].@width;
				imgHeight = projectItem.videos.video.thumbnail[0].@height;
				imgSprite = _mainMC.contentManager.getImage(fileName, path, imgWidth, imgHeight);
				projectName = projectItem.@name.toString();
				projectID = projectItem.@id.toString();
				currentThumbnail = new GalleryThumb(imgSprite, projectName, projectID);
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
					currentThumbnail.x = thumbArray[i - _navColumns].x;
					currentThumbnail.y = thumbArray[i - _navColumns].y + thumbArray[i - _navColumns].height + _navYSpace;
				}
				previousThumbnail = currentThumbnail;
				thumbArray.push(currentThumbnail);
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