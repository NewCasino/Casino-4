package com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.display.*;

    public class FreespinsOutro extends FeatureResultWindow
    {

        public function FreespinsOutro(param1:IModuleInterface, param2:Sprite, param3:Number, param4:Number, param5:WindowParameters = null)
        {
            var _loc_6:WindowParameters = null;
            if (param5 != null)
            {
                _loc_6 = param5;
            }
            else
            {
                _loc_6 = GetWindowParameters.freespinOutro();
            }
            var _loc_7:* = new Vector.<FeatureResultValue>;
            _loc_7.push(new FeatureResultValue("bonus", param3));
            _loc_7.push(new FeatureResultValue("fs", param4));
            _loc_7.push(new FeatureResultValue("total", param3 + param4));
            super(param1, param2, _loc_7, _loc_6);
            return;
        }// end function

        override protected function middleActions() : void
        {
            super.middleActions();
            m_queue.add(new CommandFunction(m_mi.playAsEffect, GameParameters.shortname + ".FS_outro_snd", SND_SOURCE));
            return;
        }// end function

    }
}
