package com.littlefilms{
	import flash.display.*;
	import com.wirestone.utils.*;
	import flash.events.*;
	import flash.utils.*;
	import gs.*;

	public class BGManager extends Sprite {
		private var _imagesXML:XML;
		private var _mainImagesXML:XML;
		private var _shuffledMainImages:XML;
		private var _imagePath:String;
		private var _mainMC:Main;
		private var _mainBG:BGRotator = null;
		private var _sectionBG:BGRotator = null;
		private var _isPaused:Boolean = false;
		private var _totalBGCount:uint;
		private var _currentBG:uint = 0;
		protected var _bgImageLoader:Timer;
		public static  var _instance:BGManager;

		public function BGManager(param1:Main) {
			_mainImagesXML = <main></main>;
			_mainMC = param1;
		}

		public function init():void {
			_imagePath = _mainMC.contentManager.contentXML.meta.background_photos.@location.toString();
			_imagesXML = _mainMC.contentManager.imagesXML;
			_mainImagesXML.appendChild(_imagesXML.main.background);
			_shuffledMainImages = shuffleImageXML(_mainImagesXML);
			_totalBGCount = _imagesXML.main.background.length();
			_mainBG = new BGRotator();
			_mainBG.name = "mainBG";
			_mainBG.registerMain(_mainMC);
			_mainBG.registerController(this);
			_mainBG.setSize(_mainMC.stageWidth, _mainMC.stageHeight);
			addChild(_mainBG);
			_sectionBG = new BGRotator();
			_sectionBG.name = "sectionBG";
			_sectionBG.registerMain(_mainMC);
			_sectionBG.registerController(this);
			_sectionBG.setSize(_mainMC.stageWidth, _mainMC.stageHeight);
			addChild(_sectionBG);
			loadNewMainBG();
			var _loc_2:* = _currentBG + 1;
			_currentBG = _loc_2;
			mainBGImageLoaderStart();
		}

		public function registerMain(param1):void {
			_mainMC = param1;
		}

		public function addSectionBG(param1:String):void {
			loadBGImage(param1);
		}

		private function loadBGImage(backID:String):void {
			var imagePath:String;
			var imageName:String;
			var imageWidth:int;
			var imageHeight:int;
			var contentImage:Sprite;
			var bgID:String = backID;
			trace("BGManager::loadBGImage()");
			imagePath = _mainMC.contentManager.contentXML.meta.background_photos.@location.toString();			
			var listImages:XMLList = _imagesXML.content.background;
			
			for each (item in listImages) {				
				if (item.@id == bgID) {
					imageName = item.@src;			
					imageWidth = item.@width;			
					imageHeight = item.@height;
				}
			}
			
			trace("imageName = " + imageName);
			contentImage = _mainMC.contentManager.getImage(imageName, imagePath, imageWidth, imageHeight);
			_sectionBG.loadNewImage(contentImage, imageWidth, imageHeight);
			_isPaused = true;
		}

		public function removeSectionBG():void {
			trace("BGManager::removeSectionBG()");
			_sectionBG.removeAllImages();
			_isPaused = false;
			TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);			
		}

		private function mainBGImageLoaderStart():void {
			_bgImageLoader = new Timer(10000, 0);
			_bgImageLoader.addEventListener(TimerEvent.TIMER, mainBGImageLoaderInterval, false, 0, true);
			_bgImageLoader.start();
		}

		private function mainBGImageLoaderInterval(event:TimerEvent):void {
			if (!_isPaused) {
				loadNewMainBG();
			}
		}

		private function loadNewMainBG():void {
			trace("BGManager::loadNewMainBG()");
			if (_currentBG > (_totalBGCount - 1)) {
				_currentBG = 0;
			}
			var location:String = _mainMC.contentManager.contentXML.meta.background_photos.@location.toString();
			var src:String = _shuffledMainImages.background[_currentBG].@src.toString();
			var imgWidth:Number = _shuffledMainImages.background[_currentBG].@width;
			var imgHeight:Number = _shuffledMainImages.background[_currentBG].@height;
 			var bgImage:Sprite = _mainMC.contentManager.getImage(src, location, imgWidth, imgHeight);
			_mainBG.loadNewImage(bgImage, imgWidth, imgHeight);
			_currentBG = _currentBG + 1;
		}

		public function pauseBGRotation(param1:Boolean):void {
			_isPaused = param1;
		}

		private function shuffleImageXML(xmlToShuffle:XML):XML {
			var bgObject:Object;
			var backgrounds:XML = <main></main>;
			var randomNumbers:Array = [];
			var i:int = 0;
			while (i < xmlToShuffle.background.length()) {
				bgObject = {ranNum:Math.floor(Math.random() * 1000), node:xmlToShuffle.background[i] as XML};
				randomNumbers[i] = bgObject;
				i++;
			}
			randomNumbers.sortOn("ranNum", Array.NUMERIC);
			i = 0;
			while (i < randomNumbers.length) {
				backgrounds.appendChild(randomNumbers[i].node);
				i++;
			}
			return backgrounds;
		}

		public function setSize(param1:Number, param2:Number):void {
			trace("BGManager::setSize()");
			if (_mainBG != null) {
				_mainBG.setSize(param1, param2);
			}
			if (_sectionBG != null) {
				_sectionBG.setSize(param1, param2);
			}
		}

		public function get isPaused():Boolean {
			return _isPaused;
		}

		public function set isPaused(param1:Boolean):void {
			if (param1 !== _isPaused) {
				_isPaused = param1;
			}
		}

		public static function getInstance(param1:Main):BGManager {
			if (_instance == null) {
				_instance = new BGManager(param1);
			}
			return _instance;
		}

	}
}