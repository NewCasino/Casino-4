package com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows
{

    public interface IMessageWindow
    {

        public function IMessageWindow();

        function cancel() : void;

        function showWindow() : void;

        function dispose() : void;

        function setCallBack(param1:Function) : void;

    }
}
