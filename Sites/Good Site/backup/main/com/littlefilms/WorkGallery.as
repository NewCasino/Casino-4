﻿package com.littlefilms
{
    import flash.display.*;

    public class WorkGallery extends Sprite
    {
        private var _mainMC:Main;
        private var _parentMC:ContentPane;
        private var _galleryXML:XML;
        private var _navArray:Array;
        private var _navColumns:uint = 4;
        private var _navXSpace:uint;
        private var _navYSpace:uint = 12;

        public function WorkGallery(param1:XML)
        {
            _navArray = [];
            _navXSpace = 945 / _navColumns;
            _galleryXML = param1;
            return;
        }// end function

        public function init() : void
        {
            var _loc_2:GalleryThumb = null;
            var _loc_5:XML = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            var _loc_10:Sprite = null;
            var _loc_11:String = null;
            var _loc_12:String = null;
            var _loc_13:GalleryThumb = null;
            var _loc_1:* = _galleryXML..project;
            var _loc_3:Array = [];
            var _loc_4:uint = 0;
            for each (_loc_5 in _loc_1)
            {
                
                _loc_6 = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
                _loc_7 = _loc_5.videos.video.thumbnail[0].@src.toString();
                _loc_8 = _loc_5.videos.video.thumbnail[0].@width;
                _loc_9 = _loc_5.videos.video.thumbnail[0].@height;
                _loc_10 = _mainMC.contentManager.getImage(_loc_7, _loc_6, _loc_8, _loc_9);
                _loc_11 = _loc_5.@name.toString();
                _loc_12 = _loc_5.@id.toString();
                _loc_13 = new GalleryThumb(_loc_10, _loc_11, _loc_12);
                _loc_13.registerMain(_mainMC);
                _loc_13.registerController(this);
                _loc_13.init();
                addChild(_loc_13);
                if (_loc_2 == null)
                {
                    _loc_13.x = 0;
                    _loc_13.y = 0;
                }
                else if (_loc_4 < _navColumns)
                {
                    _loc_13.x = _loc_2.x + _navXSpace;
                    _loc_13.y = _loc_2.y;
                }
                else
                {
                    _loc_13.x = _loc_3[_loc_4 - _navColumns].x;
                    _loc_13.y = _loc_3[_loc_4 - _navColumns].y + _loc_3[_loc_4 - _navColumns].height + _navYSpace;
                }
                _loc_2 = _loc_13;
                _loc_3.push(_loc_13);
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        public function registerMain(param1:Main) : void
        {
            _mainMC = param1;
            return;
        }// end function

        public function registerPane(param1:ContentPane) : void
        {
            _parentMC = param1;
            return;
        }// end function

        public function swapNav(param1:NavItem) : void
        {
            return;
        }// end function

    }
}
