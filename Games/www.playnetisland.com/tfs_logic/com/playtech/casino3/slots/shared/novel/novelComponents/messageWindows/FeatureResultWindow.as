package com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows
{
    import __AS3__.vec.*;
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.novelCmd.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.display.*;
    import flash.system.*;
    import flash.text.*;

    public class FeatureResultWindow extends MessageWindow
    {
        private var m_tickSnd:String;
        private var m_results:Vector.<FeatureResultValue>;
        static const SND_SOURCE:String = "FeatureResultWindow";
        static const TICK_TIME:int = 1250;

        public function FeatureResultWindow(param1:IModuleInterface, param2:Sprite, param3:Vector.<FeatureResultValue>, param4:WindowParameters = null)
        {
            super(param1, param2, param4);
            this.m_results = param3;
            this.m_tickSnd = GameParameters.shortname + ".feature_result_increase";
            if (!ApplicationDomain.currentDomain.hasDefinition(this.m_tickSnd))
            {
                this.m_tickSnd = GameParameters.library + ".fs_increase";
            }
            return;
        }// end function

        override protected function middleActionsSkipped() : void
        {
            m_mi.stopSoundsBySource(SND_SOURCE);
            return;
        }// end function

        override public function dispose() : void
        {
            this.m_results = null;
            super.dispose();
            return;
        }// end function

        override protected function middleActions() : void
        {
            var _loc_2:TextField = null;
            var _loc_3:Boolean = false;
            var _loc_1:* = this.m_results.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_1)
            {
                
                if (this.m_results[_loc_4].isTicking)
                {
                    _loc_2 = TextField(m_panel.getChildByName(this.m_results[_loc_4].textfield));
                    if (_loc_2 != null)
                    {
                        if (!_loc_3)
                        {
                            _loc_3 = true;
                            m_queue.add(new CommandFunction(m_mi.playAsEffect, this.m_tickSnd, SND_SOURCE, 16777215));
                        }
                        m_queue.add(new WinTickerCmd(_loc_2, 0, this.m_results[_loc_4].total, this.m_results[_loc_4].total * 1000 / TICK_TIME, 1, this.m_results[_loc_4].moneyFormat));
                    }
                }
                _loc_4++;
            }
            m_queue.add(new CommandFunction(m_mi.stopSoundsBySource, SND_SOURCE));
            return;
        }// end function

        override protected function beforeWindow() : void
        {
            var _loc_2:TextField = null;
            var _loc_1:* = this.m_results.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_1)
            {
                
                if (!this.m_results[_loc_3].isTicking)
                {
                    _loc_2 = TextField(m_panel.getChildByName(this.m_results[_loc_3].textfield));
                    if (_loc_2 != null)
                    {
                        _loc_2.text = this.m_results[_loc_3].moneyFormat ? (Money.format(this.m_results[_loc_3].total)) : (this.m_results[_loc_3].total.toString());
                    }
                }
                _loc_3++;
            }
            return;
        }// end function

    }
}
