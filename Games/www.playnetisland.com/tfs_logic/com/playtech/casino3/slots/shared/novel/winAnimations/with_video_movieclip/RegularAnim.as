package com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip.enum.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.utils.*;

    public class RegularAnim extends WinAnimBase
    {
        protected var m_movies:Vector.<MovieClip>;
        protected var timer_cycle_1:CommandTimer;
        protected var timer_cycle_2:CommandTimer;
        protected var fixedDuration:int = 0;
        protected const LINKAGE_PREFIX:String;
        protected const FRAME_MANE:String = "frame";
        public static var cycle_1_duration:int = 0;
        static var symbol_contaminated_indexes:Dictionary = new Dictionary();
        public static var cycle_1_duration_type:Cycle1Duration = Cycle1Duration.DURATION_OF_THE_SOUND;

        public function RegularAnim(param1:WinsNovel, param2:SlotsWin, param3:Vector.<int>, param4:Vector.<SlotsSymbol>, param5:SlotsPayline, param6:Object = null)
        {
            this.LINKAGE_PREFIX = GameParameters.shortname + ".";
            super(param1, param2, param3, param4, param5, param6);
            if (statusKey == null)
            {
                statusKey = "novel_linewin";
            }
            if (statusMap == null)
            {
                constructMap(this.Vector.<int>([L_ID, W, TW]));
            }
            this.timer_cycle_2 = new CommandTimer(760);
            this.fixedDuration = param6.duration ? (param6.duration) : (0);
            return;
        }// end function

        protected function replaceVideos() : void
        {
            var _loc_3:MovieClip = null;
            var _loc_4:VideoMovieClip = null;
            var _loc_5:String = null;
            var _loc_6:Class = null;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_10:SlotsSymbol = null;
            var _loc_11:String = null;
            var _loc_12:Boolean = false;
            if (!this.m_movies)
            {
                return;
            }
            var _loc_1:int = 0;
            var _loc_2:* = winsAnimator.m_bottom;
            var _loc_9:* = this.m_movies.length;
            _loc_8 = 0;
            while (_loc_8 < _loc_9)
            {
                
                _loc_12 = false;
                _loc_10 = symbols[_loc_8];
                _loc_3 = this.m_movies[_loc_8];
                _loc_4 = _loc_3 as VideoMovieClip;
                if (_loc_3 && !_loc_4)
                {
                    _loc_3.visible = true;
                }
                else
                {
                    if (!_loc_4)
                    {
                        _loc_4 = this.createVideo(_loc_8) as VideoMovieClip;
                        _loc_2.addChild(_loc_4);
                    }
                    _loc_5 = this.getLinkage(_loc_8);
                    _loc_5 = this.LINKAGE_PREFIX + _loc_5;
                    _loc_11 = frames_sufixes ? (frames_sufixes[_loc_8]) : (null);
                    if (_loc_11 || _loc_11 == "")
                    {
                        _loc_5 = null;
                    }
                    if (_loc_4.linkage != _loc_5)
                    {
                        _loc_4.linkage = _loc_5;
                    }
                    _loc_4.visible = true;
                }
                _loc_8++;
            }
            return;
        }// end function

        public function get has_custom_sound() : Boolean
        {
            return sound != null;
        }// end function

        protected function is_symbol_contaminated(W:SlotsSymbol, W:int) : Boolean
        {
            var _loc_3:* = symbol_contaminated_indexes[W] as Vector.<Boolean>;
            if (!_loc_3)
            {
                _loc_3 = this.createContaminationTableForSymbol(W);
            }
            return _loc_3[W];
        }// end function

        protected function hideFrames(int:Boolean = true) : void
        {
            var _loc_2:int = 0;
            var _loc_4:DisplayObject = null;
            if (!this.m_movies)
            {
                return;
            }
            var _loc_3:* = this.m_movies.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = this.m_movies[_loc_2].getChildByName(this.FRAME_MANE);
                if (!_loc_4)
                {
                }
                else
                {
                    _loc_4.visible = !int;
                    Console.write("**** " + _loc_4 + " ****", this);
                }
                _loc_2++;
            }
            return;
        }// end function

        protected function cycle1(indexes:String) : int
        {
            var _loc_2:int = 0;
            var _loc_3:* = cycle_1_duration_type == Cycle1Duration.CUSTOM_DURATION;
            if (_loc_3)
            {
                _loc_2 = cycle_1_duration;
            }
            else if (this.fixedDuration > 0)
            {
                _loc_3 = true;
                _loc_2 = this.fixedDuration;
            }
            return _loc_3 ? (this.wait(indexes, _loc_2)) : (this.playSound(indexes));
        }// end function

        protected function cycle2(indexes:String) : int
        {
            this.timer_cycle_2.execute(indexes);
            if (!winsAnimator.m_muted && winsAnimator.m_wins && winsAnimator.m_wins.length > 1)
            {
                winsAnimator.m_mi.playAsEffect("novel.line_toggle");
            }
            return 1;
        }// end function

        protected function wait(indexes:String, indexes:int) : int
        {
            Console.write("wait for " + indexes + " ms", this);
            this.timer_cycle_1 = new CommandTimer(indexes);
            return this.timer_cycle_1.execute(indexes);
        }// end function

        public function toString() : String
        {
            return "[RegularAnim] ";
        }// end function

        protected function getLinkage(getLinkage:int) : String
        {
            var _loc_2:String = null;
            var _loc_3:SlotsSymbol = null;
            var _loc_5:Boolean = false;
            var _loc_4:* = symbolIndexes[getLinkage];
            _loc_3 = symbols[getLinkage];
            _loc_2 = video != null && _loc_3.type == slotswin.symbol.type ? (video) : (winsAnimator.VIDEO + _loc_3.type);
            if (BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE)
            {
                _loc_2 = BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE + "." + _loc_2;
            }
            if (_loc_3.winvideo != null)
            {
                _loc_5 = this.is_symbol_contaminated(_loc_3, _loc_4);
                if (!_loc_5 && _loc_3.type != slotswin.symbol.type)
                {
                    _loc_2 = _loc_3.winvideo;
                }
                if (_loc_5)
                {
                    _loc_2 = _loc_3.winvideo ? (_loc_3.winvideo) : (winsAnimator.VIDEO + _loc_3.type);
                }
            }
            var _loc_6:* = frames_sufixes ? (frames_sufixes[getLinkage]) : (null);
            if (_loc_6 || _loc_6 == "")
            {
                _loc_2 = null;
            }
            return _loc_2;
        }// end function

        public function hideShowVideos(int:Boolean = true) : void
        {
            var _loc_3:int = 0;
            var _loc_2:* = this.m_movies.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                this.m_movies[_loc_3].visible = !int;
                _loc_3++;
            }
            return;
        }// end function

        override public function addVideos(int:Array, int:int) : void
        {
            var _loc_3:int = 0;
            var _loc_5:MovieClip = null;
            var _loc_6:int = 0;
            var _loc_4:* = symbolIndexes.length;
            var _loc_7:int = 0;
            this.m_movies = new Vector.<MovieClip>;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_6 = symbolIndexes[_loc_3];
                _loc_5 = int[_loc_6];
                if (!_loc_5)
                {
                    _loc_5 = this.createVideo(_loc_3);
                    int[_loc_6] = _loc_5;
                }
                if (_loc_5 is VideoMovieClip)
                {
                    _loc_5.linkage = this.LINKAGE_PREFIX + this.getLinkage(_loc_3);
                }
                this.m_movies[++_loc_7] = _loc_5;
                _loc_3++;
            }
            this.hideShowVideos(false);
            return;
        }// end function

        protected function createVideo(com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip:int) : MovieClip
        {
            var _loc_2:* = symbols[com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip];
            var _loc_3:* = symbolIndexes[com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip];
            return winsAnimator.createVideo(this.getLinkage(com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip), _loc_3, _loc_2.useBg) as MovieClip;
        }// end function

        protected function animate(indexes:String) : int
        {
            var _loc_2:int = 0;
            var _loc_3:* = this.m_movies.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                this.m_movies[_loc_2].play();
                _loc_2++;
            }
            return 0;
        }// end function

        protected function stopMovieClips() : void
        {
            var _loc_1:int = 0;
            if (!this.m_movies)
            {
                return;
            }
            var _loc_2:* = this.m_movies.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                this.m_movies[_loc_1].stop();
                _loc_1++;
            }
            return;
        }// end function

        protected function createContaminationTableForSymbol(TW:SlotsSymbol) : Vector.<Boolean>
        {
            var _loc_2:Vector.<WinAnimBase> = null;
            var _loc_3:WinAnimBase = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:Vector.<int> = null;
            var _loc_9:Vector.<int> = null;
            var _loc_10:Vector.<SlotsSymbol> = null;
            var _loc_11:Vector.<Boolean> = null;
            var _loc_13:int = 0;
            var _loc_15:int = 0;
            _loc_2 = winsAnimator.m_wins;
            var _loc_4:* = _loc_2.length;
            _loc_11 = new Vector.<Boolean>(GameParameters.numRows * GameParameters.numReels, true);
            symbol_contaminated_indexes[TW] = _loc_11;
            var _loc_12:* = new Vector.<WinAnimBase>;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3 = _loc_2[_loc_5];
                if (_loc_3.slotswin.symbol != TW)
                {
                    _loc_12.push(_loc_3);
                }
                else if (!_loc_3.slotswin.isLineSpecific)
                {
                }
                else
                {
                    _loc_8 = _loc_3.symbolIndexes;
                    _loc_10 = _loc_3.symbols;
                    _loc_7 = _loc_8.length;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_7)
                    {
                        
                        if (_loc_10[_loc_6] == TW)
                        {
                            _loc_11[_loc_8[_loc_6]] = true;
                        }
                        _loc_6++;
                    }
                }
                _loc_5++;
            }
            var _loc_14:Boolean = true;
            while (_loc_14)
            {
                
                _loc_14 = false;
                _loc_13 = _loc_12.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_13)
                {
                    
                    _loc_3 = _loc_12[_loc_5];
                    _loc_9 = _loc_3.symbolIndexes;
                    _loc_10 = _loc_3.symbols;
                    _loc_7 = _loc_9.length;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_7)
                    {
                        
                        if (_loc_10[_loc_6] == TW && _loc_11[_loc_9[_loc_6]])
                        {
                            _loc_15 = 0;
                            while (_loc_15 < _loc_7)
                            {
                                
                                if (_loc_10[_loc_15] == TW)
                                {
                                    _loc_11[_loc_9[_loc_15]] = true;
                                }
                                _loc_15++;
                            }
                            _loc_12.splice(_loc_5, 1);
                            _loc_14 = true;
                            break;
                        }
                        _loc_6++;
                    }
                    _loc_5++;
                }
            }
            return _loc_11;
        }// end function

        protected function get substitute_symbol_sound() : String
        {
            var _loc_1:int = 0;
            var _loc_3:SlotsSymbol = null;
            var _loc_2:* = symbols.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                _loc_3 = symbols[_loc_1] as SlotsSymbol;
                if (_loc_3.winsound != null)
                {
                    return _loc_3.winsound;
                }
                _loc_1++;
            }
            return null;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            if (this.timer_cycle_1)
            {
                this.timer_cycle_1.clear();
            }
            if (this.timer_cycle_2)
            {
                this.timer_cycle_2.clear();
            }
            this.stopMovieClips();
            this.timer_cycle_2 = null;
            this.timer_cycle_1 = null;
            this.m_movies = null;
            symbol_contaminated_indexes = new Dictionary();
            return;
        }// end function

        override public function cancelAnimation() : void
        {
            this.timer_cycle_2.cancel();
            this.stopMovieClips();
            return;
        }// end function

        override public function activate(indexes:int, indexes:String) : int
        {
            var _loc_3:int = 0;
            var _loc_5:int = 0;
            var _loc_7:String = null;
            var _loc_8:SlotsSymbol = null;
            winsAnimator.deactivatePrevWin();
            if (indexes == WinsNovel.PHASE_1)
            {
                this.replaceVideos();
            }
            if (payline)
            {
                _loc_3 = payline.id;
                winsAnimator.showLine(_loc_3, true);
                _loc_3++;
            }
            var _loc_4:* = new Vector.<String>;
            var _loc_6:* = symbolIndexes.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_6)
            {
                
                _loc_8 = symbols[_loc_5] as SlotsSymbol;
                _loc_7 = _loc_8.frameSuf;
                if (!_loc_7 && frames_sufixes)
                {
                    _loc_7 = frames_sufixes[_loc_5];
                }
                _loc_4[_loc_5] = _loc_7;
                _loc_5++;
            }
            winsAnimator.videosToTop(symbolIndexes, _loc_3, _loc_4);
            return indexes == WinsNovel.PHASE_1 ? (this.cycle1(indexes)) : (this.cycle2(indexes));
        }// end function

        override public function deactivate() : void
        {
            winsAnimator.videosToBottom();
            if (payline)
            {
                winsAnimator.showLine(payline.id, false);
            }
            return;
        }// end function

        public function get non_generic_sound() : String
        {
            var _loc_1:* = sound != null ? (sound) : (this.substitute_symbol_sound);
            _loc_1 = _loc_1 == null ? (null) : (this.LINKAGE_PREFIX + _loc_1);
            return _loc_1;
        }// end function

        protected function playSound(indexes:String) : int
        {
            var _loc_2:* = this.non_generic_sound;
            if (_loc_2 == null)
            {
                _loc_2 = winsAnimator.getGenericSound(slotswin.win);
            }
            var _loc_3:* = winsAnimator.playSound(_loc_2, indexes, force_sound);
            if (_loc_3 == -1)
            {
                Console.write("Warninig RegularAnim.playSound " + _loc_2 + "  was not found , default waiting time will be used instead !!!");
                _loc_3 = this.wait(indexes, cycle_1_duration);
            }
            return _loc_3;
        }// end function

    }
}
