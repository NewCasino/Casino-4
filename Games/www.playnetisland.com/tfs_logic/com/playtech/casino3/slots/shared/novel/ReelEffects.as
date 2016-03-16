package com.playtech.casino3.slots.shared.novel
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;

    public class ReelEffects extends Object
    {
        public var use_video_movieclip:Boolean = false;
        private var m_reelstops:Vector.<String>;
        private var m_reelSndBase:String;
        private var m_animIdx:int;
        private var m_positions:Array;
        private var m_stopSndBase:String;
        private var m_isAnticipation:Boolean;
        private var m_numRows:int;
        private var m_mi:IModuleInterface;
        private var m_activeSND:int;
        protected var _supressed_default_stop:int = 0;
        private var m_stopSyms:Vector.<SymbolReelStop>;
        public var use_smoothing_for_video_movieclip:Boolean = false;
        private var m_numReels:int;
        private var m_type:int;
        private var m_animName:String;
        private var m_layers:Vector.<Sprite>;
        private var m_movies:Array;
        private var m_base:TypeNovel;
        private var currentId:int;
        public static const LAYER_1:int = 1;
        public static const REEL_STOP_ANIMATION_ENDED:String = getQualifiedClassName(ReelEffects) + ".REEL_STOP_ANIMATION_ENDED";
        public static const NORMAL:int = 0;
        public static const LAYER_0:int = 0;
        public static const SEQUENTIAL:int = 1;

        public function ReelEffects(param1:TypeNovel, param2:Sprite, param3:int = 3)
        {
            var _loc_4:Sprite = null;
            this.m_base = param1;
            this.m_mi = param1.getModI();
            this.m_reelSndBase = GameParameters.library;
            this.m_stopSndBase = GameParameters.library;
            this.m_numReels = GameParameters.numReels;
            this.m_numRows = GameParameters.numRows;
            EventPool.addEventListener(ReelSpinInfo.SPIN_START, this.spinStarted);
            EventPool.addEventListener(ReelSpinInfo.SPIN_END, this.stopSpinSound);
            EventPool.addEventListener(ReelSpinInfo.REEL_END, this.showAnimation);
            EventPool.addEventListener(ReelSpinInfo.REEL_END_SND, this.playReelStop);
            EventPool.addEventListener(ReelSpinInfo.REEL_STOP_START, this.checkSound);
            this.currentId = 0;
            this.m_layers = new Vector.<Sprite>;
            var _loc_5:int = 0;
            while (_loc_5 < param3)
            {
                
                _loc_4 = Sprite(param2.getChildByName("reelEffectsLayer_" + _loc_5));
                if (_loc_4 == null)
                {
                    _loc_4 = new Sprite();
                    param2.addChild(_loc_4);
                    if (_loc_5 != 0)
                    {
                        _loc_4.x = this.m_layers[0].x;
                        _loc_4.y = this.m_layers[0].y;
                    }
                }
                this.m_layers.push(_loc_4);
                _loc_5++;
            }
            this.localPoints(param1.getReelAnimator().getGlobalPositions());
            this.m_movies = [];
            this.defaultStopSounds();
            return;
        }// end function

        public function defaultStopSounds() : void
        {
            var _loc_1:int = 0;
            this.m_reelstops = new Vector.<String>;
            _loc_1 = 0;
            while (_loc_1 < this.m_numReels)
            {
                
                this.m_reelstops.push(this.m_stopSndBase + ".reelstop");
                _loc_1++;
            }
            return;
        }// end function

        private function stopSpinSound(event:Event) : void
        {
            this.m_mi.stopSoundByID(this.m_activeSND);
            if (this.m_type == SEQUENTIAL)
            {
                var _loc_2:String = this;
                var _loc_3:* = this.currentId + 1;
                _loc_2.currentId = _loc_3;
                if (this.currentId > 3)
                {
                    this.currentId = 0;
                }
            }
            this.m_isAnticipation = false;
            return;
        }// end function

        public function removeMovie(__AS3__.vec:String, __AS3__.vec:int, __AS3__.vec:int) : void
        {
            var _loc_4:* = this.m_layers[__AS3__.vec].getChildByName(__AS3__.vec + __AS3__.vec) as MovieClip;
            if (_loc_4 != null)
            {
                this.m_layers[__AS3__.vec].removeChild(_loc_4);
            }
            return;
        }// end function

        private function playReelStop(event:RegularEvent) : void
        {
            this.playStop(event.data);
            return;
        }// end function

        public function useGameReelSnd() : void
        {
            this.m_reelSndBase = GameParameters.shortname;
            return;
        }// end function

        public function changeType(__AS3__.vec:int) : void
        {
            this.m_type = __AS3__.vec;
            return;
        }// end function

        protected function realCountSoundStop(__AS3__.vec:int) : void
        {
            var _loc_5:* = undefined;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:SymbolReelStop = null;
            var _loc_9:Vector.<int> = null;
            var _loc_10:SlotsSymbol = null;
            var _loc_11:int = 0;
            var _loc_13:int = 0;
            var _loc_2:* = GameParameters.shortname + ".";
            var _loc_3:* = this.m_base.getRoundInfo().reelSymbols.symbols;
            var _loc_4:* = this.m_stopSyms.length;
            var _loc_12:int = -1;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_8 = this.m_stopSyms[_loc_5];
                if (!_loc_8.is_real_count)
                {
                    return;
                }
                _loc_9 = _loc_8.mask;
                _loc_7 = _loc_9.length;
                _loc_2 = GameParameters.shortname + "." + _loc_8.sound;
                _loc_6 = 0;
                while (_loc_6 < _loc_7)
                {
                    
                    _loc_11 = _loc_3.countSymbolOnReel(_loc_8.symbol, _loc_6);
                    _loc_13 = _loc_9[_loc_6];
                    if (_loc_13 == -1)
                    {
                    }
                    else if (_loc_13 != _loc_11)
                    {
                        _loc_2 = null;
                        break;
                    }
                    else
                    {
                        _loc_12 = _loc_6;
                    }
                    _loc_6++;
                }
                if (_loc_12 == __AS3__.vec && _loc_2)
                {
                    this.m_mi.playAsEffect(_loc_2);
                }
                _loc_5 = _loc_5 + 1;
            }
            return;
        }// end function

        private function localPoints(__AS3__.vec:Vector.<Point>) : void
        {
            var _loc_6:Object = null;
            this.m_positions = [];
            var _loc_2:* = new Point(__AS3__.vec[0].x, __AS3__.vec[0].y);
            _loc_2 = this.m_layers[0].globalToLocal(_loc_2);
            var _loc_3:* = __AS3__.vec[0].x - _loc_2.x;
            var _loc_4:* = __AS3__.vec[0].y - _loc_2.y;
            var _loc_5:* = __AS3__.vec.length;
            var _loc_7:int = 0;
            while (_loc_7 < _loc_5)
            {
                
                _loc_6 = __AS3__.vec[_loc_7];
                this.m_positions.push({x:_loc_6.x - _loc_3, y:_loc_6.y - _loc_4});
                _loc_7++;
            }
            return;
        }// end function

        protected function noResultsFoundForReel(__AS3__.vec:int, __AS3__.vec:Boolean = true) : void
        {
            if (!__AS3__.vec)
            {
                return;
            }
            var _loc_3:* = this._supressed_default_stop >>> __AS3__.vec & 1;
            if (_loc_3 > 0)
            {
                return;
            }
            this.m_mi.playAsEffect(this.m_reelstops[__AS3__.vec]);
            return;
        }// end function

        public function setStopSymbols(__AS3__.vec:Vector.<SymbolReelStop>) : void
        {
            if (this.m_stopSyms != null)
            {
                this.disposeStopSyms();
            }
            this.m_stopSyms = __AS3__.vec.concat();
            return;
        }// end function

        public function get have_active_animations() : Boolean
        {
            return this.m_movies && this.m_movies.length != 0;
        }// end function

        public function showMovie(idx:String, idx:int, idx:int) : DisplayObject
        {
            var _loc_4:* = GameParameters.shortname + "." + idx;
            _loc_4 = ApplicationDomain.currentDomain.hasDefinition(_loc_4) ? (_loc_4) : (GameParameters.library + "." + idx);
            var _loc_5:* = getDefinitionByName(_loc_4) as Class;
            var _loc_6:* = this.use_video_movieclip ? (new VideoMovieClip(_loc_4)) : (new _loc_5 as DisplayObject);
            var _loc_7:* = _loc_6 as VideoMovieClip;
            if (_loc_7)
            {
                _loc_7.is_smoothed = this.use_smoothing_for_video_movieclip;
            }
            _loc_6.x = this.m_positions[idx].x;
            _loc_6.y = this.m_positions[idx].y;
            _loc_6.name = idx + idx;
            return this.m_layers[idx].addChild(_loc_6);
        }// end function

        public function useGameStopSnd() : void
        {
            var _loc_1:int = 0;
            this.m_stopSndBase = GameParameters.shortname;
            _loc_1 = 0;
            while (_loc_1 < this.m_numReels)
            {
                
                this.m_reelstops[_loc_1] = this.m_reelstops[_loc_1].replace(GameParameters.library, this.m_stopSndBase);
                _loc_1++;
            }
            return;
        }// end function

        public function dispose() : void
        {
            EventPool.removeEventListener(ReelSpinInfo.SPIN_START, this.spinStarted);
            EventPool.removeEventListener(ReelSpinInfo.SPIN_END, this.stopSpinSound);
            EventPool.removeEventListener(ReelSpinInfo.REEL_END, this.showAnimation);
            EventPool.removeEventListener(ReelSpinInfo.REEL_END_SND, this.playReelStop);
            EventPool.removeEventListener(ReelSpinInfo.REEL_STOP_START, this.checkSound);
            if (this.m_stopSyms != null)
            {
                this.disposeStopSyms();
            }
            this.m_reelstops = null;
            this.m_positions = null;
            this.m_layers = null;
            this.m_mi = null;
            this.m_base = null;
            this.m_movies = null;
            return;
        }// end function

        public function useStopSounds(__AS3__.vec:Vector.<String>) : void
        {
            if (__AS3__.vec == null || __AS3__.vec.length != this.m_numReels)
            {
                this.defaultStopSounds();
            }
            else
            {
                this.m_reelstops = __AS3__.vec;
            }
            return;
        }// end function

        protected function resultsFoundForReel(__AS3__.vec:int, __AS3__.vec:Vector.<ReelStopResult>, __AS3__.vec:Boolean = true) : void
        {
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:ReelStopResult = null;
            var _loc_8:Wins = null;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_4:* = __AS3__.vec.length;
            _loc_8 = this.m_base.getRoundInfo().wins;
            var _loc_9:* = _loc_8.length;
            if (_loc_4 > 1)
            {
                _loc_10 = 0;
                while (_loc_10 < _loc_4)
                {
                    
                    _loc_7 = __AS3__.vec[_loc_10];
                    _loc_11 = _loc_9 - 1;
                    while (_loc_11 > -1)
                    {
                        
                        if (_loc_8[_loc_11].win.symbol == _loc_7.symbol)
                        {
                            if (__AS3__.vec)
                            {
                                _loc_6 = "_" + __AS3__.vec;
                                _loc_5 = GameParameters.shortname + ".";
                                _loc_5 = _loc_5 + (_loc_7.rule.sound ? (_loc_7.rule.sound) : ("reelstop_" + _loc_7.symbol.type + _loc_6));
                                if (_loc_7.rule.sound && !ApplicationDomain.currentDomain.hasDefinition(_loc_5))
                                {
                                    _loc_5 = _loc_5 + _loc_6;
                                }
                                this.m_mi.playAsEffect(_loc_5);
                            }
                            if (_loc_7.video != null)
                            {
                                this.m_animName = _loc_7.video;
                                this.m_animIdx = _loc_7.index_in_reel;
                            }
                            return;
                        }
                        _loc_11 = _loc_11 - 1;
                    }
                    _loc_10++;
                }
            }
            _loc_7 = __AS3__.vec[0];
            if (__AS3__.vec)
            {
                _loc_6 = "_" + __AS3__.vec;
                _loc_5 = GameParameters.shortname + ".";
                _loc_5 = _loc_5 + (_loc_7.rule.sound ? (_loc_7.rule.sound) : ("reelstop_" + _loc_7.symbol.type + _loc_6));
                if (_loc_7.rule.sound && !ApplicationDomain.currentDomain.hasDefinition(_loc_5))
                {
                    _loc_5 = _loc_5 + _loc_6;
                }
                this.m_mi.playAsEffect(_loc_5);
            }
            if (_loc_7.video != null)
            {
                this.m_animName = _loc_7.video;
                this.m_animIdx = _loc_7.index_in_reel;
            }
            return;
        }// end function

        private function playStop(__AS3__.vec:int, __AS3__.vec:Boolean = true) : void
        {
            var _loc_4:int = 0;
            var _loc_8:int = 0;
            var _loc_9:SymbolReelStop = null;
            var _loc_10:Vector.<int> = null;
            var _loc_12:Boolean = false;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            this.realCountSoundStop(__AS3__.vec);
            this.m_animName = "";
            var _loc_3:* = this.m_stopSyms.length;
            var _loc_5:* = this.m_base.getRoundInfo();
            var _loc_6:* = _loc_5.reelSymbols.symbols;
            var _loc_7:* = new Vector.<ReelStopResult>;
            var _loc_11:int = 0;
            while (_loc_11 < _loc_3)
            {
                
                _loc_9 = this.m_stopSyms[_loc_11];
                if (_loc_9.is_real_count)
                {
                }
                else
                {
                    _loc_10 = _loc_6.indexesOfSymbolOnReel(_loc_9.symbol, __AS3__.vec);
                    _loc_8 = _loc_10 ? (_loc_10[0]) : (-1);
                    if (_loc_8 != -1)
                    {
                        if (_loc_9.onlyWin)
                        {
                            _loc_4 = _loc_5.wins.length;
                            _loc_14 = 0;
                            while (_loc_14 < _loc_4)
                            {
                                
                                if (_loc_5.wins[_loc_14].win.symbol == _loc_9.symbol)
                                {
                                    _loc_12 = true;
                                    break;
                                }
                                _loc_14++;
                            }
                            if (!_loc_12)
                            {
                                break;
                            }
                        }
                        if (_loc_9.mask[__AS3__.vec] == 0)
                        {
                            _loc_7.push(new ReelStopResult(_loc_9, __AS3__.vec, _loc_9.symbol, _loc_9.video, _loc_8));
                        }
                        else
                        {
                            _loc_13 = 0;
                            _loc_14 = 0;
                            while (_loc_14 < __AS3__.vec)
                            {
                                
                                if (_loc_6.reelContains(_loc_9.symbol, _loc_14))
                                {
                                    _loc_13++;
                                }
                                if (_loc_13 == _loc_9.mask[__AS3__.vec])
                                {
                                    _loc_7.push(new ReelStopResult(_loc_9, __AS3__.vec, _loc_9.symbol, _loc_9.video, _loc_8));
                                    break;
                                }
                                _loc_14++;
                            }
                        }
                    }
                }
                _loc_11++;
            }
            if (_loc_7.length > 0)
            {
                this.resultsFoundForReel(__AS3__.vec, _loc_7, __AS3__.vec);
            }
            else
            {
                this.noResultsFoundForReel(__AS3__.vec, __AS3__.vec);
            }
            return;
        }// end function

        private function showAnimation(event:RegularEvent) : void
        {
            var amination_complete_handler:Function;
            var play_movie:PlayMovie;
            var e:* = event;
            if (this.m_animName == null)
            {
                this.playStop(e.data[0], false);
            }
            if (this.m_animName != "")
            {
                amination_complete_handler = function () : void
            {
                var _loc_1:* = m_movies.indexOf(play_movie);
                if (_loc_1 != -1)
                {
                    m_movies.splice(_loc_1, 1);
                }
                if (!have_active_animations)
                {
                    EventPool.dispatchEvent(new Event(REEL_STOP_ANIMATION_ENDED));
                }
                return;
            }// end function
            ;
                play_movie = new PlayMovie(this.showMovie(this.m_animName, this.m_animIdx, LAYER_0) as MovieClip, true, 1, -1, amination_complete_handler);
                this.m_movies.push(play_movie);
            }
            this.m_animName = null;
            return;
        }// end function

        private function spinStarted(event:Event) : void
        {
            var _loc_2:Sprite = null;
            var _loc_3:Sprite = null;
            if (this.m_base.getState() != GameStates.STATE_FREESPIN)
            {
                this.m_activeSND = this.m_mi.playAsEffect(this.m_reelSndBase + ".SndReel" + this.currentId, null, 16777215);
            }
            if (this.m_layers[0].numChildren != 0)
            {
                _loc_2 = new Sprite();
                _loc_2.x = this.m_layers[0].x;
                _loc_2.y = this.m_layers[0].y;
                _loc_3 = this.m_layers[0].parent as Sprite;
                _loc_3.addChildAt(_loc_2, _loc_3.getChildIndex(this.m_layers[0]));
                _loc_3.removeChild(this.m_layers[0]);
                this.m_layers[0] = _loc_2;
            }
            this.m_movies = [];
            return;
        }// end function

        private function checkSound(event:RegularEvent) : void
        {
            var _loc_2:* = event.data[0];
            this._supressed_default_stop = this._supressed_default_stop & (4294967295 ^ 1 << _loc_2);
            if (this.m_isAnticipation)
            {
                if ((event.data[1] & ReelSpinInfo.ANTICIPATION_STOP) != ReelSpinInfo.ANTICIPATION_STOP)
                {
                    this.m_isAnticipation = false;
                    this.m_mi.stopSoundByID(this.m_activeSND);
                    this.m_activeSND = this.m_mi.playAsEffect(this.m_reelSndBase + ".SndReel" + this.currentId, null, 16777215);
                }
            }
            else if ((event.data[1] & ReelSpinInfo.ANTICIPATION_STOP) > 0)
            {
                this.m_isAnticipation = true;
                this.m_mi.stopSoundByID(this.m_activeSND);
                this.m_activeSND = this.m_mi.playAsEffect(GameParameters.library + ".SndAnticipation", null, 16777215);
            }
            return;
        }// end function

        public function suppresDefault(__AS3__.vec:int) : void
        {
            this._supressed_default_stop = this._supressed_default_stop | 1 << __AS3__.vec;
            return;
        }// end function

        private function disposeStopSyms() : void
        {
            var _loc_1:* = this.m_stopSyms.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                this.m_stopSyms[_loc_2].dispose();
                _loc_2++;
            }
            this.m_stopSyms = null;
            return;
        }// end function

    }
}
