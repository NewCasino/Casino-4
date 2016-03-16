package com.playtech.casino3.slots.top_trumps_stars
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import com.playtech.casino3.utils.*;
    import flash.events.*;
    import flash.utils.*;

    public class Server extends ServerNovel implements IEventDispatcher, IDisposable
    {
        protected var _module_interface:IModuleInterface;
        protected var _dispatcher:EventDispatcher;
        const USER_COOKIE_NAME:String;
        protected var _state:GameState;
        protected var _logic:Logic;
        protected var BONUS_COMMAND_HANDLERS:Dictionary;
        public static const ON_TEAMS_RECIEVED:String = getQualifiedClassName(Server) + ".ON_TEAMS_RECIEVED";

        public function Server(Dictionary:Logic, Dictionary:ServerCommand, Dictionary:ServerCommand, Dictionary:Logic, Dictionary:IModuleInterface, Dictionary:ReelsStrips) : void
        {
            this.USER_COOKIE_NAME = GameParameters.shortname + "_deafult_choice";
            this.BONUS_COMMAND_HANDLERS = new Dictionary(true);
            this._logic = Dictionary;
            super(Dictionary.type, Dictionary.type, Dictionary, Dictionary, Dictionary);
            this._module_interface = Dictionary;
            this._dispatcher = new EventDispatcher(this);
            this.state = GameState.NORMAL;
            this.BONUS_COMMAND_HANDLERS[BonusCommandType.TEAMS] = this.onGetTeamResponce;
            return;
        }// end function

        public function dispatchEvent(event:Event) : Boolean
        {
            return this._dispatcher.dispatchEvent(event);
        }// end function

        public function setTeams() : void
        {
            var _loc_1:* = new Packet(ServerCommand.BONUS.type);
            _loc_1.addData(BonusCommandType.TEAMS.type);
            if (!this._logic.country_1 || !this._logic.country_2)
            {
                return;
            }
            _loc_1.addData(this._logic.country_1.index);
            _loc_1.addData(this._logic.country_2.index);
            if (this._module_interface.getMode() != ClientMode.REAL)
            {
                this._module_interface.writeUserCookie(this.USER_COOKIE_NAME, this._logic.country_1.index + "," + this._logic.country_2.index);
            }
            this.sendPacketToServer(_loc_1, _loc_1);
            return;
        }// end function

        public function getTeams() : void
        {
            var _loc_2:String = null;
            var _loc_3:Array = null;
            var _loc_1:* = new Packet(ServerCommand.BONUS.type);
            _loc_1.addData(BonusCommandType.TEAMS.type);
            this._module_interface.listenGS(ServerCommand.BONUS.type, this.onBonusCommandRecievedFromServer);
            if (this._module_interface.getMode() != ClientMode.REAL)
            {
                _loc_2 = this._module_interface.readUserCookie(this.USER_COOKIE_NAME) as String;
                _loc_3 = _loc_2 ? (_loc_2.split(",")) : (["", ""]);
                _loc_1.addData(_loc_3[0]);
                _loc_1.addData(_loc_3[1]);
            }
            this.sendPacketToServer(_loc_1, _loc_1);
            return;
        }// end function

        public function removeEventListener(Dictionary:String, Dictionary:Function, Dictionary:Boolean = false) : void
        {
            this._dispatcher.removeEventListener(Dictionary, Dictionary, Dictionary);
            return;
        }// end function

        public function sendAfterClickToStart() : void
        {
            this.sendClickToStart(false);
            return;
        }// end function

        public function addEventListener(Dictionary:String, Dictionary:Function, Dictionary:Boolean = false, Dictionary:int = 0, Dictionary:Boolean = false) : void
        {
            this._dispatcher.addEventListener(Dictionary, Dictionary, Dictionary, Dictionary, Dictionary);
            return;
        }// end function

        public function willTrigger(GameState:String) : Boolean
        {
            return this._dispatcher.willTrigger(GameState);
        }// end function

        public function get state() : GameState
        {
            return this._state;
        }// end function

        public function sendBeforeClickToStart() : void
        {
            this.sendClickToStart(true);
            return;
        }// end function

        public function set state(Dictionary:GameState) : void
        {
            this._state = Dictionary;
            return;
        }// end function

        protected function onGetTeamResponce(Dictionary:Packet) : void
        {
            var _loc_2:* = Dictionary.data;
            this._logic.country_1 = Country.fromIndex(int(_loc_2[0]));
            this._logic.country_2 = Country.fromIndex(int(_loc_2[1]));
            this.dispatchEvent(new Event(ON_TEAMS_RECIEVED));
            return;
        }// end function

        protected function sendClickToStart(Dictionary:Boolean) : void
        {
            var _loc_2:* = new Packet(ServerCommand.BONUS.type);
            _loc_2.addData(BonusCommandType.CLICK_TO_START.type);
            _loc_2.addData(Dictionary ? (0) : (1));
            var _loc_3:* = GameParameters.shortname + "_freegames_team" + (this._logic.is_team_1_started_free_spins ? (1) : (2));
            var _loc_4:* = Dictionary ? (_loc_3) : (BonusCommandType.INVALID_GAME_NAME.type);
            _loc_2.addData(_loc_4);
            this.sendPacketToServer(_loc_2, _loc_2);
            return;
        }// end function

        protected function onBonusCommandRecievedFromServer(Dictionary:Packet) : void
        {
            this._module_interface.unlistenGS(ServerCommand.BONUS.type, this.onBonusCommandRecievedFromServer);
            var _loc_2:* = Dictionary.data.splice(0, 1).toString();
            var _loc_3:* = BonusCommandType.fromType(_loc_2);
            var _loc_4:* = this.BONUS_COMMAND_HANDLERS;
            _loc_4.this.BONUS_COMMAND_HANDLERS[_loc_3](Dictionary);
            return;
        }// end function

        protected function sendPacketToServer(Dictionary:Packet, Dictionary:Packet = null) : void
        {
            if (this._module_interface.getMode() == ClientMode.REAL)
            {
                this._module_interface.sendGS(Dictionary);
            }
            else
            {
                this._module_interface.sendGS(Dictionary, Dictionary);
            }
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            this._state = null;
            this._module_interface = null;
            this._logic = null;
            this.BONUS_COMMAND_HANDLERS = null;
            return;
        }// end function

        public function hasEventListener(GameState:String) : Boolean
        {
            return this._dispatcher.hasEventListener(GameState);
        }// end function

    }
}
