package com.playtech.casino3
{
    import com.playtech.casino3.env.websupport.*;
    import com.playtech.casino3.utils.*;
    import flash.display.*;
    import flash.system.*;

    public interface IServiceInterface extends IModuleInterface
    {

        public function IServiceInterface();

        function canActiveModuleExit() : Boolean;

        function closeDialogByRef(completionHandler:MovieClip) : void;

        function hideLoader() : void;

        function listenCall(completionHandler:String, completionHandler:Function) : void;

        function sendHTCMD(completionHandler:String, completionHandler:String, completionHandler:Object) : void;

        function wsAdd(completionHandler:WSRequest) : void;

        function closeWindow() : void;

        function isDebug() : Boolean;

        function enableGameKeyboardCapture(completionHandler:Boolean) : void;

        function isMasterWindow() : Boolean;

        function getInvocationOrigin() : String;

        function loadStartupElements(completionHandler:Object, completionHandler:Function) : void;

        function listenClientEvent(completionHandler:String, completionHandler:Function) : void;

        function getElementGraphicsContainer() : DisplayObjectContainer;

        function cancelLoadByHandler(completionHandler:Function) : void;

        function wsClose(completionHandler:String) : void;

        function showLastError() : void;

        function getAppDomain() : ApplicationDomain;

        function unlistenSend(completionHandler:String) : void;

        function isModuleSupported(com.playtech.casino3:IServiceInterface/com.playtech.casino3:IServiceInterface:loadSWF:String) : Boolean;

        function unlistenSession(completionHandler:String, completionHandler:Function) : void;

        function unlistenClientEvent(completionHandler:String, completionHandler:Function) : void;

        function sendWindow(completionHandler:String, completionHandler:String, ... args) : void;

        function getStage() : Stage;

        function sendGSService(completionHandler:Packet) : void;

        function wsCancel(completionHandler:WSRequest) : void;

        function playClip(com.playtech.casino3:IServiceInterface/com.playtech.casino3:IServiceInterface:loadSWF:String, com.playtech.casino3:IServiceInterface/com.playtech.casino3:IServiceInterface:loadSWF:Object = null, com.playtech.casino3:IServiceInterface/com.playtech.casino3:IServiceInterface:loadSWF:Boolean = false) : Boolean;

        function unlistenCall(completionHandler:String) : void;

        function isMultiwindow() : Boolean;

        function openAS2GameWindow(completionHandler:Object) : void;

        function hideCommonUI(completionHandler:Boolean = false) : void;

        function isSessionEstablished() : Boolean;

        function loadInitElements(completionHandler:Object, completionHandler:Function) : void;

        function callWindow(param1:String, param2:String, ... args);

        function listenSend(completionHandler:String, completionHandler:Function) : void;

        function showLoader(completionHandler:uint) : void;

        function listenSession(completionHandler:String, completionHandler:Function) : void;

        function loadModule(completionHandler:Object, completionHandler:Function) : void;

        function openGameWindow(completionHandler:Object) : void;

        function writeOption(completionHandler:String, completionHandler) : void;

        function dispatchClientEvent(event:ClientEvent) : void;

        function listenHTCMD(completionHandler:String, completionHandler:Function) : void;

        function bindLoader(completionHandler:int) : void;

        function closeDialogByType(completionHandler:String) : void;

        function changeMode(completionHandler:int) : void;

        function loadSWF(param1:Array, param2:Function, param3:Function = null) : int;

        function unlistenHTCMD(completionHandler:String, completionHandler:Function) : void;

        function writeSessionProtected(completionHandler:String, completionHandler) : void;

    }
}
