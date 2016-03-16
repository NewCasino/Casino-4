package com.playtech.casino3.slots.shared.novel.winAnimations
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.slots.shared.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;

    public class WinsNovel extends Object implements IWinsAnimator
    {
        var m_top:Sprite;
        var m_roundInfo:RoundInfo;
        public var use_video_movieclip:Boolean = false;
        var m_positions:Vector.<Point>;
        var m_muted:Boolean;
        private var m_activeWin:WinAnimBase;
        var m_wins:Vector.<WinAnimBase>;
        var m_activeLine:int;
        var m_mi:IModuleInterface;
        private var m_activeSnd:int;
        private var m_queueIdOut:String;
        var m_frames:Array;
        public var get_background_from:MovieClip = null;
        var m_bottom:Sprite;
        private var m_queue:CommandQueue;
        var m_background:String;
        private var m_winLimits:Vector.<int>;
        public var use_smoothing_for_video_movieclip:Boolean = false;
        var m_lineManager:LinesBase;
        var m_linebet:Number;
        private const FRAME:String = "frame";
        public var solid_color:Object = null;
        private var m_noTexts:Boolean;
        private var m_prevWin:WinAnimBase;
        const VIDEO:String = "video";
        var m_base:Sprite;
        var m_sn:String;
        private var m_topDepths:Array;
        private var m_running:Boolean;
        private var m_topIndexes:Vector.<int>;
        private var m_queueIdIn:String;
        public static const PHASE_2:int = 1;
        public static var width:int = 140;
        public static var height:int = 134;
        public static const PHASE_1:int = 0;

        public function WinsNovel(param1:IModuleInterface, param2:Sprite, param3:Vector.<Point>, param4:LinesBase)
        {
            width = 140;
            height = 134;
            this.m_mi = param1;
            this.m_base = param2;
            var _loc_5:* = param2.getChildByName("linesContainer") as Sprite;
            var _loc_6:* = param2.getChildIndex(_loc_5);
            this.m_top = param2.getChildByName("videosTop") as Sprite;
            if (this.m_top == null)
            {
                this.m_top = new Sprite();
                param2.addChildAt(this.m_top, (_loc_6 + 1));
            }
            this.m_top.x = _loc_5.x;
            this.m_top.y = _loc_5.y;
            this.m_top.mouseChildren = false;
            this.m_top.mouseEnabled = false;
            this.m_bottom = new Sprite();
            this.m_bottom.x = _loc_5.x;
            this.m_bottom.y = _loc_5.y;
            this.m_bottom.mouseChildren = false;
            this.m_bottom.mouseEnabled = false;
            param2.addChildAt(this.m_bottom, _loc_6);
            this.localPoints(param3);
            this.m_sn = GameParameters.shortname;
            this.m_queue = new CommandQueue(param2.stage);
            this.m_lineManager = param4;
            this.m_frames = [];
            this.m_winLimits = NovelParameters.winLimits;
            this.m_activeSnd = -1;
            this.m_activeLine = -1;
            this.m_background = "animBg";
            EventPool.addEventListener(GameStates.EVENT_RESET_All, this.resetAll);
            return;
        }// end function

        public function setRoundInfoObj(animBg:RoundInfo) : void
        {
            this.m_roundInfo = animBg;
            return;
        }// end function

        function addBackgroundToVideo(animBg:MovieClip, animBg:int) : void
        {
            var _loc_3:* = GameParameters.shortname + "." + this.m_background + animBg;
            var _loc_4:Class = null;
            if (ApplicationDomain.currentDomain.hasDefinition(_loc_3))
            {
                _loc_4 = getDefinitionByName(_loc_3) as Class;
            }
            var _loc_5:* = _loc_4 ? (new _loc_4) : (this.getDymanicBackgroundForVideo(animBg));
            animBg.addChildAt(_loc_5, 0);
            animBg.bgIndex = animBg;
            return;
        }// end function

        private function changeBg(animBg:Sprite) : void
        {
            var index:int;
            var video:MovieClip;
            var background_class:Class;
            var background:DisplayObject;
            var container:* = animBg;
            var length:* = container.numChildren;
            index;
            while (index < length)
            {
                
                video = container.getChildAt(index) as MovieClip;
                if (video.bgIndex == null)
                {
                }
                else
                {
                    background_class;
                    try
                    {
                        background_class = getDefinitionByName(this.m_sn + "." + this.m_background + video.bgIndex) as Class;
                    }
                    catch (error:Error)
                    {
                    }
                    background = background_class ? (new background_class) : (this.getDymanicBackgroundForVideo(video));
                    video.removeChildAt(0);
                    video.addChildAt(background, 0);
                }
                index = (index + 1);
            }
            return;
        }// end function

        function addVideosToBottom(animBg:Vector.<DisplayObject>) : void
        {
            var _loc_3:int = 0;
            var _loc_5:MovieClip = null;
            var _loc_6:Sprite = null;
            var _loc_2:int = 0;
            var _loc_4:* = animBg.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_5 = animBg[_loc_3] as MovieClip;
                _loc_6 = _loc_5.getChildByName(this.FRAME + "Pos") as Sprite;
                if (_loc_6)
                {
                    this.m_bottom.addChild(_loc_5);
                }
                else
                {
                    this.m_bottom.addChildAt(_loc_5, _loc_2);
                }
                if (!_loc_6)
                {
                    _loc_2++;
                }
                _loc_3++;
            }
            return;
        }// end function

        function deactivatePrevWin() : void
        {
            if (this.m_prevWin != null)
            {
                this.m_prevWin.deactivate();
                this.m_prevWin = null;
            }
            return;
        }// end function

        public function dispose() : void
        {
            this.m_queue.dispose();
            EventPool.removeEventListener(GameStates.EVENT_RESET_All, this.resetAll);
            this.m_base = null;
            this.m_queue = null;
            this.m_top = null;
            this.m_bottom = null;
            this.m_positions = null;
            this.m_mi = null;
            this.m_wins = null;
            this.m_lineManager = null;
            this.m_frames = null;
            this.m_winLimits = null;
            this.m_roundInfo = null;
            this.m_topIndexes = null;
            this.m_topDepths = null;
            this.m_activeWin = null;
            this.m_prevWin = null;
            return;
        }// end function

        function showLine(animBg:int, animBg:Boolean) : void
        {
            this.m_lineManager.showLine(animBg, animBg, LineShowInfo.HIGHLIGHTED);
            if (!animBg)
            {
                this.m_activeLine = -1;
            }
            else
            {
                this.m_activeLine = animBg;
            }
            return;
        }// end function

        function videosToBottom() : void
        {
            var _loc_2:Sprite = null;
            if (!this.m_topIndexes)
            {
                return;
            }
            var _loc_1:* = this.m_topIndexes.length;
            var _loc_3:* = _loc_1 - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_2 = this.m_top.getChildByName(this.VIDEO + this.m_topIndexes[_loc_3]) as Sprite;
                if (!_loc_2)
                {
                }
                else
                {
                    _loc_2.removeChild(_loc_2.getChildByName(this.FRAME));
                }
                _loc_3 = _loc_3 - 1;
            }
            this.m_topIndexes = null;
            return;
        }// end function

        function animDone(animBg:String) : void
        {
            QueueEventManager.dispatchEvent(animBg);
            EventPool.dispatchEvent(new Event(WinAnimInfo.FST_TOGGLE_STOPPED));
            return;
        }// end function

        public function showWins(__AS3__.vec, __AS3__.vec:int, __AS3__.vec:String) : int
        {
            this.m_running = true;
            this.m_queueIdOut = __AS3__.vec;
            this.m_wins = this.Vector.<WinAnimBase>(__AS3__.vec);
            this.m_linebet = this.m_roundInfo.getLineBet();
            if (this.m_bottom.numChildren == 0 && this.m_top.numChildren == 0)
            {
                this.addAllVideos(__AS3__.vec);
            }
            this.activatePhase(__AS3__.vec);
            return 1;
        }// end function

        function getDymanicBackgroundForVideo(SOUND_WIN_MID_HIGH:DisplayObject) : Bitmap
        {
            var _loc_2:* = new Rectangle();
            _loc_2.topLeft = new Point((-width) / 2, (-height) / 2);
            _loc_2.bottomRight = new Point(width / 2, height / 2);
            _loc_2.offset(this.m_base.x, this.m_base.y);
            var _loc_3:* = this.get_background_from ? (this.get_background_from) : (this.m_base.getChildByName("reels"));
            _loc_2 = rectangleToFromCoordinateSpace(_loc_2, _loc_3, SOUND_WIN_MID_HIGH);
            _loc_2.offset(this.m_top.x, this.m_top.y);
            var _loc_4:* = getPartFromAsBitmap(_loc_2, _loc_3, false, false, 0);
            _loc_4.x = (-width) / 2;
            _loc_4.y = (-height) / 2;
            return _loc_4;
        }// end function

        public function hideTexts(animBg:Boolean) : void
        {
            this.m_noTexts = animBg;
            return;
        }// end function

        function playSound(__AS3__.vec:String, __AS3__.vec:String, __AS3__.vec:Boolean = false) : int
        {
            this.m_queueIdIn = __AS3__.vec;
            this.m_activeSnd = this.m_mi.playAsEffect(__AS3__.vec, null, 0, this.soundEnded);
            if (!__AS3__.vec && this.m_muted)
            {
                this.m_mi.muteSoundByID(this.m_activeSnd);
            }
            return this.m_activeSnd == -1 ? (0) : (1);
        }// end function

        private function localPoints(animBg:Vector.<Point>) : void
        {
            var _loc_2:int = 0;
            var _loc_4:Point = null;
            var _loc_3:* = animBg.length;
            this.m_positions = new Vector.<Point>(_loc_3, true);
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = animBg[_loc_2] as Point;
                this.m_positions[_loc_2] = this.m_bottom.globalToLocal(_loc_4);
                _loc_2++;
            }
            return;
        }// end function

        function clear(animBg:Boolean = false) : void
        {
            if (this.m_activeLine != -1)
            {
                this.showLine(this.m_activeLine, false);
            }
            this.clearContainer(this.m_bottom);
            this.clearContainer(this.m_top);
            this.m_noTexts = false;
            this.m_topIndexes = null;
            if (!animBg)
            {
                this.m_activeWin = null;
            }
            this.m_prevWin = null;
            return;
        }// end function

        public function stopAnim() : void
        {
            if (this.m_running)
            {
                this.m_queue.empty();
                this.m_mi.stopSoundByID(this.m_activeSnd);
                this.clear();
                EventPool.dispatchEvent(new Event(WinAnimInfo.ANIM_STOPPED));
                this.m_running = false;
            }
            return;
        }// end function

        private function clearContainer(animBg:Sprite) : void
        {
            var _loc_2:* = this.m_bottom == animBg;
            var _loc_3:* = new Sprite();
            _loc_3.x = animBg.x;
            _loc_3.y = animBg.y;
            var _loc_4:* = animBg.parent as Sprite;
            _loc_4.addChildAt(_loc_3, _loc_4.getChildIndex(animBg));
            _loc_4.removeChild(animBg);
            if (_loc_2)
            {
                this.m_bottom = _loc_3;
            }
            else
            {
                this.m_top = _loc_3;
            }
            return;
        }// end function

        private function resetAll(event:Event) : void
        {
            this.stopAnim();
            this.m_muted = false;
            return;
        }// end function

        function createVideo(CommandObject:String, CommandObject:int, CommandObject:Boolean = false) : MovieClip
        {
            var _loc_5:MovieClip = null;
            var _loc_7:Class = null;
            var _loc_4:* = GameParameters.shortname + "." + CommandObject;
            if (this.use_video_movieclip && CommandObject)
            {
                _loc_5 = new VideoMovieClip(_loc_4, width, height);
                _loc_5.is_smoothed = this.use_smoothing_for_video_movieclip;
            }
            else
            {
                if (CommandObject)
                {
                    _loc_7 = getDefinitionByName(_loc_4) as Class;
                }
                _loc_5 = CommandObject ? (new _loc_7 as MovieClip) : (new MovieClip());
            }
            var _loc_6:* = this.m_positions[CommandObject];
            _loc_5.x = _loc_6.x;
            _loc_5.y = _loc_6.y;
            _loc_5.name = this.VIDEO + CommandObject;
            _loc_5.videoName = CommandObject;
            if (CommandObject && CommandObject)
            {
                if (this.solid_color != null)
                {
                    if (_loc_5.numChildren == 1)
                    {
                        _loc_5.getChildAt(0).opaqueBackground = this.solid_color;
                    }
                }
                else
                {
                    this.addBackgroundToVideo(_loc_5, CommandObject);
                }
            }
            return _loc_5;
        }// end function

        private function activatePhase(animBg:int) : void
        {
            var _loc_3:int = 0;
            var _loc_2:* = this.m_wins.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                this.m_queue.add(new CommandFunction(this.focusWin, this.m_wins[_loc_3]), new CommandObject(this.m_wins[_loc_3].activate, animBg, this.m_wins[_loc_3].cancelAnimation));
                _loc_3++;
            }
            switch(animBg)
            {
                case PHASE_2:
                {
                    if (_loc_2 > 1)
                    {
                        this.m_queue.add(new CommandFunction(this.activatePhase, PHASE_2));
                    }
                    return;
                }
                case PHASE_1:
                {
                    this.m_queue.add(new CommandFunction(this.animDone, this.m_queueIdOut));
                    return;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        function addAllVideos(animBg:int) : void
        {
            var _loc_3:int = 0;
            var _loc_2:Array = [];
            var _loc_4:* = this.m_wins.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                this.m_wins[_loc_3].addVideos(_loc_2, animBg);
                _loc_3++;
            }
            _loc_4 = _loc_2.length;
            _loc_3 = _loc_4 - 1;
            while (_loc_3 >= 0)
            {
                
                if (_loc_2[_loc_3] == null)
                {
                    _loc_2.splice(_loc_3, 1);
                }
                _loc_3 = _loc_3 - 1;
            }
            _loc_2.sortOn(["y", "x"], Array.DESCENDING | Array.NUMERIC);
            this.addVideosToBottom(this.Vector.<DisplayObject>(_loc_2));
            return;
        }// end function

        function videosToTop(animBg:Vector.<int>, animBg:int, animBg:Vector.<String> = null) : void
        {
            var _loc_5:Class = null;
            var _loc_6:String = null;
            var _loc_7:Sprite = null;
            var _loc_8:Sprite = null;
            var _loc_9:Sprite = null;
            var _loc_12:String = null;
            this.m_topDepths = [];
            var _loc_4:* = animBg.length;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            while (_loc_11 < _loc_4)
            {
                
                _loc_7 = this.m_bottom.getChildByName(this.VIDEO + animBg[_loc_11]) as Sprite;
                if (!_loc_7)
                {
                }
                else
                {
                    if (animBg != null)
                    {
                        _loc_6 = animBg[_loc_11];
                    }
                    if (_loc_6 == null)
                    {
                        _loc_6 = "";
                    }
                    if (this.m_frames[animBg + _loc_6] == null)
                    {
                        if (animBg < 0)
                        {
                            _loc_5 = getDefinitionByName(this.m_sn + "." + this.FRAME + animBg * -1 + _loc_6) as Class;
                        }
                        else
                        {
                            if (animBg == 0 && _loc_6)
                            {
                                _loc_6 = "";
                            }
                            _loc_12 = GameParameters.shortname + "." + GameParameters.maxLines + this.FRAME + animBg + _loc_6;
                            _loc_12 = ApplicationDomain.currentDomain.hasDefinition(_loc_12) ? (_loc_12) : (GameParameters.library + "." + GameParameters.maxLines + this.FRAME + animBg + _loc_6);
                            _loc_5 = getDefinitionByName(_loc_12) as Class;
                        }
                        this.m_frames[animBg + _loc_6] = _loc_5;
                    }
                    else
                    {
                        _loc_5 = this.m_frames[animBg + _loc_6];
                    }
                    _loc_8 = new _loc_5;
                    if (_loc_8 is MovieClip)
                    {
                        MovieClip(_loc_8).stop();
                    }
                    _loc_8.name = this.FRAME;
                    _loc_8.cacheAsBitmap = true;
                    _loc_9 = _loc_7.getChildByName(this.FRAME + "Pos") as Sprite;
                    if (_loc_9 != null)
                    {
                        _loc_7.addChildAt(_loc_8, (_loc_7.getChildIndex(_loc_9) + 1));
                    }
                    else
                    {
                        _loc_7.addChild(_loc_8);
                    }
                    this.m_topDepths.push(this.m_bottom.getChildIndex(_loc_7));
                    if (_loc_9)
                    {
                        this.m_top.addChild(_loc_7);
                    }
                    else
                    {
                        this.m_top.addChildAt(_loc_7, _loc_10);
                    }
                    if (!_loc_9)
                    {
                        _loc_10++;
                    }
                }
                _loc_11++;
            }
            this.m_topIndexes = animBg;
            return;
        }// end function

        private function focusWin(animBg:WinAnimBase) : void
        {
            if (!this.m_noTexts && animBg.statusKey)
            {
                this.m_mi.updateStatusBar(animBg.statusKey, animBg.statusMap);
            }
            this.m_prevWin = this.m_activeWin;
            this.m_activeWin = animBg;
            return;
        }// end function

        function getGenericSound(Vector:Number) : String
        {
            if (Vector < this.m_winLimits[0] * this.m_linebet)
            {
                return NovelSoundMap.SOUND_WIN_LOW;
            }
            if (Vector < this.m_winLimits[1] * this.m_linebet)
            {
                return NovelSoundMap.SOUND_WIN_MID_LOW;
            }
            if (Vector < this.m_winLimits[2] * this.m_linebet)
            {
                return NovelSoundMap.SOUND_WIN_MID_HIGH;
            }
            if (Vector < this.m_winLimits[3] * this.m_linebet)
            {
                return NovelSoundMap.SOUND_WIN_HIGH;
            }
            return NovelSoundMap.SOUND_WIN_TOP;
        }// end function

        private function soundEnded(animBg:String, animBg:String) : void
        {
            QueueEventManager.dispatchEvent(this.m_queueIdIn);
            return;
        }// end function

        public function pause(animBg:Boolean = true) : void
        {
            this.m_muted = animBg;
            if (!animBg && this.m_activeLine != -1)
            {
                this.showLine(this.m_activeLine, true);
            }
            return;
        }// end function

        public function updateBackgrounds(animBg:String) : void
        {
            this.m_background = animBg;
            this.changeBg(this.m_bottom);
            this.changeBg(this.m_top);
            return;
        }// end function

    }
}
