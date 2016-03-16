package com.playtech.casino3.slots.shared.novel
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.utils.*;

    public class ReelsNovel extends Object implements IReelsAnimator
    {
        private var m_reelstrips:ReelsStrips;
        private const P_ANTIC_ACC:int = 5;
        private var m_spaceH:int;
        private var m_sinDec:Number;
        private var m_baseGfx:Sprite;
        private var m_syms:Array;
        private var m_counter:int;
        private var m_reelW:int;
        private var m_reelGfx:Sprite;
        private const T_ANTICIPATIN:int = 15;
        protected var S_ANTICIPATION:int = 0;
        private var m_anticInfo:Vector.<int>;
        private var m_numReels:int;
        private const P_NORM:int = 3;
        protected var S_ROCK_END:int = 0;
        protected var S_NORMAL:int = 0;
        protected var S_ROCK_START:int = 0;
        private const T_ANTIC_SPEED_UP:int = 25;
        private const T_ROCK:int = 5;
        private var m_rows:int;
        private const P_DEC:int = 2;
        private const T_DEC:int = 11;
        private var m_queueIds:Vector.<String>;
        private var m_reelInfo:Array;
        private var m_blurValues:Vector.<int>;
        protected var S_SLOW:int = 0;
        private var m_pos:Vector.<Point>;
        private var m_sn:String;
        private var m_spinning:int;
        private var m_sinRock:Number;
        protected var BLUR_LEVEL:int = 0;
        private const P_SLOW:int = 7;
        private const P_STOP:int = 0;
        private const P_ANTIC:int = 6;
        private var m_current:Vector.<int>;
        private var m_midPoint:int;
        public var solid_color:Object = null;
        private const P_ACC:int = 1;
        private var m_symH:int;
        private const P_ROCK:int = 4;

        public function ReelsNovel(param1:Sprite, param2:ReelsStrips, param3:int = -1)
        {
            param3 = param3 == -1 ? (1) : (param3);
            this.setAnimParams();
            this.m_baseGfx = new Sprite();
            this.m_baseGfx.x = param1.x;
            this.m_baseGfx.y = param1.y;
            param1.parent.addChildAt(this.m_baseGfx, (param1.parent.getChildIndex(param1) + 1));
            this.m_reelGfx = new Sprite();
            this.m_baseGfx.addChild(this.m_reelGfx);
            var _loc_4:* = param1.getChildByName("reels_mask") as Sprite;
            var _loc_5:* = new Sprite();
            _loc_5.graphics.beginFill(16711680);
            if (_loc_4 != null)
            {
                _loc_5.graphics.drawRect(_loc_4.x, _loc_4.y, _loc_4.width, _loc_4.height);
                _loc_4.visible = false;
            }
            else
            {
                _loc_5.graphics.drawRect(0, 0, param1.width, param1.height);
            }
            _loc_5.graphics.endFill();
            this.m_baseGfx.addChild(_loc_5);
            this.m_reelGfx.mask = _loc_5;
            this.m_sn = GameParameters.shortname;
            this.m_midPoint = param3;
            this.m_reelstrips = param2;
            this.m_numReels = this.m_reelstrips.reels_strips.length;
            this.m_reelInfo = [];
            this.m_blurValues = new Vector.<int>;
            var _loc_6:int = 0;
            while (_loc_6 < this.m_numReels)
            {
                
                this.m_reelInfo[_loc_6] = {v:0, a:0, t:0, l:0, p:this.P_STOP, sin:0};
                this.m_blurValues[_loc_6] = this.BLUR_LEVEL;
                _loc_6++;
            }
            this.m_rows = GameParameters.numRows;
            this.m_symH = param1.height / this.m_rows;
            var _loc_7:* = param1.getChildByName("r0") as Sprite;
            this.m_reelW = _loc_7.width;
            this.m_spaceH = (param1.getChildByName("r1") as Sprite).x - _loc_7.x;
            this.initPos(param1);
            this.calcSins();
            this.m_queueIds = new Vector.<String>(this.m_numReels);
            return;
        }// end function

        protected function setAnimParams() : void
        {
            this.S_NORMAL = 55;
            this.S_ANTICIPATION = 90;
            this.S_ROCK_START = 25;
            this.S_ROCK_END = 0;
            this.S_SLOW = 5;
            this.BLUR_LEVEL = 5;
            return;
        }// end function

        public function symbolOnFlatIndex(numRows:int) : DisplayObject
        {
            var _loc_2:* = numRows % GameParameters.numReels;
            var _loc_3:* = int(numRows / GameParameters.numReels);
            return this.symbolOnIndex(_loc_2, _loc_3);
        }// end function

        private function symDown(a:int) : void
        {
            var _loc_3:int = 0;
            var _loc_4:Class = null;
            var _loc_5:Sprite = null;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_8:SlotsSymbol = null;
            var _loc_11:String = null;
            var _loc_2:* = this.m_syms[a];
            var _loc_9:* = this.m_reelstrips.reels_strips;
            var _loc_10:* = _loc_9[a].strip;
            _loc_6 = _loc_2[this.m_rows].y;
            if (_loc_6 <= this.m_symH * this.m_rows - this.m_symH / 2)
            {
                this.m_reelGfx.removeChild(_loc_2.shift());
                _loc_3 = int(this.m_current[a]) + 1;
                if (_loc_3 > (_loc_10.length - 1))
                {
                    _loc_3 = _loc_3 - _loc_10.length;
                }
                this.m_current[a] = _loc_3;
                _loc_3 = _loc_3 + (this.m_rows - this.m_midPoint);
                _loc_3 = _loc_3 % _loc_10.length;
                if (_loc_3 < 0)
                {
                    _loc_3 = _loc_10.length + _loc_3;
                }
                _loc_8 = _loc_10[_loc_3] as SlotsSymbol;
                _loc_7 = _loc_8.type + "";
                _loc_11 = _loc_8.image ? (this.m_sn + "." + _loc_8.image) : (this.m_sn + ".s" + _loc_7);
                _loc_4 = getDefinitionByName(_loc_11) as Class;
                _loc_5 = new _loc_4 as Sprite;
                _loc_5.opaqueBackground = this.solid_color;
                var _loc_12:String = this;
                var _loc_13:* = this.m_counter + 1;
                _loc_12.m_counter = _loc_13;
                _loc_5.name = "s" + _loc_7 + "_" + this.m_counter;
                _loc_5.x = _loc_2[0].x;
                _loc_5.y = _loc_6 + this.m_symH;
                _loc_5.filters = [new BlurFilter(0, this.m_blurValues[a], BitmapFilterQuality.LOW)];
                this.m_reelGfx.addChild(_loc_5);
                _loc_2.push(_loc_5);
            }
            return;
        }// end function

        public function changeSpin(a:int = 0, a:int = 0) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Function = null;
            if ((a & ReelSpinInfo.UP) > 0)
            {
                _loc_3 = -this.S_NORMAL;
                _loc_4 = this.symDown;
            }
            else
            {
                _loc_3 = this.S_NORMAL;
                _loc_4 = this.symUp;
            }
            this.m_reelInfo[a] = {v:_loc_3, a:0, t:-1, l:-1, p:this.P_NORM, f:_loc_4, sin:0, v2:_loc_3, a2:0, initial_info:a};
            this.m_blurValues[a] = this.BLUR_LEVEL;
            return;
        }// end function

        public function dispose() : void
        {
            this.m_baseGfx.removeEventListener(Event.ENTER_FRAME, this.doSpin);
            this.m_baseGfx = null;
            this.m_reelGfx = null;
            this.m_reelstrips = null;
            this.m_pos = null;
            this.m_current = null;
            this.m_reelInfo = null;
            this.m_syms = null;
            this.m_queueIds = null;
            this.m_anticInfo = null;
            this.m_blurValues = null;
            return;
        }// end function

        private function initPos(a:DisplayObjectContainer) : void
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:DisplayObject = null;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_2:int = 0;
            this.m_pos = new Vector.<Point>(this.m_rows * this.m_numReels, true);
            var _loc_3:* = this.m_reelW / 2;
            var _loc_4:* = this.m_symH / 2;
            _loc_5 = 0;
            while (_loc_5 < this.m_rows)
            {
                
                _loc_6 = 0;
                while (_loc_6 < this.m_numReels)
                {
                    
                    _loc_7 = a.getChildByName("r" + _loc_6) as Sprite;
                    if (_loc_7)
                    {
                        _loc_8 = _loc_7.x + _loc_7.width / 2;
                        _loc_9 = _loc_7.y + _loc_5 * _loc_7.height / GameParameters.numRows + this.m_symH / 2;
                    }
                    else
                    {
                        _loc_8 = _loc_3 + _loc_6 * this.m_spaceH;
                        _loc_9 = _loc_4 + _loc_5 * this.m_symH;
                    }
                    this.m_pos[++_loc_2] = new Point(_loc_8, _loc_9);
                    _loc_6++;
                }
                _loc_5++;
            }
            return;
        }// end function

        private function reelEnd(a:Object, a:int) : void
        {
            var _loc_5:Number = NaN;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_3:* = this.m_reelstrips.reels_strips;
            var _loc_4:* = _loc_3[a].strip;
            switch(a.p)
            {
                case this.P_DEC:
                {
                    if (a < (this.m_numReels - 1))
                    {
                        QueueEventManager.dispatchEvent(this.m_queueIds[a]);
                    }
                    a.p = this.P_ROCK;
                    if (a.f == this.symUp)
                    {
                        a.f = this.symDown;
                        this.changeSpinInfo(a, -this.S_ROCK_START, -this.S_ROCK_END, this.T_ROCK, int(this.m_symH / 2));
                    }
                    else
                    {
                        a.f = this.symUp;
                        this.changeSpinInfo(a, this.S_ROCK_START, this.S_ROCK_END, this.T_ROCK, int(this.m_symH / 2));
                    }
                    EventPool.dispatchEvent(new RegularEvent(ReelSpinInfo.REEL_END_SND, a));
                    break;
                }
                case this.P_ROCK:
                {
                    this.pixelCorrection(a, true);
                    EventPool.dispatchEvent(new RegularEvent(ReelSpinInfo.REEL_END, [a, true]));
                    a.p = this.P_STOP;
                    var _loc_9:String = this;
                    var _loc_10:* = this.m_spinning - 1;
                    _loc_9.m_spinning = _loc_10;
                    if (a == (this.m_numReels - 1))
                    {
                        QueueEventManager.dispatchEvent(this.m_queueIds[a]);
                    }
                    if (this.m_spinning == 0)
                    {
                        EventPool.dispatchEvent(new Event(ReelSpinInfo.SPIN_END));
                        this.m_baseGfx.removeEventListener(Event.ENTER_FRAME, this.doSpin);
                    }
                    break;
                }
                case this.P_ANTIC_ACC:
                {
                    a.p = this.P_ANTIC;
                    a.l = this.T_ANTICIPATIN;
                    var _loc_9:int = 0;
                    a.a2 = 0;
                    a.a = _loc_9;
                    break;
                }
                case this.P_ANTIC:
                {
                    _loc_5 = this.S_ANTICIPATION * this.T_ANTICIPATIN;
                    _loc_6 = _loc_5 / this.m_symH;
                    if (a.v > 0)
                    {
                        _loc_7 = this.m_anticInfo[0] + _loc_6;
                        if (_loc_7 > (_loc_4.length - 1))
                        {
                            _loc_7 = _loc_7 - _loc_4.length;
                        }
                        _loc_8 = (_loc_6 - 1) * this.m_symH + (this.m_pos[0].y - this.m_syms[a][0].y) + int(this.m_symH / 2);
                    }
                    else
                    {
                        _loc_7 = this.m_anticInfo[0] - _loc_6;
                        if (_loc_7 < 0)
                        {
                            _loc_7 = _loc_4.length + _loc_7;
                        }
                        _loc_8 = -((_loc_6 - 1) * this.m_symH + (this.m_symH - (this.m_pos[0].y - this.m_syms[a][0].y)) + int(this.m_symH / 2));
                    }
                    this.m_current[a] = _loc_7;
                    a.l = this.T_ANTICIPATIN;
                    a.p = this.P_DEC;
                    var _loc_9:* = _loc_8 / this.T_ANTICIPATIN;
                    a.v2 = _loc_8 / this.T_ANTICIPATIN;
                    a.v = _loc_9;
                    break;
                }
                case this.P_SLOW:
                {
                    this.pixelCorrection(a, false);
                    a.p = this.P_STOP;
                    var _loc_9:String = this;
                    var _loc_10:* = this.m_spinning - 1;
                    _loc_9.m_spinning = _loc_10;
                    QueueEventManager.dispatchEvent(this.m_queueIds[a]);
                    if (this.m_spinning == 0)
                    {
                        this.m_baseGfx.removeEventListener(Event.ENTER_FRAME, this.doSpin);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function reelPosition(endFill:int) : int
        {
            return this.m_current[endFill];
        }// end function

        public function stopSpin(endFill:int, endFill:int, endFill:int, endFill:String) : int
        {
            var _loc_7:Function = null;
            var _loc_8:int = 0;
            var _loc_9:Number = NaN;
            var _loc_10:Object = null;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_5:* = this.m_reelstrips.reels_strips;
            var _loc_6:* = _loc_5[endFill].strip;
            this.m_queueIds[endFill] = endFill;
            if ((endFill & ReelSpinInfo.SLOW_MOVE) > 0)
            {
                var _loc_13:String = this;
                var _loc_14:* = this.m_spinning + 1;
                _loc_13.m_spinning = _loc_14;
                if ((endFill & ReelSpinInfo.DOWN) > 0)
                {
                    _loc_7 = this.symUp;
                    _loc_8 = this.S_SLOW;
                }
                else
                {
                    _loc_7 = this.symDown;
                    _loc_8 = this.S_SLOW * -1;
                }
                this.m_reelInfo[endFill] = {v:_loc_8, a:0, t:-1, l:int(endFill * this.m_symH / this.S_SLOW), p:this.P_SLOW, f:_loc_7, sin:0, v2:_loc_8, a2:0};
                this.m_baseGfx.addEventListener(Event.ENTER_FRAME, this.doSpin);
            }
            else
            {
                EventPool.dispatchEvent(new RegularEvent(ReelSpinInfo.REEL_STOP_START, [endFill, endFill]));
                if ((endFill & ReelSpinInfo.ANTICIPATION_STOP) > 0)
                {
                    this.m_blurValues[endFill] = 10;
                    this.m_anticInfo = this.Vector.<int>([endFill, endFill]);
                    _loc_9 = (this.S_ANTICIPATION - this.S_NORMAL) / this.T_ANTIC_SPEED_UP;
                    if (this.m_reelInfo[endFill].v > 0)
                    {
                        this.m_reelInfo[endFill] = {v:this.S_NORMAL, a:_loc_9, t:-1, l:this.T_ANTIC_SPEED_UP, p:this.P_ANTIC_ACC, f:this.symUp, sin:0, v2:this.S_NORMAL, a2:_loc_9};
                    }
                    else
                    {
                        this.m_reelInfo[endFill] = {v:-this.S_NORMAL, a:-_loc_9, t:-1, l:this.T_ANTIC_SPEED_UP, p:this.P_ANTIC_ACC, f:this.symDown, sin:0, v2:-this.S_NORMAL, a2:-_loc_9};
                    }
                }
                else
                {
                    _loc_10 = this.m_reelInfo[endFill];
                    _loc_10.p = this.P_DEC;
                    if (_loc_10.v > 0)
                    {
                        _loc_11 = endFill + (this.m_rows + 1);
                        if (_loc_11 > (_loc_6.length - 1))
                        {
                            _loc_11 = _loc_11 - _loc_6.length;
                        }
                        _loc_12 = this.m_rows * this.m_symH + (this.m_pos[0].y - this.m_syms[endFill][0].y) + int(this.m_symH / 2);
                        this.changeSpinInfo(_loc_10, this.S_NORMAL, this.S_ROCK_START, this.T_DEC, _loc_12);
                    }
                    else
                    {
                        _loc_11 = endFill - (this.m_rows + 1);
                        if (_loc_11 < 0)
                        {
                            _loc_11 = _loc_6.length + _loc_11;
                        }
                        _loc_12 = this.m_rows * this.m_symH + (this.m_symH - (this.m_pos[0].y - this.m_syms[endFill][0].y)) + int(this.m_symH / 2);
                        this.changeSpinInfo(_loc_10, -this.S_NORMAL, -this.S_ROCK_START, this.T_DEC, _loc_12);
                    }
                    this.m_current[endFill] = _loc_11;
                }
            }
            return 1;
        }// end function

        public function toString() : String
        {
            return "[ReelsAnimator] ";
        }// end function

        private function doSpin(event:Event) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Array = null;
            var _loc_4:Number = NaN;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            _loc_5 = 0;
            while (_loc_5 < this.m_numReels)
            {
                
                _loc_2 = this.m_reelInfo[_loc_5];
                _loc_4 = 0;
                if (_loc_2.p != this.P_STOP)
                {
                    var _loc_7:* = _loc_2;
                    var _loc_8:* = _loc_2.l - 1;
                    _loc_7.l = _loc_8;
                    _loc_2.v = _loc_2.v + _loc_2.a;
                    _loc_2.v2 = _loc_2.v2 + _loc_2.a2;
                    if (_loc_2.sin != 0)
                    {
                        _loc_4 = _loc_2.sin * Math.sin(((_loc_2.t - 1) - _loc_2.l) * 1 / _loc_2.t);
                    }
                    _loc_3 = this.m_syms[_loc_5];
                    _loc_6 = 0;
                    while (_loc_6 < (this.m_rows + 1))
                    {
                        
                        _loc_3[_loc_6].y = _loc_3[_loc_6].y + (_loc_2.v + _loc_4 + (_loc_2.v2 - _loc_2.v));
                        _loc_6++;
                    }
                    _loc_2.f(_loc_5);
                    if (_loc_2.l == 0)
                    {
                        this.reelEnd(_loc_2, _loc_5);
                    }
                }
                _loc_5++;
            }
            return;
        }// end function

        private function clearSyms() : void
        {
            var _loc_1:* = this.m_reelGfx.mask as Sprite;
            var _loc_2:* = new Sprite();
            this.m_baseGfx.addChildAt(_loc_2, this.m_baseGfx.getChildIndex(this.m_reelGfx));
            this.m_baseGfx.removeChild(this.m_reelGfx);
            this.m_reelGfx = _loc_2;
            this.m_reelGfx.mask = _loc_1;
            this.m_syms = [];
            return;
        }// end function

        private function pixelCorrection(a:int, a:Boolean) : void
        {
            var _loc_4:Class = null;
            var _loc_5:Sprite = null;
            var _loc_6:String = null;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:Point = null;
            var _loc_10:int = 0;
            var _loc_11:Number = NaN;
            var _loc_3:* = this.m_syms[a];
            _loc_5 = _loc_3[_loc_7];
            _loc_9 = this.m_pos[a];
            a = _loc_5.y < _loc_9.y - 20;
            _loc_7 = 0;
            while (_loc_7 < (this.m_rows + 1))
            {
                
                _loc_5 = _loc_3[_loc_7] as Sprite;
                _loc_5.cacheAsBitmap = false;
                _loc_5.filters = null;
                _loc_8 = a + _loc_7 * this.m_numReels;
                _loc_10 = _loc_5.y;
                if (a)
                {
                    if (_loc_7 >= 1)
                    {
                        _loc_9 = this.m_pos[_loc_8 - this.m_numReels];
                        _loc_11 = _loc_9.y - _loc_10;
                        _loc_10 = _loc_9.y;
                    }
                }
                else if (_loc_7 < this.m_rows)
                {
                    _loc_9 = this.m_pos[_loc_8];
                    _loc_11 = _loc_9.y - _loc_10;
                    _loc_10 = _loc_9.y;
                }
                else
                {
                    _loc_10 = _loc_10 + _loc_11;
                }
                _loc_5.y = _loc_10;
                _loc_5.cacheAsBitmap = true;
                _loc_7++;
            }
            if (a)
            {
                _loc_5 = _loc_3[0] as Sprite;
                _loc_5.y = _loc_5.y - int(_loc_11);
            }
            return;
        }// end function

        public function showResult(a:Vector.<int>, a:ReelsSymbolsState) : void
        {
            var i:int;
            var mcClassRef:Class;
            var sym:Sprite;
            var idx:int;
            var p:Point;
            var a:Array;
            var name:String;
            var symbol:SlotsSymbol;
            var static_symbol_linkage:String;
            var reel_strip:Vector.<SlotsSymbol>;
            var j:int;
            var res:* = a;
            var reels_symbols_state:* = a;
            var syms:* = reels_symbols_state.unmasked_symbols;
            var reelstrips:* = this.m_reelstrips.reels_strips;
            Console.write("showResult " + res + " " + syms, this);
            this.m_baseGfx.removeEventListener(Event.ENTER_FRAME, this.doSpin);
            this.clearSyms();
            this.m_current = res.slice();
            i;
            while (i < this.m_numReels)
            {
                
                a;
                j;
                while (j < this.m_rows)
                {
                    
                    idx = i + j * this.m_numReels;
                    symbol = syms[idx] as SlotsSymbol;
                    name = symbol.type + "";
                    static_symbol_linkage = symbol.image ? (this.m_sn + "." + symbol.image) : (this.m_sn + ".s" + name);
                    mcClassRef = getDefinitionByName(static_symbol_linkage) as Class;
                    sym = new mcClassRef as Sprite;
                    sym.opaqueBackground = this.solid_color;
                    p = this.m_pos[idx];
                    sym.x = p.x;
                    sym.y = p.y;
                    this.m_reelGfx.addChild(sym);
                    var _loc_4:String = this;
                    _loc_4.m_counter = this.m_counter + 1;
                    sym.name = "s" + name + "_" + ++this.m_counter;
                    a.push(sym);
                    j = (j + 1);
                }
                reel_strip = reelstrips[i].strip;
                idx = res[i] - this.m_midPoint - 1;
                if (idx < 0)
                {
                    idx = reel_strip.length + idx;
                }
                idx = idx % reel_strip.length;
                if (idx < 0)
                {
                    idx = reel_strip.length + idx;
                }
                symbol = reel_strip[idx];
                name = symbol.type + "";
                static_symbol_linkage = symbol.image ? (this.m_sn + "." + symbol.image) : (this.m_sn + ".s" + name);
                mcClassRef = getDefinitionByName(static_symbol_linkage) as Class;
                sym = new mcClassRef as Sprite;
                sym.opaqueBackground = this.solid_color;
                this.m_reelGfx.addChild(sym);
                var _loc_4:String = this;
                _loc_4.m_counter = this.m_counter + 1;
                sym.name = "s" + name + "_" + ++this.m_counter;
                sym.x = p.x;
                sym.y = int(p.y - this.m_rows * this.m_symH);
                a.unshift(sym);
                this.m_syms.push(a);
                i = (i + 1);
            }
            i = this.m_numReels - this.m_spinning;
            while (i < this.m_numReels)
            {
                
                try
                {
                    this.m_reelInfo[i].p = this.P_STOP;
                }
                catch (error:Error)
                {
                    throw new Error("howReeels Error  index is " + i);
                }
                EventPool.dispatchEvent(new RegularEvent(ReelSpinInfo.REEL_END, [i, false]));
                i = (i + 1);
            }
            if (this.m_spinning != 0)
            {
                this.m_spinning = 0;
                EventPool.dispatchEvent(new Event(ReelSpinInfo.SPIN_END));
            }
            return;
        }// end function

        public function symbolOnIndex(numRows:int, numRows:int) : DisplayObject
        {
            var _loc_4:int = 0;
            var _loc_6:DisplayObject = null;
            var _loc_3:* = this.m_syms[numRows].concat();
            _loc_3 = _loc_3.sortOn("y", Array.NUMERIC);
            var _loc_5:* = _loc_3.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_5)
            {
                
                _loc_6 = _loc_3[_loc_4] as DisplayObject;
                if (Math.abs(_loc_6.y - this.m_symH * (numRows + 0.5)) < 10)
                {
                    _loc_6.parent.addChild(_loc_6);
                    return _loc_6;
                }
                _loc_4++;
            }
            return null;
        }// end function

        private function calcSins() : void
        {
            var _loc_1:int = 0;
            var _loc_2:* = 1 / this.T_DEC;
            this.m_sinDec = 0;
            _loc_1 = 0;
            while (_loc_1 < this.T_DEC)
            {
                
                this.m_sinDec = this.m_sinDec + Math.sin(_loc_1 * _loc_2);
                _loc_1++;
            }
            _loc_2 = 1 / this.T_ROCK;
            this.m_sinRock = 0;
            _loc_1 = 0;
            while (_loc_1 < this.T_ROCK)
            {
                
                this.m_sinRock = this.m_sinRock + Math.sin(_loc_1 * _loc_2);
                _loc_1++;
            }
            return;
        }// end function

        private function symUp(a:int) : void
        {
            var _loc_3:int = 0;
            var _loc_4:Class = null;
            var _loc_5:Sprite = null;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_8:SlotsSymbol = null;
            var _loc_11:String = null;
            var _loc_2:* = this.m_syms[a];
            var _loc_9:* = this.m_reelstrips.reels_strips;
            var _loc_10:* = _loc_9[a].strip;
            _loc_6 = _loc_2[0].y;
            if (_loc_6 >= this.m_symH / 2 - 1)
            {
                this.m_reelGfx.removeChild(_loc_2.pop());
                _loc_3 = this.m_current[a] - 1;
                if (_loc_3 < 0)
                {
                    _loc_3 = _loc_10.length + _loc_3;
                }
                this.m_current[a] = _loc_3;
                _loc_3 = _loc_3 - (this.m_midPoint + 1);
                _loc_3 = _loc_3 % _loc_10.length;
                if (_loc_3 < 0)
                {
                    _loc_3 = _loc_10.length + _loc_3;
                }
                _loc_8 = _loc_10[_loc_3] as SlotsSymbol;
                _loc_7 = _loc_8.type + "";
                _loc_11 = _loc_8.image ? (this.m_sn + "." + _loc_8.image) : (this.m_sn + ".s" + _loc_7);
                _loc_4 = getDefinitionByName(_loc_11) as Class;
                _loc_5 = new _loc_4 as Sprite;
                _loc_5.opaqueBackground = this.solid_color;
                var _loc_12:String = this;
                var _loc_13:* = this.m_counter + 1;
                _loc_12.m_counter = _loc_13;
                _loc_5.name = "s" + _loc_7 + "_" + this.m_counter;
                _loc_5.x = _loc_2[0].x;
                _loc_5.y = _loc_6 - this.m_symH;
                _loc_5.filters = [new BlurFilter(0, this.m_blurValues[a], BitmapFilterQuality.LOW)];
                this.m_reelGfx.addChild(_loc_5);
                _loc_2.unshift(_loc_5);
            }
            return;
        }// end function

        public function startSpin(a:int = 0, a:int = 0) : void
        {
            var _loc_3:String = this;
            var _loc_4:* = this.m_spinning + 1;
            _loc_3.m_spinning = _loc_4;
            this.changeSpin(a, a);
            if (!this.m_baseGfx.hasEventListener(Event.ENTER_FRAME))
            {
                this.m_baseGfx.addEventListener(Event.ENTER_FRAME, this.doSpin);
                EventPool.dispatchEvent(new Event(ReelSpinInfo.SPIN_START));
            }
            return;
        }// end function

        public function getGlobalPositions() : Vector.<Point>
        {
            var _loc_1:int = 0;
            var _loc_2:* = this.m_pos.length;
            var _loc_3:* = new Vector.<Point>(_loc_2, true);
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                _loc_3[_loc_1] = this.m_reelGfx.localToGlobal(this.m_pos[_loc_1]);
                _loc_1++;
            }
            return _loc_3;
        }// end function

        private function changeSpinInfo(a:Object, a:int, a:int, a:int, a:int) : void
        {
            var _loc_8:Number = NaN;
            a.v = a;
            a.v2 = a;
            a.a = (a - a) / a;
            a.a2 = -a / a;
            var _loc_6:* = (a - 0) * (a - 1) / 2;
            var _loc_7:* = _loc_6 < 0 ? (-1) : (1);
            _loc_6 = _loc_6 * _loc_7;
            switch(a)
            {
                case this.T_DEC:
                {
                    _loc_8 = this.m_sinDec;
                    break;
                }
                case this.T_ROCK:
                {
                    _loc_8 = this.m_sinRock;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_9:* = (a - _loc_6) / _loc_8;
            _loc_9 = _loc_9 * _loc_7;
            a.sin = _loc_9;
            a.t = a;
            a.l = a;
            return;
        }// end function

    }
}
