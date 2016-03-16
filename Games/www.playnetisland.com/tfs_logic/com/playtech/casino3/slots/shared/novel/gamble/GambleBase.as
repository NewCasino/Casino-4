package com.playtech.casino3.slots.shared.novel.gamble
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.gamble.enum.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class GambleBase extends EventDispatcher
    {
        protected var m_gameShortName:String;
        protected const CMD_DOUBLEUP_COLLECT:uint = 11141;
        protected var m_gambleLimit:Number;
        protected const CMD_DOUBLEUP_CHECK:uint = 11143;
        protected var m_regamble:Boolean;
        protected var m_mi:IModuleInterface;
        protected var m_gfxCont:DisplayObjectContainer;
        private var m_gameAmbient:int;
        protected var m_gambleAmbient:int = -1;
        public static const EVT_CAN_GAMBLE:String = "evt_can_gamble";

        public function GambleBase(param1:IModuleInterface, param2:DisplayObjectContainer, param3:Number)
        {
            this.m_mi = param1;
            this.m_gfxCont = param2;
            this.m_gambleLimit = param3;
            EventPool.addEventListener(GameStates.EVENT_RESET_All, this.closeGambleImmediately);
            return;
        }// end function

        private function getSoundString(com.playtech.casino3:String) : String
        {
            var classRef:Class;
            var id:* = com.playtech.casino3;
            var defname:* = this.m_gameShortName + ".gamble_snd_" + id;
            try
            {
                classRef = getDefinitionByName(defname) as Class;
            }
            catch (e:Error)
            {
                Console.write("getSoundString(" + id + ") returns null, no custom ambient sound for gamble", this);
                return null;
            }
            Console.write("getSoundString(" + id + ")  returns: " + defname, this);
            return defname;
        }// end function

        public function getResult() : GambleResult
        {
            return GambleResult.RESULT_OTHER;
        }// end function

        public function canGamble(ambient_id:Number) : void
        {
            return;
        }// end function

        public function regamble() : Boolean
        {
            return this.m_regamble;
        }// end function

        protected function closeGambleImmediately(event:Event) : void
        {
            return;
        }// end function

        public function start(addEventListener:Number, addEventListener:int = -1, addEventListener:Array = null, addEventListener:String = null) : int
        {
            this.m_gameShortName = GameParameters.shortname;
            this.m_gameAmbient = addEventListener;
            this.startGambleAmbientSound();
            return 1;
        }// end function

        protected function sendCommand(ambient_id:uint, ambient_id:Array = null, ambient_id:Packet = null) : void
        {
            var _loc_5:uint = 0;
            var _loc_4:* = new Packet(ambient_id);
            if (ambient_id != null)
            {
                _loc_5 = 0;
                while (_loc_5 < ambient_id.length)
                {
                    
                    _loc_4.addData(ambient_id[_loc_5]);
                    _loc_5 = _loc_5 + 1;
                }
            }
            if (ambient_id == null)
            {
                this.m_mi.sendGS(_loc_4);
            }
            else
            {
                this.m_mi.sendGS(_loc_4, ambient_id);
            }
            return;
        }// end function

        public function getWin() : Number
        {
            return 0;
        }// end function

        protected function startGameAmbientSound()
        {
            if (this.m_gambleAmbient != -1)
            {
                this.m_mi.stopSoundByID(this.m_gambleAmbient);
                this.m_gambleAmbient = -1;
                this.m_mi.pauseSoundByID(this.m_gameAmbient, false);
            }
            return;
        }// end function

        override public function toString() : String
        {
            return "[GambleBase] ";
        }// end function

        protected function startGambleAmbientSound() : void
        {
            var _loc_1:* = this.getSoundString("ambient");
            if (_loc_1 != null)
            {
                this.m_mi.pauseSoundByID(this.m_gameAmbient, true);
                this.m_gambleAmbient = this.m_mi.playAsAmbient(_loc_1);
            }
            return;
        }// end function

        public function unload() : void
        {
            this.startGameAmbientSound();
            this.m_gfxCont = null;
            this.m_mi = null;
            EventPool.removeEventListener(GameStates.EVENT_RESET_All, this.closeGambleImmediately);
            return;
        }// end function

    }
}
