package com.playtech.casino3.slots.shared
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.core.*;

    public class ServerBase extends Object
    {
        protected var m_descriptor:Object;
        private var CMD_SPIN:int = 210;
        private var m_balance:Number;
        private var CMD_LOGUSERPREFERENCES:int = 10200;
        private var CMD_LOGOUT:int;
        private var m_lastSpinCmd:int;
        private var m_checkCredit:Boolean;
        private var m_lastRes:Vector.<int>;
        private var CMD_LOGIN:int;
        protected var m_mi:IModuleInterface;
        private var m_gameRef:SlotsBase;
        private var CMD_FREESPIN:int = 213;
        private var CMD_RESPIN:int = 216;

        public function ServerBase(gameRef:int, gameRef:int, gameRef:SlotsBase, gameRef:IModuleInterface) : void
        {
            this.CMD_LOGIN = gameRef;
            this.CMD_LOGOUT = gameRef;
            this.m_gameRef = gameRef;
            this.m_mi = gameRef;
            this.m_balance = 0;
            return;
        }// end function

        public function updateCredit(gameRef:Number) : void
        {
            this.m_balance = this.m_balance + gameRef;
            return;
        }// end function

        public function genResults() : Vector.<int>
        {
            throw new Error("Cannot generate offline results, override genResults method");
        }// end function

        public function spin(gameRef:Number, gameRef:Number, gameRef:Array, gameRef:int) : void
        {
            this.m_mi.showSandglass();
            switch(gameRef)
            {
                case GameStates.STATE_FREESPIN:
                {
                    this.m_lastSpinCmd = this.CMD_FREESPIN;
                    break;
                }
                case GameStates.STATE_RESPIN:
                {
                    this.m_lastSpinCmd = this.CMD_RESPIN;
                    break;
                }
                default:
                {
                    this.m_lastSpinCmd = this.CMD_SPIN;
                    this.m_balance = this.m_balance - gameRef;
                    break;
                }
            }
            this.m_mi.listenGS(this.m_lastSpinCmd, this.onSpinResponse);
            var _loc_5:* = new Packet(this.m_lastSpinCmd);
            _loc_5.addData(gameRef);
            _loc_5.addData(gameRef);
            var _loc_6:* = gameRef.length;
            var _loc_7:int = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_5.addData(gameRef[_loc_7] > 0 ? (1) : (0));
                _loc_7++;
            }
            if (this.m_mi.getMode() == ClientMode.REAL)
            {
                this.m_mi.sendGS(_loc_5);
            }
            else
            {
                this.m_mi.sendGS(_loc_5, this.processPacket(_loc_5));
            }
            this.m_mi.addRecentGame({shortname:this.m_mi.getActiveShortname()});
            return;
        }// end function

        public function reconnect() : void
        {
            this.m_mi.listenGS(SharedCommand.COMMAND_MPCG_REJOIN_TABLE, this.onReconnect);
            this.m_mi.listenGS(SharedCommand.BROKEN_GAME_INFO, this.onBrokenGame);
            var _loc_1:* = new Packet(SharedCommand.COMMAND_MPCG_REJOIN_TABLE);
            this.m_mi.sendGS(_loc_1);
            return;
        }// end function

        public function finalizeInit() : void
        {
            this.m_mi.updateLogoutPacket(new Packet(this.CMD_LOGOUT, true));
            this.m_checkCredit = this.m_mi.getMode() == ClientMode.REAL && this.m_mi.readConf(SlotsConf.CHECK_GAME_CREDIT) == "1";
            return;
        }// end function

        public function dispose() : void
        {
            Console.write("ServerBase disposed");
            this.m_mi.unlistenGS(SharedCommand.BROKEN_GAME_INFO, this.onBrokenGame);
            this.m_mi.unlistenGS(this.m_lastSpinCmd, this.onSpinResponse);
            this.m_mi.unlistenGS(SharedCommand.COMMAND_MPCG_REJOIN_TABLE, this.onReconnect);
            this.m_gameRef = null;
            this.m_mi = null;
            this.m_lastRes = null;
            this.m_descriptor = null;
            return;
        }// end function

        public function activateAP(gameRef:Boolean) : void
        {
            var _loc_2:* = new Packet(this.CMD_LOGUSERPREFERENCES);
            _loc_2.addData("autoplay");
            _loc_2.addData("run");
            if (gameRef)
            {
                _loc_2.addData(1);
            }
            else
            {
                _loc_2.addData(0);
            }
            this.m_mi.sendGS(_loc_2);
            return;
        }// end function

        private function addSpinResParameters(gameRef:Packet) : void
        {
            gameRef.addData("0");
            var _loc_2:* = this.genResults();
            var _loc_3:* = _loc_2.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                gameRef.addData(_loc_2[_loc_4]);
                _loc_4++;
            }
            return;
        }// end function

        public function login(gameRef:Object, gameRef:int) : void
        {
            this.m_descriptor = gameRef;
            var _loc_3:* = new Packet(SharedCommand.GAME_LOGIN, true);
            _loc_3.addData(gameRef.shortname);
            _loc_3.addData(gameRef.chosenLimit.min);
            _loc_3.addData(gameRef.chosenLimit.max);
            _loc_3.addData(gameRef.chosenLimit.minPos);
            _loc_3.addData(gameRef.chosenLimit.maxPos);
            _loc_3.addData(this.CMD_LOGIN);
            _loc_3.addData("1.0");
            _loc_3.addData(gameRef);
            this.m_mi.listenGS(SharedCommand.BROKEN_GAME_INFO, this.onBrokenGame);
            this.m_mi.listenGS(this.CMD_LOGIN, this.onLoginResponse);
            this.m_mi.sendGS(_loc_3, this.processPacket(_loc_3));
            return;
        }// end function

        private function onLoginResponse(gameRef:Packet) : void
        {
            this.m_mi.unlistenGS(this.CMD_LOGIN, this.onLoginResponse);
            if (gameRef.errorCode != SharedError.ERR_OK)
            {
                this.m_mi.hideSandglass();
                this.m_mi.exitModuleImmediately(this.m_descriptor, SharedError.ERR_GAMEUNAVAILABLE);
                return;
            }
            this.m_mi.updateTDHStatus(this.m_descriptor, true);
            this.m_balance = Number(gameRef.data[0]);
            this.m_mi.hideSandglass();
            this.m_mi.moduleLoginSuccess(this.m_descriptor, GameParameters.progressive);
            return;
        }// end function

        protected function getCheat() : Vector.<int>
        {
            var _loc_1:* = this.m_mi.readSession(SharedSession.CHEAT);
            if (_loc_1 != null && _loc_1 != "")
            {
                this.m_mi.writeSession(SharedSession.CHEAT, "");
                return this.Vector.<int>(_loc_1.split(","));
            }
            return new Vector.<int>;
        }// end function

        protected function onSpinResponse(gameRef:Packet) : void
        {
            var _loc_2:* = gameRef.data.length;
            this.m_mi.unlistenGS(this.m_lastSpinCmd, this.onSpinResponse);
            this.m_mi.hideSandglass();
            if (gameRef.errorCode != SharedError.ERR_OK)
            {
                this.m_balance = this.m_balance + this.m_gameRef.getRoundInfo().getTotalBet();
                if (SharedError.isRGError(gameRef.errorCode))
                {
                    this.m_gameRef.restorePreviousGame(true);
                    this.m_mi.showLastRGError();
                }
                else if (SharedError.ERR_BALANCE_LOW == gameRef.errorCode)
                {
                    this.m_gameRef.restorePreviousGame(false);
                    this.m_mi.openDialog(SharedDialog.ALERT_SE, gameRef.errorCode);
                }
                else
                {
                    this.m_mi.exitModuleImmediately(this.m_descriptor, gameRef.errorCode);
                }
                return;
            }
            var _loc_3:* = gameRef.data.shift();
            if (this.m_checkCredit && !this.testCredit(_loc_3))
            {
                return;
            }
            this.m_lastRes = new Vector.<int>;
            _loc_2 = gameRef.data.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                this.m_lastRes.push(int(gameRef.data[_loc_4]));
                _loc_4++;
            }
            this.m_gameRef.spinResponse(this.m_lastRes);
            return;
        }// end function

        private function testCredit(ERR_GAMEUNAVAILABLE:Number) : Boolean
        {
            var _loc_2:* = this.m_balance - ERR_GAMEUNAVAILABLE;
            if (_loc_2 != 0)
            {
                this.m_mi.openDialog(SharedDialog.ALERT, "Credit out of sync, reelInfo: " + this.m_lastRes + ",diff " + _loc_2 + ", server: " + ERR_GAMEUNAVAILABLE + ", game: " + this.m_balance);
                return false;
            }
            return true;
        }// end function

        private function onBrokenGame(gameRef:Packet) : void
        {
            if (this.m_lastRes == null)
            {
                this.m_lastRes = new Vector.<int>(5);
            }
            this.m_mi.unlistenGS(SharedCommand.BROKEN_GAME_INFO, this.onBrokenGame);
            this.m_mi.hideSandglass();
            this.m_gameRef.typeBrokenHandler(gameRef.data);
            return;
        }// end function

        public function resultIsValid(ERR_GAMEUNAVAILABLE:Vector.<int>) : Boolean
        {
            throw new Error("Cannot check whether the result is valid, override resultIsValid method");
        }// end function

        private function onReconnect(gameRef:Packet) : void
        {
            this.m_mi.unlistenGS(SharedCommand.COMMAND_MPCG_REJOIN_TABLE, this.onReconnect);
            Console.write("onReconnect " + gameRef.data, this);
            if (gameRef.errorCode != SharedError.ERR_OK)
            {
                this.m_mi.exitModuleImmediately(this.m_descriptor, gameRef.errorCode);
                return;
            }
            if (this.m_lastRes == null)
            {
                this.m_mi.hideSandglass();
                this.m_gameRef.firstEntrance();
            }
            return;
        }// end function

        public function processPacket(m_gameRef:Packet) : Packet
        {
            var _loc_2:Packet = null;
            switch(m_gameRef.code)
            {
                case SharedCommand.GAME_LOGIN:
                {
                    _loc_2 = new Packet(this.CMD_LOGIN, true);
                    _loc_2.addData("0");
                    return _loc_2;
                }
                case this.CMD_SPIN:
                {
                    _loc_2 = new Packet(this.CMD_SPIN);
                    this.addSpinResParameters(_loc_2);
                    return _loc_2;
                }
                case this.CMD_FREESPIN:
                {
                    _loc_2 = new Packet(this.CMD_FREESPIN);
                    this.addSpinResParameters(_loc_2);
                    return _loc_2;
                }
                case this.CMD_RESPIN:
                {
                    _loc_2 = new Packet(this.CMD_RESPIN);
                    this.addSpinResParameters(_loc_2);
                    return _loc_2;
                }
                default:
                {
                    return new Packet(0);
                    break;
                }
            }
        }// end function

    }
}
