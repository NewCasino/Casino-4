package com.playtech.casino3.slots.shared
{
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.enum.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;

    public class LinesBase extends Object
    {
        protected var m_maxLines:int;
        protected var m_linesConatinerMask:DisplayObjectContainer;
        protected var m_gfx:DisplayObjectContainer;
        protected var m_linesConatiner:DisplayObjectContainer;
        protected var m_innerLinesContainer:DisplayObjectContainer;
        protected var m_buttons:Array;
        protected var m_lines:Array;
        protected const LINENAME:String = "line";

        public function LinesBase(param1:DisplayObjectContainer)
        {
            this.m_innerLinesContainer = new Sprite();
            this.m_buttons = [];
            this.m_lines = [];
            this.m_gfx = param1;
            this.m_maxLines = GameParameters.maxLines;
            this.m_linesConatiner = this.m_gfx.getChildByName("linesContainer") as DisplayObjectContainer;
            this.m_linesConatinerMask = this.m_gfx.getChildByName("lines_container_mask") as DisplayObjectContainer;
            this.m_linesConatiner.addChild(this.m_innerLinesContainer);
            this.m_linesConatiner.mask = this.m_linesConatinerMask;
            this.initButtons();
            this.initLines();
            EventPool.addEventListener(ReelSpinInfo.SPIN_START, this.spinStarted);
            return;
        }// end function

        public function getButtons() : Array
        {
            return this.m_buttons;
        }// end function

        private function initLines() : void
        {
            var _loc_1:Class = null;
            var _loc_2:Sprite = null;
            var _loc_4:String = null;
            var _loc_3:int = 0;
            while (_loc_3 < this.m_maxLines)
            {
                
                _loc_4 = GameParameters.shortname + "." + this.m_maxLines + this.LINENAME + _loc_3;
                _loc_4 = ApplicationDomain.currentDomain.hasDefinition(_loc_4) ? (_loc_4) : (GameParameters.library + "." + this.m_maxLines + this.LINENAME + _loc_3);
                _loc_1 = getDefinitionByName(_loc_4) as Class;
                _loc_2 = new _loc_1 as Sprite;
                this.m_lines.push(_loc_2);
                _loc_3++;
            }
            return;
        }// end function

        protected function initButtons() : void
        {
            var _loc_1:int = 0;
            while (_loc_1 < this.m_maxLines)
            {
                
                this.m_buttons.push(this.m_gfx.getChildByName(GameButtons.LINE_BUTTON + "_" + _loc_1));
                _loc_1++;
            }
            return;
        }// end function

        public function showLine(EventPool:int, EventPool:Boolean, EventPool:int) : void
        {
            var _loc_4:Sprite = null;
            if (EventPool)
            {
                _loc_4 = Sprite(this.m_innerLinesContainer.addChild(this.m_lines[EventPool]));
                _loc_4.name = this.LINENAME + EventPool;
            }
            else
            {
                this.m_innerLinesContainer.removeChild(this.m_innerLinesContainer.getChildByName(this.LINENAME + EventPool));
            }
            return;
        }// end function

        protected function spinStarted(event:Event) : void
        {
            return;
        }// end function

        public function dispose() : void
        {
            this.m_buttons = null;
            this.m_gfx = null;
            this.m_linesConatiner = null;
            this.m_innerLinesContainer = null;
            this.m_linesConatinerMask = null;
            this.m_lines = null;
            EventPool.removeEventListener(ReelSpinInfo.SPIN_START, this.spinStarted);
            return;
        }// end function

        public function updateLineSelection(EventPool:Array) : void
        {
            return;
        }// end function

        public function pressbutton(EventPool:int) : void
        {
            this.m_buttons[EventPool].getLogic().buttonPress();
            return;
        }// end function

        public function updateButtons(EventPool:Array) : void
        {
            return;
        }// end function

    }
}
