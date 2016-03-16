package com.littlefilms
{
    import flash.display.*;

    public class ClientsGallery extends Sprite
    {
        private var _mainMC:Main;
        private var _parentMC:ContentPane;
        private var _galleryXML:XML;
        private var _navArray:Array;
        private var _navColumns:uint = 5;
        private var _navXSpace:uint;
        private var _navYSpace:uint = 0;
        private var _maxImageHeight:uint = 85;

        public function ClientsGallery(param1:XMLList)
        {
            _galleryXML = <images/>")("<images/>;
            _navArray = [];
            _navXSpace = 945 / _navColumns;
            _galleryXML.appendChild(param1);
            return;
        }// end function

        public function init() : void
        {
            var _loc_2:Sprite = null;
            var _loc_5:XML = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            var _loc_10:Sprite = null;
            var _loc_1:* = _galleryXML..image;
            var _loc_3:Array = [];
            var _loc_4:uint = 0;
            for each (_loc_5 in _loc_1)
            {
                
                _loc_6 = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
                _loc_7 = _loc_5.@src.toString();
                _loc_8 = _navXSpace;
                _loc_9 = _maxImageHeight;
                _loc_10 = _mainMC.contentManager.getImage(_loc_7, _loc_6, _loc_8, _loc_9);
                addChild(_loc_10);
                if (_loc_2 == null)
                {
                    _loc_10.x = 0;
                    _loc_10.y = 0;
                }
                else if (_loc_4 < _navColumns)
                {
                    _loc_10.x = _loc_2.x + _navXSpace;
                    _loc_10.y = _loc_2.y;
                }
                else
                {
                    _loc_10.x = _loc_3[_loc_4 - _navColumns].x;
                    _loc_10.y = _loc_3[_loc_4 - _navColumns].y + _loc_3[_loc_4 - _navColumns].height + _navYSpace;
                }
                _loc_2 = _loc_10;
                _loc_3.push(_loc_10);
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
