package com.playtech.casino3.slots.top_trumps_stars.wins.anims
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.with_video_movieclip.*;
    import com.playtech.casino3.slots.top_trumps_stars.slot_symbols.*;
    import flash.display.*;
    import flash.utils.*;

    public class ThemeAnim extends RegularAnim
    {

        public function ThemeAnim(com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim:WinsNovel, com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim:SlotsWin, com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim:Vector.<int>, com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim:Vector.<SlotsSymbol>, com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim:SlotsPayline, com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim:Object = null) : void
        {
            super(com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim, com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim, com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim, com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim, com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim, com.playtech.casino3.slots.top_trumps_stars.wins.anims:ThemeAnim);
            return;
        }// end function

        override protected function createVideo(index:int) : MovieClip
        {
            var _loc_2:* = symbols[index] as GameSpecificSlotSymbol;
            if (!_loc_2.is_from_team_1 && !_loc_2.is_from_team_2)
            {
                return super.createVideo(index);
            }
            var _loc_3:* = symbolIndexes[index];
            var _loc_4:* = getDefinitionByName(LINKAGE_PREFIX + _loc_2.image) as Class;
            var _loc_5:* = new _loc_4;
            var _loc_6:* = winsAnimator.com.playtech.casino3.slots.shared.novel.winAnimations:wins_animator::createVideo(getLinkage(index), _loc_3, _loc_2.useBg);
            _loc_6.addChildAt(_loc_5, 1);
            _loc_6.bgIndex = _loc_3;
            return _loc_6;
        }// end function

    }
}
