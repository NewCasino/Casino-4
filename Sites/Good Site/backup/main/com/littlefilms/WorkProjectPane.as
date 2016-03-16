package com.littlefilms
{
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    import gs.easing.*;

    public class WorkProjectPane extends ContentPane
    {
        private var _navInfo:Array;
        private var _memberNode:XMLList;
        private var _avatarAreaWidth:uint = 190;
        private var _contentAreaWidth:uint = 945;
        private var _orange:Number;
        private var _white:Number;
        private var _photoLabel:ProjectPhotoLabel;
        private var _thumbPhotoArray:Array;
        private var _activeItem:uint = 0;
        private var _activeVideoScreen:VideoScreen = null;

        public function WorkProjectPane(param1:String)
        {
            _navInfo = [];
            _thumbPhotoArray = [];
            trace("WorkProjectPane::()");
            super(param1);
            return;
        }// end function

        override public function init() : void
        {
            _orange = TextFormatter.getColor("_orange");
            _white = TextFormatter.getColor("_white");
            TweenMax.to(_paneBG, 0, {tint:14473405});
            fetchContent(name);
            super.init();
            return;
        }// end function

        private function fetchContent(param1:String) : void
        {
            var imageButton:Sprite;
            var item:XML;
            var copyWidth:uint;
            var projectDetails:WorkProjectDetails;
            var imageName:String;
            var imageWidth:uint;
            var imageHeight:uint;
            var videoThumbnail:Sprite;
            var titleLabel:ProjectPhotoLabel;
            var numberLabel:ProjectPhotoLabel;
            var thumbInfoArray:Array;
            var paneName:* = param1;
            var _loc_4:int = 0;
            var _loc_5:* = _mainMC.contentManager.workXML..project;
            var _loc_3:* = new XMLList("");
            for each (_loc_6 in _loc_5)
            {
                
                var _loc_7:* = _loc_5[_loc_4];
                with (_loc_5[_loc_4])
                {
                    if (@id == paneName)
                    {
                        _loc_3[_loc_4] = _loc_6;
                    }
                }
            }
            _memberNode = _loc_3;
            imageButton = new Sprite();
            imageButton.buttonMode = true;
            imageButton.mouseEnabled = true;
            imageButton.mouseChildren = true;
            imageButton.addEventListener(MouseEvent.ROLL_OVER, photoOverHandler, false, 0, true);
            imageButton.addEventListener(MouseEvent.ROLL_OUT, photoOutHandler, false, 0, true);
            imageButton.addEventListener(MouseEvent.CLICK, photoClickHandler, false, 0, true);
            var titleLabelHolder:* = new Sprite();
            var numberLabelHolder:* = new Sprite();
            var imagePath:* = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
            var totalVideos:* = _memberNode..video.length();
            var currentItem:uint;
            var _loc_3:int = 0;
            var _loc_4:* = _memberNode..video;
            while (_loc_4 in _loc_3)
            {
                
                item = _loc_4[_loc_3];
                imageName = item.thumbnail.@src.toString();
                imageWidth = item.thumbnail.@width;
                imageHeight = item.thumbnail.@height;
                videoThumbnail = _mainMC.contentManager.getImage(imageName, imagePath, imageWidth, imageHeight);
                videoThumbnail.x = _contentAreaWidth - imageWidth;
                videoThumbnail.y = 0;
                imageButton.addChild(videoThumbnail);
                titleLabel = new ProjectPhotoLabel(item.label);
                titleLabel.name = "titleLabel" + currentItem.toString();
                titleLabelHolder.addChild(titleLabel);
                numberLabel;
                if (totalVideos > 1)
                {
                    numberLabel = new ProjectPhotoLabel(currentItem.toString());
                    numberLabel.name = "numberLabel" + currentItem.toString();
                    numberLabel.x = -numberLabel.width * (totalVideos - currentItem) - (totalVideos - currentItem);
                    numberLabel.addEventListener(MouseEvent.ROLL_OVER, numberOverHandler, false, 0, true);
                    numberLabelHolder.addChild(numberLabel);
                }
                thumbInfoArray;
                _thumbPhotoArray.push(thumbInfoArray);
                currentItem = (currentItem + 1);
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
            return;
        }// end function

        private function buildSprite(param1:uint, param2:uint) : Sprite
        {
            var _loc_5:Sprite = null;
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            _loc_5 = new Sprite();
            _loc_5.graphics.beginFill(0);
            _loc_5.graphics.drawRect(0, 0, _loc_3, _loc_4);
            _loc_5.graphics.endFill();
            _loc_5.x = 0;
            _loc_5.y = 0;
            return _loc_5;
        }// end function

        private function swapThumbs(param1:uint) : void
        {
            _activeItem = param1;
            var _loc_2:int = 0;
            while (_loc_2 < _thumbPhotoArray.length)
            {
                
                if (_loc_2 == _activeItem)
                {
                    revealThumb(_thumbPhotoArray[_loc_2][0]);
                    _thumbPhotoArray[_loc_2][1].revealLabel();
                    if (_thumbPhotoArray[_loc_2][2] != null)
                    {
                        _thumbPhotoArray[_loc_2][2].highlightLabel();
                    }
                }
                else
                {
                    hideThumb(_thumbPhotoArray[_loc_2][0]);
                    _thumbPhotoArray[_loc_2][1].hideLabel();
                    if (_thumbPhotoArray[_loc_2][2] != null)
                    {
                        _thumbPhotoArray[_loc_2][2].unHighlightLabel();
                    }
                }
                _loc_2++;
            }
            return;
        }// end function

        private function revealThumb(param1:Sprite) : void
        {
            TweenMax.to(param1, 0.2, {autoAlpha:1, ease:Expo.easeOut});
            return;
        }// end function

        private function hideThumb(param1:Sprite) : void
        {
            TweenMax.to(param1, 0.2, {autoAlpha:0, ease:Expo.easeOut});
            return;
        }// end function

        protected function highlightNavItem() : void
        {
            _thumbPhotoArray[_activeItem][1].highlightLabel();
            return;
        }// end function

        protected function unHighlightNavItem() : void
        {
            _thumbPhotoArray[_activeItem][1].unHighlightLabel();
            return;
        }// end function

        override public function setSize(param1:Number, param2:Number) : void
        {
            super.setSize(param1, param2);
            if (_activeVideoScreen != null)
            {
                _activeVideoScreen.setSize(param1, param2);
            }
            return;
        }// end function

        override protected function closeClickHandler(event:MouseEvent) : void
        {
            _mainMC.sequencer.changeSection("primary", "");
            return;
        }// end function

        protected function photoOverHandler(event:MouseEvent) : void
        {
            highlightNavItem();
            return;
        }// end function

        protected function photoOutHandler(event:MouseEvent) : void
        {
            unHighlightNavItem();
            return;
        }// end function

        protected function photoClickHandler(event:MouseEvent) : void
        {
            var _loc_2:* = _memberNode.videos.video[_activeItem].@src.toString();
            var _loc_3:* = _memberNode.videos.video[_activeItem].@width;
            var _loc_4:* = _memberNode.videos.video[_activeItem].@height;
            _activeVideoScreen = _mainMC.contentManager.getVideoScreen(_loc_2, _loc_3, _loc_4);
            _activeVideoScreen.setSize(_stageWidth, _stageHeight);
            _activeVideoScreen.init();
            var _loc_5:* = _mainMC.logo;
            _mainMC.addChildAt(_activeVideoScreen, _mainMC.getChildIndex(_loc_5));
            return;
        }// end function

        private function numberOverHandler(event:MouseEvent) : void
        {
            var _loc_3:int = 0;
            var _loc_4:Array = null;
            var _loc_2:* = event.target as ProjectPhotoLabel;
            for each (_loc_4 in _thumbPhotoArray)
            {
                
                if (_loc_4[2] == _loc_2)
                {
                    _loc_3 = _thumbPhotoArray.indexOf(_loc_4);
                }
            }
            swapThumbs(_loc_3);
            _thumbPhotoArray[_activeItem][1].highlightLabel();
            return;
        }// end function

    }
}
