package com.littlefilms {
	import com.stimuli.loading.*;
	import com.wirestone.utils.*;
	import flash.display.*;

	public class ContentManager extends Sprite {
		private var _contentXML:XML;
		private var _imagesXML:XML;
		private var _workXML:XML;
		private var _assetLoader:BulkLoader;
		private var _mainMC:Main;
		private var _panesArray:Array;
		private var _contentBlockArray:Array;
		private var _workGalleryArray:Array;
		private var _thumbsArray:Array;
		private var _imagesArray:Array;
		private var _videoScreensArray:Array;

		public function ContentManager(param1:XML, param2:XML, param3:XML, param4:BulkLoader) {
			_panesArray = [];
			_contentBlockArray = [];
			_workGalleryArray = [];
			_thumbsArray = [];
			_imagesArray = [];
			_videoScreensArray = [];
			contentXML = param1;
			imagesXML = param2;
			workXML = param3;
			_assetLoader = param4;
		}

		public function registerMain(param1:Main):void {
			_mainMC = param1;
		}

		public function getPane(paneName:String, paneType:String):ContentPane {
			var selectedPane:ContentPane;
			for (var i:int = 0; i < _panesArray.length; i++) {
				if ((_panesArray[i] as ContentPane).name == paneName) {
					selectedPane = _panesArray[i] as ContentPane;
					break;
				}
			}
			
			if (selectedPane == null) {
				selectedPane = createNewPane(paneName, paneType);
			}
			return selectedPane;
		}

		private function createNewPane(paneName:String, paneType:String):ContentPane {
			trace("paneName = " + paneName);
			trace("paneType = " + paneType);
			var newPane:ContentPane;
			outerSwitch: {
				switch (paneType) {
					case "standard" : {
						switch (paneName) {
							case "whatWeDo" :
							case "whoWeAre" :
							case "contactUs" : {
								newPane = new StandardPane(paneName);
								break outerSwitch;
							};
							case "ourWork" : {
								newPane = new WorkPane(paneName);
								break outerSwitch;
							};
							case "credits" : {
								newPane = new CreditsPane(paneName);
								break outerSwitch;
							};
							case "ourClients" : {
								newPane = new ClientsPane(paneName);
								break outerSwitch;
							};
							default : {
								newPane = new ContentPane(paneName);
								break outerSwitch;
							}
						};
					};
					case "member" : {
						newPane = new MemberPane(paneName);
						break outerSwitch;
					};
					case "project" : {
						newPane = new WorkProjectPane(paneName);
						break outerSwitch;
					};
					default : {
						newPane = new ContentPane(paneName);
						break outerSwitch;
					}
				}
			}
			if (newPane != null) {
				newPane.registerMain(_mainMC);
				newPane.init();
				_panesArray.push(newPane);
			}
			return newPane;
		}

		public function getContentBlock(section:String, subSection:String):ContentBlock {
			var selectedBlock:ContentBlock;
			for each (var cBlock:ContentBlock in _contentBlockArray) {
				if (cBlock.name == section + "_" + subSection) {
					selectedBlock = cBlock;
					break;
				}
			}
			if (selectedBlock == null) {
				selectedBlock = new ContentBlock(section, subSection, 720);
				_contentBlockArray.push(selectedBlock);
			}
			return selectedBlock;
		}

		public function getWorkGallery(galleryName:String):WorkGallery {
			trace("ContentManager::getWorkGallery()");
			trace("galleryName = " + galleryName);
			var newGallery:WorkGallery;
			for (var i:int = 0; i < _workGalleryArray.length; i++) {				
				if (_workGalleryArray[i].name == galleryName) {
					newGallery = _workGalleryArray[i];
					break;
				}
			}

			if (!newGallery) {
				var galleryXML:XML = <gallery></gallery>;
				var folios:XMLList = _workXML.folio;
				for each (var folio:XML in folios) {
					if ( folio.@id == galleryName) {
						galleryXML.appendChild(folio);
					}
				}
				
				trace("_workXML.folio.(@id == galleryName) = " + galleryXML.folio.@id);
				newGallery = new WorkGallery(galleryXML);
				_workGalleryArray.push(newGallery);
			}
			return newGallery;
		}

		public function getVideoScreen(fileName:String, videoWidth:int, videoHeight:int):VideoScreen {
			var selectedVideoScreen:VideoScreen;
			for each (var videoScreenItem:VideoScreen in _videoScreensArray) {
				if (videoScreenItem.name == fileName) {
					selectedVideoScreen = videoScreenItem;
					break;
				}
			}
			if (selectedVideoScreen == null) {
				selectedVideoScreen = new VideoScreen(fileName, videoWidth, videoHeight);
				selectedVideoScreen.registerMain(_mainMC);
				selectedVideoScreen.x = 0;
				selectedVideoScreen.y = 0;
				_videoScreensArray.push(selectedVideoScreen);
			}
			return selectedVideoScreen;
		}

		public function getImage(fileName:String, imgPath:String, imgWidth:Number, imgHeight:Number):Sprite {
			var loader:ObjectLoader;
			var targetBitmap:Bitmap;
			var imgName:String = fileName.slice(0, fileName.indexOf("."));
			var container:Sprite;
			for each (loader in _imagesArray) {
				if (loader.name == imgName) {
					container = new Sprite();
					targetBitmap = new Bitmap(loader.imageBitmap.bitmapData.clone());
					targetBitmap.smoothing = true;
					targetBitmap.cacheAsBitmap = true;
					container.addChild(targetBitmap);
					container.width = imgWidth;
					container.height = imgHeight;
					break;
				}
			}
			if (container == null) {
				container = new ObjectLoader(fileName,imgPath,imgWidth,imgHeight);
				_imagesArray.push(container);
			}
			container.name = imgName;
			return container;
		}

		public function get contentXML():XML {
			return _contentXML;
		}

		public function set contentXML(param1:XML):void {
			_contentXML = param1;
		}

		public function get imagesXML():XML {
			return _imagesXML;
		}

		public function set imagesXML(param1:XML):void {
			_imagesXML = param1;
		}

		public function get workXML():XML {
			return _workXML;
		}

		public function set workXML(param1:XML):void {
			_workXML = param1;
		}

	}
}