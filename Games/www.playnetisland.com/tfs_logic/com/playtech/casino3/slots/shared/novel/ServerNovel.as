package com.playtech.casino3.slots.shared.novel
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.utils.*;

    public class ServerNovel extends ServerBase
    {
        protected var reels_strips:Vector.<ReelStrip>;
        private static var COMMAND_START_BONUSGAME:int = 7300;

        public function ServerNovel(param1:int, param2:int, param3:TypeNovel, param4:IModuleInterface, param5:ReelsStrips)
        {
            this.reels_strips = param5.reels_strips;
            super(param1, param2, param3, param4);
            return;
        }// end function

        override public function resultIsValid(com.playtech.casino3:IModuleInterface:Vector.<int>) : Boolean
        {
            var _loc_3:int = 0;
            var _loc_2:* = Math.min(com.playtech.casino3:IModuleInterface.length, this.reels_strips.length);
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (com.playtech.casino3:IModuleInterface[_loc_3] < 0 || com.playtech.casino3:IModuleInterface[_loc_3] > (this.reels_strips[_loc_3].strip.length - 1))
                {
                    return false;
                }
                _loc_3++;
            }
            return true;
        }// end function

        public function startBonusCmd() : void
        {
            var _loc_1:* = new Packet(COMMAND_START_BONUSGAME);
            m_mi.sendGS(_loc_1);
            return;
        }// end function

        override public function genResults() : Vector.<int>
        {
            var _loc_2:int = 0;
            var _loc_1:* = getCheat();
            _loc_2 = _loc_1.length;
            while (_loc_2 < GameParameters.numReels)
            {
                
                _loc_1.push(Math.ceil(Math.random() * this.reels_strips[_loc_2].strip.length - 1));
                _loc_2++;
            }
            return _loc_1;
        }// end function

    }
}
