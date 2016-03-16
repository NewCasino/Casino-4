package com.littlefilms
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import gs.*;

    public class BGManager extends Sprite
    {
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
        public static var _instance:BGManager;

        public function BGManager(param1:Main)
        {
            _mainImagesXML = <main/>")("<main/>;
            _mainMC = param1;
            return;
        }// end function

        public function init() : void
        {
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
            return;
        }// end function

        public function registerMain(param1) : void
        {
            _mainMC = param1;
            return;
        }// end function

        public function addSectionBG(param1:String) : void
        {
            loadBGImage(param1);
            return;
        }// end function

        private function loadBGImage(param1:String) : void
        {
            var imagePath:String;
            var imageName:String;
            var imageWidth:uint;
            var imageHeight:uint;
            var contentImage:Sprite;
            var bgID:* = param1;
            trace("BGManager::loadBGImage()");
            imagePath = _mainMC.contentManager.contentXML.meta.background_photos.@location.toString();
            var _loc_4:int = 0;
            var _loc_5:* = _imagesXML.content.background;
            var _loc_3:* = new XMLList("");
            for each (_loc_6 in _loc_5)
            {
                
                var _loc_7:* = _loc_5[_loc_4];
                with (_loc_5[_loc_4])
                {
                    if (@id == bgID)
                    {
                        _loc_3[_loc_4] = _loc_6;
                    }
                }
            }
            imageName = _loc_3.@src.toString();
            var _loc_4:int = 0;
            var _loc_5:* = _imagesXML.content.background;
            var _loc_3:* = new XMLList("");
            for each (_loc_6 in _loc_5)
            {
                
                var _loc_7:* = _loc_5[_loc_4];
                with (_loc_5[_loc_4])
                {
                    if (@id == bgID)
                    {
                        _loc_3[_loc_4] = _loc_6;
                    }
                }
            }
            imageWidth = _loc_3.@width;
            var _loc_4:int = 0;
            var _loc_5:* = _imagesXML.content.background;
            var _loc_3:* = new XMLList("");
            for each (_loc_6 in _loc_5)
            {
                
                var _loc_7:* = _loc_5[_loc_4];
                with (_loc_5[_loc_4])
                {
                    if (@id == bgID)
                    {
                        _loc_3[_loc_4] = _loc_6;
                    }
                }
            }
            imageHeight = _loc_3.@height;
            trace("imageName = " + imageName);
            contentImage = _mainMC.contentManager.getImage(imageName, imagePath, imageWidth, imageHeight);
            _sectionBG.loadNewImage(contentImage, imageWidth, imageHeight);
            _isPaused = true;
            return;
        }// end function

        public function removeSectionBG() : void
        {
            trace("BGManager::removeSectionBG()");
            _sectionBG.removeAllImages();
            _isPaused = false;
            TweenMax.delayedCall(0.5, _mainMC.sequencer.nextStep);
            return;
        }// end function

        private function mainBGImageLoaderStart() : void
        {
            _bgImageLoader = new Timer(10000, 0);
            _bgImageLoader.addEventListener(TimerEvent.TIMER, mainBGImageLoaderInterval, false, 0, true);
            _bgImageLoader.start();
            return;
        }// end function

        private function mainBGImageLoaderInterval(event:TimerEvent) : void
        {
            if (!_isPaused)
            {
                loadNewMainBG();
            }
            return;
        }// end function

        private function loadNewMainBG() : void
        {
            trace("BGManager::loadNewMainBG()");
            if (_currentBG > (_totalBGCount - 1))
            {
                _currentBG = 0;
            }
            var _loc_1:* = _mainMC.contentManager.contentXML.meta.background_photos.@location.toString();
            var _loc_2:* = _shuffledMainImages.background[_currentBG].@src.toString();
            var _loc_3:* = _shuffledMainImages.background[_currentBG].@width;
            var _loc_4:* = _shuffledMainImages.background[_currentBG].@height;
            var _loc_5:* = _mainMC.contentManager.getImage(_loc_2, _loc_1, _loc_3, _loc_4);
            _mainBG.loadNewImage(_loc_5, _loc_3, _loc_4);
            var _loc_7:* = _currentBG + 1;
            _currentBG = _loc_7;
            return;
        }// end function

        public function pauseBGRotation(param1:Boolean) : void
        {
            _isPaused = param1;
            return;
        }// end function

        private function shuffleImageXML(param1:XML) : XML
        {
            var _loc_4:Object = null;
            var _loc_5:XMLList = null;
            var _loc_2:* = <main></main>")("<main></main>;
            var _loc_3:Array = [];
            var _loc_6:uint = 0;
            while (_loc_6 < param1.background.length())
            {
                
                _loc_4 = {ranNum:Math.floor(Math.random() * 1000), node:param1.background[_loc_6] as XML};
                _loc_3[_loc_6] = _loc_4;
                _loc_6 = _loc_6 + 1;
            }
            _loc_3.sortOn("ranNum", Array.NUMERIC);
            var _loc_7:uint = 0;
            while (_loc_7 < _loc_3.length)
            {
                
                _loc_2.appendChild(_loc_3[_loc_7].node);
                _loc_7 = _loc_7 + 1;
            }
            return _loc_2;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            trace("BGManager::setSize()");
            if (_mainBG != null)
            {
                _mainBG.setSize(param1, param2);
            }
            if (_sectionBG != null)
            {
                _sectionBG.setSize(param1, param2);
            }
            return;
        }// end function

        public function get isPaused() : Boolean
        {
            return _isPaused;
        }// end function

        public function set isPaused(param1:Boolean) : void
        {
            if (param1 !== _isPaused)
            {
                _isPaused = param1;
            }
            return;
        }// end function

        public static function getInstance(param1:Main) : BGManager
        {
            if (_instance == null)
            {
                _instance = new BGManager(param1);
            }
            return _instance;
        }// end function

    }
}
