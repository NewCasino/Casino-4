package com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.*;
    import flash.display.*;

    public class BonusAnim extends RegularAnim
    {
        private var m_shortAnim:RegularAnim;

        public function BonusAnim(param1:WinsNovel, param2:SlotsWin, param3:Vector.<int>, param4:Vector.<SlotsSymbol>, param5:SlotsPayline, param6:Object = null)
        {
            super(param1, param2, param3, param4, param5, param6);
            return;
        }// end function

        override public function isBlockingToggle() : Boolean
        {
            return true;
        }// end function

        override public function deactivate() : void
        {
            if (this.m_shortAnim)
            {
                this.m_shortAnim.deactivate();
            }
            stopMovieClips();
            return;
        }// end function

        override public function addVideos(com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip:BonusAnim/BonusAnim:Array, com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip:BonusAnim/BonusAnim:int) : void
        {
            return;
        }// end function

        override public function activate(animator:int, animator:String) : int
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:MovieClip = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            if (animator == WinsNovel.PHASE_1)
            {
                winsAnimator.m_mi.updateStatusBar(statusKey, statusMap);
                winsAnimator.clear();
                _loc_3 = symbolIndexes.length;
                m_movies = new Vector.<MovieClip>(_loc_3);
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_5 = symbolIndexes[_loc_4];
                    _loc_6 = m_movies[_loc_4];
                    _loc_8 = LINKAGE_PREFIX + video ? (video) : (getLinkage(_loc_4));
                    if (_loc_6)
                    {
                        _loc_6.linkage = _loc_8;
                    }
                    else
                    {
                        _loc_6 = winsAnimator.createVideo(_loc_8, _loc_5, symbols[_loc_4]);
                        m_movies[_loc_4] = _loc_6;
                        winsAnimator.m_bottom.addChild(_loc_6);
                    }
                    _loc_4++;
                }
                winsAnimator.videosToTop(symbolIndexes, slotswin.frameId);
                _loc_7 = sound != null ? (winsAnimator.m_sn + "." + sound) : (winsAnimator.getGenericSound(slotswin.win));
                return winsAnimator.playSound(_loc_7, animator, force_sound);
            }
            if (!this.m_shortAnim)
            {
                this.m_shortAnim = new RegularAnim(winsAnimator, slotswin, symbolIndexes, symbols, payline, {statusMap:new Vector.<int>});
            }
            this.m_shortAnim.activate(animator, animator);
            return 1;
        }// end function

        override public function dispose() : void
        {
            if (!this.m_shortAnim)
            {
                return;
            }
            super.dispose();
            this.m_shortAnim.dispose();
            this.m_shortAnim = null;
            return;
        }// end function

    }
}
