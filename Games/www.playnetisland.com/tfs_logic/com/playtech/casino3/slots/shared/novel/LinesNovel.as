package com.playtech.casino3.slots.shared.novel
{
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.utils.button.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class LinesNovel extends LinesBase
    {
        protected var m_highlight:Sprite;
        private var cached_lines:Bitmap;
        private var cached_bitmap:BitmapData;
        private var m_isFading:Boolean;
        private var m_currentLines:Array;
        private var m_animId:String;
        private var m_queue:CommandQueue;

        public function LinesNovel(param1:DisplayObjectContainer)
        {
            super(param1);
            this.m_queue = new CommandQueue(m_gfx.stage);
            this.m_currentLines = [];
            this.m_highlight = m_gfx.getChildByName("highlight") as Sprite;
            if (this.m_highlight != null)
            {
                this.m_highlight.visible = false;
                this.m_highlight.mouseEnabled = false;
            }
            return;
        }// end function

        override protected function spinStarted(event:Event) : void
        {
            this.m_queue.empty();
            this.removeAllLines();
            return;
        }// end function

        private function startFade(LineShowInfo:String) : int
        {
            this.m_animId = LineShowInfo;
            m_innerLinesContainer.visible = false;
            var _loc_2:* = m_gfx.getChildByName("reels");
            this.cached_bitmap = new BitmapData(800, _loc_2.y + _loc_2.height, true, 16777215);
            var _loc_3:* = new Matrix();
            _loc_3.translate(0, -m_innerLinesContainer.y);
            this.cached_bitmap.draw(m_innerLinesContainer, _loc_3, null, null, null, true);
            this.cached_lines = new Bitmap(this.cached_bitmap, "auto", true);
            this.cached_lines.y = m_innerLinesContainer.y;
            m_linesConatiner.addChild(this.cached_lines);
            m_linesConatiner.addEventListener(Event.ENTER_FRAME, this.fadeAnim);
            return 1;
        }// end function

        override public function dispose() : void
        {
            this.m_queue.dispose();
            this.m_queue = null;
            this.candelFade();
            this.m_currentLines = null;
            this.m_highlight = null;
            this.cached_lines = null;
            if (this.cached_bitmap)
            {
                this.cached_bitmap.dispose();
            }
            this.cached_bitmap = null;
            super.dispose();
            return;
        }// end function

        override public function updateLineSelection(alpha:Array) : void
        {
            var _loc_3:int = 0;
            var _loc_2:* = alpha.length;
            m_innerLinesContainer.visible = true;
            if (this.m_isFading)
            {
                this.m_queue.empty();
                m_linesConatiner.alpha = 1;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    if (alpha[_loc_3] == -1 && this.m_currentLines[_loc_3] != -1)
                    {
                        this.showLine(_loc_3, false, LineShowInfo.NORMAL);
                        this.set_button_selected(_loc_3, false);
                    }
                    else if (alpha[_loc_3] != -1 && this.m_currentLines[_loc_3] == -1)
                    {
                        this.showLine(_loc_3, true, LineShowInfo.NORMAL);
                        this.set_button_selected(_loc_3, true);
                    }
                    else if (alpha[_loc_3] != -1)
                    {
                        this.set_button_selected(_loc_3, true);
                    }
                    _loc_3++;
                }
            }
            else
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    if (alpha[_loc_3] != -1)
                    {
                        this.showLine(_loc_3, true, LineShowInfo.NORMAL);
                        this.set_button_selected(_loc_3, true);
                    }
                    else
                    {
                        this.set_button_selected(_loc_3, false);
                    }
                    _loc_3++;
                }
                this.m_isFading = true;
            }
            this.m_currentLines = alpha.slice();
            this.m_queue.add(new CommandTimer(2000));
            this.m_queue.add(new CommandObject(this.startFade, null, this.candelFade));
            return;
        }// end function

        override public function showLine(alpha:int, alpha:Boolean, alpha:int) : void
        {
            var _loc_4:IButton = null;
            super.showLine(alpha, alpha, alpha);
            if (alpha == LineShowInfo.HIGHLIGHTED)
            {
                if (this.m_highlight != null)
                {
                    if (alpha)
                    {
                        this.m_highlight.x = m_buttons[alpha].x;
                        this.m_highlight.y = m_buttons[alpha].y;
                    }
                    this.m_highlight.visible = alpha;
                }
                else
                {
                    _loc_4 = m_buttons[alpha].getLogic() as IButton;
                    if (alpha)
                    {
                        _loc_4.gotoFrame(ButtonState.STATE_OVER);
                        _loc_4.registerOverOutHandler(_loc_4.gotoFrame, ButtonState.STATE_OVER);
                    }
                    else
                    {
                        if (!_loc_4.isMouseOnButton())
                        {
                            _loc_4.gotoFrame(ButtonState.STATE_NORMAL);
                        }
                        _loc_4.registerOverOutHandler(null);
                    }
                }
            }
            return;
        }// end function

        protected function set_button_selected(alpha:int, alpha:Boolean) : void
        {
            m_buttons[alpha].getLogic().select(alpha);
            return;
        }// end function

        private function fadeAnim(event:Event) : void
        {
            if (m_linesConatiner.alpha < 0.01)
            {
                this.candelFade();
                this.removeAllLines();
                QueueEventManager.dispatchEvent(this.m_animId);
            }
            else
            {
                m_linesConatiner.alpha = m_linesConatiner.alpha - 0.1;
            }
            return;
        }// end function

        private function candelFade() : void
        {
            this.m_isFading = false;
            if (this.cached_lines && m_linesConatiner.contains(this.cached_lines))
            {
                m_linesConatiner.removeChild(this.cached_lines);
            }
            m_linesConatiner.alpha = 1;
            m_innerLinesContainer.visible = true;
            m_linesConatiner.removeEventListener(Event.ENTER_FRAME, this.fadeAnim);
            return;
        }// end function

        override public function updateButtons(alpha:Array) : void
        {
            var _loc_3:int = 0;
            var _loc_2:* = alpha.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                this.set_button_selected(_loc_3, alpha[_loc_3] != -1);
                _loc_3++;
            }
            this.m_currentLines = alpha.slice();
            return;
        }// end function

        private function removeAllLines() : void
        {
            var _loc_1:int = 0;
            this.candelFade();
            var _loc_2:* = m_innerLinesContainer.numChildren;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                m_innerLinesContainer.removeChildAt(0);
                _loc_1++;
            }
            _loc_2 = this.m_currentLines.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                this.m_currentLines[_loc_1] = -1;
                _loc_1++;
            }
            return;
        }// end function

    }
}
