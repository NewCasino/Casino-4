package com.playtech.casino3.utils.queue
{

    public interface ICommand
    {

        public function ICommand();

        function cancel() : void;

        function hasFrameChange() : Boolean;

        function setId(id:int) : void;

        function execute(param1:String) : int;

        function isCancelable() : Boolean;

        function getId() : int;

        function decreaseLocks() : int;

        function clear() : void;

        function getRepeatCount() : int;

    }
}
