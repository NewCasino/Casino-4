package com.playtech.casino3.slots.shared.novel
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.utils.button.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.text.*;

    public class NovelPaytable extends PaytableBase
    {
        protected var m_payline_txt:TextField;
        protected var m_next:IButton;
        protected var m_previous:IButton;
        protected var m_payline:ButtonComponent;
        protected var m_rememberPage:int;
        protected var m_replace:Object;
        private var m_keyboardId:int;
        protected var m_cf:TextField;

        public function NovelPaytable(param1:Sprite, param2:IModuleInterface, param3:int, param4:Object = null)
        {
            super(param1, param2, param3);
            this.m_rememberPage = -1;
            this.m_replace = param4;
            return;
        }// end function

        private function replace() : void
        {
            var _loc_1:TextField = null;
            var _loc_2:* = undefined;
            for (_loc_2 in this.m_replace)
            {
                
                _loc_1 = m_PageWnd.getChildByName(_loc_2) as TextField;
                if (_loc_1 != null)
                {
                    _loc_1.htmlText = this.m_replace[_loc_2];
                }
            }
            return;
        }// end function

        override protected function initButtons() : void
        {
            this.m_keyboardId = m_mi.createKeyboardSet();
            var _loc_1:* = ButtonComponent(m_paytableWnd.getChildByName("previous"));
            this.m_previous = _loc_1.getLogic() as IButton;
            this.m_previous.registerHandler(this.changeFrame, -1);
            m_mi.addTabElement(this.m_keyboardId, _loc_1);
            _loc_1 = ButtonComponent(m_paytableWnd.getChildByName("next"));
            this.m_next = _loc_1.getLogic() as IButton;
            this.m_next.registerHandler(this.changeFrame, 1);
            m_mi.addTabElement(this.m_keyboardId, _loc_1);
            this.m_payline = m_paytableWnd.getChildByName("paylines") as ButtonComponent;
            this.m_payline.getLogic().registerHandler(this.showLines);
            m_mi.addTabElement(this.m_keyboardId, this.m_payline);
            this.m_payline_txt = m_paytableWnd.getChildByName("paylines_txt") as TextField;
            if (this.m_payline_txt != null)
            {
                this.m_payline_txt.text = m_mi.readText("novel_showpaylines");
                this.m_payline_txt.mouseEnabled = false;
            }
            _loc_1 = m_paytableWnd.getChildByName("close") as ButtonComponent;
            _loc_1.getLogic().registerHandler(this.paytableClose);
            m_mi.addTabElement(this.m_keyboardId, _loc_1);
            this.checkButtons();
            this.m_cf = TextField(m_paytableWnd.getChildByName("pageMax"));
            this.m_cf.mouseEnabled = false;
            this.m_cf.text = m_maxPages.toString();
            this.m_cf = m_paytableWnd.getChildByName("currentPage") as TextField;
            this.m_cf.mouseEnabled = false;
            this.updateNumber();
            return;
        }// end function

        protected function checkButtons() : void
        {
            this.checkBrowseBtns();
            this.checkPayline();
            return;
        }// end function

        private function showLines() : void
        {
            if (this.m_rememberPage == -1)
            {
                this.m_rememberPage = m_currentPage;
                this.openFrame(m_maxPages);
                if (this.m_payline_txt != null)
                {
                    this.m_payline_txt.text = m_mi.readText("novel_hidepaylines");
                }
                else
                {
                    this.m_payline.getLogic().setLabel("novel_hidepaylines");
                }
            }
            else
            {
                if (this.m_payline_txt != null)
                {
                    this.m_payline_txt.text = m_mi.readText("novel_showpaylines");
                }
                else
                {
                    this.m_payline.getLogic().setLabel("novel_showpaylines");
                }
                this.openFrame(this.m_rememberPage);
                this.m_rememberPage = -1;
            }
            return;
        }// end function

        override protected function openFrame(addTabElement:int) : void
        {
            super.openFrame(addTabElement);
            if (this.m_replace != null)
            {
                this.replace();
            }
            return;
        }// end function

        protected function changeFrame(addTabElement:int) : void
        {
            if (this.m_rememberPage != -1)
            {
                this.m_rememberPage = this.m_rememberPage + addTabElement;
                this.showLines();
            }
            else
            {
                this.openFrame(m_currentPage + addTabElement);
            }
            if (m_transitionType == TYPE_REGULAR)
            {
                this.checkButtons();
            }
            this.updateNumber();
            return;
        }// end function

        override public function dispose() : void
        {
            m_mi.removeKeyboardSet(this.m_keyboardId);
            super.dispose();
            this.m_next = null;
            this.m_previous = null;
            this.m_cf = null;
            this.m_payline_txt = null;
            this.m_payline = null;
            this.m_replace = null;
            return;
        }// end function

        override protected function enableBrowseBtns(addTabElement:Boolean) : void
        {
            Console.write("enableBrowseBtns, enable: " + addTabElement, this);
            if (addTabElement)
            {
                this.checkBrowseBtns();
            }
            else
            {
                this.m_next.disable(true);
                this.m_previous.disable(true);
            }
            return;
        }// end function

        override public function toString() : String
        {
            return "[NovelPaytable] ";
        }// end function

        protected function checkBrowseBtns() : void
        {
            switch(m_currentPage)
            {
                case (m_maxPages - 1):
                {
                    this.m_next.disable(true);
                    this.m_previous.disable(false);
                    break;
                }
                case 0:
                {
                    this.m_previous.disable(true);
                    this.m_next.disable(false);
                    break;
                }
                default:
                {
                    this.m_next.disable(false);
                    this.m_previous.disable(false);
                    break;
                }
            }
            return;
        }// end function

        protected function updateNumber() : void
        {
            this.m_cf.text = ((m_currentPage + 1)).toString();
            return;
        }// end function

        override protected function paytableClose() : void
        {
            if (this.m_rememberPage != -1)
            {
                m_currentPage = this.m_rememberPage;
                this.m_rememberPage = -1;
            }
            m_mi.removeKeyboardSet(this.m_keyboardId);
            super.paytableClose();
            return;
        }// end function

        private function checkPayline() : void
        {
            this.m_payline.visible = m_currentPage == 0;
            this.m_payline.getLogic().disable(m_currentPage != 0);
            if (this.m_payline_txt != null)
            {
                this.m_payline_txt.visible = m_currentPage == 0;
            }
            return;
        }// end function

    }
}
