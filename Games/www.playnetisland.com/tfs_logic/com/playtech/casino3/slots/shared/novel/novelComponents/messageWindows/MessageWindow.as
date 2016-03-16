package com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.enum.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.novelCmd.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.utils.button.*;
    import com.playtech.casino3.utils.queue.*;
    import flash.display.*;
    import flash.events.*;
    import flash.ui.*;
    import flash.utils.*;

    public class MessageWindow extends Object implements IMessageWindow
    {
        private var m_callback:Function;
        private var m_params:WindowParameters;
        private var m_skipped:Boolean;
        protected var m_queue:CommandQueue;
        private var m_gfx:Sprite;
        protected var m_mi:IModuleInterface;
        protected var m_panel:Sprite;
        private var m_bLogic:IButton;
        private var m_jumpId:int;
        private var m_tabId:int;
        private var m_clickTarget:DisplayObject;
        static const SND_SOURCE_NAME:String = "MessageWindow";

        public function MessageWindow(param1:IModuleInterface, param2:Sprite, param3:WindowParameters)
        {
            this.m_queue = new CommandQueue();
            this.m_mi = param1;
            this.m_params = param3;
            this.m_gfx = param2;
            return;
        }// end function

        public function cancel() : void
        {
            this.removeWindowClose();
            this.middleActionsSkipped();
            this.m_queue.empty();
            this.finish();
            return;
        }// end function

        private function playSound(m_mi:String) : void
        {
            var _loc_2:int = 0;
            if (m_mi != null)
            {
                _loc_2 = this.m_mi.playAsEffect(GameParameters.shortname + "." + m_mi, SND_SOURCE_NAME);
                if (_loc_2 == -1)
                {
                    this.m_mi.playAsEffect(GameParameters.library + "." + m_mi, SND_SOURCE_NAME);
                }
            }
            return;
        }// end function

        private function removeWindowClose() : void
        {
            if (this.m_bLogic != null)
            {
                this.m_bLogic.disable(true);
                EventPool.dispatchEvent(new Event(MessageWindowInfo.MESSAGE_SPACE_NOT_IN_SERVICE));
                this.m_mi.removeKeyboardSet(this.m_tabId);
            }
            if (this.m_clickTarget != null)
            {
                this.m_clickTarget.removeEventListener(MouseEvent.CLICK, this.skipMiddleActions);
            }
            EventPool.dispatchEvent(new Event(MessageWindowInfo.MESSAGE_CLOSING));
            return;
        }// end function

        public function get graphics() : Sprite
        {
            return this.m_panel;
        }// end function

        public function showWindow() : void
        {
            var _loc_1:* = getDefinitionByName(GameParameters.shortname + "." + this.m_params.linkageName) as Class;
            this.m_panel = new _loc_1 as Sprite;
            this.m_panel.visible = false;
            if (this.m_params.linkageBackground != null)
            {
                _loc_1 = getDefinitionByName(GameParameters.shortname + "." + this.m_params.linkageBackground) as Class;
                this.m_panel.addChildAt(new _loc_1, 0);
            }
            this.m_gfx.addChild(this.m_panel);
            this.beforeWindow();
            this.appear();
            this.m_queue.add(new CommandFunction(this.initWindowClose));
            this.middleActions();
            if (this.m_params.duration > 0)
            {
                this.m_queue.add(new CommandTimer(this.m_params.duration));
            }
            else
            {
                this.m_queue.add(new CommandObject(this.blocker));
            }
            var _loc_2:* = new CommandFunction(this.removeWindowClose);
            this.m_queue.add(_loc_2);
            this.m_jumpId = _loc_2.getId();
            this.disappear();
            this.m_queue.add(new CommandFunction(this.finish));
            return;
        }// end function

        protected function beforeWindow() : void
        {
            return;
        }// end function

        private function finish() : void
        {
            this.afterWindow();
            this.m_panel.parent.removeChild(this.m_panel);
            this.m_callback();
            return;
        }// end function

        public function dispose() : void
        {
            this.m_mi.stopSoundsBySource(SND_SOURCE_NAME);
            this.m_queue.dispose();
            this.m_queue = null;
            this.m_clickTarget = null;
            this.m_panel = null;
            this.m_gfx = null;
            this.m_mi = null;
            this.m_callback = null;
            this.m_params = null;
            this.m_bLogic = null;
            return;
        }// end function

        protected function middleActions() : void
        {
            return;
        }// end function

        private function skipMiddleActions(event:Event = null) : void
        {
            if (this.m_skipped)
            {
                return;
            }
            this.m_skipped = true;
            this.middleActionsSkipped();
            this.m_queue.jumpToCommand(this.m_jumpId);
            return;
        }// end function

        protected function disappear() : void
        {
            var _loc_2:Object = null;
            var _loc_1:* = this.m_mi.readSession(SharedSession.CLIENT_HEIGHT);
            switch(this.m_params.outAnimation)
            {
                case MessageWindowInfo.MOVE_ANIM:
                {
                    _loc_2 = {prop:"y", begin:int(_loc_1 / 2), finish:this.m_panel.y, duration:16};
                    break;
                }
                case MessageWindowInfo.FADE_ANIM:
                {
                    _loc_2 = {prop:"alpha", begin:1, finish:0, duration:10};
                    break;
                }
                case MessageWindowInfo.NO_ANIM:
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (_loc_2 != null)
            {
                this.m_queue.add(new TweenCmd(this.m_panel, _loc_2), new CommandFunction(this.playSound, this.m_params.outSound));
            }
            else
            {
                this.m_queue.add(new CommandFunction(this.playSound, this.m_params.outSound));
            }
            return;
        }// end function

        protected function afterWindow() : void
        {
            return;
        }// end function

        private function appear() : void
        {
            var _loc_3:Object = null;
            var _loc_1:* = this.m_mi.readSession(SharedSession.CLIENT_WIDTH);
            var _loc_2:* = this.m_mi.readSession(SharedSession.CLIENT_HEIGHT);
            switch(this.m_params.inAnimation)
            {
                case MessageWindowInfo.MOVE_ANIM:
                {
                    this.m_panel.x = int(_loc_1 / 2);
                    this.m_panel.y = -this.m_panel.height;
                    _loc_3 = {prop:"y", begin:this.m_panel.y, finish:int(_loc_2 / 2), duration:16};
                    break;
                }
                case MessageWindowInfo.FADE_ANIM:
                {
                    this.m_panel.x = int(_loc_1 / 2);
                    this.m_panel.y = int(_loc_2 / 2);
                    this.m_panel.alpha = 0;
                    _loc_3 = {prop:"alpha", begin:0, finish:1, duration:10};
                    break;
                }
                case MessageWindowInfo.NO_ANIM:
                {
                    this.m_panel.x = int(_loc_1 / 2);
                    this.m_panel.y = int(_loc_2 / 2);
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.m_panel.visible = true;
            if (_loc_3 != null)
            {
                this.m_queue.add(new TweenCmd(this.m_panel, _loc_3), new CommandFunction(this.playSound, this.m_params.inSound));
            }
            else
            {
                this.m_queue.add(new CommandFunction(this.playSound, this.m_params.inSound));
            }
            this.m_queue.add(new CommandFunction(EventPool.dispatchEvent, new Event(MessageWindowInfo.MESSAGE_OPENED)));
            return;
        }// end function

        protected function middleActionsSkipped() : void
        {
            return;
        }// end function

        public function setCallBack(m_mi:Function) : void
        {
            this.m_callback = m_mi;
            return;
        }// end function

        private function initWindowClose() : void
        {
            var _loc_1:ButtonComponent = null;
            if (this.m_params.hasContinueBtn)
            {
                _loc_1 = ButtonComponent(this.m_panel.getChildByName("buttonContinue"));
                this.m_bLogic = IButton(_loc_1.getLogic());
                this.m_bLogic.registerHandler(this.skipMiddleActions);
                this.m_tabId = this.m_mi.createKeyboardSet();
                this.m_mi.addTabElement(this.m_tabId, _loc_1);
                this.m_mi.addButtonShortcut(this.m_tabId, Keyboard.SPACE, _loc_1);
                EventPool.dispatchEvent(new Event(MessageWindowInfo.MESSAGE_SPACE_IN_SERVICE));
            }
            switch(this.m_params.clickTarget)
            {
                case MessageWindowInfo.FULL_SCREEN:
                {
                    this.m_clickTarget = this.m_gfx.stage;
                    break;
                }
                case MessageWindowInfo.FULL_WINDOW:
                {
                    this.m_clickTarget = this.m_panel;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this.m_clickTarget != null)
            {
                this.m_clickTarget.addEventListener(MouseEvent.CLICK, this.skipMiddleActions);
            }
            return;
        }// end function

        private function blocker(Class:String) : int
        {
            return 1;
        }// end function

    }
}
