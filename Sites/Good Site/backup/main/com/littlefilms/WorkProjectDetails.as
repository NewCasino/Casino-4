package com.littlefilms
{
    import flash.display.*;
    import flash.text.*;

    public class WorkProjectDetails extends Sprite
    {
        private var _member:XMLList;
        private var _mainMC:Main;
        private var _section:String;
        private var _subSection:String;
        private var _allCopy:Sprite;
        private var _contentWidth:uint = 720;
        private var _contentX:uint = 0;
        private var _paragraphYSpace:uint = 10;

        public function WorkProjectDetails(param1:XMLList, param2:uint)
        {
            _member = param1;
            _contentWidth = param2;
            trace("_member = " + _member);
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
            trace("_mainMC = " + _mainMC);
            return;
        }// end function

        private function layoutContent() : void
        {
            var _loc_10:XML = null;
            var _loc_11:Sprite = null;
            var _loc_12:Sprite = null;
            var _loc_13:String = null;
            var _loc_14:TextField = null;
            _allCopy = new Sprite();
            _allCopy.x = _contentX;
            addChild(_allCopy);
            var _loc_1:* = TextFormatter.getTextFmt("_workProjectHeader");
            var _loc_2:* = TextFormatter.getTextFmt("_workProjectSubHeader");
            var _loc_3:* = TextFormatter.getTextFmt("_workProjectCopy");
            var _loc_4:* = _member.@name;
            var _loc_5:* = new TextField();
            _allCopy.addChild(_loc_5);
            setLayout(_loc_5, _loc_1, _loc_4, "fixed");
            var _loc_6:* = _member.@client;
            var _loc_7:* = new TextField();
            _allCopy.addChild(_loc_7);
            setLayout(_loc_7, _loc_2, _loc_6, "fixed");
            _loc_7.y = _loc_5.y + _loc_5.height;
            var _loc_8:* = _member.children().length();
            var _loc_9:uint = 0;
            for each (_loc_10 in _member.description.children())
            {
                
                trace("item = " + _loc_10);
                trace("item.name () = " + _loc_10.name());
                _loc_12 = new Sprite();
                _loc_13 = _loc_10.name().toString();
                switch(_loc_13)
                {
                    case "p":
                    {
                        _loc_14 = new TextField();
                        setLayout(_loc_14, _loc_3, _loc_10.toString(), "fixed");
                        _loc_12.addChild(_loc_14);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (_loc_9 == 0)
                {
                    _loc_12.y = _loc_7.y + _loc_7.height + _paragraphYSpace;
                }
                else
                {
                    _loc_12.y = _allCopy.height + _paragraphYSpace;
                }
                _allCopy.addChild(_loc_12);
                _loc_9 = _loc_9 + 1;
            }
            _loc_11 = buildSprite(10, _mainMC.paneManager.collapsedPaneHeight);
            _loc_11.y = _allCopy.height;
            _loc_11.alpha = 0;
            _allCopy.addChild(_loc_11);
            return;
        }// end function

        private function setLayout(param1:TextField, param2:TextFormat, param3:String, param4:String) : void
        {
            if (param4 == "fixed")
            {
                param1.multiline = true;
                param1.wordWrap = true;
                param1.width = _contentWidth;
            }
            else
            {
                param1.multiline = false;
                param1.wordWrap = false;
            }
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
            return;
        }// end function

        private function buildSprite(param1:uint, param2:uint) : Sprite
        {
            var _loc_5:Sprite = null;
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            _loc_5 = new Sprite();
            _loc_5.graphics.beginFill(15780865);
            _loc_5.graphics.drawRect(0, 0, _loc_3, _loc_4);
            _loc_5.graphics.endFill();
            _loc_5.x = 0;
            _loc_5.y = 0;
            return _loc_5;
        }// end function

    }
}
