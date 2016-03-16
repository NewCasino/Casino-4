package com.littlefilms
{
    import com.stimuli.loading.*;
    import com.wirestone.utils.*;
    import flash.display.*;

    public class ContentManager extends Sprite
    {
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

        public function ContentManager(param1:XML, param2:XML, param3:XML, param4:BulkLoader)
        {
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
            return;
        }// end function

        public function registerMain(param1:Main) : void
        {
            _mainMC = param1;
            return;
        }// end function

        public function getPane(param1:String, param2:String) : ContentPane
        {
            var _loc_4:ContentPane = null;
            var _loc_3:ContentPane = null;
            for each (_loc_4 in _panesArray)
            {
                
                if (_loc_4.name == param1)
                {
                    _loc_3 = _loc_4;
                    break;
                }
            }
            if (_loc_3 == null)
            {
                _loc_3 = createNewPane(param1, param2);
            }
            return _loc_3;
        }// end function

        private function createNewPane(param1:String, param2:String) : ContentPane
        {
            trace("paneName = " + param1);
            trace("paneType = " + param2);
            var _loc_3:ContentPane = null;
            switch(param2)
            {
                case "standard":
                {
                    switch(param1)
                    {
                        case "whatWeDo":
                        case "whoWeAre":
                        case "contactUs":
                        {
                            _loc_3 = new StandardPane(param1);
                            break;
                        }
                        case "ourWork":
                        {
                            _loc_3 = new WorkPane(param1);
                            break;
                        }
                        case "credits":
                        {
                            _loc_3 = new CreditsPane(param1);
                            break;
                        }
                        case "ourClients":
                        {
                            _loc_3 = new ClientsPane(param1);
                            break;
                        }
                        default:
                        {
                            _loc_3 = new ContentPane(param1);
                            break;
                            break;
                        }
                    }
                    break;
                }
                case "member":
                {
                    _loc_3 = new MemberPane(param1);
                    break;
                }
                case "project":
                {
                    _loc_3 = new WorkProjectPane(param1);
                    break;
                }
                default:
                {
                    _loc_3 = new ContentPane(param1);
                    break;
                    break;
                }
            }
            if (_loc_3 != null)
            {
                _loc_3.registerMain(_mainMC);
                _loc_3.init();
                _panesArray.push(_loc_3);
            }
            return _loc_3;
        }// end function

        public function getContentBlock(param1:String, param2:String) : ContentBlock
        {
            var _loc_4:ContentBlock = null;
            var _loc_3:ContentBlock = null;
            for each (_loc_4 in _contentBlockArray)
            {
                
                if (_loc_4.name == param1 + "_" + param2)
                {
                    _loc_3 = _loc_4;
                    break;
                }
            }
            if (_loc_3 == null)
            {
                _loc_3 = new ContentBlock(param1, param2, 720);
                _contentBlockArray.push(_loc_3);
            }
            return _loc_3;
        }// end function

        public function getWorkGallery(param1:String) : WorkGallery
        {
            var item:WorkGallery;
            var galleryXML:XML;
            var galleryName:* = param1;
            trace("ContentManager::getWorkGallery()");
            trace("galleryName = " + galleryName);
            var newGallery:WorkGallery;
            var _loc_3:int = 0;
            var _loc_4:* = _workGalleryArray;
            while (_loc_4 in _loc_3)
            {
                
                item = _loc_4[_loc_3];
                if (item.name == galleryName)
                {
                    newGallery = item;
                    break;
                }
            }
            if (newGallery == null)
            {
                galleryXML = <gallery/>")("<gallery/>;
                var _loc_4:int = 0;
                var _loc_5:* = _workXML.folio;
                var _loc_3:* = new XMLList("");
                for each (_loc_6 in _loc_5)
                {
                    
                    var _loc_7:* = _loc_5[_loc_4];
                    with (_loc_5[_loc_4])
                    {
                        if (@id == galleryName)
                        {
                            _loc_3[_loc_4] = _loc_6;
                        }
                    }
                }
                trace("_workXML.folio.(@id == galleryName) = " + _loc_3);
                var _loc_4:int = 0;
                var _loc_5:* = _workXML.folio;
                var _loc_3:* = new XMLList("");
                for each (_loc_6 in _loc_5)
                {
                    
                    var _loc_7:* = _loc_5[_loc_4];
                    with (_loc_5[_loc_4])
                    {
                        if (@id == galleryName)
                        {
                            _loc_3[_loc_4] = _loc_6;
                        }
                    }
                }
                galleryXML.appendChild(_loc_3);
                newGallery = new WorkGallery(galleryXML);
                _workGalleryArray.push(newGallery);
            }
            return newGallery;
        }// end function

        public function getVideoScreen(param1:String, param2:uint, param3:uint) : VideoScreen
        {
            var _loc_5:VideoScreen = null;
            var _loc_4:VideoScreen = null;
            for each (_loc_5 in _videoScreensArray)
            {
                
                if (_loc_5.name == param1)
                {
                    _loc_4 = _loc_5;
                    break;
                }
            }
            if (_loc_4 == null)
            {
                _loc_4 = new VideoScreen(param1, param2, param3);
                _loc_4.registerMain(_mainMC);
                _loc_4.x = 0;
                _loc_4.y = 0;
                _videoScreensArray.push(_loc_4);
            }
            return _loc_4;
        }// end function

        public function getImage(param1:String, param2:String, param3:Number, param4:Number) : Sprite
        {
            var _loc_7:Bitmap = null;
            var _loc_8:ObjectLoader = null;
            var _loc_9:Bitmap = null;
            var _loc_5:* = param1.slice(0, param1.indexOf("."));
            var _loc_6:Sprite = null;
            for each (_loc_8 in _imagesArray)
            {
                
                if (_loc_8.name == _loc_5)
                {
                    _loc_6 = new Sprite();
                    _loc_9 = new Bitmap(_loc_8.imageBitmap.bitmapData.clone());
                    _loc_9.smoothing = true;
                    _loc_9.cacheAsBitmap = true;
                    _loc_6.addChild(_loc_9);
                    _loc_6.width = param3;
                    _loc_6.height = param4;
                    break;
                }
            }
            if (_loc_6 == null)
            {
                _loc_6 = new ObjectLoader(param1, param2, param3, param4);
                _imagesArray.push(_loc_6);
            }
            _loc_6.name = _loc_5;
            return _loc_6;
        }// end function

        public function get contentXML() : XML
        {
            return _contentXML;
        }// end function

        public function set contentXML(param1:XML) : void
        {
            _contentXML = param1;
            return;
        }// end function

        public function get imagesXML() : XML
        {
            return _imagesXML;
        }// end function

        public function set imagesXML(param1:XML) : void
        {
            _imagesXML = param1;
            return;
        }// end function

        public function get workXML() : XML
        {
            return _workXML;
        }// end function

        public function set workXML(param1:XML) : void
        {
            _workXML = param1;
            return;
        }// end function

    }
}
