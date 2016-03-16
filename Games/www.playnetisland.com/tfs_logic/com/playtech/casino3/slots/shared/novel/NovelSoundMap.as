package com.playtech.casino3.slots.shared.novel
{
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;

    public class NovelSoundMap extends Object
    {
        public static var SOUND_CLICK_TO_START:String;
        public static var SOUND_WIN_MID_HIGH:String;
        public static var SOUND_WIN_MID_LOW:String;
        public static var SOUND_STOP:String;
        public static var SOUND_WIN_HIGH:String;
        public static var FREESPIN_WIN_INCREASE:String;
        public static var SOUND_SPIN:String;
        public static var SOUND_WIN_LOW:String;
        public static var SOUND_WIN_TOP:String;
        public static var CELEBRATION_WIN_INCREASE_END:String;
        public static var NORMAL_WIN_INCREASE_END:String;
        public static var CELEBRATION_WIN_INCREASE:String;
        public static var NORMAL_WIN_INCREASE:String;
        public static var FREESPIN_WIN_INCREASE_END:String;

        public function NovelSoundMap()
        {
            return;
        }// end function

        public static function resetParameters() : void
        {
            var _loc_1:* = GameParameters.sound_library;
            if (!_loc_1)
            {
                _loc_1 = GameParameters.library;
            }
            if (!_loc_1)
            {
                _loc_1 = GameParameters.shortname;
            }
            _loc_1 = _loc_1 + ".";
            SOUND_SPIN = _loc_1 + NovelSoundEnum.SOUND_SPIN;
            SOUND_STOP = _loc_1 + NovelSoundEnum.SOUND_DEFAULT;
            SOUND_CLICK_TO_START = _loc_1 + NovelSoundEnum.SOUND_DEFAULT;
            SOUND_WIN_LOW = _loc_1 + NovelSoundEnum.SOUND_WIN_LOW;
            SOUND_WIN_MID_LOW = _loc_1 + NovelSoundEnum.SOUND_WIN_MID_LOW;
            SOUND_WIN_MID_HIGH = _loc_1 + NovelSoundEnum.SOUND_WIN_MID_HIGH;
            SOUND_WIN_HIGH = _loc_1 + NovelSoundEnum.SOUND_WIN_HIGH;
            SOUND_WIN_TOP = _loc_1 + NovelSoundEnum.SOUND_WIN_TOP;
            NORMAL_WIN_INCREASE = _loc_1 + NovelSoundEnum.NORMAL_WIN_INCREASE;
            FREESPIN_WIN_INCREASE = _loc_1 + NovelSoundEnum.FREESPIN_WIN_INCREASE;
            NORMAL_WIN_INCREASE_END = _loc_1 + NovelSoundEnum.NORMAL_WIN_INCREASE_END;
            FREESPIN_WIN_INCREASE_END = _loc_1 + NovelSoundEnum.FREESPIN_WIN_INCREASE_END;
            _loc_1 = GameParameters.celebration_sound_library;
            if (!_loc_1)
            {
                _loc_1 = GameParameters.library;
            }
            if (!_loc_1)
            {
                _loc_1 = GameParameters.shortname;
            }
            _loc_1 = _loc_1 + ".";
            CELEBRATION_WIN_INCREASE = _loc_1 + NovelSoundEnum.CELEBRATION_WIN_INCREASE;
            CELEBRATION_WIN_INCREASE_END = _loc_1 + NovelSoundEnum.CELEBRATION_WIN_INCREASE_END;
            return;
        }// end function

    }
}
