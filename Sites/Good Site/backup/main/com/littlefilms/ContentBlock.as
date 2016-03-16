package com.littlefilms
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class ContentBlock extends Sprite
    {
        private var _mainMC:Main;
        private var _section:String;
        private var _subSection:String;
        private var _allCopy:Sprite;
        private var _contentWidth:uint;
        private var _contentX:uint = 225;
        private var _paragraphYSpace:uint = 10;

        public function ContentBlock(param1:String, param2:String, param3:uint)
        {
            _section = param1;
            _subSection = param2;
            _contentWidth = param3;
            return;
        }// end function

        public function init() : void
        {
            layoutContent();
            return;
        }// end function

        public function registerMain(param1:Main) : void
        {
            _mainMC = param1;
            return;
        }// end function

        private function layoutContent() : void
        {
            var contentParagraphFmt:TextFormat;
            var headerCopy:String;
            var contentHeader:TextField;
            var childCount:uint;
            var i:uint;
            var item:XML;
            var contentContainer:Sprite;
            var itemName:String;
            var newParagraph:TextField;
            var imagePath:String;
            var imageName:String;
            var imageWidth:uint;
            var imageHeight:uint;
            var contentImage:Sprite;
            var teamNav:TeamNav;
            _allCopy = new Sprite();
            _allCopy.x = _contentX;
            addChild(_allCopy);
            trace("_section = " + _section);
            if (_section == "contactUs")
            {
                contentParagraphFmt = TextFormatter.getTextFmt("_contactUsCopy");
            }
            else
            {
                contentParagraphFmt = TextFormatter.getTextFmt("_contentBlockCopy");
            }
            var contentHeaderFmt:* = TextFormatter.getTextFmt("_contentBlockHeader");
            var _loc_3:int = 0;
            var _loc_6:int = 0;
            var _loc_7:* = _mainMC.contentManager.contentXML.section;
            var _loc_5:* = new XMLList("");
            for each (_loc_8 in _loc_7)
            {
                
                var _loc_9:* = _loc_7[_loc_6];
                with (_loc_7[_loc_6])
                {
                    if (@id == _section)
                    {
                        _loc_5[_loc_6] = _loc_8;
                    }
                }
            }
            var _loc_4:* = _loc_5.subSection;
            var _loc_2:* = new XMLList("");
            for each (_loc_5 in _loc_4)
            {
                
                var _loc_6:* = _loc_4[_loc_3];
                with (_loc_4[_loc_3])
                {
                    if (@id == _subSection)
                    {
                        _loc_2[_loc_3] = _loc_5;
                    }
                }
            }
            var blockSource:* = _loc_2;
            headerCopy = blockSource.@name;
            contentHeader = new TextField();
            _allCopy.addChild(contentHeader);
            setLayout(contentHeader, contentHeaderFmt, headerCopy);
            childCount = blockSource.children().length();
            i;
            var _loc_2:int = 0;
            var _loc_3:* = blockSource.children();
            while (_loc_3 in _loc_2)
            {
                
                item = _loc_3[_loc_2];
                contentContainer = new Sprite();
                itemName = item.name().toString();
                switch(itemName)
                {
                    case "p":
                    {
                        newParagraph = new TextField();
                        setLayout(newParagraph, contentParagraphFmt, item.toString());
                        contentContainer.addChild(newParagraph);
                        break;
                    }
                    case "image":
                    {
                        imagePath = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
                        imageName = item.@src.toString();
                        imageWidth = item.@width;
                        imageHeight = item.@height;
                        contentImage = _mainMC.contentManager.getImage(imageName, imagePath, imageWidth, imageHeight);
                        contentContainer.addChild(contentImage);
                        break;
                    }
                    case "crew":
                    {
                        teamNav = new TeamNav(item);
                        teamNav.registerMain(_mainMC);
                        teamNav.init();
                        contentContainer.addChild(teamNav);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (i == 0)
                {
                    contentContainer.y = contentHeader.y + contentHeader.height + _paragraphYSpace;
                }
                else if (itemName == "crew")
                {
                    contentContainer.y = _allCopy.height + _paragraphYSpace + 10;
                }
                else
                {
                    contentContainer.y = _allCopy.height + _paragraphYSpace;
                }
                _allCopy.addChild(contentContainer);
                i = (i + 1);
            }
            return;
        }// end function

        private function setLayout(param1:TextField, param2:TextFormat, param3:String) : void
        {
            var _loc_4:* = new StyleSheet();
            var _loc_5:* = new Object();
            new Object().fontWeight = "bold";
            _loc_5.color = "#81735d";
            var _loc_6:* = new Object();
            new Object().fontWeight = "bold";
            _loc_6.color = "#e74416";
            var _loc_7:* = new Object();
            new Object().fontWeight = "bold";
            _loc_7.color = "#e74416";
            var _loc_8:* = new Object();
            new Object().fontWeight = "bold";
            _loc_8.color = "#cc0099";
            _loc_4.setStyle("a:link", _loc_6);
            _loc_4.setStyle("a:hover", _loc_5);
            _loc_4.setStyle("a:active", _loc_7);
            param1.addEventListener(TextEvent.LINK, onHyperLinkEvent);
            param1.multiline = true;
            param1.wordWrap = true;
            param1.embedFonts = true;
            param1.selectable = false;
            param1.width = _contentWidth;
            param1.autoSize = TextFieldAutoSize.LEFT;
            param1.antiAliasType = AntiAliasType.ADVANCED;
            if (param2.size <= 12)
            {
                param1.thickness = 100;
            }
            param1.htmlText = param3;
            param1.setTextFormat(param2);
            param1.styleSheet = _loc_4;
            return;
        }// end function

        private function onHyperLinkEvent(event:TextEvent) : void
        {
            trace("**click**" + event.text);
            trace("event.target = " + event.target);
            var _loc_2:* = event.target.htmlText;
            _loc_2 = _loc_2.split("\'event:" + event.text + "\'").join("\'event:" + event.text + "\' class=\'visited\' ");
            event.target.htmlText = _loc_2;
            return;
        }// end function

        private function buildSprite(param1:uint, param2:uint) : Sprite
        {
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            var _loc_5:* = new Sprite();
            new Sprite().graphics.beginFill(15780865);
            _loc_5.graphics.drawRect(0, 0, _loc_3, _loc_4);
            _loc_5.graphics.endFill();
            _loc_5.x = 0;
            _loc_5.y = 0;
            return _loc_5;
        }// end function

    }
}
