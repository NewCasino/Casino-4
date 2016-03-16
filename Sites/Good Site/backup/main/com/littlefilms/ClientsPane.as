package com.littlefilms
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;

    public class ClientsPane extends ContentPane
    {
        private var _allCopy:Sprite;
        private var _contentAreaWidth:uint = 945;
        private var _paragraphYSpace:uint = 10;
        private var _headerBaselineBuffer:uint = 5;
        private var _copyWidth:uint;
        private var _clientsXMLList:XMLList;

        public function ClientsPane(param1:String)
        {
            trace("ClientsPane::()");
            super(param1);
            return;
        }// end function

        override public function init() : void
        {
            var _loc_3:int = 0;
            var _loc_4:* = _mainMC.contentManager.contentXML.section.subSection;
            var _loc_2:* = new XMLList("");
            for each (_loc_5 in _loc_4)
            {
                
                var _loc_6:* = _loc_4[_loc_3];
                with (_loc_4[_loc_3])
                {
                    if (@id == "ourClients")
                    {
                        _loc_2[_loc_3] = _loc_5;
                    }
                }
            }
            _clientsXMLList = _loc_2;
            trace("_clientsXMLList = " + _clientsXMLList);
            TweenMax.to(_paneBG, 0, {tint:12498828});
            fetchContent(name);
            fetchGallery();
            super.init();
            return;
        }// end function

        private function fetchContent(param1:String) : void
        {
            var _loc_7:XML = null;
            var _loc_8:Sprite = null;
            var _loc_9:String = null;
            var _loc_10:TextField = null;
            var _loc_2:* = TextFormatter.getTextFmt("_ourClientsHeader");
            var _loc_3:* = TextFormatter.getTextFmt("_ourClientsCopy");
            var _loc_4:* = new TextField();
            setLayout(_loc_4, _loc_2, "our clients", "dynamic");
            content.addChild(_loc_4);
            _allCopy = new Sprite();
            _allCopy.x = _loc_4.x + _loc_4.width + 40;
            content.addChild(_allCopy);
            _copyWidth = _contentAreaWidth - _allCopy.x;
            var _loc_5:* = _clientsXMLList;
            var _loc_6:uint = 0;
            for each (_loc_7 in _loc_5.children())
            {
                
                _loc_8 = new Sprite();
                _loc_9 = _loc_7.name().toString();
                switch(_loc_9)
                {
                    case "p":
                    {
                        _loc_10 = new TextField();
                        setLayout(_loc_10, _loc_3, _loc_7.toString(), "fixed");
                        _loc_8.addChild(_loc_10);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (_loc_6 == 0)
                {
                    _loc_8.y = _loc_4.height - _loc_8.height - _headerBaselineBuffer;
                }
                else
                {
                    _loc_8.y = _allCopy.height + _paragraphYSpace;
                }
                _allCopy.addChild(_loc_8);
                _loc_6 = _loc_6 + 1;
            }
            return;
        }// end function

        private function fetchGallery() : void
        {
            var _loc_1:* = new ClientsGallery(_clientsXMLList);
            _loc_1.registerMain(_mainMC);
            _loc_1.x = 0;
            _loc_1.y = content.height + 20;
            _loc_1.alpha = 1;
            _loc_1.init();
            content.addChild(_loc_1);
            return;
        }// end function

        private function setLayout(param1:TextField, param2:TextFormat, param3:String, param4:String) : void
        {
            var _loc_5:* = new StyleSheet();
            var _loc_6:* = new Object();
            new Object().fontWeight = "bold";
            _loc_6.color = "#81735d";
            var _loc_7:* = new Object();
            new Object().fontWeight = "bold";
            _loc_7.color = "#e74416";
            var _loc_8:* = new Object();
            new Object().fontWeight = "bold";
            _loc_8.color = "#e74416";
            var _loc_9:* = new Object();
            new Object().fontWeight = "bold";
            _loc_9.color = "#cc0099";
            _loc_5.setStyle("a:link", _loc_7);
            _loc_5.setStyle("a:hover", _loc_6);
            _loc_5.setStyle("a:active", _loc_8);
            if (param4 == "fixed")
            {
                param1.multiline = true;
                param1.wordWrap = true;
                param1.width = _copyWidth;
            }
            else
            {
                param1.multiline = false;
                param1.wordWrap = false;
            }
            param1.addEventListener(TextEvent.LINK, onHyperLinkEvent);
            param1.embedFonts = true;
            param1.selectable = false;
            param1.autoSize = TextFieldAutoSize.LEFT;
            param1.antiAliasType = AntiAliasType.ADVANCED;
            if (param2.size <= 12)
            {
                param1.thickness = 100;
            }
            param1.htmlText = param3;
            param1.setTextFormat(param2);
            param1.styleSheet = _loc_5;
            return;
        }// end function

        private function onHyperLinkEvent(event:TextEvent) : void
        {
            trace("**click**" + event.text);
            var _loc_2:* = event.target.htmlText;
            _loc_2 = _loc_2.split("\'event:" + event.text + "\'").join("\'event:" + event.text + "\' class=\'visited\' ");
            event.target.htmlText = _loc_2;
            return;
        }// end function

    }
}
