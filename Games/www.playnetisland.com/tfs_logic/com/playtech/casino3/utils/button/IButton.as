package com.playtech.casino3.utils.button
{
    import flash.display.*;

    public interface IButton
    {

        public function IButton();

        function getGraphics() : String;

        function setIcon(param1:String) : void;

        function setIconPicture(param1:DisplayObject) : void;

        function getButtonComponent() : Object;

        function isDisabled() : Boolean;

        function setHint(param1:String) : void;

        function gotoFrame(param1:String) : void;

        function setType(param1:String) : void;

        function registerUpHandler(param1:Function, param2 = null) : void;

        function setGraphics(param1:String) : void;

        function registerOverInHandler(param1:Function, param2 = null) : void;

        function registerOverOutHandler(param1:Function, param2 = null) : void;

        function setSound(param1:String) : void;

        function removeButton() : void;

        function getFontResize() : String;

        function buttonDown() : void;

        function setFontResize(param1:String) : void;

        function registerHandler(param1:Function, ... args) : void;

        function disable(param1:Boolean) : void;

        function isSelected() : Boolean;

        function buttonUp(param1:Boolean = false) : void;

        function setGraphicsSize(param1:Boolean) : void;

        function getIcon() : String;

        function getType() : String;

        function buttonPress() : void;

        function setLabel(param1:String) : void;

        function isMouseOnButton() : Boolean;

        function registerDownHandler(param1:Function, param2 = null, param3:Boolean = false) : void;

        function setFocused(param1:Boolean) : void;

        function setFreeText(param1:String) : void;

        function select(param1:Boolean = true) : void;

        function getHint() : String;

        function getLabel() : String;

    }
}
