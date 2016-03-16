package com.littlefilms {
	import flash.display.*;

	public class ClientsGallery extends Sprite {
		private var _mainMC:Main;
		private var _parentMC:ContentPane;
		private var _galleryXML:XML;
		private var _navArray:Array;
		private var _navColumns:int = 5;
		private var _navXSpace:int;
		private var _navYSpace:int = 0;
		private var _maxImageHeight:int = 85;

		public function ClientsGallery(param1:XMLList) {
			_galleryXML = <images></images>;
			_navArray = [];
			_navXSpace = 945 / _navColumns;
			_galleryXML.appendChild(param1);
		}

		public function init():void {
			var prevImageLoader:Sprite;
			var currentImageLoader:Sprite;
			var path:String;
			var fileName:String;
			var imgWidth:int = 0;
			var imgHeight:int = 0;			
			var imagesList:XMLList = _galleryXML..image;
			var imageLoadersArray:Array = [];
			var i:int = 0;
			for each (var xImage:XML in imagesList) {
				path = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
				fileName = xImage.@src.toString();
				imgWidth = _navXSpace;
				imgHeight = _maxImageHeight;
				currentImageLoader = _mainMC.contentManager.getImage(fileName, path, imgWidth, imgHeight);
				addChild(currentImageLoader);
				if (prevImageLoader == null) {
					currentImageLoader.x = 0;
					currentImageLoader.y = 0;
				} else if (i < _navColumns) {
					currentImageLoader.x = prevImageLoader.x + _navXSpace;
					currentImageLoader.y = prevImageLoader.y;
				} else {
					currentImageLoader.x = imageLoadersArray[i - _navColumns].x;
					currentImageLoader.y = imageLoadersArray[i - _navColumns].y + imageLoadersArray[i - _navColumns].height + _navYSpace;
				}
				prevImageLoader = currentImageLoader;
				imageLoadersArray.push(currentImageLoader);
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