package com.playtech.casino3.slots.shared.novel.winAnimations
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.core.*;

    public class WinAnimBase extends Object implements IWinAnimation
    {
        public var force_sound:Boolean;
        public var frames_sufixes:Vector.<String>;
        protected var _statusMap:Object;
        public var statusKey:String;
        public var sound:String;
        protected const CONSTANT_NAMES:Object;
        public var symbolIndexes:Vector.<int>;
        public var symbols:Vector.<SlotsSymbol>;
        public var payline:SlotsPayline;
        protected var winsAnimator:WinsNovel;
        protected var _slotswin:SlotsWin;
        protected var init:Object;
        protected const CONSTANT_VALUE_FUNCTIONS:Object;
        public var video:String;
        public static const S:int = 4;
        public static const W:int = 3;
        public static const X:int = 1;
        public static const TW:int = 5;
        public static const L_ID:int = 2;

        public function WinAnimBase(param1:WinsNovel, param2:SlotsWin, param3:Vector.<int>, param4:Vector.<SlotsSymbol>, param5:SlotsPayline, param6:Object = null)
        {
            this.CONSTANT_NAMES = {};
            this.CONSTANT_VALUE_FUNCTIONS = {};
            this.init = this.init_before_constructor();
            this.winsAnimator = param1;
            this._slotswin = param2;
            this.symbolIndexes = param3;
            this.symbols = param4;
            this.payline = param5;
            if (param6 == null)
            {
                return;
            }
            this.frames_sufixes = param6.frames_sufixes;
            this.sound = param6.snd;
            this.force_sound = param6.force_sound;
            this.video = param6.vid;
            this.statusKey = param6.statusKey;
            this.statusMap = param6.statusMap;
            return;
        }// end function

        public function get slotswin() : SlotsWin
        {
            return this._slotswin;
        }// end function

        function init_before_constructor()
        {
            this.CONSTANT_NAMES[X] = "X";
            this.CONSTANT_NAMES[L_ID] = "L_ID";
            this.CONSTANT_NAMES[W] = "W";
            this.CONSTANT_NAMES[S] = "S";
            this.CONSTANT_NAMES[TW] = "TW";
            this.CONSTANT_VALUE_FUNCTIONS[X] = this.constant_X_value;
            this.CONSTANT_VALUE_FUNCTIONS[L_ID] = this.constant_L_ID_value;
            this.CONSTANT_VALUE_FUNCTIONS[W] = this.constant_W_value;
            this.CONSTANT_VALUE_FUNCTIONS[S] = this.constant_S_value;
            this.CONSTANT_VALUE_FUNCTIONS[TW] = this.constant_TW_value;
            return;
        }// end function

        public function get statusMap() : Object
        {
            return this._statusMap;
        }// end function

        public function activate(snd:int, snd:String) : int
        {
            throw new Error("Cannot animate this win, override activate method");
        }// end function

        public function addVideos(__AS3__.vec:Array, __AS3__.vec:int) : void
        {
            throw new Error("Cannot add videos, override addVideos method");
        }// end function

        protected function constructMap(__AS3__.vec:Vector.<int>) : void
        {
            var _loc_3:int = 0;
            this._statusMap = {};
            if (!__AS3__.vec || __AS3__.vec.length == 0)
            {
                return;
            }
            var _loc_2:* = __AS3__.vec.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                this.setMapConstantValue(__AS3__.vec[_loc_3], this._statusMap);
                _loc_3++;
            }
            return;
        }// end function

        public function constant_L_ID_value() : Number
        {
            if (this.payline)
            {
                return (this.payline.id + 1);
            }
            return NaN;
        }// end function

        public function set statusMap(__AS3__.vec:Object) : void
        {
            if (__AS3__.vec == null)
            {
                return;
            }
            var _loc_2:* = __AS3__.vec as TextSubstitutions;
            if (!_loc_2)
            {
                this.constructMap(__AS3__.vec as Vector.<int>);
                return;
            }
            this._statusMap = __AS3__.vec;
            this.checkAndReplaceConstantValue(X);
            this.checkAndReplaceConstantValue(L_ID);
            this.checkAndReplaceConstantValue(W);
            this.checkAndReplaceConstantValue(S);
            this.checkAndReplaceConstantValue(TW);
            return;
        }// end function

        public function constant_S_value() : Number
        {
            if (this._slotswin)
            {
                return this._slotswin.special;
            }
            return NaN;
        }// end function

        public function isBlockingToggle() : Boolean
        {
            return false;
        }// end function

        public function constant_W_value() : String
        {
            if (this._slotswin)
            {
                return Money.format(this._slotswin.win);
            }
            return "NaN";
        }// end function

        protected function checkAndReplaceConstantValue(__AS3__.vec:int) : void
        {
            if (!this._statusMap.hasOwnProperty(__AS3__.vec))
            {
                return;
            }
            if (this._statusMap[__AS3__.vec] !== null)
            {
                return;
            }
            this._statusMap[this.CONSTANT_NAMES[__AS3__.vec]] = this.CONSTANT_VALUE_FUNCTIONS[__AS3__.vec];
            return;
        }// end function

        public function constant_TW_value() : String
        {
            if (this.winsAnimator && this.winsAnimator.m_roundInfo)
            {
                return Money.format(this.winsAnimator.m_roundInfo.totalwin);
            }
            return "NaN";
        }// end function

        public function cancelAnimation() : void
        {
            return;
        }// end function

        public function deactivate() : void
        {
            throw new Error("Cannot deactivate this win, override deactivate method");
        }// end function

        public function dispose() : void
        {
            this.symbolIndexes = null;
            this.symbols = null;
            this.payline = null;
            this.winsAnimator = null;
            this._slotswin = null;
            this._statusMap = null;
            return;
        }// end function

        protected function setMapConstantValue(param1:int, param2:Object, param3:Object = null)
        {
            if (param3)
            {
                var _loc_6:* = param3;
                param2[this.CONSTANT_NAMES[param1]] = param3;
                return _loc_6;
            }
            var _loc_4:* = this.CONSTANT_VALUE_FUNCTIONS[param1] as Function;
            if (_loc_4 == null)
            {
                Console.write("Warning WinAnimBase.setMapConstantValue(map_constant:int) , map_constant: " + param1 + " is not recognized !!!");
                var _loc_6:String = null;
                param2[param1] = null;
                return _loc_6;
            }
            var _loc_5:* = this._loc_4();
            var _loc_6:* = _loc_5;
            param2[this.CONSTANT_NAMES[param1]] = _loc_5;
            return _loc_6;
        }// end function

        public function constant_X_value() : Number
        {
            if (this._slotswin)
            {
                return this._slotswin.count;
            }
            return NaN;
        }// end function

    }
}
