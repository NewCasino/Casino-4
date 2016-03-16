package com.playtech.casino3
{
    import com.playtech.casino3.ui.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.button.*;

    public interface IModuleInterface
    {

        public function IModuleInterface();

        function sendGS(completionHandler:Packet, completionHandler:Packet = null) : void;

        function setWindowTitle(completionHandler:String = null, completionHandler:Object = null) : void;

        function updateStatusBar(completionHandler:String, completionHandler:Object = null, completionHandler:Number = 0) : void;

        function pauseSoundByID(completionHandler:int, completionHandler:Boolean = true) : void;

        function unlistenGS(completionHandler:uint, completionHandler:Function) : void;

        function commitCredit(completionHandler:int = -1) : void;

        function getWindowName() : String;

        function getActiveDescriptor() : Object;

        function loadRuntimeElementGroup(param1:Object, param2:String, param3:Function) : int;

        function getMode() : int;

        function updateLogoutPacket(completionHandler:Packet) : void;

        function createWallet() : int;

        function getElementByTag(param1:String);

        function readSession(param1:String);

        function getDisplayCredit() : Number;

        function addTabElement(completionHandler:int, ... args) : void;

        function uncommitCredit(completionHandler:Number = -1, completionHandler:int = -1) : void;

        function exitModule(completionHandler:Object) : void;

        function writeRoundHistory(completionHandler:HistoryEntry) : void;

        function addButtonShortcut(completionHandler:int, completionHandler:int, completionHandler:ButtonComponent) : void;

        function closeDialogByID(completionHandler:int) : void;

        function poolCredit(completionHandler:Number, completionHandler:int = -1) : void;

        function playAsEffect(param1:String, param2:String = null, param3:uint = 0, param4:Function = null) : int;

        function flushPooledCredit() : Boolean;

        function playAsAmbient(param1:String, param2:String = null) : int;

        function reserveCreditFromPooled(Object:Number, Object:int = -1) : Boolean;

        function writeSession(completionHandler:String, completionHandler) : void;

        function writeCasinoCookie(completionHandler:String, completionHandler) : void;

        function showLastRGError() : void;

        function updateTDHStatus(completionHandler:Object, completionHandler:Boolean) : void;

        function readUserCookie(param1:String);

        function showTooltip(completionHandler:Boolean, completionHandler:String = null) : void;

        function muteSoundByID(completionHandler:int, completionHandler:Boolean = true) : void;

        function openDialog(param1:String, param2 = null, param3:Array = null) : int;

        function removeTabElement(completionHandler:int, ... args) : void;

        function moduleGraphicsReady(completionHandler:Object) : void;

        function listenLoad(completionHandler:int, completionHandler:Function) : void;

        function writeUserCookie(completionHandler:String, completionHandler) : void;

        function deriveWindowID() : int;

        function playAsVoice(param1:String, param2:String = null, param3:Function = null) : int;

        function reserveCredit(Object:Number, Object:int = -1) : Boolean;

        function hideSandglass() : void;

        function removeKeyboardSet(completionHandler:int) : void;

        function stopSoundsBySource(completionHandler:String = null) : void;

        function updateExitStatus(completionHandler:Boolean) : void;

        function readConf(d:String) : String;

        function getUsername() : String;

        function allowCreditSync() : void;

        function createKeyboardSet(param1:uint = 0) : int;

        function readText(d:String, d:Object = null) : String;

        function addKeyShortcut(completionHandler:int, completionHandler:int, completionHandler:Function, completionHandler:Array = null) : void;

        function readAlert(d:uint, d:Object = null) : String;

        function showPopupMessage(completionHandler:PopupMessage) : void;

        function muteSoundBySource(completionHandler:String = null, completionHandler:Boolean = true) : void;

        function removeShortcut(completionHandler:int, completionHandler:int) : void;

        function getActiveShortname() : String;

        function grabFocus() : void;

        function moduleLoginSuccess(completionHandler:Object, completionHandler:Boolean) : void;

        function addRecentGame(completionHandler:Object, completionHandler:Boolean = true) : void;

        function setModuleExitHook(completionHandler:Object, completionHandler:Function) : void;

        function hasCap(Object:String, Object:uint) : Boolean;

        function listenGS(completionHandler:uint, completionHandler:Function) : void;

        function exitModuleImmediately(completionHandler:Object, completionHandler = null) : void;

        function readCasinoCookie(param1:String);

        function enableKeyboardSet(completionHandler:int, completionHandler:Boolean) : void;

        function showSandglass() : void;

        function stopSoundByID(completionHandler:int) : void;

    }
}
