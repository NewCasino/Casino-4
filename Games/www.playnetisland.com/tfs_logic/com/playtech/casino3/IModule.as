package com.playtech.casino3
{

    public interface IModule
    {

        public function IModule();

        function interrupt() : void;

        function initializeGraphics(param1:IModuleInterface, param2:Object) : void;

        function resume() : void;

        function initializeLogic() : void;

        function dispose() : void;

    }
}
