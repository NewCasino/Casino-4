package com.playtech.casino3.slots.top_trumps_stars
{
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.utils.button.*;
    import flash.display.*;

    public class Lines extends LinesNovel
    {

        public function Lines(com.playtech.casino3.slots.top_trumps_stars:Lines:DisplayObjectContainer) : void
        {
            super(com.playtech.casino3.slots.top_trumps_stars:Lines);
            return;
        }// end function

        override public function showLine(com.playtech.casino3.slots.top_trumps_stars:Lines:int, com.playtech.casino3.slots.top_trumps_stars:Lines:Boolean, com.playtech.casino3.slots.top_trumps_stars:Lines:int) : void
        {
            var _loc_4:IButton = null;
            var _loc_5:IButton = null;
            super.showLine(com.playtech.casino3.slots.top_trumps_stars:Lines, com.playtech.casino3.slots.top_trumps_stars:Lines, com.playtech.casino3.slots.top_trumps_stars:Lines);
            if (com.playtech.casino3.slots.top_trumps_stars:Lines == LineShowInfo.HIGHLIGHTED)
            {
                if (m_highlight != null)
                {
                    if (com.playtech.casino3.slots.top_trumps_stars:Lines)
                    {
                        m_highlight.x = m_buttons[com.playtech.casino3.slots.top_trumps_stars:Lines].x;
                        m_highlight.y = m_buttons[com.playtech.casino3.slots.top_trumps_stars:Lines].y;
                    }
                    m_highlight.visible = com.playtech.casino3.slots.top_trumps_stars:Lines;
                }
                else
                {
                    _loc_4 = m_buttons[com.playtech.casino3.slots.top_trumps_stars:Lines].getLogic() as IButton;
                    if (m_buttons[com.playtech.casino3.slots.top_trumps_stars:Lines + m_lines.length])
                    {
                        _loc_5 = m_buttons[com.playtech.casino3.slots.top_trumps_stars:Lines + m_lines.length].getLogic() as IButton;
                    }
                    if (com.playtech.casino3.slots.top_trumps_stars:Lines)
                    {
                        _loc_4.gotoFrame(ButtonState.STATE_OVER);
                        _loc_4.registerOverOutHandler(_loc_4.gotoFrame, ButtonState.STATE_OVER);
                        if (_loc_5)
                        {
                            _loc_5.gotoFrame(ButtonState.STATE_OVER);
                            _loc_5.registerOverOutHandler(_loc_4.gotoFrame, ButtonState.STATE_OVER);
                        }
                    }
                    else
                    {
                        if (!_loc_4.isMouseOnButton())
                        {
                            _loc_4.gotoFrame(ButtonState.STATE_NORMAL);
                            if (_loc_5)
                            {
                                _loc_5.gotoFrame(ButtonState.STATE_NORMAL);
                            }
                        }
                        _loc_4.registerOverOutHandler(null);
                        if (_loc_5)
                        {
                            _loc_5.registerOverOutHandler(null);
                        }
                    }
                }
            }
            return;
        }// end function

        override protected function initButtons() : void
        {
            var _loc_2:DisplayObject = null;
            var _loc_4:DisplayObject = null;
            var _loc_1:Array = [];
            var _loc_3:int = 0;
            while (_loc_3 < m_maxLines)
            {
                
                m_buttons.push(m_gfx.getChildByName(GameButtons.LINE_BUTTON + "_" + _loc_3));
                _loc_2 = m_gfx.getChildByName(GameButtons.LINE_BUTTON + "_" + _loc_3 + "_1");
                if (_loc_2)
                {
                    _loc_1.push(_loc_2);
                }
                _loc_3++;
            }
            for each (_loc_4 in _loc_1)
            {
                
                m_buttons.push(_loc_4);
            }
            return;
        }// end function

        override protected function set_button_selected(com.playtech.casino3.slots.top_trumps_stars:Lines:int, com.playtech.casino3.slots.top_trumps_stars:Lines:Boolean) : void
        {
            m_buttons[com.playtech.casino3.slots.top_trumps_stars:Lines].getLogic().select(com.playtech.casino3.slots.top_trumps_stars:Lines);
            if (m_buttons[com.playtech.casino3.slots.top_trumps_stars:Lines + m_maxLines])
            {
                m_buttons[com.playtech.casino3.slots.top_trumps_stars:Lines + m_maxLines].getLogic().select(com.playtech.casino3.slots.top_trumps_stars:Lines);
            }
            return;
        }// end function

    }
}
